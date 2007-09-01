Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbXIALSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbXIALSj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 07:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbXIALSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 07:18:30 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57432 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbXIALS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 07:18:29 -0400
Date: Sat, 1 Sep 2007 07:18:28 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ata_piix: use more-robust form of array init
Message-ID: <20070901111828.GA26314@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit f1aa850441adc237d237a469dca7d87dde0fe3b2
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sat Sep 1 07:17:36 2007 -0400

    [libata] ata_piix: Use more-robust form of array initialization
    
    Use a form of array init that is less fragile, less sensitive to trivial
    typos and ordering mismatches.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/ata_piix.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

f1aa850441adc237d237a469dca7d87dde0fe3b2
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 54c3487..cf5c599 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -123,7 +123,6 @@ enum {
 	ich_pata_33		= 1,	/* ICH up to UDMA 33 only */
 	ich_pata_66		= 2,	/* ICH up to 66 Mhz */
 	ich_pata_100		= 3,	/* ICH up to UDMA 100 */
-	/* ICH up to UDMA 133 is not supported */
 	ich5_sata		= 5,
 	ich6_sata		= 6,
 	ich6_sata_ahci		= 7,
@@ -459,7 +458,7 @@ static const struct piix_map_db *piix_map_db_table[] = {
 };
 
 static struct ata_port_info piix_port_info[] = {
-	/* piix_pata_33: 0:  PIIX4 at 33MHz */
+	[piix_pata_33] =	/* PIIX4 at 33MHz */
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS,
@@ -469,7 +468,7 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &piix_pata_ops,
 	},
 
-	/* ich_pata_33: 1 	ICH0 - ICH at 33Mhz*/
+	[ich_pata_33] = 	/* ICH0 - ICH at 33Mhz*/
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS,
@@ -478,7 +477,8 @@ static struct ata_port_info piix_port_info[] = {
 		.udma_mask	= ATA_UDMA2, /* UDMA33 */
 		.port_ops	= &ich_pata_ops,
 	},
-	/* ich_pata_66: 2 	ICH controllers up to 66MHz */
+
+	[ich_pata_66] = 	/* ICH controllers up to 66MHz */
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS,
@@ -488,7 +488,7 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &ich_pata_ops,
 	},
 
-	/* ich_pata_100: 3 */
+	[ich_pata_100] =
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
@@ -498,17 +498,7 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &ich_pata_ops,
 	},
 
-	/* ich_pata_133: 4 - Not supported - */
-	{
-		.sht		= &piix_sht,
-		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
-		.pio_mask 	= 0x1f,	/* pio 0-4 */
-		.mwdma_mask	= 0x06, /* Check: maybe 0x07  */
-		.udma_mask	= ATA_UDMA6, /* UDMA133 */
-		.port_ops	= &ich_pata_ops,
-	},
-
-	/* ich5_sata: 5 */
+	[ich5_sata] =
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_SATA_FLAGS,
@@ -518,7 +508,7 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &piix_sata_ops,
 	},
 
-	/* ich6_sata: 6 */
+	[ich6_sata] =
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR,
@@ -528,7 +518,7 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &piix_sata_ops,
 	},
 
-	/* ich6_sata_ahci: 7 */
+	[ich6_sata_ahci] =
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
@@ -539,7 +529,7 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &piix_sata_ops,
 	},
 
-	/* ich6m_sata_ahci: 8 */
+	[ich6m_sata_ahci] =
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
@@ -550,7 +540,7 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &piix_sata_ops,
 	},
 
-	/* ich8_sata_ahci: 9 */
+	[ich8_sata_ahci] =
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
@@ -561,7 +551,7 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &piix_sata_ops,
 	},
 
-	/* piix_pata_mwdma: 10:  PIIX3 MWDMA only */
+	[piix_pata_mwdma] = 	/* PIIX3 MWDMA only */
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS,
@@ -570,7 +560,7 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &piix_pata_ops,
 	},
 
-	/* tolapai_sata_ahci: 11: */
+	[tolapai_sata_ahci] =
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
