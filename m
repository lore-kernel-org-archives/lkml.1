Return-Path: <linux-kernel-owner+w=401wt.eu-S1422771AbXBALgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422771AbXBALgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422780AbXBALgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:36:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46703 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422771AbXBALgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:36:01 -0500
Date: Thu, 1 Feb 2007 12:34:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: jbohac@suse.cz
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, arjan@infradead.org,
       tglx@linutronix.de, johnstul@us.ibm.com
Subject: Re: [patch 0/9] x86_64: reliable TSC-based gettimeofday
Message-ID: <20070201113440.GA26453@elte.hu>
References: <20070201095952.589234000@jet.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201095952.589234000@jet.suse.cz>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.7 required=5.9 tests=ALL_TRUSTED,BAYES_05 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-0.4 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0456]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* jbohac@suse.cz <jbohac@suse.cz> wrote:

> This implementation allows the current time to be approximated by 
> reading the CPU's TSC even on SMP machines with unsynchronised TSCs. 
> This allows us to have a very fast gettimeofday() vsyscall on all SMP 
> machines supporting the RDTSCP instruction (AMD) or having 
> synchronised TSCs (Intel).
>
> Inter-CPU monotonicity can not, however, be guaranteed in a vsyscall, 
> so vsyscall is not used by default. Still, the syscall version of 
> gettimeofday is a lot faster using the TSC approximation instead of 
> other hardware timers.

ok, this looks mostly good to me - but this definitely should be based 
/ontop/ of the x86_64 GTOD code. I.e. ontop of these patches in -mm:

 generic-vsyscall-gtod-support-for-generic_time.patch
 generic-vsyscall-gtod-support-for-generic_time-tidy.patch
 time-x86_64-hpet_address-cleanup.patch
 revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
 time-x86_64-split-x86_64-kernel-timec-up.patch
 time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
 time-x86_64-split-x86_64-kernel-timec-up-fix.patch
 reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
 time-x86_64-convert-x86_64-to-use-generic_time.patch
 time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
 time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
 time-x86_64-hpet-fixup-clocksource-changes.patch
 time-x86_64-tsc-fixup-clocksource-changes.patch
 time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
 time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch

also, note that there is a new TSC synchronization check code in -mm as 
well:

 x86-rewrite-smp-tsc-sync-code.patch

this should be ontop of that too. (and ontop of the high-res timers 
queue)

	Ingo
