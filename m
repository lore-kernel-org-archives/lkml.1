Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbYF0SVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbYF0SVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758190AbYF0SUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:20:50 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11656 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757122AbYF0SUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:20:49 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jun 2008 14:20:49 EDT
Date: Fri, 27 Jun 2008 12:12:58 -0600
From: dougthompson@xmission.com
To: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 2/13] EDAC i5100 fix missing bits
Message-ID: <48652daa.4DTBp46e9JmWLicv%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Arthur Jones <ajones@riverbed.com>

Applied to linux-2.6.26-rc5-mm3

Patch to thenew i5100_edac module.

The error mask we use to trigger ECC notifications
is missing many bits of interest.  We add these
bits here so that all possible ECC errors can be
reported.

Signed-off-by:	Arthur Jones <ajones@riverbed.com>
Signed-off-by:	Doug Thompson <dougthompson@xmission.com>
---
 drivers/edac/i5100_edac.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

Index: linux-2.6.26-rc5/drivers/edac/i5100_edac.c
===================================================================
--- linux-2.6.26-rc5.orig/drivers/edac/i5100_edac.c
+++ linux-2.6.26-rc5/drivers/edac/i5100_edac.c
@@ -52,12 +52,24 @@
 #define		I5100_FERR_NF_MEM_M16ERR_MASK	(1 << 16)
 #define		I5100_FERR_NF_MEM_M15ERR_MASK	(1 << 15)
 #define		I5100_FERR_NF_MEM_M14ERR_MASK	(1 << 14)
-#define		I5100_FERR_NF_MEM_
-#define		I5100_FERR_NF_MEM_
+#define		I5100_FERR_NF_MEM_M12ERR_MASK	(1 << 12)
+#define		I5100_FERR_NF_MEM_M11ERR_MASK	(1 << 11)
+#define		I5100_FERR_NF_MEM_M10ERR_MASK	(1 << 10)
+#define		I5100_FERR_NF_MEM_M6ERR_MASK	(1 << 6)
+#define		I5100_FERR_NF_MEM_M5ERR_MASK	(1 << 5)
+#define		I5100_FERR_NF_MEM_M4ERR_MASK	(1 << 4)
+#define		I5100_FERR_NF_MEM_M1ERR_MASK	1
 #define		I5100_FERR_NF_MEM_ANY_MASK	\
 			(I5100_FERR_NF_MEM_M16ERR_MASK | \
 			I5100_FERR_NF_MEM_M15ERR_MASK | \
-			I5100_FERR_NF_MEM_M14ERR_MASK)
+			I5100_FERR_NF_MEM_M14ERR_MASK | \
+			I5100_FERR_NF_MEM_M12ERR_MASK | \
+			I5100_FERR_NF_MEM_M11ERR_MASK | \
+			I5100_FERR_NF_MEM_M10ERR_MASK | \
+			I5100_FERR_NF_MEM_M6ERR_MASK | \
+			I5100_FERR_NF_MEM_M5ERR_MASK | \
+			I5100_FERR_NF_MEM_M4ERR_MASK | \
+			I5100_FERR_NF_MEM_M1ERR_MASK)
 #define		I5100_FERR_NF_MEM_ANY(a)  ((a) & I5100_FERR_NF_MEM_ANY_MASK)
 #define	I5100_NERR_NF_MEM	0xa4	/* MC Next Non-Fatal Errors */
 #define		I5100_NERR_NF_MEM_ANY(a)  I5100_FERR_NF_MEM_ANY(a)
