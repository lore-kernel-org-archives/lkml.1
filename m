Return-Path: <linux-kernel-owner+w=401wt.eu-S1759202AbXFCOsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202AbXFCOsZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756121AbXFCOnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:43:21 -0400
Received: from web50111.mail.re2.yahoo.com ([206.190.39.137]:28617 "HELO
	web50111.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756519AbXFCOnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:43:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Io/6nq4JwaX3j0vLB88NFZa1epYOdHYTc9Istj+kWpdJbmxFphSKCN1WyVseVZUG9wzqa7HGwRBiUnkf+sojeKqE1OvumGkrt47+nFSudfv253xpZ7atEIe+6dTZYPnQ9/zvWGk4O9lGu4WjqPxMH+NORRL5jb075LzPlqsLOYU=;
X-YMail-OSG: q0ZckQwVM1kwa6Dhgpc4vwLfVH_NVb.Shkr8FG6HJ8Sev_kq9yeIpY32EWR2zHyH7vIniGQcusaBG8w1yaY.SNvN6Qigp2Mhfo9g1mZefUIK1bY-
Date: Sun, 3 Jun 2007 07:43:18 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 26/36] drivers edac Lindent i3000 driver
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <810492.86896.qm@web50111.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Dave Jiang <djiang@mvista.com>

Lindent cleanup of i3000_edac driver

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
---
 i3000_edac.c |   55
++++++++++++++++++++++++++-----------------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

Index: linux-2.6.22-rc1/drivers/edac/i3000_edac.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/edac/i3000_edac.c
+++ linux-2.6.22-rc1/drivers/edac/i3000_edac.c
@@ -130,7 +130,6 @@
 					 * 30:0  reserved
 					 */
 
-
 enum i3000p_chips {
 	I3000 = 0,
 };
@@ -149,15 +148,14 @@ struct i3000_error_info {
 
 static const struct i3000_dev_info i3000_devs[] = {
 	[I3000] = {
-		     .ctl_name = "i3000"
-	},
+		   .ctl_name = "i3000"},
 };
 
 static struct pci_dev *mci_pdev = NULL;
 static int i3000_registered = 1;
 
 static void i3000_get_error_info(struct mem_ctl_info *mci,
-		struct i3000_error_info *info)
+				 struct i3000_error_info *info)
 {
 	struct pci_dev *pdev;
 
@@ -183,22 +181,21 @@ static void i3000_get_error_info(struct 
 	 * should be UE info.
 	 */
 	if ((info->errsts ^ info->errsts2) & I3000_ERRSTS_BITS) {
-			pci_read_config_byte(pdev, I3000_EDEAP,
-					&info->edeap);
-			pci_read_config_dword(pdev, I3000_DEAP,
-					&info->deap);
-			pci_read_config_byte(pdev, I3000_DERRSYN,
-					&info->derrsyn);
+		pci_read_config_byte(pdev, I3000_EDEAP, &info->edeap);
+		pci_read_config_dword(pdev, I3000_DEAP, &info->deap);
+		pci_read_config_byte(pdev, I3000_DERRSYN, &info->derrsyn);
 	}
 
 	/* Clear any error bits.
 	 * (Yes, we really clear bits by writing 1 to them.)
 	 */
-	pci_write_bits16(pdev, I3000_ERRSTS, I3000_ERRSTS_BITS,
I3000_ERRSTS_BITS);
+	pci_write_bits16(pdev, I3000_ERRSTS, I3000_ERRSTS_BITS,
+			 I3000_ERRSTS_BITS);
 }
 
 static int i3000_process_error_info(struct mem_ctl_info *mci,
-		struct i3000_error_info *info, int handle_errors)
+				    struct i3000_error_info *info,
+				    int handle_errors)
 {
 	int row, multi_chan;
 	int pfn, offset, channel;
@@ -226,8 +223,7 @@ static int i3000_process_error_info(stru
 		edac_mc_handle_ue(mci, pfn, offset, row, "i3000 UE");
 	else
 		edac_mc_handle_ce(mci, pfn, offset, info->derrsyn, row,
-				       multi_chan ? channel : 0,
-				       "i3000 CE");
+				  multi_chan ? channel : 0, "i3000 CE");
 
 	return 1;
 }
@@ -281,18 +277,19 @@ static int i3000_probe1(struct pci_dev *
 
 	debugf0("MC: %s()\n", __func__);
 
-	pci_read_config_dword(pdev, I3000_MCHBAR, (u32 *)&mchbar);
+	pci_read_config_dword(pdev, I3000_MCHBAR, (u32 *) & mchbar);
 	mchbar &= I3000_MCHBAR_MASK;
 	window = ioremap_nocache(mchbar, I3000_MMR_WINDOW_SIZE);
 	if (!window) {
-		printk(KERN_ERR "i3000: cannot map mmio space at 0x%lx\n", mchbar);
+		printk(KERN_ERR "i3000: cannot map mmio space at 0x%lx\n",
+		       mchbar);
 		return -ENODEV;
 	}
 
-	c0dra[0] = readb(window + I3000_C0DRA + 0); /* ranks 0,1 */
-	c0dra[1] = readb(window + I3000_C0DRA + 1); /* ranks 2,3 */
-	c1dra[0] = readb(window + I3000_C1DRA + 0); /* ranks 0,1 */
-	c1dra[1] = readb(window + I3000_C1DRA + 1); /* ranks 2,3 */
+	c0dra[0] = readb(window + I3000_C0DRA + 0);	/* ranks 0,1 */
+	c0dra[1] = readb(window + I3000_C0DRA + 1);	/* ranks 2,3 */
+	c1dra[0] = readb(window + I3000_C1DRA + 0);	/* ranks 0,1 */
+	c1dra[1] = readb(window + I3000_C1DRA + 1);	/* ranks 2,3 */
 
 	for (i = 0; i < I3000_RANKS_PER_CHANNEL; i++) {
 		c0drb[i] = readb(window + I3000_C0DRB + i);
@@ -367,7 +364,8 @@ static int i3000_probe1(struct pci_dev *
 	/* Clear any error bits.
 	 * (Yes, we really clear bits by writing 1 to them.)
 	 */
-	pci_write_bits16(pdev, I3000_ERRSTS, I3000_ERRSTS_BITS,
I3000_ERRSTS_BITS);
+	pci_write_bits16(pdev, I3000_ERRSTS, I3000_ERRSTS_BITS,
+			 I3000_ERRSTS_BITS);
 
 	rc = -ENODEV;
 	if (edac_mc_add_mc(mci, 0)) {
@@ -388,7 +386,7 @@ static int i3000_probe1(struct pci_dev *
 
 /* returns count (>= 0), or negative on error */
 static int __devinit i3000_init_one(struct pci_dev *pdev,
-				      const struct pci_device_id *ent)
+				    const struct pci_device_id *ent)
 {
 	int rc;
 
@@ -418,12 +416,11 @@ static void __devexit i3000_remove_one(s
 
 static const struct pci_device_id i3000_pci_tbl[] __devinitdata = {
 	{
-		PCI_VEND_DEV(INTEL, 3000_HB), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-	 	I3000
-	},
+	 PCI_VEND_DEV(INTEL, 3000_HB), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	 I3000},
 	{
-		0,
-	}	/* 0 terminated list. */
+	 0,
+	 }			/* 0 terminated list. */
 };
 
 MODULE_DEVICE_TABLE(pci, i3000_pci_tbl);
@@ -464,10 +461,10 @@ static int __init i3000_init(void)
 
 	return 0;
 
-fail1:
+      fail1:
 	pci_unregister_driver(&i3000_driver);
 
-fail0:
+      fail0:
 	if (mci_pdev)
 		pci_dev_put(mci_pdev);
 

