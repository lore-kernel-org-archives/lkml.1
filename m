Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbXFCOsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbXFCOsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbXFCOna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:43:30 -0400
Received: from web50111.mail.re2.yahoo.com ([206.190.39.137]:28913 "HELO
	web50111.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757402AbXFCOn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:43:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=vkLAZsrUiV+Vs1LqRDZbzByfWiwsrY/vGl1msN1zF+dmMEFfKzdJxtB7A8difD88jfOammqEmGpIEk52M+A8HIBsa0pcT48hFBE/NOmSJTzLm3GlPHvUCUndG3Rc24F6Lp7lwptIR8TPCKyxxMNtFS8NSsZN8PT00sbb416rzyQ=;
X-YMail-OSG: 7Eyttu0VM1lOeCLIyLBfLrQsJqrgCab8ohwWBvLWy7yNU7HFotPSvCAZWneG5yhXvDMPcDt0wq0KDGqKoO3U6RotT_AauBHCCuwSQ5MQ9OzrGEbMg1c85GxvUC4TgBgG8wloyw--
Date: Sun, 3 Jun 2007 07:43:28 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 27/36] drivers edac Lindent i82860 driver
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <474598.87201.qm@web50111.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Dave Jiang <djiang@mvista.com>

Lindent cleanup of i82860 edac driver

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
---
 i82860_edac.c |   40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)


Index: linux-2.6.22-rc1/drivers/edac/i82860_edac.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/edac/i82860_edac.c
+++ linux-2.6.22-rc1/drivers/edac/i82860_edac.c
@@ -54,8 +54,7 @@ struct i82860_error_info {
 
 static const struct i82860_dev_info i82860_devs[] = {
 	[I82860] = {
-		.ctl_name = "i82860"
-	},
+		    .ctl_name = "i82860"},
 };
 
 static struct pci_dev *mci_pdev = NULL;	/* init dev: in case that AGP
code
@@ -63,7 +62,7 @@ static struct pci_dev *mci_pdev = NULL;	
 					 */
 
 static void i82860_get_error_info(struct mem_ctl_info *mci,
-		struct i82860_error_info *info)
+				  struct i82860_error_info *info)
 {
 	struct pci_dev *pdev;
 
@@ -91,13 +90,13 @@ static void i82860_get_error_info(struct
 
 	if ((info->errsts ^ info->errsts2) & 0x0003) {
 		pci_read_config_dword(pdev, I82860_EAP, &info->eap);
-		pci_read_config_word(pdev, I82860_DERRCTL_STS,
-				&info->derrsyn);
+		pci_read_config_word(pdev, I82860_DERRCTL_STS, &info->derrsyn);
 	}
 }
 
 static int i82860_process_error_info(struct mem_ctl_info *mci,
-		struct i82860_error_info *info, int handle_errors)
+				     struct i82860_error_info *info,
+				     int handle_errors)
 {
 	int row;
 
@@ -119,7 +118,7 @@ static int i82860_process_error_info(str
 		edac_mc_handle_ue(mci, info->eap, 0, row, "i82860 UE");
 	else
 		edac_mc_handle_ce(mci, info->eap, 0, info->derrsyn, row, 0,
-				"i82860 UE");
+				  "i82860 UE");
 
 	return 1;
 }
@@ -136,7 +135,7 @@ static void i82860_check(struct mem_ctl_
 static void i82860_init_csrows(struct mem_ctl_info *mci, struct
pci_dev *pdev)
 {
 	unsigned long last_cumul_size;
-	u16 mchcfg_ddim;  /* DRAM Data Integrity Mode 0=none, 2=edac */
+	u16 mchcfg_ddim;	/* DRAM Data Integrity Mode 0=none, 2=edac */
 	u16 value;
 	u32 cumul_size;
 	struct csrow_info *csrow;
@@ -204,12 +203,12 @@ static int i82860_probe1(struct pci_dev 
 	mci->edac_check = i82860_check;
 	mci->ctl_page_to_phys = NULL;
 	i82860_init_csrows(mci, pdev);
-	i82860_get_error_info(mci, &discard);  /* clear counters */
+	i82860_get_error_info(mci, &discard);	/* clear counters */
 
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci,0)) {
+	if (edac_mc_add_mc(mci, 0)) {
 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail;
 	}
@@ -219,14 +218,14 @@ static int i82860_probe1(struct pci_dev 
 
 	return 0;
 
-fail:
+      fail:
 	edac_mc_free(mci);
 	return -ENODEV;
 }
 
 /* returns count (>= 0), or negative on error */
 static int __devinit i82860_init_one(struct pci_dev *pdev,
-		const struct pci_device_id *ent)
+				     const struct pci_device_id *ent)
 {
 	int rc;
 
@@ -258,12 +257,11 @@ static void __devexit i82860_remove_one(
 
 static const struct pci_device_id i82860_pci_tbl[] __devinitdata = {
 	{
-		PCI_VEND_DEV(INTEL, 82860_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		I82860
-	},
+	 PCI_VEND_DEV(INTEL, 82860_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	 I82860},
 	{
-		0,
-	}	/* 0 terminated list. */
+	 0,
+	 }			/* 0 terminated list. */
 };
 
 MODULE_DEVICE_TABLE(pci, i82860_pci_tbl);
@@ -286,7 +284,7 @@ static int __init i82860_init(void)
 
 	if (!mci_pdev) {
 		mci_pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
-					PCI_DEVICE_ID_INTEL_82860_0, NULL);
+					  PCI_DEVICE_ID_INTEL_82860_0, NULL);
 
 		if (mci_pdev == NULL) {
 			debugf0("860 pci_get_device fail\n");
@@ -305,10 +303,10 @@ static int __init i82860_init(void)
 
 	return 0;
 
-fail1:
+      fail1:
 	pci_unregister_driver(&i82860_driver);
 
-fail0:
+      fail0:
 	if (mci_pdev != NULL)
 		pci_dev_put(mci_pdev);
 
@@ -330,5 +328,5 @@ module_exit(i82860_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com) "
-	"Ben Woodard <woodard@redhat.com>");
+	      "Ben Woodard <woodard@redhat.com>");
 MODULE_DESCRIPTION("ECC support for Intel 82860 memory hub
controllers");

