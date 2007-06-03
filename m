Return-Path: <linux-kernel-owner+w=401wt.eu-S1759640AbXFCOuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640AbXFCOuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbXFCOoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:44:14 -0400
Received: from web50106.mail.re2.yahoo.com ([206.190.38.34]:20837 "HELO
	web50106.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758025AbXFCOoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:44:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=tzJPMQzQPwGozwZoh5n99f9UHEO3R6GFAkN8o6v5CZ+bncFohLTOGx9rVWFzmiIWzjJ8p7+QTHMcC6aUvyMvpBIP16TGL4tCBESIQPBTB3z2ORnGcvk6270nm5ZQMQyObSzbagL/dN2HeyzknxIKLRNR9B3dHfPoBbwQjMPho+o=;
X-YMail-OSG: cFCQbkwVM1nchEwOugJatHHODrvDFJ.Q_lgB7XvNw7qLt._OVyvCDJR6adS.xIN7igdwKziPoejkmWibfGqRDChYMX2JQElHXn4oLgGH8VNpEFLGeqqUJOKtYeBkNBJ_XuRCWSy2xwcGoT_tA5XEGOmsNgrxjeEIxQ--
Date: Sun, 3 Jun 2007 07:44:08 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 31/36] drivers edac Lindent r82600 driver
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <959669.4320.qm@web50106.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

Run r82600_edac.c file through Lindent for cleanup

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Dave Jiang <djiang@mvista.com>
---
 r82600_edac.c |   55
+++++++++++++++++++++++++++----------------------------
 1 file changed, 27 insertions(+), 28 deletions(-)


Index: linux-2.6.22-rc1/drivers/edac/r82600_edac.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/edac/r82600_edac.c
+++ linux-2.6.22-rc1/drivers/edac/r82600_edac.c
@@ -133,8 +133,8 @@ struct r82600_error_info {
 
 static unsigned int disable_hardware_scrub = 0;
 
-static void r82600_get_error_info (struct mem_ctl_info *mci,
-		struct r82600_error_info *info)
+static void r82600_get_error_info(struct mem_ctl_info *mci,
+				  struct r82600_error_info *info)
 {
 	struct pci_dev *pdev;
 
@@ -144,18 +144,19 @@ static void r82600_get_error_info (struc
 	if (info->eapr & BIT(0))
 		/* Clear error to allow next error to be reported [p.62] */
 		pci_write_bits32(pdev, R82600_EAP,
-				((u32) BIT(0) & (u32) BIT(1)),
-				((u32) BIT(0) & (u32) BIT(1)));
+				 ((u32) BIT(0) & (u32) BIT(1)),
+				 ((u32) BIT(0) & (u32) BIT(1)));
 
 	if (info->eapr & BIT(1))
 		/* Clear error to allow next error to be reported [p.62] */
 		pci_write_bits32(pdev, R82600_EAP,
-				((u32) BIT(0) & (u32) BIT(1)),
-				((u32) BIT(0) & (u32) BIT(1)));
+				 ((u32) BIT(0) & (u32) BIT(1)),
+				 ((u32) BIT(0) & (u32) BIT(1)));
 }
 
-static int r82600_process_error_info (struct mem_ctl_info *mci,
-		struct r82600_error_info *info, int handle_errors)
+static int r82600_process_error_info(struct mem_ctl_info *mci,
+				     struct r82600_error_info *info,
+				     int handle_errors)
 {
 	int error_found;
 	u32 eapaddr, page;
@@ -172,25 +173,23 @@ static int r82600_process_error_info (st
 	 * granularity (upper 19 bits only)     */
 	page = eapaddr >> PAGE_SHIFT;
 
-	if (info->eapr & BIT(0)) {  /* CE? */
+	if (info->eapr & BIT(0)) {	/* CE? */
 		error_found = 1;
 
 		if (handle_errors)
-			edac_mc_handle_ce(mci, page, 0,  /* not avail */
-					syndrome,
-					edac_mc_find_csrow_by_page(mci, page),
-					0,  /* channel */
-					mci->ctl_name);
+			edac_mc_handle_ce(mci, page, 0,	/* not avail */
+					  syndrome, edac_mc_find_csrow_by_page(mci, page), 0,	/* channel
*/
+					  mci->ctl_name);
 	}
 
-	if (info->eapr & BIT(1)) {  /* UE? */
+	if (info->eapr & BIT(1)) {	/* UE? */
 		error_found = 1;
 
 		if (handle_errors)
 			/* 82600 doesn't give enough info */
 			edac_mc_handle_ue(mci, page, 0,
-				edac_mc_find_csrow_by_page(mci, page),
-				mci->ctl_name);
+					  edac_mc_find_csrow_by_page(mci, page),
+					  mci->ctl_name);
 	}
 
 	return error_found;
@@ -211,11 +210,11 @@ static inline int ecc_enabled(u8 dramcr)
 }
 
 static void r82600_init_csrows(struct mem_ctl_info *mci, struct
pci_dev *pdev,
-		u8 dramcr)
+			       u8 dramcr)
 {
 	struct csrow_info *csrow;
 	int index;
-	u8 drbar;  /* SDRAM Row Boundry Address Register */
+	u8 drbar;		/* SDRAM Row Boundry Address Register */
 	u32 row_high_limit, row_high_limit_last;
 	u32 reg_sdram, ecc_on, row_base;
 
@@ -309,12 +308,12 @@ static int r82600_probe1(struct pci_dev 
 	mci->edac_check = r82600_check;
 	mci->ctl_page_to_phys = NULL;
 	r82600_init_csrows(mci, pdev, dramcr);
-	r82600_get_error_info(mci, &discard);  /* clear counters */
+	r82600_get_error_info(mci, &discard);	/* clear counters */
 
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci,0)) {
+	if (edac_mc_add_mc(mci, 0)) {
 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail;
 	}
@@ -330,14 +329,14 @@ static int r82600_probe1(struct pci_dev 
 	debugf3("%s(): success\n", __func__);
 	return 0;
 
-fail:
+      fail:
 	edac_mc_free(mci);
 	return -ENODEV;
 }
 
 /* returns count (>= 0), or negative on error */
 static int __devinit r82600_init_one(struct pci_dev *pdev,
-		const struct pci_device_id *ent)
+				     const struct pci_device_id *ent)
 {
 	debugf0("%s()\n", __func__);
 
@@ -359,11 +358,11 @@ static void __devexit r82600_remove_one(
 
 static const struct pci_device_id r82600_pci_tbl[] __devinitdata = {
 	{
-		PCI_DEVICE(PCI_VENDOR_ID_RADISYS, R82600_BRIDGE_ID)
-	},
+	 PCI_DEVICE(PCI_VENDOR_ID_RADISYS, R82600_BRIDGE_ID)
+	 },
 	{
-		0,
-	}	/* 0 terminated list. */
+	 0,
+	 }			/* 0 terminated list. */
 };
 
 MODULE_DEVICE_TABLE(pci, r82600_pci_tbl);
@@ -390,7 +389,7 @@ module_exit(r82600_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tim Small <tim@buttersideup.com> - WPAD Ltd. "
-	"on behalf of EADS Astrium");
+	      "on behalf of EADS Astrium");
 MODULE_DESCRIPTION("MC support for Radisys 82600 memory controllers");
 
 module_param(disable_hardware_scrub, bool, 0644);

