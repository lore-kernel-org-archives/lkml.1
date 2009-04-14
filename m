Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbZDNGxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbZDNGxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 02:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZDNGx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 02:53:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57991 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbZDNGx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 02:53:27 -0400
Date: Tue, 14 Apr 2009 08:53:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tracing/lockdep: turn lock->name into an array
Message-ID: <20090414065303.GA24626@elte.hu>
References: <1239662166-13208-1-git-send-email-fweisbec@gmail.com> <20090414153035.C662.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414153035.C662.A69D9226@jp.fujitsu.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi
> 
> > Impact: allow filtering by lock name / fix module tracing
> > 
> > Currently, the "lock acquired" event is traced using a TRACE_EVENT.
> > But we can't use the char * type for the name without risking to
> > dereference a freed pointer. A lock name can come from a module
> > towards lockdep and it is risky to only store its address because we
> > defer its name printing.
> 
> When released lockdep string table? I guess it only happend at 
> module unloading. if so, we should consider to make delayed string 
> table freeing at module unloading.
> 
> My point is, module unloading is rare event. thus meking pointer 
> safe mechanism widely avoid string copy.
> 
> IOW, if not, ringbuffer is filled tons string. it kill the merit 
> of binary buffer and current design.

We could zap all pending trace entries on module unload (it is a 
rare operation). That would indeed make a whole category of 
symbol-alike string pointers safe to be passed by value.

	Ingo
