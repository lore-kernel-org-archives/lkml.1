Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYGJKi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYGJKi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 06:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYGJKiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 06:38:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43583 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbYGJKiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 06:38:50 -0400
Date: Thu, 10 Jul 2008 12:38:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86/pci: Broken build for X86_VISWS
Message-ID: <20080710103831.GA30650@elte.hu>
References: <20080710095757.GB5607@erda.amd.com> <20080710102305.GA20096@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710102305.GA20096@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > Ingo,
> > 
> > during testing of my pci changes I observed a build error if X86_VISWS 
> > is set:
> > 
> > arch/x86/mach-visws/built-in.o: In function `machine_power_off':
> > (.text+0x48): undefined reference to `pci_bus0'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > make: *** [sub-make] Error 2
> > 
> > The root cause is disabling PCI dependencies in change 1ac97018 that 
> > disables compilation of x86/pci for VISWS though there are files in 
> > needed to build. I am not sure if it is save to enable PCI for VISWS 
> > to fix this.
> > 
> > Could you take a look at this?
> 
> well spotted. Does the patch below fix it for you?

there's another visws build bug related to generic-ipi - i fixed that in 
tip/master.

	Ingo
