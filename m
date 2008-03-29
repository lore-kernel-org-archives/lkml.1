Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbYC2DOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbYC2DOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760403AbYC2DLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:11:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58365 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760396AbYC2DK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:10:59 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] mfd/asic3: ioread/iowrite take pointer, not unsigned long
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1JfRT8-00032E-Lp@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:10:58 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/mfd/asic3.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 63fb1ff..f6f2d96 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -28,14 +28,14 @@
 static inline void asic3_write_register(struct asic3 *asic,
 				 unsigned int reg, u32 value)
 {
-	iowrite16(value, (unsigned long)asic->mapping +
+	iowrite16(value, asic->mapping +
 		  (reg >> asic->bus_shift));
 }
 
 static inline u32 asic3_read_register(struct asic3 *asic,
 			       unsigned int reg)
 {
-	return ioread16((unsigned long)asic->mapping +
+	return ioread16(asic->mapping +
 			(reg >> asic->bus_shift));
 }
 
-- 
1.5.3.GIT


