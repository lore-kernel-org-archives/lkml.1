Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbYBCKcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbYBCKcq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 05:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYBCKck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 05:32:40 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:57920 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbYBCKck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 05:32:40 -0500
Date: Sun, 3 Feb 2008 11:32:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "A.E.Lawrence" <lawrence_a_e@ntlworld.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: restore correct module name for apm
Message-ID: <20080203103213.GC20810@uranus.ravnborg.org>
References: <47A4E70D.1000607@ntlworld.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A4E70D.1000607@ntlworld.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The apm module were renamed to apm_32 during the merge of 32 and 64 bit x86 which
is unfortunate.
As apm is 32 bit specific we like to keep the _32 in the filename
but the module should be named apm.

Fix this in the Makefile.
Reported by "A.E.Lawrence" <lawrence_a_e@ntlworld.com>

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "A.E.Lawrence" <lawrence_a_e@ntlworld.com>
---

build tested only but obviously correct.

	Sam

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 6f81300..f080635 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -37,7 +37,8 @@ obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
 obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
-obj-$(CONFIG_APM)		+= apm_32.o
+apm-y				:= apm_32.o
+obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_X86_SMP)		+= smp_$(BITS).o smpboot_$(BITS).o tsc_sync.o
 obj-$(CONFIG_X86_32_SMP)	+= smpcommon_32.o
 obj-$(CONFIG_X86_64_SMP)	+= smp_64.o smpboot_64.o tsc_sync.o
