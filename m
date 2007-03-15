Return-Path: <linux-kernel-owner+w=401wt.eu-S965275AbXCOFUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965275AbXCOFUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965389AbXCOFRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:17:37 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:47870 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965275AbXCOFQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:16:56 -0400
Message-Id: <20070315051531.526287109@goodmis.org>
References: <20070315051337.488091591@goodmis.org>
User-Agent: quilt/0.45-1
Date: Thu, 15 Mar 2007 01:13:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH take3 11/20] pcspeaker.c switch
Content-Disposition: inline; filename=12-pcspeaker.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the pcspeaker.c to the common area.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/i386/kernel/Makefile b/arch/i386/kernel/Makefile
index ac925bc..ce1f742 100644
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -37,7 +37,6 @@ obj-$(CONFIG_K8_NB)		+= k8.o
 
 obj-$(CONFIG_VMI)		+= vmi.o vmitime.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
-obj-y				+= pcspeaker.o
 
 EXTRA_AFLAGS   := -traditional
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index f1c6b2e..3e15c9e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -5,6 +5,8 @@ obj-$(CONFIG_X86_CPUID)		+= cpuid.o
 obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
+obj-y				+= pcspeaker.o
+
 # i386 defines CONFIG_X86_SMP when CONFIG_SMP and !CONFIG_X86_VOYAGER
 ifeq ($(CONFIG_X86_VOYAGER), )
 obj-$(CONFIG_SMP)		+= tsc_sync.o
diff --git a/arch/i386/kernel/pcspeaker.c b/arch/x86/kernel/pcspeaker.c
similarity index 100%
rename from arch/i386/kernel/pcspeaker.c
rename to arch/x86/kernel/pcspeaker.c
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index 08795d8..3fae694 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -38,10 +38,8 @@ obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
 
 obj-y				+= intel_cacheinfo.o
-obj-y				+= pcspeaker.o
 
 CFLAGS_vsyscall.o		:= $(PROFILING) -g0
 
 therm_throt-y                   += ../../i386/kernel/cpu/mcheck/therm_throt.o
 intel_cacheinfo-y		+= ../../i386/kernel/cpu/intel_cacheinfo.o
-pcspeaker-y			+= ../../i386/kernel/pcspeaker.o

--
