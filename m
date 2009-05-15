Return-Path: <linux-kernel-owner+w=401wt.eu-S1763168AbZEOSCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763168AbZEOSCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbZEOSAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:00:04 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2053 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219AbZEOR77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 13:59:59 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] drivers/macintosh: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
Date: Fri, 15 May 2009 10:59:41 -0700
Message-Id: <06a83d7bf4f193098e93cc0f1721e982fcef310f.1242407227.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b.dirty
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/macintosh/ans-lcd.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/macintosh/ans-lcd.c b/drivers/macintosh/ans-lcd.c
index 6a82218..d8b4d75 100644
--- a/drivers/macintosh/ans-lcd.c
+++ b/drivers/macintosh/ans-lcd.c
@@ -32,9 +32,7 @@ static volatile unsigned char __iomem *anslcd_ptr;
 static void
 anslcd_write_byte_ctrl ( unsigned char c )
 {
-#ifdef DEBUG
-	printk(KERN_DEBUG "LCD: CTRL byte: %02x\n",c);
-#endif
+	pr_debug("LCD: CTRL byte: %02x\n",c);
 	out_8(anslcd_ptr + ANSLCD_CTRL_IX, c);
 	switch(c) {
 		case 1:
@@ -59,9 +57,7 @@ anslcd_write( struct file * file, const char __user * buf,
 	const char __user *p = buf;
 	int i;
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "LCD: write\n");
-#endif
+	pr_debug("LCD: write\n");
 
 	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT;
@@ -81,9 +77,7 @@ anslcd_ioctl( struct inode * inode, struct file * file,
 {
 	char ch, __user *temp;
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "LCD: ioctl(%d,%d)\n",cmd,arg);
-#endif
+	pr_debug("LCD: ioctl(%d,%d)\n",cmd,arg);
 
 	switch ( cmd )
 	{
@@ -164,9 +158,7 @@ anslcd_init(void)
 		return retval;
 	}
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "LCD: init\n");
-#endif
+	pr_debug("LCD: init\n");
 
 	anslcd_write_byte_ctrl ( 0x38 );
 	anslcd_write_byte_ctrl ( 0x0c );
-- 
1.6.3.1.9.g95405b.dirty

