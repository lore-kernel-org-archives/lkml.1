Return-Path: <linux-kernel-owner+w=401wt.eu-S1760769AbYC2DMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760769AbYC2DMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760179AbYC2DKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:10:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50149 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759408AbYC2DJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:09:59 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] drivers/crypto/hifn_795x.c trivial endianness annotations
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1JfRSA-0002uH-Kq@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:09:58 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


NB: remaining endianness warnings in the file are, AFAICS, real bugs.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/crypto/hifn_795x.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 3110bf7..81f3f95 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -392,8 +392,8 @@ static atomic_t hifn_dev_number;
 
 struct hifn_desc
 {
-	volatile u32		l;
-	volatile u32		p;
+	volatile __le32		l;
+	volatile __le32		p;
 };
 
 struct hifn_dma {
@@ -481,10 +481,10 @@ struct hifn_device
 
 struct hifn_base_command
 {
-	volatile u16		masks;
-	volatile u16		session_num;
-	volatile u16		total_source_count;
-	volatile u16		total_dest_count;
+	volatile __le16		masks;
+	volatile __le16		session_num;
+	volatile __le16		total_source_count;
+	volatile __le16		total_dest_count;
 };
 
 #define	HIFN_BASE_CMD_COMP		0x0100	/* enable compression engine */
@@ -504,10 +504,10 @@ struct hifn_base_command
  */
 struct hifn_crypt_command
 {
-	volatile u16 		masks;
-	volatile u16 		header_skip;
-	volatile u16 		source_count;
-	volatile u16 		reserved;
+	volatile __le16 		masks;
+	volatile __le16 		header_skip;
+	volatile __le16 		source_count;
+	volatile __le16 		reserved;
 };
 
 #define	HIFN_CRYPT_CMD_ALG_MASK		0x0003		/* algorithm: */
@@ -670,7 +670,7 @@ static inline u32 hifn_read_0(struct hifn_device *dev, u32 reg)
 {
 	u32 ret;
 
-	ret = readl((char *)(dev->bar[0]) + reg);
+	ret = readl(dev->bar[0] + reg);
 
 	return ret;
 }
@@ -679,19 +679,19 @@ static inline u32 hifn_read_1(struct hifn_device *dev, u32 reg)
 {
 	u32 ret;
 
-	ret = readl((char *)(dev->bar[1]) + reg);
+	ret = readl(dev->bar[1] + reg);
 
 	return ret;
 }
 
 static inline void hifn_write_0(struct hifn_device *dev, u32 reg, u32 val)
 {
-	writel(val, (char *)(dev->bar[0]) + reg);
+	writel(val, dev->bar[0] + reg);
 }
 
 static inline void hifn_write_1(struct hifn_device *dev, u32 reg, u32 val)
 {
-	writel(val, (char *)(dev->bar[1]) + reg);
+	writel(val, dev->bar[1] + reg);
 }
 
 static void hifn_wait_puc(struct hifn_device *dev)
-- 
1.5.3.GIT


