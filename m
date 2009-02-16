Return-Path: <linux-kernel-owner+w=401wt.eu-S1757680AbZBPNkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbZBPNkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 08:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756394AbZBPNkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 08:40:22 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:50025 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbZBPNkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:40:21 -0500
Message-ID: <49996CBB.7040007@in.ibm.com>
Date: Mon, 16 Feb 2009 19:10:11 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       avorontsov@ru.mvista.com
Subject: [Patch - Next] [USB/FHCI] use dev_name() in place of bus_id.
References: <20090216172016.f1d159a7.sfr@canb.auug.org.au> <499929CB.2030004@in.ibm.com> <20090216211310.5513de1a.sfr@canb.auug.org.au>
In-Reply-To: <20090216211310.5513de1a.sfr@canb.auug.org.au>
Content-Type: multipart/mixed;
 boundary="------------070300090804010904080502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070300090804010904080502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Replace references to bus_id with dev_name() to fix fhci driver build break.

drivers/usb/host/fhci-hcd.c:586: error: struct device has no member named bus_id
drivers/usb/host/fhci-hcd.c:653: error: struct device has no member named bus_id
drivers/usb/host/fhci-dbg.c:111: error: struct device has no member named bus_id

Signed-off-by: Sachin Sant <sachinp@in.ibm.com>
---



--------------070300090804010904080502
Content-Type: text/x-patch;
 name="use_dev_name_instead_of_bus_id_for_fhci.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="use_dev_name_instead_of_bus_id_for_fhci.patch"

Replace references to bus_id with dev_name() to fix fhci driver build break.

drivers/usb/host/fhci-hcd.c:586: error: struct device has no member named bus_id
drivers/usb/host/fhci-hcd.c:653: error: struct device has no member named bus_id
drivers/usb/host/fhci-dbg.c:111: error: struct device has no member named bus_id

Signed-off-by: Sachin Sant <sachinp@in.ibm.com>
---

diff -Naurp a/drivers/usb/host/fhci-dbg.c b/drivers/usb/host/fhci-dbg.c
--- a/drivers/usb/host/fhci-dbg.c	2009-02-14 05:01:30.000000000 +0530
+++ b/drivers/usb/host/fhci-dbg.c	2009-02-16 18:19:25.000000000 +0530
@@ -108,7 +108,7 @@ void fhci_dfs_create(struct fhci_hcd *fh
 {
 	struct device *dev = fhci_to_hcd(fhci)->self.controller;
 
-	fhci->dfs_root = debugfs_create_dir(dev->bus_id, NULL);
+	fhci->dfs_root = debugfs_create_dir(dev_name(dev), NULL);
 	if (!fhci->dfs_root) {
 		WARN_ON(1);
 		return;
diff -Naurp a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
--- a/drivers/usb/host/fhci-hcd.c	2009-02-14 05:01:30.000000000 +0530
+++ b/drivers/usb/host/fhci-hcd.c	2009-02-16 18:19:00.000000000 +0530
@@ -583,7 +583,7 @@ static int __devinit of_fhci_probe(struc
 	if (sprop && strcmp(sprop, "host"))
 		return -ENODEV;
 
-	hcd = usb_create_hcd(&fhci_driver, dev, dev->bus_id);
+	hcd = usb_create_hcd(&fhci_driver, dev, dev_name(dev));
 	if (!hcd) {
 		dev_err(dev, "could not create hcd\n");
 		return -ENOMEM;
@@ -650,7 +650,7 @@ static int __devinit of_fhci_probe(struc
 			}
 		}
 
-		ret = gpio_request(gpio, dev->bus_id);
+		ret = gpio_request(gpio, dev_name(dev));
 		if (ret) {
 			dev_err(dev, "failed to request gpio %d", i);
 			goto err_gpios;

--------------070300090804010904080502--
