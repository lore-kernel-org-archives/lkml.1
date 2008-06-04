Return-Path: <linux-kernel-owner+w=401wt.eu-S1761194AbYFDMQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761194AbYFDMQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760870AbYFDMK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:10:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:20551 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760715AbYFDMKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=JJem/zza6f8v/dwRNU4+atr2p+K6u0tUPOGUZvm/uV4INcayqpA/GKxIwchPGncfvh
         t5Zbs8Vq+23VQWicmv2MLJ6Bh/511S9uYT+sWVo+oKddzyTcjNhTpEzHn8z1nK6x1ahc
         zNrad9wgoMhv95gfU44FTekMvpwaciBLE8g2Y=
Message-Id: <20080604115835.346945584@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:51 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch -v3 18/22] zorro: use memory_read_from_buffer
Content-Disposition: inline; filename=zorro-use-memory-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
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
