Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbZDNK0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbZDNK0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbZDNKZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:25:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36792 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZDNKZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:25:57 -0400
Date: Tue, 14 Apr 2009 12:25:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/lockdep: turn lock->name into an array
Message-ID: <20090414102533.GG3558@elte.hu>
References: <1239662166-13208-1-git-send-email-fweisbec@gmail.com> <20090414153035.C662.A69D9226@jp.fujitsu.com> <20090414065303.GA24626@elte.hu> <1239693611.21985.6694.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239693611.21985.6694.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-04-14 at 08:53 +0200, Ingo Molnar wrote:
> > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > Hi
> > > 
> > > > Impact: allow filtering by lock name / fix module tracing
> > > > 
> > > > Currently, the "lock acquired" event is traced using a TRACE_EVENT.
> > > > But we can't use the char * type for the name without risking to
> > > > dereference a freed pointer. A lock name can come from a module
> > > > towards lockdep and it is risky to only store its address because we
> > > > defer its name printing.
> > > 
> > > When released lockdep string table? I guess it only happend at 
> > > module unloading. if so, we should consider to make delayed string 
> > > table freeing at module unloading.
> > > 
> > > My point is, module unloading is rare event. thus meking pointer 
> > > safe mechanism widely avoid string copy.
> > > 
> > > IOW, if not, ringbuffer is filled tons string. it kill the merit 
> > > of binary buffer and current design.
> > 
> > We could zap all pending trace entries on module unload (it is a 
> > rare operation). That would indeed make a whole category of 
> > symbol-alike string pointers safe to be passed by value.
> 
> Except that might make debugging a module unload bug rather 
> hard...

yes. Never needed to do that personally though. Plus more specific 
tracers like function tracer without event-tracing embellishments 
could still be used in such situations too, without flushing.

	Ingo
