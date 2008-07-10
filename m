Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbYGJKX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbYGJKX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 06:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYGJKXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 06:23:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35311 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbYGJKXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 06:23:48 -0400
Date: Thu, 10 Jul 2008 12:23:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86/pci: Broken build for X86_VISWS
Message-ID: <20080710102305.GA20096@elte.hu>
References: <20080710095757.GB5607@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710095757.GB5607@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> during testing of my pci changes I observed a build error if X86_VISWS 
> is set:
> 
> arch/x86/mach-visws/built-in.o: In function `machine_power_off':
> (.text+0x48): undefined reference to `pci_bus0'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [sub-make] Error 2
> 
> The root cause is disabling PCI dependencies in change 1ac97018 that 
> disables compilation of x86/pci for VISWS though there are files in 
> needed to build. I am not sure if it is save to enable PCI for VISWS 
> to fix this.
> 
> Could you take a look at this?

well spotted. Does the patch below fix it for you?

	Ingo

------------------------->
commit 50e810529abfb39259c2877ed8dc784a4bb81167
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Jul 10 12:21:58 2008 +0200

    x86: fix visws and vsmp build
    
    these two sub-architectures want PCI to be default-on, not default-off.
    
    Reported-by: Robert Richter <robert.richter@amd.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4d85501..c8f7fb6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -287,7 +287,7 @@ config X86_VOYAGER
 
 config X86_VISWS
 	bool "SGI 320/540 (Visual Workstation)"
-	depends on X86_32 && !PCI
+	depends on X86_32 && PCI
 	help
 	  The SGI Visual Workstation series is an IA32-based workstation
 	  based on SGI systems chips with some legacy PC hardware attached.
@@ -359,7 +359,7 @@ config X86_RDC321X
 config X86_VSMP
 	bool "Support for ScaleMP vSMP"
 	select PARAVIRT
-	depends on X86_64 && !PCI
+	depends on X86_64 && PCI
 	help
 	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
 	  supposed to run on these EM64T-based machines.  Only choose this option

