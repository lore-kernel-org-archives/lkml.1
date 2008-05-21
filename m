Return-Path: <linux-kernel-owner+w=401wt.eu-S1765149AbYEUAbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765149AbYEUAbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbYEUAbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:31:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45295 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763290AbYEUAaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:30:52 -0400
To: mchehab@infradead.org
Subject: [PATCH] fix unaligned access in av7110.c
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycEF-0004l5-Q6@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:30:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/dvb/ttpci/av7110.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 747e7f1..f05d43d 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -51,6 +51,7 @@
 #include <linux/crc32.h>
 #include <linux/i2c.h>
 #include <linux/kthread.h>
+#include <asm/unaligned.h>
 
 #include <asm/system.h>
 
@@ -1461,9 +1462,9 @@ static int check_firmware(struct av7110* av7110)
 	ptr += 4;
 
 	/* check dpram file */
-	crc = ntohl(*(u32*) ptr);
+	crc = get_unaligned_be32(ptr);
 	ptr += 4;
-	len = ntohl(*(u32*) ptr);
+	len = get_unaligned_be32(ptr);
 	ptr += 4;
 	if (len >= 512) {
 		printk("dvb-ttpci: dpram file is way too big.\n");
@@ -1478,9 +1479,9 @@ static int check_firmware(struct av7110* av7110)
 	ptr += len;
 
 	/* check root file */
-	crc = ntohl(*(u32*) ptr);
+	crc = get_unaligned_be32(ptr);
 	ptr += 4;
-	len = ntohl(*(u32*) ptr);
+	len = get_unaligned_be32(ptr);
 	ptr += 4;
 
 	if (len <= 200000 || len >= 300000 ||
-- 
1.5.3.GIT


