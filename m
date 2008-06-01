Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbYFAXd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbYFAXd7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbYFAX2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:28:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:25723 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791AbYFAX2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:28:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=u7S6XFJjM525g6D0zCmSstvBT8qKxKQr2kY4QZt0h7qCLMKROP/O4j0BWjGc2ov5lqBAaV2Zl97hE8iyDfkWyAxc6A4llvqdwqKxse1/ua8455NU3i6a59hQiU96Zr+oD/J49Djddny9M1qor5NyGyYWSOC5u2C1vQaTtoDKPms=
Message-Id: <20080601231633.611599860@gmail.com>
References: <20080601231329.223608711@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 08:13:48 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch -v2 19/23] zorro: use memory_read_from_buffer
Content-Disposition: inline; filename=zorro-use-memory-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/zorro/zorro-sysfs.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

Index: 2.6-git/drivers/zorro/zorro-sysfs.c
===================================================================
--- 2.6-git.orig/drivers/zorro/zorro-sysfs.c
+++ 2.6-git/drivers/zorro/zorro-sysfs.c
@@ -15,6 +15,7 @@
 #include <linux/zorro.h>
 #include <linux/stat.h>
 #include <linux/string.h>
+#include <linux/fs.h>
 
 #include "zorro.h"
 
@@ -56,12 +57,6 @@ static ssize_t zorro_read_config(struct 
 	struct zorro_dev *z = to_zorro_dev(container_of(kobj, struct device,
 					   kobj));
 	struct ConfigDev cd;
-	unsigned int size = sizeof(cd);
-
-	if (off > size)
-		return 0;
-	if (off+count > size)
-		count = size-off;
 
 	/* Construct a ConfigDev */
 	memset(&cd, 0, sizeof(cd));
@@ -71,8 +66,7 @@ static ssize_t zorro_read_config(struct 
 	cd.cd_BoardAddr = (void *)zorro_resource_start(z);
 	cd.cd_BoardSize = zorro_resource_len(z);
 
-	memcpy(buf, (void *)&cd+off, count);
-	return count;
+	return memory_read_from_buffer(buf, count, &off, &cd, sizeof(cd));
 }
 
 static struct bin_attribute zorro_config_attr = {

-- 
