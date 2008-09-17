Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbYIWNkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbYIWNkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYIWNj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:39:58 -0400
Received: from [165.204.77.10] ([165.204.77.10]:48984 "EHLO elemente.amd.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751661AbYIWNj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:39:57 -0400
Message-Id: <200809231436.m8NEaMK0030314@elemente.amd.com>
In-Reply-To: <b647ffbd0809230212s41d2ef90u2915e40128b254e3@mail.gmail.com>
References: <b647ffbd0809230212s41d2ef90u2915e40128b254e3@mail.gmail.com>
From: Peter Oruba <peter.oruba@amd.com>
Date: Wed, 17 Sep 2008 15:05:52 +0200
Subject: [RESEND] [PATCH] x86, microcode rework, v2, renaming
To: Ingo Molnar <mingo@elte.hu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renaming based on patch from Dmitry Adamushko.

Made code more readable by renaming define and variables related
to microcode _container_file_ header to make it distinguishable from
microcode _patch_ header.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>



---
 arch/x86/kernel/microcode_amd.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 48aec9f..8d97840 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -274,12 +274,12 @@ static void * get_next_ucode(u8 *buf, unsigned int size,
 static int install_equiv_cpu_table(u8 *buf,
 		int (*get_ucode_data)(void *, const void *, size_t))
 {
-#define UCODE_HEADER_SIZE	12
-	u8 *hdr[UCODE_HEADER_SIZE];
-	unsigned int *buf_pos = (unsigned int *)hdr;
+#define UCODE_CONTAINER_HEADER_SIZE	12
+	u8 *container_hdr[UCODE_CONTAINER_HEADER_SIZE];
+	unsigned int *buf_pos = (unsigned int *)container_hdr;
 	unsigned long size;
 
-	if (get_ucode_data(&hdr, buf, UCODE_HEADER_SIZE))
+	if (get_ucode_data(&container_hdr, buf, UCODE_CONTAINER_HEADER_SIZE))
 		return 0;
 
 	size = buf_pos[2];
@@ -296,14 +296,14 @@ static int install_equiv_cpu_table(u8 *buf,
 		return 0;
 	}
 
-	buf += UCODE_HEADER_SIZE;
+	buf += UCODE_CONTAINER_HEADER_SIZE;
 	if (get_ucode_data(equiv_cpu_table, buf, size)) {
 		vfree(equiv_cpu_table);
 		return 0;
 	}
 
-	return size + UCODE_HEADER_SIZE; /* add header length */
-#undef UCODE_HEADER_SIZE
+	return size + UCODE_CONTAINER_HEADER_SIZE; /* add header length */
+#undef UCODE_CONTAINER_HEADER_SIZE
 }
 
 static void free_equiv_cpu_table(void)
-- 
1.5.4.1


