Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbYKWQdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbYKWQdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 11:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbYKWQcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 11:32:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48777 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbYKWQcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 11:32:53 -0500
Date: Sun, 23 Nov 2008 17:32:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #12064] [regression] Measured 688 cycles TSC warp;
	marking TSC unstable
Message-ID: <20081123163240.GA5884@elte.hu>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera> <vyitTh0pP2N.A.d2B.M7HKJB@chimera> <200811231729.59256.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811231729.59256.elendil@planet.nl>
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


* Frans Pop <elendil@planet.nl> wrote:

> On Saturday 22 November 2008, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12064
> > Date		: 2008-11-16 19:27:43 (7 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122686370308852&w=2
> 
> Looks to be fixed in -rc6:
> 
> -Calibrating delay using timer specific routine.. 6198.05 BogoMIPS (lpj=12396107)
> +Calibrating delay using timer specific routine.. 6399.82 BogoMIPS (lpj=12799647)
> [...]
> -checking TSC synchronization [CPU#0 -> CPU#1]:
> -Measured 696 cycles TSC warp between CPUs, turning off TSC clock.
> -Marking TSC unstable due to check_tsc_sync_source failed
> +checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> 
> So, BogoMIPS value on CPU#1 is in line with CPU#0 again and TSC passes.
> No idea what commit would be responsible.

this one from Venki fixed it:

| commit 93ce99e849433ede4ce8b410b749dc0cad1100b2
| Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
| Date:   Mon Nov 17 14:43:58 2008 -0800
| 
|    x86: add rdtsc barrier to TSC sync check

	Ingo
