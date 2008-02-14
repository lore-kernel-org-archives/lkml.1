Return-Path: <linux-kernel-owner+w=401wt.eu-S934229AbYBNVYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934229AbYBNVYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756888AbYBNVX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:23:58 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45084 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388AbYBNVX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:23:58 -0500
Date: Thu, 14 Feb 2008 23:23:37 +0200
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove mca-pentium
Message-ID: <20080214212337.GC23227@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the mca-pentium boot option that was a noop.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/kernel-parameters.txt |    2 --
 arch/x86/kernel/cpu/bugs.c          |    8 --------
 arch/x86/kernel/setup_32.c          |    1 -
 include/asm-x86/processor.h         |    1 -
 4 files changed, 12 deletions(-)

99ed2026b816535de14fb6bc0365ac22a02316dc diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a4fc7fc..7278295 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1056,8 +1056,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			[SCSI] Maximum number of LUNs received.
 			Should be between 1 and 16384.
 
-	mca-pentium	[BUGS=X86-32]
-
 	mcatest=	[IA-64]
 
 	mce		[X86-32] Machine Check Exception
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 9b95edc..027e5c0 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -25,14 +25,6 @@ static int __init no_halt(char *s)
 
 __setup("no-hlt", no_halt);
 
-static int __init mca_pentium(char *s)
-{
-	mca_pentium_flag = 1;
-	return 1;
-}
-
-__setup("mca-pentium", mca_pentium);
-
 static int __init no_387(char *s)
 {
 	boot_cpu_data.hard_math = 0;
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 691ab4c..a1d7071 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -164,7 +164,6 @@ unsigned long mmu_cr4_features = X86_CR4_PAE;
 unsigned int machine_id;
 unsigned int machine_submodel_id;
 unsigned int BIOS_revision;
-unsigned int mca_pentium_flag;
 
 /* Boot loader ID as an integer, for the benefit of proc_dointvec */
 int bootloader_type;
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 149920d..7b1ca1f 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -671,7 +671,6 @@ extern void init_gdt(int cpu);
 extern unsigned int machine_id;
 extern unsigned int machine_submodel_id;
 extern unsigned int BIOS_revision;
-extern unsigned int mca_pentium_flag;
 
 /* Boot loader type from the setup header */
 extern int bootloader_type;

