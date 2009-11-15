Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbZKOKe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbZKOKe7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 05:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZKOKe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 05:34:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46475 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbZKOKe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:34:58 -0500
Date: Sun, 15 Nov 2009 11:34:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Simon K??mpflein <s.kaempflein@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: perf counters: problem with perf record
Message-ID: <20091115103459.GC24931@elte.hu>
References: <4AFEE55B.3000906@gmx.de>
 <1258227980.30187.512.camel@laptop>
 <4AFFD2B8.5060400@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFFD2B8.5060400@gmx.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon K??mpflein <s.kaempflein@gmx.de> wrote:

> Peter Zijlstra schrieb:
> > On Sun, 2009-11-15 at 03:14 +1000, Simon K??mpflein wrote:
> >> Hello,
> >>
> >> I have a problem with the new kernel perf tools in kernel 2.6.31.6 (very
> >> nice tools by the way). I like to monitor the cache-misses of a program.
> >> "perf stat -e cache-misses program" works without problems, but I can't
> >> get "perf record -e cache-misses program" working (even running as root
> >> and CONFIG_PERF_COUNTERS=y):
> >>
> >> Error: perfcounter syscall returned with -1 (Operation not supported)
> >> Fatal: No CONFIG_PERF_COUNTERS=y kernel support configured?
> >>
> >> My CPU is a "Intel(R) Pentium(R) M processor 1.80GHz":
> > 
> > Does the bootlog perchance contain the output of?
> > 
> >         if (!cpu_has_apic) {
> >                 pr_info("no APIC, boot with the \"lapic\" boot parameter
> > to force-enable it.\n");
> >                 pr_info("no hardware sampling interrupt available.\n");
> >                 x86_pmu.apic = 0;
> >         }
> 
> Yes. I didn't realize that it has something to do with the Performance
> Counters because I didn't see that it belongs to the Performance Counter
> output.
> Maybe it's a good idea to add another comment making it clear that the
> performance counters are not fully working in this case. Or detect this
> case in "perf-record" and output a message relating to that.

Ok. Mind sending a patch that changes the message so that it explains it 
all to you more clearly?

> > And does booting with the suggested lapic parameter cure your problems?
> > 
> 
> Yes, thank you!

Great.

You might want to send another patch that allows the .config enabling of 
that lapic boot parameter. It sucks to carry around boot parameters.

	Ingo
