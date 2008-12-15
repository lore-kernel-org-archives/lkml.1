Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbYLOXeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbYLOXeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 18:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYLOXdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 18:33:54 -0500
Received: from xenotime.net ([72.52.64.118]:35562 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752902AbYLOXdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 18:33:53 -0500
Message-ID: <4946E967.6030908@xenotime.net>
Date: Mon, 15 Dec 2008 15:33:59 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] mtd: fix dataflash printk formats
References: <20081216020642.fc1007d9.sfr@canb.auug.org.au>
In-Reply-To: <20081216020642.fc1007d9.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings:

build-r7137.out:/local/linsrc/linux-next-20081215/drivers/mtd/devices/mtd_dataflash.c:156: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'uint64_t'
build-r7137.out:/local/linsrc/linux-next-20081215/drivers/mtd/devices/mtd_dataflash.c:156: warning: format '%x' expects type 'unsigned int', but argument 4 has type 'uint64_t'
build-r7137.out:/local/linsrc/linux-next-20081215/drivers/mtd/devices/mtd_dataflash.c:670: warning: format '%d' expects type 'int', but argument 5 has type 'uint64_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/mtd/devices/mtd_dataflash.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- linux-next-20081215.orig/drivers/mtd/devices/mtd_dataflash.c
+++ linux-next-20081215/drivers/mtd/devices/mtd_dataflash.c
@@ -153,9 +153,10 @@ static int dataflash_erase(struct mtd_in
 	unsigned		blocksize = priv->page_size << 3;
 	uint8_t			*command;
 
-	DEBUG(MTD_DEBUG_LEVEL2, "%s: erase addr=0x%x len 0x%x\n",
+	DEBUG(MTD_DEBUG_LEVEL2, "%s: erase addr=0x%llx len 0x%llx\n",
 			dev_name(&spi->dev),
-			instr->addr, instr->len);
+			(unsigned long long)instr->addr,
+			(unsigned long long)instr->len);
 
 	/* Sanity checks */
 	if ((instr->addr + instr->len) > mtd->size
@@ -667,8 +668,8 @@ add_dataflash_otp(struct spi_device *spi
 	if (revision >= 'c')
 		otp_tag = otp_setup(device, revision);
 
-	dev_info(&spi->dev, "%s (%d KBytes) pagesize %d bytes%s\n",
-			name, DIV_ROUND_UP(device->size, 1024),
+	dev_info(&spi->dev, "%s (%llu KBytes) pagesize %d bytes%s\n",
+			name, (unsigned long long)DIV_ROUND_UP(device->size, 1024),
 			pagesize, otp_tag);
 	dev_set_drvdata(&spi->dev, priv);
 
