Return-Path: <linux-kernel-owner+w=401wt.eu-S933158AbXDZG4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbXDZG4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933161AbXDZG4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:56:50 -0400
Received: from imx9.toshiba.co.jp ([202.33.96.51]:36214 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158AbXDZG4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:56:48 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2/2]  Fixed typo Intel RNG driver for 2.6.21-rc7-mm1
X-MimeOLE: Produced By Microsoft Exchange V6.5.7226.0
Date: Thu, 26 Apr 2007 15:27:45 +0900
Message-ID: <BF571719A4041A478005EF3F08EA6DF004332397@pcsmail03.pcs.pc.ome.toshiba.co.jp>
Thread-Topic: [PATCH 2/2]  Fixed typo Intel RNG driver for 2.6.21-rc7-mm1
Thread-Index: AceHzAA5dDQcwLDARfWFC8IWhgBd5w==
From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
To: <prarit@redhat.com>, <jbeulich@novell.com>
Cc: "lkml" <linux-kernel@vger.kernel.org>,
       "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a typo in mod_init().
fwh_done is performed when Intel fwh is found.

 intel-rng.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.21-rc7-mm1/drivers/char/hw_random/intel-rng.c~	2007-04-26 13:41:53.000000000 +0900
+++ linux-2.6.21-rc7-mm1/drivers/char/hw_random/intel-rng.c	2007-04-26 13:43:35.000000000 +0900
@@ -264,7 +264,6 @@ static int __init intel_rng_hw_init(void
 	if (mfc != INTEL_FWH_MANUFACTURER_CODE ||
 	    (dvc != INTEL_FWH_DEVICE_CODE_8M &&
 	     dvc != INTEL_FWH_DEVICE_CODE_4M)) {
-		printk(KERN_ERR PFX "FWH not detected\n");
 		return -ENODEV;
 	}
 
@@ -365,7 +364,8 @@ static int __init mod_init(void)
 	pci_dev_put(dev);
 	iounmap(intel_rng_hw->mem);
 	kfree(intel_rng_hw);
-	goto out;
+	if (err)
+		goto out;
 
 fwh_done:
 	err = -ENOMEM;
