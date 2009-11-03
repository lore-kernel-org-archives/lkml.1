Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbZKCTiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbZKCTiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZKCTiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:38:00 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:38461 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZKCTh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:37:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=UaEyeCmb/KICXteFFUGvquQq642eeRgnEPGqnRMgERai6JwD1B0CUZ4yc+YqorUldG
         WIEjnUE7jj1Q3LFXyHcufJiCcXunQ+EWg1Nd88qvtsMZIdZT2rQp+Ro8uwh7rPW9EoM4
         /u6X+ySj6e9Pytrwnp5soE3PPw/QTq+OA+eP0=
Message-ID: <4AF0893E.8040101@gmail.com>
Date: Tue, 03 Nov 2009 20:49:18 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] UBI: Ensure index is positive
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The index is signed, make sure it is not negative
when we read the array element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/mtd/mtdcore.c      |    2 +-
 drivers/mtd/nand/fsl_upm.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 467a4f1..c356c0a 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -447,7 +447,7 @@ struct mtd_info *get_mtd_device(struct mtd_info *mtd, int num)
 		for (i=0; i< MAX_MTD_DEVICES; i++)
 			if (mtd_table[i] == mtd)
 				ret = mtd_table[i];
-	} else if (num < MAX_MTD_DEVICES) {
+	} else if (num >= 0 && num < MAX_MTD_DEVICES) {
 		ret = mtd_table[num];
 		if (mtd && mtd != ret)
 			ret = NULL;
diff --git a/drivers/mtd/nand/fsl_upm.c b/drivers/mtd/nand/fsl_upm.c
index d120cd8..071a60c 100644
--- a/drivers/mtd/nand/fsl_upm.c
+++ b/drivers/mtd/nand/fsl_upm.c
@@ -112,7 +112,7 @@ static void fun_select_chip(struct mtd_info *mtd, int mchip_nr)
 
 	if (mchip_nr == -1) {
 		chip->cmd_ctrl(mtd, NAND_CMD_NONE, 0 | NAND_CTRL_CHANGE);
-	} else if (mchip_nr >= 0) {
+	} else if (mchip_nr >= 0 && mchip_nr < NAND_MAX_CHIPS) {
 		fun->mchip_number = mchip_nr;
 		chip->IO_ADDR_R = fun->io_base + fun->mchip_offsets[mchip_nr];
 		chip->IO_ADDR_W = chip->IO_ADDR_R;
