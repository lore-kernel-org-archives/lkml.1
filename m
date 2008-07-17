Return-Path: <linux-kernel-owner+w=401wt.eu-S933362AbYGQTes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362AbYGQTes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932362AbYGQTXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:23:41 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:53947 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759526AbYGQTWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:45 -0400
Message-Id: <20080717191752.200830186@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:17 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: [patch 10/29] zorro: use memory_read_from_buffer
Content-Disposition: inline; filename=zorro-use-memory_read_from_buffer.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: akinobu.mita@gmail.com

zorro: use memory_read_from_buffer

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/zorro/zorro-sysfs.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/zorro/zorro-sysfs.c
+++ b/drivers/zorro/zorro-sysfs.c
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
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

