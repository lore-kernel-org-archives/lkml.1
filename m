Return-Path: <linux-kernel-owner+w=401wt.eu-S1751938AbYGYPMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbYGYPMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbYGYPMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:12:45 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:7434 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbYGYPMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:12:44 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K4KI8W-04-38E-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] introduce lower_32_bits() macro
Date: Fri, 25 Jul 2008 17:12:27 +0200
Message-ID: <1216998747-16896-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 25 Jul 2008 15:12:27.0576 (UTC) FILETIME=[D9A86380:01C8EE68]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file kernel.h contains the upper_32_bits macro. This patch adds the other
part, the lower_32_bits macro. Its first use will be in the driver for AMD
IOMMU.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/kernel.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f9cd7a5..6fd2977 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -73,6 +73,12 @@ extern const char linux_proc_banner[];
  */
 #define upper_32_bits(n) ((u32)(((n) >> 16) >> 16))
 
+/**
+ * lower_32_bits - return bits 0-31 of a number
+ * @n: the number we're accessing
+ */
+#define lower_32_bits(n) ((n) & 0xffffffffULL)
+
 #define	KERN_EMERG	"<0>"	/* system is unusable			*/
 #define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/
 #define	KERN_CRIT	"<2>"	/* critical conditions			*/
-- 
1.5.3.7


