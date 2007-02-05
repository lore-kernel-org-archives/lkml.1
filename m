Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbXBEFTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbXBEFTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 00:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbXBEFTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 00:19:15 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:51895 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbXBEFTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 00:19:10 -0500
Date: Sun, 04 Feb 2007 23:18:32 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH -mm] sata_nv: propagate ata_pci_device_do_resume return value
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>
Message-id: <45C6BE28.9070205@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ata_pci_device_do_resume can fail if the PCI device couldn't be re-enabled.
Update sata_nv to propagate the return value from this call and to
not try to do any other resume activities if it fails. Fixes a compile
warning.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.20-rc6-mm3edit/drivers/ata/sata_nv.c.beforeresumechange	2007-02-04 22:18:49.000000000 -0600
+++ linux-2.6.20-rc6-mm3edit/drivers/ata/sata_nv.c	2007-02-04 22:20:06.000000000 -0600
@@ -1604,8 +1604,11 @@ static int nv_pci_device_resume(struct p
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	struct nv_host_priv *hpriv = host->private_data;
+	int rc;
 
-	ata_pci_device_do_resume(pdev);
+	rc = ata_pci_device_do_resume(pdev);
+	if(rc)
+		return rc;
 
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
 		if(hpriv->type >= CK804) {

