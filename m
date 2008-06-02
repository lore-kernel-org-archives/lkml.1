Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbYFBJ7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbYFBJ7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYFBJ7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:59:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32956 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbYFBJ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:59:04 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] usb/c67x00 endianness annotations
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Message-Id: <E1K36og-0007Yx-HX@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 02 Jun 2008 10:59:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/usb/c67x00/c67x00-ll-hpi.c b/drivers/usb/c67x00/c67x00-ll-hpi.c
index 5100fbb..a9636f4 100644
--- a/drivers/usb/c67x00/c67x00-ll-hpi.c
+++ b/drivers/usb/c67x00/c67x00-ll-hpi.c
@@ -120,7 +120,7 @@ static void hpi_write_word(struct c67x00_device *dev, u16 reg, u16 value)
  * Only data is little endian, addr has cpu endianess
  */
 static void hpi_write_words_le16(struct c67x00_device *dev, u16 addr,
-				 u16 *data, u16 count)
+				 __le16 *data, u16 count)
 {
 	unsigned long flags;
 	int i;
@@ -129,7 +129,7 @@ static void hpi_write_words_le16(struct c67x00_device *dev, u16 addr,
 
 	hpi_write_reg(dev, HPI_ADDR, addr);
 	for (i = 0; i < count; i++)
-		hpi_write_reg(dev, HPI_DATA, cpu_to_le16(*data++));
+		hpi_write_reg(dev, HPI_DATA, le16_to_cpu(*data++));
 
 	spin_unlock_irqrestore(&dev->hpi.lock, flags);
 }
@@ -138,7 +138,7 @@ static void hpi_write_words_le16(struct c67x00_device *dev, u16 addr,
  * Only data is little endian, addr has cpu endianess
  */
 static void hpi_read_words_le16(struct c67x00_device *dev, u16 addr,
-				u16 *data, u16 count)
+				__le16 *data, u16 count)
 {
 	unsigned long flags;
 	int i;
@@ -146,7 +146,7 @@ static void hpi_read_words_le16(struct c67x00_device *dev, u16 addr,
 	spin_lock_irqsave(&dev->hpi.lock, flags);
 	hpi_write_reg(dev, HPI_ADDR, addr);
 	for (i = 0; i < count; i++)
-		*data++ = le16_to_cpu(hpi_read_reg(dev, HPI_DATA));
+		*data++ = cpu_to_le16(hpi_read_reg(dev, HPI_DATA));
 
 	spin_unlock_irqrestore(&dev->hpi.lock, flags);
 }
@@ -425,7 +425,7 @@ void c67x00_ll_write_mem_le16(struct c67x00_device *dev, u16 addr,
 		len--;
 	}
 
-	hpi_write_words_le16(dev, addr, (u16 *)buf, len / 2);
+	hpi_write_words_le16(dev, addr, (__le16 *)buf, len / 2);
 	buf += len & ~0x01;
 	addr += len & ~0x01;
 	len &= 0x01;
@@ -456,7 +456,7 @@ void c67x00_ll_read_mem_le16(struct c67x00_device *dev, u16 addr,
 		len--;
 	}
 
-	hpi_read_words_le16(dev, addr, (u16 *)buf, len / 2);
+	hpi_read_words_le16(dev, addr, (__le16 *)buf, len / 2);
 	buf += len & ~0x01;
 	addr += len & ~0x01;
 	len &= 0x01;
