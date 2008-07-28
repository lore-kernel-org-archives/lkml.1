Return-Path: <linux-kernel-owner+w=401wt.eu-S1759949AbYG1Qte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949AbYG1Qte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbYG1Qqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:46:52 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:59370 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314AbYG1Qqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:46:50 -0400
X-BigFish: VPS7(zz1cddkzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K4Q6LG-01-PPV-01
Message-ID: <20080728164448.966984698@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 28 Jul 2008 18:44:19 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [patch 08/11] [PATCH 08/11] x86: Add AMD specific declarations.
References: <20080728164411.490752571@amd.com>
Content-Disposition: inline;
	filename="0008-x86-Add-AMD-specific-declarations.patch"
X-OriginalArrivalTime: 28 Jul 2008 16:46:29.0653 (UTC) FILETIME=[7BD64450:01C8F0D1]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added AMD specific declarations to header file.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 include/asm-x86/microcode.h |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/microcode.h b/include/asm-x86/microcode.h
index ef77c6f..4e94172 100644
--- a/include/asm-x86/microcode.h
+++ b/include/asm-x86/microcode.h
@@ -30,6 +30,35 @@ struct extended_sigtable {
 	struct extended_signature sigs[0];
 };
 
+struct equiv_cpu_entry {
+	unsigned int installed_cpu;
+	unsigned int fixed_errata_mask;
+	unsigned int fixed_errata_compare;
+	unsigned int equiv_cpu;
+};
+
+struct microcode_header_amd {
+	unsigned int  data_code;
+	unsigned int  patch_id;
+	unsigned char mc_patch_data_id[2];
+	unsigned char mc_patch_data_len;
+	unsigned char init_flag;
+	unsigned int  mc_patch_data_checksum;
+	unsigned int  nb_dev_id;
+	unsigned int  sb_dev_id;
+	unsigned char processor_rev_id[2];
+	unsigned char nb_rev_id;
+	unsigned char sb_rev_id;
+	unsigned char bios_api_rev;
+	unsigned char reserved1[3];
+	unsigned int  match_reg[8];
+};
+
+struct microcode_amd {
+	struct microcode_header_amd hdr;
+	unsigned int mpb[0];
+};
+
 struct ucode_cpu_info {
 	int valid;
 	unsigned int sig;
@@ -37,5 +66,6 @@ struct ucode_cpu_info {
 	unsigned int rev;
 	union {
 		struct microcode_intel *mc_intel;
+		struct microcode_amd *mc_amd;
 	} mc;
 };
-- 
1.5.4.5




