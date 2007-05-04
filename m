Return-Path: <linux-kernel-owner+w=401wt.eu-S1161295AbXEDTuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161295AbXEDTuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161918AbXEDTuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:50:22 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:44625 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161295AbXEDTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:50:20 -0400
X-Originating-Ip: 72.143.66.196
Date: Fri, 4 May 2007 15:49:38 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] MTD: Delete allegedly obsolete "bank_size" field of mtd_info.
Message-ID: <Pine.LNX.4.64.0705041541170.29526@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Delete the allegedly obsolete "bank_size" member of struct mtd_info.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  the only other references to the symbol "bank_size" in the entire
tree are here:

$ grep -rw bank_size *
drivers/net/e1000/e1000_hw.c:    int32_t  bank_size;
drivers/net/e1000/e1000_hw.c:        bank_size = ICH_FLASH_SECTOR_SIZE;
drivers/net/e1000/e1000_hw.c:        bank_size = ICH_FLASH_SEG_SIZE_4K;
drivers/net/e1000/e1000_hw.c:        bank_size = ICH_FLASH_SEG_SIZE_64K;
drivers/net/e1000/e1000_hw.c:            flash_linear_address = bank * bank_size + j * sub_sector_size;

and those don't look like they have anything to do with mtd_info.

  compile-tested under x86 with "make allyesconfig".


diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 1af9890..9c62368 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -347,7 +347,6 @@ int add_mtd_partitions(struct mtd_info *master,
 		slave->mtd.subpage_sft = master->subpage_sft;

 		slave->mtd.name = parts[i].name;
-		slave->mtd.bank_size = master->bank_size;
 		slave->mtd.owner = master->owner;

 		slave->mtd.read = part_read;
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 45d482c..150f1b4 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -137,9 +137,6 @@ struct mtd_info {
 	int numeraseregions;
 	struct mtd_erase_region_info *eraseregions;

-	/* This really shouldn't be here. It can go away in 2.5 */
-	u_int32_t bank_size;
-
 	int (*erase) (struct mtd_info *mtd, struct erase_info *instr);

 	/* This stuff for eXecute-In-Place */
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
