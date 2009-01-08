Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbZAHKPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbZAHKPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZAHKPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:15:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:48848 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZAHKPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:15:05 -0500
Subject: [PATCH -tip 1/2] x86: rename intel_mp_floating to mpf_intel
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 15:42:46 +0530
Message-Id: <1231409566.7119.5.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, solve 80 columns wrap problems

intel_mp_floating should be renamed to mpf_intel.
The reason: the 'f' in MPF already means 'floating'
which means MP Floating pointer structure -
no need to repeat that in the type name.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/mpspec_def.h |    3 ++-
 arch/x86/kernel/mpparse.c         |   12 ++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index 59568bc..187dc92 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -24,7 +24,8 @@
 # endif
 #endif
 
-struct intel_mp_floating {
+/* Intel MP Floating Pointer Structure */
+struct mpf_intel {
 	char mpf_signature[4];		/* "_MP_"			*/
 	unsigned int mpf_physptr;	/* Configuration table address	*/
 	unsigned char mpf_length;	/* Our length (paragraphs)	*/
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index c0601c2..6cea941 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -569,14 +569,14 @@ static inline void __init construct_default_ISA_mptable(int mpc_default_type)
 	}
 }
 
-static struct intel_mp_floating *mpf_found;
+static struct mpf_intel *mpf_found;
 
 /*
  * Scan the memory blocks for an SMP configuration block.
  */
 static void __init __get_smp_config(unsigned int early)
 {
-	struct intel_mp_floating *mpf = mpf_found;
+	struct mpf_intel *mpf = mpf_found;
 
 	if (!mpf)
 		return;
@@ -687,14 +687,14 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 				  unsigned reserve)
 {
 	unsigned int *bp = phys_to_virt(base);
-	struct intel_mp_floating *mpf;
+	struct mpf_intel *mpf;
 
 	apic_printk(APIC_VERBOSE, "Scan SMP from %p for %ld bytes.\n",
 			bp, length);
 	BUILD_BUG_ON(sizeof(*mpf) != 16);
 
 	while (length > 0) {
-		mpf = (struct intel_mp_floating *)bp;
+		mpf = (struct mpf_intel *)bp;
 		if ((*bp == SMP_MAGIC_IDENT) &&
 		    (mpf->mpf_length == 1) &&
 		    !mpf_checksum((unsigned char *)bp, 16) &&
@@ -1000,7 +1000,7 @@ static int __init update_mp_table(void)
 {
 	char str[16];
 	char oem[10];
-	struct intel_mp_floating *mpf;
+	struct mpf_intel *mpf;
 	struct mpc_table *mpc, *mpc_new;
 
 	if (!enable_update_mptable)
@@ -1052,7 +1052,7 @@ static int __init update_mp_table(void)
 		mpc = mpc_new;
 		/* check if we can modify that */
 		if (mpc_new_phys - mpf->mpf_physptr) {
-			struct intel_mp_floating *mpf_new;
+			struct mpf_intel *mpf_new;
 			/* steal 16 bytes from [0, 1k) */
 			printk(KERN_INFO "mpf new: %x\n", 0x400 - 16);
 			mpf_new = phys_to_virt(0x400 - 16);
-- 
1.5.6.6



