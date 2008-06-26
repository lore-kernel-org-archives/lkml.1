Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbYFZBDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbYFZBDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbYFZBBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:01:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:2779 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbYFZBBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=X/3n51VRDhLxHXTyJ2Yg+z97PcUMUJwwYzSZxdtRozEVzv1g5eDIA2763tgFHjujn+
         7utq4Y0IpcW2wemi4pXOxAWMzv3psgfzOoPG2dm1vJrEQrVSC1yyMuHcs3ZFDyAU0opQ
         SvzET6IEPAuwtW0O/VrQzH0mHUNZwTGK7Ymow=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 05/16] x86: add extra includes for 64bit support
Date: Wed, 25 Jun 2008 17:51:29 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com>
In-Reply-To: <200806251748.06743.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251751.29483.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -45,31 +45,75 @@
 #include <linux/dmi.h>
 #include <linux/pfn.h>
 #include <linux/pci.h>
+#include <asm/pci-direct.h>
 #include <linux/init_ohci1394_dma.h>
 #include <linux/kvm_para.h>
 
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/stddef.h>
+#include <linux/unistd.h>
+#include <linux/ptrace.h>
+#include <linux/slab.h>
+#include <linux/user.h>
+#include <linux/delay.h>
+#include <linux/highmem.h>
+
+#include <linux/kallsyms.h>
+#include <linux/edd.h>
+#include <linux/iscsi_ibft.h>
+#include <linux/kexec.h>
+#include <linux/cpufreq.h>
+#include <linux/dma-mapping.h>
+#include <linux/ctype.h>
+#include <linux/uaccess.h>
+
+#include <linux/percpu.h>
+#include <linux/crash_dump.h>
+
 #include <video/edid.h>
 
 #include <asm/mtrr.h>
 #include <asm/apic.h>
 #include <asm/e820.h>
 #include <asm/mpspec.h>
-#include <asm/mmzone.h>
 #include <asm/setup.h>
 #include <asm/arch_hooks.h>
 #include <asm/sections.h>
 #include <asm/dmi.h>
 #include <asm/io_apic.h>
 #include <asm/ist.h>
-#include <asm/io.h>
 #include <asm/vmi.h>
 #include <setup_arch.h>
 #include <asm/bios_ebda.h>
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
-#include <asm/efi.h>
 #include <asm/bugs.h>
 
+#include <asm/system.h>
+#include <asm/vsyscall.h>
+#include <asm/smp.h>
+#include <asm/desc.h>
+#include <asm/dma.h>
+#include <asm/gart.h>
+#include <asm/mmu_context.h>
+#include <asm/proto.h>
+
+#include <mach_apic.h>
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define ARCH_SETUP
+#endif
+
+#include <asm/percpu.h>
+#include <asm/sections.h>
+#include <asm/topology.h>
+#include <asm/apicdef.h>
+#ifdef CONFIG_X86_32
+#include <asm/highmem.h>
+#endif
+
 /* This value is set up by the early boot code to point to the value
    immediately after the boot time page tables.  It contains a *physical*
    address, and must not be in the .bss segment! */
