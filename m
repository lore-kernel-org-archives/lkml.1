Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbYJEQjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbYJEQjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761343AbYJEQhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:37:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35295 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757698AbYJEQhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:37:04 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 09/19] mtd: map_rom has NULL erase pointer
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:37:03 +0100
Message-ID: <20081005163657.3799.62635.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which means if inftl or similar are loaded with it (which is a dumb thing
to do admittedly) it may oops

Closes #8108

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/mtd/chips/map_rom.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/chips/map_rom.c b/drivers/mtd/chips/map_rom.c
index 821d0ed..c11f398 100644
--- a/drivers/mtd/chips/map_rom.c
+++ b/drivers/mtd/chips/map_rom.c
@@ -19,6 +19,7 @@ static int maprom_read (struct mtd_info *, loff_t, size_t, size_t *, u_char *);
 static int maprom_write (struct mtd_info *, loff_t, size_t, size_t *, const u_char *);
 static void maprom_nop (struct mtd_info *);
 static struct mtd_info *map_rom_probe(struct map_info *map);
+static void maprom_erase (struct mtd_info *mtd, struct erase_info *info);
 
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
@@ -71,6 +73,11 @@ static int maprom_write (struct mtd_info *mtd, loff_t to, size_t len, size_t *re
 	return -EIO;
 }
 
+static void maprom_erase (struct mtd_info *mtd, struct erase_info *info)
+{
+	/* We do our best 8) */
+}
+
 static int __init map_rom_init(void)
 {
 	register_mtd_chip_driver(&maprom_chipdrv);

