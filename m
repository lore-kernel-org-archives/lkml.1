Return-Path: <linux-kernel-owner+w=401wt.eu-S1030875AbXDVN2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030875AbXDVN2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 09:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030887AbXDVN2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 09:28:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42230 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030875AbXDVN2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 09:28:40 -0400
Date: Sun, 22 Apr 2007 15:27:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <lkml@rtr.ca>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Con Kolivas <kernel@kolivas.org>,
       Willy Tarreau <w@1wt.eu>, William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070422132732.GB18471@elte.hu>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <Pine.LNX.4.61.0704211913130.9989@yvahk01.tjqt.qr> <20070421190026.GA25720@elte.hu> <462B60A1.1020407@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462B60A1.1020407@rtr.ca>
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


* Mark Lord <lkml@rtr.ca> wrote:

> > i've not experienced a 'runaway X' personally, at most it would 
> > crash or lock up ;) The value is boot-time and sysctl configurable 
> > as well back to 0.
> 
> Mmmm.. I've had to kill off the odd X that was locking in 100% CPU 
> usage. In the past, this has happened maybe 1-3 times a year or so on 
> my notebook.
> 
> Now mind you, that usage could have been due to some client process, 
> but X is where the 100% showed up, so X is what I nuked.

well, i just simulated a runaway X at nice -19 on CFS (on a UP box), and 
while the box was a tad laggy, i was able to killall it without 
problems, within 2 seconds that also included a 'su'. So it's not an 
issue in CFS, it can be turned off, and because every distro has another 
way to renice Xorg, this is a convenience hack until Xorg standardizes 
it into some xorg.conf field. (It also makes sure that X isnt preempted 
by other userspace stuff while it does timing-sensitive operations like 
setting the video modes up or switching video modes, etc.)

	Ingo
