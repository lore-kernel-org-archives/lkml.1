Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZAZGR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZAZGR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 01:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZAZGPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 01:15:43 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:50781 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbZAZGPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 01:15:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aCFWSM0HFkMJxAIGjmnmpzqEqioiqAqulv1IaByvM+iJFe0S8B4Y4CwMARAKxxQJAz
         MQbZjqTHa5+xOo4E122VYJlnc+h89beMEdJzF9xHNWZzvcZXRJts1S2bCnWODL/FmWxF
         ldGiCz6/KnoG1oKDyzdamKuEmKGoMNG9pAqzk=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] x86: Only compile setup_percpu.o on SMP
Date: Mon, 26 Jan 2009 01:15:26 -0500
Message-Id: <1232950532-22923-6-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
References: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Minor build optimization

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/Makefile       |    3 ++-
 arch/x86/kernel/setup_percpu.c |    6 ------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index a99437c..73de055 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -28,7 +28,7 @@ CFLAGS_paravirt.o	:= $(nostackp)
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time_$(BITS).o ioport.o ldt.o dumpstack.o
-obj-y			+= setup.o i8259.o irqinit_$(BITS).o setup_percpu.o
+obj-y			+= setup.o i8259.o irqinit_$(BITS).o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
@@ -59,6 +59,7 @@ apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_X86_SMP)		+= smp.o
 obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o ipi.o
+obj-$(CONFIG_SMP)		+= setup_percpu.o
 obj-$(CONFIG_X86_32_SMP)	+= smpcommon.o
 obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index d367996..f30ff69 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -22,14 +22,8 @@
 # define DBG(x...)
 #endif
 
-/*
- * Could be inside CONFIG_HAVE_SETUP_PER_CPU_AREA with other stuff but
- * voyager wants cpu_number too.
- */
-#ifdef CONFIG_SMP
 DEFINE_PER_CPU(int, cpu_number);
 EXPORT_PER_CPU_SYMBOL(cpu_number);
-#endif
 
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 
-- 
1.6.1

