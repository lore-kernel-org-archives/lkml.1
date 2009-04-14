Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbZDNHSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbZDNHSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZDNHRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:17:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35164 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbZDNHRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:17:52 -0400
Subject: Re: [PATCH] tracing/lockdep: turn lock->name into an array
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090414065303.GA24626@elte.hu>
References: <1239662166-13208-1-git-send-email-fweisbec@gmail.com>
	 <20090414153035.C662.A69D9226@jp.fujitsu.com>
	 <20090414065303.GA24626@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Apr 2009 09:20:11 +0200
Message-Id: <1239693611.21985.6694.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 08:53 +0200, Ingo Molnar wrote:
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Hi
> > 
> > > Impact: allow filtering by lock name / fix module tracing
> > > 
> > > Currently, the "lock acquired" event is traced using a TRACE_EVENT.
> > > But we can't use the char * type for the name without risking to
> > > dereference a freed pointer. A lock name can come from a module
> > > towards lockdep and it is risky to only store its address because we
> > > defer its name printing.
> > 
> > When released lockdep string table? I guess it only happend at 
> > module unloading. if so, we should consider to make delayed string 
> > table freeing at module unloading.
> > 
> > My point is, module unloading is rare event. thus meking pointer 
> > safe mechanism widely avoid string copy.
> > 
> > IOW, if not, ringbuffer is filled tons string. it kill the merit 
> > of binary buffer and current design.
> 
> We could zap all pending trace entries on module unload (it is a 
> rare operation). That would indeed make a whole category of 
> symbol-alike string pointers safe to be passed by value.

Except that might make debugging a module unload bug rather hard...
