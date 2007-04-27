Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbXD0GxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbXD0GxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbXD0GxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:53:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40052 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427AbXD0GxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:53:01 -0400
Date: Fri, 27 Apr 2007 08:52:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: ck@vds.kolivas.org, Michael Gerdau <mgd@technosis.de>,
       Nick Piggin <npiggin@suse.de>, Bill Davidsen <davidsen@tmr.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Gene Heskett <gene.heskett@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [ck] Re: [REPORT] cfs-v6-rc2 vs sd-0.46 vs 2.6.21-rc7
Message-ID: <20070427065204.GA31708@elte.hu>
References: <200704261312.25571.mgd@technosis.de> <20070426120723.GA4092@elte.hu> <200704270859.37931.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704270859.37931.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

> > as a summary: i think your numbers demonstrate it nicely that the
> > shorter 'timeslice length' that both CFS and SD utilizes does not have a
> > measurable negative impact on your workload. To measure the total impact
> > of 'timeslicing' you might want to try the exact same workload with a
> > much higher 'timeslice length' of say 400 msecs, via:
> >
> >     echo 400000000 > /proc/sys/kernel/sched_granularity_ns  # on CFS
> >     echo 400 > /proc/sys/kernel/rr_interval                 # on SD
> 
> I thought that the effective "timeslice" on CFS was double the 
> sched_granularity_ns so wouldn't this make the effective timeslice 
> double that of what you're setting SD to? [...]

The two settings are not really comparable. The "effective timeslice is 
the double of the granularity" thing i mentioned before is really a 
special-case: only true for a really undisturbed 100% CPU-using 
_two-task_ workload, if and only if the workload would not reschedule 
otherwise, but that is clearly not the case here: and if you look at the 
vmstat output provided by Michael you'll see that all 3 schedulers 
rescheduled this workload at around 1000/sec or 1 msec per scheduling 
atom. (But i'd agree that to be on the safe side the context-switch rate 
has to be monitored and if it seems too high on SD, the rr_interval 
should be increased.)

> [...] Anyway the difference between 400 and 800ms timeslices is 
> unlikely to be significant so I don't mind.

even on a totally idle system there's at least a 10 Hz 'background 
sound' of various activities, so any setting above 100 msecs rarely has 
any effect.

	Ingo
