Return-Path: <linux-kernel-owner+w=401wt.eu-S1764255AbYBTPAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764255AbYBTPAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbYBTPA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:00:27 -0500
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:48522 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762949AbYBTPA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:00:26 -0500
Date: Wed, 20 Feb 2008 15:00:21 +0000
From: Stephane Chazelas <stephane.chazelas@emerson.com>
To: Joern Engel <joern@lazybastard.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [PATCH 2.6.25-rc2] block2mtd: logging typo fixes
Message-ID: <chaz20080220150021.GM4539@artesyncp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Embedded Computing Emerson Network Power
X-URL: http://www.emersonembeddedcomputing.com
User-Agent: Mutt/1.5.16 (2007-09-19)
X-OriginalArrivalTime: 20 Feb 2008 15:00:22.0558 (UTC) FILETIME=[51126BE0:01C873D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi joern,

this patch addresses a number of small issues mainly regarding
the output made by this driver to dmesg:
  - Some of the blkmtd's had not been changed to block2mtd which
    caused display problem
  - the parse_err() macro was displaying "block2mtd: " twice

Signed-off-by: Stephane Chazelas <stephane.chazelas@emerson.com>

--- drivers/mtd/devices/block2mtd.c~	2008-02-20 14:56:56.942145223 +0000
+++ drivers/mtd/devices/block2mtd.c	2008-02-20 14:57:15.802131021 +0000
@@ -305,7 +305,7 @@ static struct block2mtd_dev *add_device(
 	}
 	list_add(&dev->list, &blkmtd_device_list);
 	INFO("mtd%d: [%s] erase_size = %dKiB [%d]", dev->mtd.index,
-			dev->mtd.name + strlen("blkmtd: "),
+			dev->mtd.name + strlen("block2mtd: "),
 			dev->mtd.erasesize >> 10, dev->mtd.erasesize);
 	return dev;
 
@@ -366,9 +366,9 @@ static inline void kill_final_newline(ch
 }
 
 
-#define parse_err(fmt, args...) do {		\
-	ERROR("block2mtd: " fmt "\n", ## args);	\
-	return 0;				\
+#define parse_err(fmt, args...) do {	\
+	ERROR(fmt, ## args);		\
+	return 0;			\
 } while (0)
 
 #ifndef MODULE
@@ -474,7 +474,7 @@ static void __devexit block2mtd_exit(voi
 		block2mtd_sync(&dev->mtd);
 		del_mtd_device(&dev->mtd);
 		INFO("mtd%d: [%s] removed", dev->mtd.index,
-				dev->mtd.name + strlen("blkmtd: "));
+				dev->mtd.name + strlen("block2mtd: "));
 		list_del(&dev->list);
 		block2mtd_free_device(dev);
 	}
