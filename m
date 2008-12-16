Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbYLPSSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbYLPSSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYLPSSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:18:00 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:15297 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYLPSSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:18:00 -0500
X-BigFish: VPS3(zzzzzzz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBZETH-01-CX6-01
Date: Tue, 16 Dec 2008 19:17:45 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [PATCH 7/10] x86: microcode_amd: consolidate macro definitions
Message-ID: <20081216181745.GN7013@alberich.amd.com>
References: <20081216180639.GG7013@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081216180639.GG7013@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Dec 2008 18:17:48.0016 (UTC) FILETIME=[9970DF00:01C95FAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 2856955..e68e723 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -75,15 +75,9 @@ struct microcode_amd {
 	unsigned int mpb[0];
 };
 
-#define UCODE_MAX_SIZE          (2048)
-#define DEFAULT_UCODE_DATASIZE	(896)
-#define MC_HEADER_SIZE		(sizeof(struct microcode_header_amd))
-#define DEFAULT_UCODE_TOTALSIZE (DEFAULT_UCODE_DATASIZE + MC_HEADER_SIZE)
-#define DWSIZE			(sizeof(u32))
-/* For now we support a fixed ucode total size only */
-#define get_totalsize(mc) \
-	((((struct microcode_amd *)mc)->hdr.mc_patch_data_len * 28) \
-	 + MC_HEADER_SIZE)
+#define UCODE_MAX_SIZE			2048
+#define UCODE_CONTAINER_SECTION_HDR	8
+#define UCODE_CONTAINER_HEADER_SIZE	12
 
 /* serialize access to the physical write */
 static DEFINE_SPINLOCK(microcode_update_lock);
@@ -222,7 +216,6 @@ static void *get_next_ucode(const u8 *buf, unsigned int size,
 			    unsigned int *mc_size)
 {
 	unsigned int total_size;
-#define UCODE_CONTAINER_SECTION_HDR	8
 	u8 section_hdr[UCODE_CONTAINER_SECTION_HDR];
 	void *mc;
 
@@ -255,14 +248,12 @@ static void *get_next_ucode(const u8 *buf, unsigned int size,
 		} else
 			*mc_size = total_size + UCODE_CONTAINER_SECTION_HDR;
 	}
-#undef UCODE_CONTAINER_SECTION_HDR
 	return mc;
 }
 
 
 static int install_equiv_cpu_table(const u8 *buf)
 {
-#define UCODE_CONTAINER_HEADER_SIZE	12
 	u8 *container_hdr[UCODE_CONTAINER_HEADER_SIZE];
 	unsigned int *buf_pos = (unsigned int *)container_hdr;
 	unsigned long size;
@@ -291,7 +282,6 @@ static int install_equiv_cpu_table(const u8 *buf)
 	}
 
 	return size + UCODE_CONTAINER_HEADER_SIZE; /* add header length */
-#undef UCODE_CONTAINER_HEADER_SIZE
 }
 
 static void free_equiv_cpu_table(void)
-- 
1.6.0.4



