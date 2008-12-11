Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbYLKQv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbYLKQv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbYLKQtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:49:00 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:20558 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142AbYLKQs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:48:58 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KBQ1D6-02-VMT-01
From: Robert Richter <robert.richter@amd.com>
To: oprofile-list <oprofile-list@lists.sourceforge.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 05/10] x86/oprofile: reordering IBS code in op_model_amd.c
Date: Thu, 11 Dec 2008 16:04:41 +0100
Message-ID: <1229007886-14362-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
References: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:26.0854 (UTC) FILETIME=[49DFB860:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of the cpu buffer rework.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index f71bd21..8ff657b 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -376,18 +376,7 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 	}
 }
 
-#ifndef CONFIG_OPROFILE_IBS
-
-/* no IBS support */
-
-static int op_amd_init(struct oprofile_operations *ops)
-{
-	return 0;
-}
-
-static void op_amd_exit(void) {}
-
-#else
+#ifdef CONFIG_OPROFILE_IBS
 
 static u8 ibs_eilvt_off;
 
@@ -531,7 +520,18 @@ static void op_amd_exit(void)
 	clear_ibs_nmi();
 }
 
-#endif
+#else
+
+/* no IBS support */
+
+static int op_amd_init(struct oprofile_operations *ops)
+{
+	return 0;
+}
+
+static void op_amd_exit(void) {}
+
+#endif /* CONFIG_OPROFILE_IBS */
 
 struct op_x86_model_spec const op_amd_spec = {
 	.init			= op_amd_init,
-- 
1.6.0.1


