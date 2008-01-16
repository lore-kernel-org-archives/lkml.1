Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYAPU2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYAPU2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYAPU2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:28:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37795 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbYAPU2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:28:35 -0500
Date: Wed, 16 Jan 2008 21:28:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ak@suse.de
Subject: Re: [PATCH] x86: fix detection of CONSTANT_TSC bit for AMD CPUs
Message-ID: <20080116202820.GA6016@elte.hu>
References: <20080116194606.GB11244@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116194606.GB11244@alberich.amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> Commits
>  - c52f61fcbdb2aa84f0e4d831ef07f375e6b99b2c 
>   (x86: allow TSC clock source on AMD Fam10h and some cleanup)
>  - e30436f05d456efaff77611e4494f607b14c2782
>   (x86: move X86_FEATURE_CONSTANT_TSC into early cpu feature detection)
> 
> are supposed to fix the detection of contant TSC for AMD CPUs.
> Unfortunately on x86_64 it does still not work with current x86/mm.
> For a Phenom I still get:
> 
>   ...
>   TSC calibrated against PM_TIMER 
>   Marking TSC unstable due to TSCs unsynchronized
>   time.c: Detected 2288.366 MHz processor.
>   ...
> 
> We have to set c->x86_power in early_identify_cpu to properly detect
> the CONSTANT_TSC bit in early_init_amd.
> 
> Attached patch fixes this issue. Following the relevant boot
> messages when the fix is used:
> 
>   ...
>   TSC calibrated against PM_TIMER
>   time.c: Detected 2288.279 MHz processor.
>   ...
>   Initializing CPU#1
>   ...
>   checking TSC synchronization [CPU#0 -> CPU#1]: passed.
>   ...
>   Initializing CPU#2
>   ...
>   checking TSC synchronization [CPU#0 -> CPU#2]: passed.
>   ...
>   Booting processor 3/4 APIC 0x3
>   ...
>   checking TSC synchronization [CPU#0 -> CPU#3]: passed.
>   Brought up 4 CPUs
>   ...
> 
> Patch is against x86/mm (v2.6.24-rc8-672-ga9f7faa).
> Please apply.

thanks, applied.

	Ingo
