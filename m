Return-Path: <linux-kernel-owner+w=401wt.eu-S932827AbXBFQGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827AbXBFQGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbXBFQGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:06:24 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:58148 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827AbXBFQGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:06:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=CNAxyXbwggwkF3nLw43mqtGj/t57nC8nra3YGfOVMj8Is4cGJmcGIzSd/dk8gPrG6J1GsN9IrP0CN4rosaPdrGIHAJIZeYfFsZfa4Xf94pn5uKei4huILiptWVenj7RbKQW0rOG2uCbn+sB2lo1Lqqbtt/tcJHAHYOoyDjf6tK0=
Date: Tue, 6 Feb 2007 18:06:08 +0200
To: chas@cmf.nrl.navy.mil
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20] atm: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206160608.GH8991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206160204.GA8991@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in kernel.h for ATM
drivers.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index db33f6f..8510026 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -3017,7 +3017,7 @@ read_prom_byte(struct he_dev *he_dev, int addr)
 	he_writel(he_dev, val, HOST_CNTL);
        
 	/* Send READ instruction */
-	for (i = 0; i < sizeof(readtab)/sizeof(readtab[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(readtab); i++) {
 		he_writel(he_dev, val | readtab[i], HOST_CNTL);
 		udelay(EEPROM_DELAY);
 	}
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index f407861..b4b8014 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -388,7 +388,7 @@ idt77252_eeprom_read_status(struct idt77252_dev *card)
 
 	gp = idt77252_read_gp(card) & ~(SAR_GP_EESCLK|SAR_GP_EECS|SAR_GP_EEDO);
 
-	for (i = 0; i < sizeof(rdsrtab)/sizeof(rdsrtab[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(rdsrtab); i++) {
 		idt77252_write_gp(card, gp | rdsrtab[i]);
 		udelay(5);
 	}
@@ -422,7 +422,7 @@ idt77252_eeprom_read_byte(struct idt77252_dev *card, u8 offset)
 
 	gp = idt77252_read_gp(card) & ~(SAR_GP_EESCLK|SAR_GP_EECS|SAR_GP_EEDO);
 
-	for (i = 0; i < sizeof(rdtab)/sizeof(rdtab[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(rdtab); i++) {
 		idt77252_write_gp(card, gp | rdtab[i]);
 		udelay(5);
 	}
@@ -469,14 +469,14 @@ idt77252_eeprom_write_byte(struct idt77252_dev *card, u8 offset, u8 data)
 
 	gp = idt77252_read_gp(card) & ~(SAR_GP_EESCLK|SAR_GP_EECS|SAR_GP_EEDO);
 
-	for (i = 0; i < sizeof(wrentab)/sizeof(wrentab[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(wrentab); i++) {
 		idt77252_write_gp(card, gp | wrentab[i]);
 		udelay(5);
 	}
 	idt77252_write_gp(card, gp | SAR_GP_EECS);
 	udelay(5);
 
-	for (i = 0; i < sizeof(wrtab)/sizeof(wrtab[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(wrtab); i++) {
 		idt77252_write_gp(card, gp | wrtab[i]);
 		udelay(5);
 	}
diff --git a/drivers/atm/nicstarmac.c b/drivers/atm/nicstarmac.c
index 2c5e3ae..480947f 100644
--- a/drivers/atm/nicstarmac.c
+++ b/drivers/atm/nicstarmac.c
@@ -7,6 +7,8 @@
  * Read this ForeRunner's MAC address from eprom/eeprom
  */
 
+#include <linux/kernel.h>
+
 typedef void __iomem *virt_addr_t;
 
 #define CYCLE_DELAY 5
@@ -176,7 +178,7 @@ read_eprom_byte(virt_addr_t base, u_int8_t offset)
    val = NICSTAR_REG_READ( base, NICSTAR_REG_GENERAL_PURPOSE ) & 0xFFFFFFF0;
 
    /* Send READ instruction */
-   for (i=0; i<sizeof readtab/sizeof readtab[0]; i++)
+   for (i=0; i<ARRAY_SIZE(readtab); i++)
    {
 	NICSTAR_REG_WRITE( base, NICSTAR_REG_GENERAL_PURPOSE,
 		(val | readtab[i]) );


-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
