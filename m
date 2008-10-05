Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbYJEQkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbYJEQkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756121AbYJEQhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:37:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35297 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759220AbYJEQhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:37:17 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 10/19] ibmtr: PCMCIA IBMTR is ok on 64bit
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:37:17 +0100
Message-ID: <20081005163708.3799.64928.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For whatever value of 'OK' can be applied to the use of token ring. Seems
the 32bit to 64bit cleanups missed re-enabling the pcmcia driver

Closes #7133 and also reviewed the code in question

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/mtd/chips/map_rom.c |    5 +++--
 drivers/net/pcmcia/Kconfig  |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/chips/map_rom.c b/drivers/mtd/chips/map_rom.c
index c11f398..8fb3280 100644
--- a/drivers/mtd/chips/map_rom.c
+++ b/drivers/mtd/chips/map_rom.c
@@ -19,7 +19,7 @@ static int maprom_read (struct mtd_info *, loff_t, size_t, size_t *, u_char *);
 static int maprom_write (struct mtd_info *, loff_t, size_t, size_t *, const u_char *);
 static void maprom_nop (struct mtd_info *);
 static struct mtd_info *map_rom_probe(struct map_info *map);
-static void maprom_erase (struct mtd_info *mtd, struct erase_info *info);
+static int maprom_erase (struct mtd_info *mtd, struct erase_info *info);
 
 static struct mtd_chip_driver maprom_chipdrv = {
 	.probe	= map_rom_probe,
@@ -73,9 +73,10 @@ static int maprom_write (struct mtd_info *mtd, loff_t to, size_t len, size_t *re
 	return -EIO;
 }
 
-static void maprom_erase (struct mtd_info *mtd, struct erase_info *info)
+static int maprom_erase (struct mtd_info *mtd, struct erase_info *info)
 {
 	/* We do our best 8) */
+	return -EIO;
 }
 
 static int __init map_rom_init(void)
diff --git a/drivers/net/pcmcia/Kconfig b/drivers/net/pcmcia/Kconfig
index e8f55d8..9b8f793 100644
--- a/drivers/net/pcmcia/Kconfig
+++ b/drivers/net/pcmcia/Kconfig
@@ -111,7 +111,7 @@ config ARCNET_COM20020_CS
 
 config PCMCIA_IBMTR
 	tristate "IBM PCMCIA tokenring adapter support"
-	depends on IBMTR!=y && TR && !64BIT
+	depends on IBMTR!=y && TR
 	help
 	  Say Y here if you intend to attach this type of Token Ring PCMCIA
 	  card to your computer. You then also need to say Y to "Token Ring

