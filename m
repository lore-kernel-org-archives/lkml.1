Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbZAKTwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbZAKTwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZAKTwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:52:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52112 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752556AbZAKTwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:52:08 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] (Resend #3) mtd: map_rom has NULL erase pointer
To: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Date: Sun, 11 Jan 2009 19:52:19 +0000
Message-ID: <20090111195202.16333.75975.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Which means if inftl or similar are loaded with it (which is a dumb thing
to do admittedly) it may oops

Closes #8108

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/mtd/chips/map_rom.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)


diff --git a/drivers/mtd/chips/map_rom.c b/drivers/mtd/chips/map_rom.c
index 821d0ed..8fb3280 100644
--- a/drivers/mtd/chips/map_rom.c
+++ b/drivers/mtd/chips/map_rom.c
@@ -19,6 +19,7 @@ static int maprom_read (struct mtd_info *, loff_t, size_t, size_t *, u_char *);
 static int maprom_write (struct mtd_info *, loff_t, size_t, size_t *, const u_char *);
 static void maprom_nop (struct mtd_info *);
 static struct mtd_info *map_rom_probe(struct map_info *map);
+static int maprom_erase (struct mtd_info *mtd, struct erase_info *info);
 
 static struct mtd_chip_driver maprom_chipdrv = {
 	.probe	= map_rom_probe,
@@ -42,6 +43,7 @@ static struct mtd_info *map_rom_probe(struct map_info *map)
 	mtd->read = maprom_read;
 	mtd->write = maprom_write;
 	mtd->sync = maprom_nop;
+	mtd->erase = maprom_erase;
 	mtd->flags = MTD_CAP_ROM;
 	mtd->erasesize = map->size;
 	mtd->writesize = 1;
@@ -71,6 +73,12 @@ static int maprom_write (struct mtd_info *mtd, loff_t to, size_t len, size_t *re
 	return -EIO;
 }
 
+static int maprom_erase (struct mtd_info *mtd, struct erase_info *info)
+{
+	/* We do our best 8) */
+	return -EIO;
+}
+
 static int __init map_rom_init(void)
 {
 	register_mtd_chip_driver(&maprom_chipdrv);

