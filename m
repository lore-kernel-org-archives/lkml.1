Return-Path: <linux-kernel-owner+w=401wt.eu-S1031057AbXDXIYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031057AbXDXIYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031047AbXDXIX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:23:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39164 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031038AbXDXIX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:23:29 -0400
Date: Tue, 24 Apr 2007 10:23:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Gerdau <mgd@technosis.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>, ck list <ck@vds.kolivas.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [REPORT] cfs-v5 vs sd-0.46
Message-ID: <20070424082305.GA6332@elte.hu>
References: <200704240938.07482.mgd@technosis.de> <20070424075319.GA30909@elte.hu> <200704241017.10610.mgd@technosis.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704241017.10610.mgd@technosis.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Gerdau <mgd@technosis.de> wrote:

> > so to be totally 'fair' and get the same rescheduling 'granularity' 
> > you should probably lower CFS's sched_granularity_ns to 2 msecs.
> 
> I'll change default nice in cfs to -10.
> 
> I'm also happy to adjust /proc/sys/kernel/sched_granularity_ns to 
> 2msec. However checking /proc/sys/kernel/rr_interval reveals it is 16 
> (msec) on my system.

ah, yeah - there due to the SMP rule in SD:

       rr_interval *= 1 + ilog2(num_online_cpus());

and you have a 2-CPU system, so you get 8msec*2 == 16 msecs default 
interval. I find this a neat solution and i have talked to Con about 
this already and i'll adopt Con's idea in CFS too. Nevertheless, despite 
the settings, SD seems to be rescheduling every 6-7 msecs, while CFS 
reschedules only every 13 msecs.

Here i'm assuming that the vmstats are directly comparable: that your 
number-crunchers behave the same during the full runtime - is that 
correct? (If not then the vmstat result should be run at roughly the 
same type of "stage" of the workload, on all the schedulers.)

	Ingo
