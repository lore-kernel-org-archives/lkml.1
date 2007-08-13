Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbXHMEGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbXHMEGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 00:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbXHMEGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 00:06:41 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:64819 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbXHMEGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 00:06:40 -0400
Date: Mon, 13 Aug 2007 00:06:39 -0400
To: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
       <dri-devel@lists.sourceforge.net>
Subject: [PATCH 5 of 5 ] /drivers/char/watchdog ioremap balancing/ returncode check
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070813040639.F067ADA820@mailserver8.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

patchset against 2.6.23-rc2 and this set is an audit of 
/drivers/char/a* 
through drivers/char .   

this corrects missing ioremap return checks and balancing on 
iounmap calls..

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------
diff --git a/drivers/char/watchdog/iTCO_wdt.c 
b/drivers/char/watchdog/iTCO_wdt.c
index cd5a565..81c5901 100644
--- a/drivers/char/watchdog/iTCO_wdt.c
+++ b/drivers/char/watchdog/iTCO_wdt.c
@@ -621,6 +621,12 @@ static int iTCO_wdt_init(struct pci_dev *pdev, 
const struct pci_device_id *ent,
 		pci_read_config_dword(pdev, 0xf0, &base_address);
 		RCBA = base_address & 0xffffc000;
 		iTCO_wdt_private.gcs = ioremap((RCBA + 0x3410),4);
+		if (!iTCO_wdt_private.gcs) {
+			printk(KERN_ERR PFX "failed to ioremap\n");
+			ret = -ENOMEM;
+			goto out;
+		}
+
 	}
 
 	/* Check chipset's NO_REBOOT bit */


