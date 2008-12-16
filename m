Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbYLPSLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbYLPSLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYLPSLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:11:38 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:41574 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYLPSLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:11:37 -0500
X-BigFish: VPS1(zzzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KBZEIW-02-VUE-01
Date: Tue, 16 Dec 2008 19:11:23 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [PATCH 3/10] x86: microcode_amd: fix checkpatch warnings/errors
Message-ID: <20081216181123.GJ7013@alberich.amd.com>
References: <20081216180639.GG7013@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081216180639.GG7013@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Dec 2008 18:11:26.0894 (UTC) FILETIME=[B64644E0:01C95FA9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 83a9fa3..a8a0ec6 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -32,9 +32,9 @@
 #include <linux/platform_device.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
+#include <linux/uaccess.h>
 
 #include <asm/msr.h>
-#include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <asm/microcode.h>
 
@@ -225,7 +225,7 @@ static void apply_microcode_amd(int cpu)
 	uci->cpu_sig.rev = rev;
 }
 
-static void * get_next_ucode(u8 *buf, unsigned int size,
+static void *get_next_ucode(u8 *buf, unsigned int size,
 			int (*get_ucode_data)(void *, const void *, size_t),
 			unsigned int *mc_size)
 {
@@ -256,7 +256,8 @@ static void * get_next_ucode(u8 *buf, unsigned int size,
 	mc = vmalloc(UCODE_MAX_SIZE);
 	if (mc) {
 		memset(mc, 0, UCODE_MAX_SIZE);
-		if (get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR, total_size)) {
+		if (get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR,
+				   total_size)) {
 			vfree(mc);
 			mc = NULL;
 		} else
@@ -332,7 +333,8 @@ static int generic_load_microcode(int cpu, void *data, size_t size,
 		unsigned int uninitialized_var(mc_size);
 		struct microcode_header_amd *mc_header;
 
-		mc = get_next_ucode(ucode_ptr, leftover, get_ucode_data, &mc_size);
+		mc = get_next_ucode(ucode_ptr, leftover, get_ucode_data,
+				    &mc_size);
 		if (!mc)
 			break;
 
@@ -342,7 +344,7 @@ static int generic_load_microcode(int cpu, void *data, size_t size,
 				vfree(new_mc);
 			new_rev = mc_header->patch_id;
 			new_mc  = mc;
-		} else 
+		} else
 			vfree(mc);
 
 		ucode_ptr += mc_size;
@@ -354,9 +356,9 @@ static int generic_load_microcode(int cpu, void *data, size_t size,
 			if (uci->mc)
 				vfree(uci->mc);
 			uci->mc = new_mc;
-			pr_debug("microcode: CPU%d found a matching microcode update with"
-				" version 0x%x (current=0x%x)\n",
-				cpu, new_rev, uci->cpu_sig.rev);
+			pr_debug("microcode: CPU%d found a matching microcode "
+				 "update with version 0x%x (current=0x%x)\n",
+				 cpu, new_rev, uci->cpu_sig.rev);
 		} else
 			vfree(new_mc);
 	}
@@ -383,7 +385,8 @@ static int request_microcode_fw(int cpu, struct device *device)
 
 	ret = request_firmware(&firmware, fw_name, device);
 	if (ret) {
-		printk(KERN_ERR "microcode: ucode data file %s load failed\n", fw_name);
+		printk(KERN_ERR "microcode: ucode data file %s load failed\n",
+		       fw_name);
 		return ret;
 	}
 
@@ -397,8 +400,8 @@ static int request_microcode_fw(int cpu, struct device *device)
 
 static int request_microcode_user(int cpu, const void __user *buf, size_t size)
 {
-	printk(KERN_WARNING "microcode: AMD microcode update via /dev/cpu/microcode"
-			"is not supported\n");
+	printk(KERN_WARNING "microcode: AMD microcode update via "
+	       "/dev/cpu/microcode is not supported\n");
 	return -1;
 }
 
-- 
1.6.0.4



