Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbYIWNkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbYIWNkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbYIWNjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:39:54 -0400
Received: from [165.204.77.10] ([165.204.77.10]:48982 "EHLO elemente.amd.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751141AbYIWNjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:39:54 -0400
Message-Id: <200809231436.m8NEaNlM030319@elemente.amd.com>
In-Reply-To: <b647ffbd0809230212s41d2ef90u2915e40128b254e3@mail.gmail.com>
References: <b647ffbd0809230212s41d2ef90u2915e40128b254e3@mail.gmail.com>
From: Peter Oruba <peter.oruba@amd.com>
Date: Wed, 17 Sep 2008 15:39:18 +0200
Subject: [RESEND] [PATCH] x86, microcode rework, v2, renaming cont.
To: Ingo Molnar <mingo@elte.hu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renaming based on patch from Dmitry Adamushko.

Further clarification by renaming define and variable related to
microcode container file.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>


---
 arch/x86/kernel/microcode_amd.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 8d97840..113be63 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -233,21 +233,20 @@ static void * get_next_ucode(u8 *buf, unsigned int size,
 			unsigned int *mc_size)
 {
 	unsigned int total_size;
-#define UCODE_UNKNOWN_HDR	8
-	u8 hdr[UCODE_UNKNOWN_HDR];
+#define UCODE_CONTAINER_SECTION_HDR	8
+	u8 section_hdr[UCODE_CONTAINER_SECTION_HDR];
 	void *mc;
 
-	if (get_ucode_data(hdr, buf, UCODE_UNKNOWN_HDR))
+	if (get_ucode_data(section_hdr, buf, UCODE_CONTAINER_SECTION_HDR))
 		return NULL;
 
-	if (hdr[0] != UCODE_UCODE_TYPE) {
+	if (section_hdr[0] != UCODE_UCODE_TYPE) {
 		printk(KERN_ERR "microcode: error! "
 		       "Wrong microcode payload type field\n");
 		return NULL;
 	}
 
-	/* FIXME! dimm: Why not by means of get_totalsize(hdr)? */
-	total_size = (unsigned long) (hdr[4] + (hdr[5] << 8));
+	total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));
 
 	printk(KERN_INFO "microcode: size %u, total_size %u\n",
 		size, total_size);
@@ -260,13 +259,13 @@ static void * get_next_ucode(u8 *buf, unsigned int size,
 	mc = vmalloc(UCODE_MAX_SIZE);
 	if (mc) {
 		memset(mc, 0, UCODE_MAX_SIZE);
-		if (get_ucode_data(mc, buf + UCODE_UNKNOWN_HDR, total_size)) {
+		if (get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR, total_size)) {
 			vfree(mc);
 			mc = NULL;
 		} else
-			*mc_size = total_size + UCODE_UNKNOWN_HDR;
+			*mc_size = total_size + UCODE_CONTAINER_SECTION_HDR;
 	}
-#undef UCODE_UNKNOWN_HDR
+#undef UCODE_CONTAINER_SECTION_HDR
 	return mc;
 }
 
-- 
1.5.4.1

