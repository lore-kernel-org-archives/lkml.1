Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbYLEInL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbYLEInL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbYLEIm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:42:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42792 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYLEIm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:42:56 -0500
Date: Fri, 5 Dec 2008 09:42:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, eranian@googlemail.com, dada1@cosmosbay.com,
       robert.richter@amd.com, arjan@infradead.org, hpa@zytor.com,
       rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Message-ID: <20081205084233.GE2030@elte.hu>
References: <20081205081137.GB2030@elte.hu> <20081205.001717.216522767.davem@davemloft.net> <20081205082431.GD2030@elte.hu> <20081205.002701.172921476.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205.002701.172921476.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 5 Dec 2008 09:24:31 +0100
> 
> > Right now we begun with the most trivial ones:
> > 
> >   enum perf_record_type {
> >           PERF_RECORD_SIMPLE,
> >           PERF_RECORD_IRQ,
> >   };
> > 
> > ... but it would be natural to do a PERF_RECORD_GP_REGISTERS as well. 
> > Perhaps even a PERF_RECORD_STACKTRACE using the sysprof facilities, to do 
> > a hierarchic multi-dimension profile that sysprof does so nicely.
> 
> Maybe even add something like PERF_RECORD_THE_MOON...
> 
> see how rediculious this is?

Note that more notification record types is actually where latest 
hardware is going: for example in Nehalem there's a PEBS notification 
record type that has cachemiss latency included in the record. I.e. we 
can get profiles with _cachemiss latency_ included (as measured from 
issuing the instruction to completion).

You cannot get that information out of any 'stop the task' interface ...

Stopping a task is way too intrusive, i dont know why you keep harping on 
it. Listen to the scheduler guys: it's a non-starter.

> It's not your business in the kernel to decide what things are useful.  
> The monitor can stop the task and inspect whatever it wants with 
> _existing_ facilities.  We need none of this stuff.

You try to ridicule our efforts, while you have not answered our 
technical arguments in substance.

Please let me repeat: it's a _fundamental_ thesis of performance 
instrumentation to not disturb the monitored context. Your insistence on 
_stopping_ the monitored task breaks that fundamental axiom!

Stopping a task destroys the characteristics of many, many workloads. To 
get a reasonable histogram out of a system a highlevel event count of 
thousands a second is desired (but hundreds of them are a minimum, to get 
any reasonable coverage).

But injecting even hundreds of artificialy task-stoppages will destroy 
the true behavior of many reference workloads we care about in Linux!

Stopping the task is a fundamental and obvious design failure of perfmon.

	Ingo
