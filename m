Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbYLPSWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbYLPSWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYLPSVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:21:50 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:38870 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYLPSVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:21:49 -0500
X-BigFish: VPS3(zzzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBZEZQ-02-WDD-01
Date: Tue, 16 Dec 2008 19:21:30 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [PATCH 9/10] x86: microcode_amd: use 'packed' attribute for structs
Message-ID: <20081216182130.GP7013@alberich.amd.com>
References: <20081216180639.GG7013@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081216180639.GG7013@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Dec 2008 18:21:33.0538 (UTC) FILETIME=[1FDCCC20:01C95FAB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   45 ++++++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 2e8af6e..e1ce650 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -47,28 +47,29 @@ MODULE_LICENSE("GPL v2");
 #define UCODE_UCODE_TYPE           0x00000001
 
 struct equiv_cpu_entry {
-	unsigned int installed_cpu;
-	unsigned int fixed_errata_mask;
-	unsigned int fixed_errata_compare;
-	unsigned int equiv_cpu;
-};
+	u32	installed_cpu;
+	u32	fixed_errata_mask;
+	u32	fixed_errata_compare;
+	u16	equiv_cpu;
+	u16	res;
+} __attribute__((packed));
 
 struct microcode_header_amd {
-	unsigned int  data_code;
-	unsigned int  patch_id;
-	unsigned char mc_patch_data_id[2];
-	unsigned char mc_patch_data_len;
-	unsigned char init_flag;
-	unsigned int  mc_patch_data_checksum;
-	unsigned int  nb_dev_id;
-	unsigned int  sb_dev_id;
-	u16 processor_rev_id;
-	unsigned char nb_rev_id;
-	unsigned char sb_rev_id;
-	unsigned char bios_api_rev;
-	unsigned char reserved1[3];
-	unsigned int  match_reg[8];
-};
+	u32	data_code;
+	u32	patch_id;
+	u16	mc_patch_data_id;
+	u8	mc_patch_data_len;
+	u8	init_flag;
+	u32	mc_patch_data_checksum;
+	u32	nb_dev_id;
+	u32	sb_dev_id;
+	u16	processor_rev_id;
+	u8	nb_rev_id;
+	u8	sb_rev_id;
+	u8	bios_api_rev;
+	u8	reserved1[3];
+	u32	match_reg[8];
+} __attribute__((packed));
 
 struct microcode_amd {
 	struct microcode_header_amd hdr;
@@ -109,7 +110,7 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 {
 	struct microcode_header_amd *mc_header = mc;
 	unsigned int current_cpu_id;
-	unsigned int equiv_cpu_id = 0x00;
+	u16 equiv_cpu_id = 0;
 	unsigned int i = 0;
 
 	BUG_ON(equiv_cpu_table == NULL);
@@ -117,7 +118,7 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 
 	while (equiv_cpu_table[i].installed_cpu != 0) {
 		if (current_cpu_id == equiv_cpu_table[i].installed_cpu) {
-			equiv_cpu_id = equiv_cpu_table[i].equiv_cpu & 0xffff;
+			equiv_cpu_id = equiv_cpu_table[i].equiv_cpu;
 			break;
 		}
 		i++;
-- 
1.6.0.4



