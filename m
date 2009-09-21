Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbZIUHLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbZIUHLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbZIUHLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:11:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44452 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbZIUHLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:11:40 -0400
Date: Mon, 21 Sep 2009 09:11:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Sachin Sant <sachinp@in.ibm.com>,
       Markus Metzger <markus.t.metzger@intel.com>, benh@kernel.crashing.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] perf_counter/powerpc: Fix compilation after
	perf_counter_overflow change
Message-ID: <20090921071127.GA24467@elte.hu>
References: <19127.8400.376239.586120@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19127.8400.376239.586120@drongo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Commit 5622f295 ("x86, perf_counter, bts: Optimize BTS overflow
> handling") removed the regs field from struct perf_sample_data and
> added a regs parameter to perf_counter_overflow().  This breaks the
> build on powerpc as reported by Sachin Sant:
> 
> arch/powerpc/kernel/perf_counter.c: In function 'record_and_restart':
> arch/powerpc/kernel/perf_counter.c:1165: error: unknown field 'regs' specified in initializer
> cc1: warnings being treated as errors
> arch/powerpc/kernel/perf_counter.c:1165: error: initialization makes integer from pointer without a cast
> arch/powerpc/kernel/perf_counter.c:1173: error: too few arguments to function 'perf_counter_overflow'
> make[1]: *** [arch/powerpc/kernel/perf_counter.o] Error 1
> make: *** [arch/powerpc/kernel] Error 2
> 
> This adjusts arch/powerpc/kernel/perf_counter.c to correspond with the
> new struct perf_sample_data and perf_counter_overflow().
> 
> Reported-by: Sachin Sant <sachinp@in.ibm.com>
> Signed-off-by: Paul Mackerras <paulus@samba.org>

Applied, thanks Paul.

> ---
>
> I missed this problem when the "x86, perf_counter, bts: Optimize BTS 
> overflow handling" patch was posted because the headline made it seem 
> entirely x86-specific, and the changes to struct perf_sample_data and 
> perf_counter_overflow() were not mentioned in the changelog.
> 
> Markus, please take care in future to mention it in the changelog if 
> your patches touch definitions used by other architectures.  If you 
> could go so far as to use grep a bit more and fix up other 
> architectures' callsites for the things you're changing, that would be 
> very much appreciated.  Thanks.

Yes, that should be done in general - still, nothing beats actual 
testing.

Paul, you might also want to test the perfcounter bits of -tip on 
PowerPC a bit more frequently - this patch was there for 5 days before i 
sent it to Linus.

Cross-builds didnt catch it as perfcounters isnt enabled by default in 
any of the powerpc defconfigs:

phoenix:~/linux/linux> grep -w CONFIG_PERF_COUNTERS arch/powerpc/configs/*
arch/powerpc/configs/adder875_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/c2k_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/ep8248e_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/ep88xc_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/linkstation_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/mgcoge_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/mgsuvd_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/mpc7448_hpc2_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/mpc8272_ads_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/mpc83xx_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/mpc85xx_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/mpc85xx_smp_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/mpc866_ads_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/mpc86xx_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/mpc885_ads_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/pq2fads_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/prpmc2800_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/ps3_defconfig:# CONFIG_PERF_COUNTERS is not set
arch/powerpc/configs/storcenter_defconfig:# CONFIG_PERF_COUNTERS is not set

There's not that many PowerPC users so all extra testing help would be 
much welcome. Also, enabling them in the powerpc defconfigs would be 
helpful as well.

Thanks,

	Ingo
