Return-Path: <linux-kernel-owner+w=401wt.eu-S1946007AbXEAUvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946007AbXEAUvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423637AbXEAUln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:41:43 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:40236 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423638AbXEAUfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:35:04 -0400
Message-Id: <20070501203338.041335667@mail.of.borg>
References: <20070501203234.252205858@mail.of.borg>
User-Agent: quilt/0.45-1
Date: Tue, 01 May 2007 22:33:04 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 30/33] Amiga Zorro bus: kill resource_size_t warnings
Content-Disposition: inline; filename=zorro-resource_size_t-warnings.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kill resource_size_t warnings by casting resource_size_t to unsigned long when
formatting Zorro bus resources, as they are always 32-bit.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/zorro/proc.c        |    5 +++--
 drivers/zorro/zorro-sysfs.c |    3 ++-
 drivers/zorro/zorro.c       |    3 ++-
 3 files changed, 7 insertions(+), 4 deletions(-)

--- linux-m68k-2.6.21.orig/drivers/zorro/proc.c
+++ linux-m68k-2.6.21/drivers/zorro/proc.c
@@ -90,8 +90,9 @@ get_zorro_dev_info(char *buf, char **sta
 	for (slot = cnt = 0; slot < zorro_num_autocon && count > cnt; slot++) {
 		struct zorro_dev *z = &zorro_autocon[slot];
 		len = sprintf(buf, "%02x\t%08x\t%08lx\t%08lx\t%02x\n", slot,
-			      z->id, zorro_resource_start(z),
-			      zorro_resource_len(z), z->rom.er_Type);
+			      z->id, (unsigned long)zorro_resource_start(z),
+			      (unsigned long)zorro_resource_len(z),
+			      z->rom.er_Type);
 		at += len;
 		if (at >= pos) {
 			if (!*start) {
--- linux-m68k-2.6.21.orig/drivers/zorro/zorro-sysfs.c
+++ linux-m68k-2.6.21/drivers/zorro/zorro-sysfs.c
@@ -42,7 +42,8 @@ static ssize_t zorro_show_resource(struc
 	struct zorro_dev *z = to_zorro_dev(dev);
 
 	return sprintf(buf, "0x%08lx 0x%08lx 0x%08lx\n",
-		       zorro_resource_start(z), zorro_resource_end(z),
+		       (unsigned long)zorro_resource_start(z),
+		       (unsigned long)zorro_resource_end(z),
 		       zorro_resource_flags(z));
 }
 
--- linux-m68k-2.6.21.orig/drivers/zorro/zorro.c
+++ linux-m68k-2.6.21/drivers/zorro/zorro.c
@@ -164,7 +164,8 @@ static int __init zorro_init(void)
 	if (request_resource(zorro_find_parent_resource(z), &z->resource))
 	    printk(KERN_ERR "Zorro: Address space collision on device %s "
 		   "[%lx:%lx]\n",
-		   z->name, zorro_resource_start(z), zorro_resource_end(z));
+		   z->name, (unsigned long)zorro_resource_start(z),
+		   (unsigned long)zorro_resource_end(z));
 	sprintf(z->dev.bus_id, "%02x", i);
 	z->dev.parent = &zorro_bus.dev;
 	z->dev.bus = &zorro_bus_type;

--
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

