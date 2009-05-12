Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbZELTG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbZELTG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 15:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZELTGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 15:06:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53716 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZELTGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 15:06:14 -0400
Date: Tue, 12 May 2009 21:05:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/numa] x86: read apic ID in the !acpi_lapic case
Message-ID: <20090512190538.GA9769@elte.hu>
References: <tip-4797f6b021a3fa399942245d07a1feb30df81bb8@git.kernel.org> <20090512112205.GA12108@elte.hu> <20090512145128.GA10220@lenovo> <20090512145808.GA20587@elte.hu> <4A099013.6040708@kernel.org> <20090512150631.GA32067@elte.hu> <20090512164617.GA21673@elte.hu> <4A09C068.3010308@kernel.org> <20090512183302.GA4000@elte.hu> <4A09C157.7010407@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A09C157.7010407@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> Ingo Molnar wrote:
> >>> got this on a testbox:
> >>>
> >>> [    0.113333] WARNING: at arch/x86/kernel/apic/apic.c:253 warn_slowpath_null+0x28/0x50()
> >>>
> >>> 	Ingo
> >>>
> >>> [    0.000000] Initializing cgroup subsys cpuset
> >>> [    0.000000] Linux version 2.6.30-rc5-tip-01553-g4bc9bac-dirty (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #48764 SMP PREEMPT Tue May 12 18:30:18 CEST 2009
> >>> [    0.000000] Command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty debug initcall_debug apic=verbose sysrq_always_enabled 5 ignore_loglevel nosmp no_hz=off highres=0 nmi_watchdog=0 noapic nolapic_timer hpet=disable idle=poll notsc acpi=off
> >> you should use
> >> nolapic and noapic_timer
> >>
> >> /* same as disableapic, for compatibility */
> >> static int __init setup_nolapic(char *arg)
> >> {
> >>         return setup_disableapic(arg);
> >> }
> >> early_param("nolapic", setup_nolapic);
> >>
> >> static int __init parse_disable_apic_timer(char *arg)
> >> {
> >>         disable_apic_timer = 1;
> >>         return 0;
> >> }
> >> early_param("noapictimer", parse_disable_apic_timer);
> > 
> > What do you mean? This warning never triggered before on this 
> > test-box. This is a plain regression.
> 
> just a reminder: that in your command there are some typo: should 
> use nolapic and noapic_timer.

ah, ok - indeed. But that is irrelevant to the bugreport.

	Ingo
