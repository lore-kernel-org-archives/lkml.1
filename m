Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbYFEPER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbYFEPER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYFEPEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:04:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44528 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbYFEPEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:04:04 -0400
Date: Thu, 5 Jun 2008 17:03:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 8/8] x86: I/O APIC: Timer through 8259A second-chance
Message-ID: <20080605150327.GA22128@elte.hu>
References: <Pine.LNX.4.55.0805271950010.18833@cliff.in.clinika.pl> <20080531101832.GA15170@elte.hu> <20080605091949.GA2307@elte.hu> <Pine.LNX.4.55.0806051541210.2875@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806051541210.2875@cliff.in.clinika.pl>
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


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

>  It seems wrong to me to set timer_through_8259 in apic_{32,64}.c -- 
> can I get .config for this setup as well as the bootstrap log?  Why is 
> the 8259A needed here to supply the timer interrupt?  It shouldn't be 
> needed except as arranged in check_timer() -- elsewhere the 
> corresponding I/O APIC input is not set up correctly.
> 
>  Note I have chosen the default value of timer_through_8259 
> deliberately to trigger dodgy cases like this ;) so that they can be 
> investigated.

find them here:

 http://redhat.com/~mingo/misc/config-Thu_Jun__5_16_40_50_CEST_2008.bad
 http://redhat.com/~mingo/misc/log-Thu_Jun__5_16_40_50_CEST_2008.bad

NOTE: you need to copy out and use the boot parameters from the boot 
log:

 [ 0.000000] Command line: root=/dev/sda6 console=ttyS0,115200 
 earlyprintk=se rial,ttyS0,115200 debug initcall_debug apic=verbose 
 sysrq_always_enabled ignore _loglevel selinux=0 nmi_watchdog=1 
 profile=0 maxcpus=1 nosmp no_hz=off highres =0 noapic nolapic_timer 
 hpet=disable idle=mwait

as -tip testing occasionally randomizes boot parameters too. (to find 
regressions like this) Let me know if you cannot reproduce this.

	Ingo
