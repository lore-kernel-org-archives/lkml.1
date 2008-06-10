Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYFJLsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYFJLsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 07:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYFJLsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 07:48:43 -0400
Received: from mail.bencastricum.nl ([213.84.203.196]:44449 "EHLO
	bencastricum.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbYFJLsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 07:48:42 -0400
X-Greylist: delayed 1426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jun 2008 07:48:41 EDT
Date: Tue, 10 Jun 2008 13:15:12 +0200 (CEST)
From: Ben Castricum <lk0806@bencastricum.nl>
X-X-Sender: benc@gateway.bencastricum.nl
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org
Subject: [patch] x86: microcode: Cosmetic changes
Message-ID: <alpine.LNX.1.10.0806101312170.14868@gateway.bencastricum.nl>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


First announce ourself, then start working. Currently this module reports 
itself when all is completed which is not most modules do. Plus some 
cosmetic/whitespace cleanups.

Signed-off-by: Ben Castricum <lk0806@bencastricum.nl>
---

diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 69729e3..8ce70ac 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -5,13 +5,14 @@
  *		      2006	Shaohua Li <shaohua.li@intel.com>
  *
  *	This driver allows to upgrade microcode on Intel processors
- *	belonging to IA-32 family - PentiumPro, Pentium II, 
+ *	belonging to IA-32 family - PentiumPro, Pentium II,
  *	Pentium III, Xeon, Pentium 4, etc.
  *
- *	Reference: Section 8.10 of Volume III, Intel Pentium 4 Manual, 
- *	Order Number 245472 or free download from:
- *		
- *	http://developer.intel.com/design/pentium4/manuals/245472.htm
+ *	Reference: Section 8.11 of Volume 3a, IA-32 Intel? Architecture
+ *	Software Developer's Manual
+ *	Order Number 253668 or free download from:
+ *
+ *	http://developer.intel.com/design/pentium4/manuals/253668.htm
  *
  *	For more information, go to http://www.urbanmyth.org/microcode
  *
@@ -58,12 +59,12 @@
  *		nature of implementation.
  *	1.11	22 Mar 2002 Tigran Aivazian <tigran@veritas.com>
  *		Fix the panic when writing zero-length microcode chunk.
- *	1.12	29 Sep 2003 Nitin Kamble <nitin.a.kamble@intel.com>, 
+ *	1.12	29 Sep 2003 Nitin Kamble <nitin.a.kamble@intel.com>,
  *		Jun Nakajima <jun.nakajima@intel.com>
  *		Support for the microcode updates in the new format.
  *	1.13	10 Oct 2003 Tigran Aivazian <tigran@veritas.com>
  *		Removed ->read() method and obsoleted MICROCODE_IOCFREE ioctl
- *		because we no longer hold a copy of applied microcode 
+ *		because we no longer hold a copy of applied microcode
  *		in kernel memory.
  *	1.14	25 Jun 2004 Tigran Aivazian <tigran@veritas.com>
  *		Fix sigmatch() macro to handle old CPUs with pf == 0.
@@ -320,11 +321,11 @@ static void apply_microcode(int cpu)
 		return;
 
 	/* serialize access to the physical write to MSR 0x79 */
-	spin_lock_irqsave(&microcode_update_lock, flags);          
+	spin_lock_irqsave(&microcode_update_lock, flags);
 
 	/* write microcode via MSR 0x79 */
 	wrmsr(MSR_IA32_UCODE_WRITE,
-		(unsigned long) uci->mc->bits, 
+		(unsigned long) uci->mc->bits,
 		(unsigned long) uci->mc->bits >> 16 >> 16);
 	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
 
@@ -341,7 +342,7 @@ static void apply_microcode(int cpu)
 		return;
 	}
 	printk(KERN_INFO "microcode: CPU%d updated from revision "
-	       "0x%x to 0x%x, date = %08x \n", 
+	       "0x%x to 0x%x, date = %08x \n",
 	       cpu_num, uci->rev, val[1], uci->mc->hdr.date);
 	uci->rev = val[1];
 }
@@ -534,7 +535,7 @@ static int cpu_request_microcode(int cpu
 		c->x86, c->x86_model, c->x86_mask);
 	error = request_firmware(&firmware, name, &microcode_pdev->dev);
 	if (error) {
-		pr_debug("microcode: ucode data file %s load failed\n", name);
+		pr_debug("microcode: data file %s load failed\n", name);
 		return error;
 	}
 	buf = firmware->data;
@@ -805,6 +806,9 @@ static int __init microcode_init (void)
 {
 	int error;
 
+	printk(KERN_INFO
+		"IA-32 Microcode Update Driver: v" MICROCODE_VERSION " <tigran@aivazian.fsnet.co.uk>\n");
+
 	error = microcode_dev_init();
 	if (error)
 		return error;
@@ -825,9 +829,6 @@ static int __init microcode_init (void)
 	}
 
 	register_hotcpu_notifier(&mc_cpu_notifier);
-
-	printk(KERN_INFO 
-		"IA-32 Microcode Update Driver: v" MICROCODE_VERSION " <tigran@aivazian.fsnet.co.uk>\n");
 	return 0;
 }
 
