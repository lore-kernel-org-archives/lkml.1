Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbZBYM4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbZBYM4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 07:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZBYM4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 07:56:24 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:1881 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZBYM4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 07:56:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Ha7igzvI0RBikgf2+EN2l3UWnau1p5FvQ5EEWpSsIGGK2jW01Pnf49wO2nhhB4vnQ+
         X3dt+bHRPI63S7uu9P8WTg8QEfEIPD8Ftsas+mJJsk/PzqfpWOWRXbPGUiEnsW4zoE6Q
         lWVMwYi8F91f6Oee69BuiXTNPS8uVwf2GROB0=
Message-ID: <49A53FF5.1020509@gmail.com>
Date: Wed, 25 Feb 2009 13:56:21 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: dan.j.williams@intel.com
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] iop-adma, dmaengine: misplaced curly brackets?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I observed this by code inspection, and it was not tested in any way,
but aren't the curly brackets below wrong?

please review.
------------------------------>8-------------8<---------------------------------
Misplaced curly brackets.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/dma/iop-adma.c |   16 ++++++++--------
 drivers/dma/mv_xor.c   |   16 ++++++++--------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index ea5440d..4131ab8 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -928,19 +928,19 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 
 	for (src_idx = 0; src_idx < IOP_ADMA_NUM_SRC_TEST; src_idx++) {
 		xor_srcs[src_idx] = alloc_page(GFP_KERNEL);
-		if (!xor_srcs[src_idx])
-			while (src_idx--) {
+		if (!xor_srcs[src_idx]) {
+			while (src_idx--)
 				__free_page(xor_srcs[src_idx]);
-				return -ENOMEM;
-			}
+			return -ENOMEM;
+		}
 	}
 
 	dest = alloc_page(GFP_KERNEL);
-	if (!dest)
-		while (src_idx--) {
+	if (!dest) {
+		while (src_idx--)
 			__free_page(xor_srcs[src_idx]);
-			return -ENOMEM;
-		}
+		return -ENOMEM;
+	}
 
 	/* Fill in src buffers */
 	for (src_idx = 0; src_idx < IOP_ADMA_NUM_SRC_TEST; src_idx++) {
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index d35cbd1..2a4e3e3 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1019,19 +1019,19 @@ mv_xor_xor_self_test(struct mv_xor_device *device)
 
 	for (src_idx = 0; src_idx < MV_XOR_NUM_SRC_TEST; src_idx++) {
 		xor_srcs[src_idx] = alloc_page(GFP_KERNEL);
-		if (!xor_srcs[src_idx])
-			while (src_idx--) {
+		if (!xor_srcs[src_idx]) {
+			while (src_idx--)
 				__free_page(xor_srcs[src_idx]);
-				return -ENOMEM;
-			}
+			return -ENOMEM;
+		}
 	}
 
 	dest = alloc_page(GFP_KERNEL);
-	if (!dest)
-		while (src_idx--) {
+	if (!dest) {
+		while (src_idx--)
 			__free_page(xor_srcs[src_idx]);
-			return -ENOMEM;
-		}
+		return -ENOMEM;
+	}
 
 	/* Fill in src buffers */
 	for (src_idx = 0; src_idx < MV_XOR_NUM_SRC_TEST; src_idx++) {
