Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbXKZJD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbXKZJD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 04:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbXKZJC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 04:02:57 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:60760 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbXKZJCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 04:02:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=K6tLEaXrPWoIoR4w+Gz3WpoTErPBOsZuceDRlKf+NPwo3alSK9fZJMU8cC5xUyrLRmTdibLhOcJckU98wQ8+xQbQU9cZeG2RNlNwx6AmaNZ5xT69gRIfXbDBQrddl7epX/f1W5Nd+vgJwE1JT+1MYw/gL36JWNt6gJ8b01/puug=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <netdev@vger.kernel.org>, <chas@cmf.nrl.navy.mil>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] atm/ambassador: kmalloc + memset conversion to kzalloc
Date: Mon, 26 Nov 2007 18:02:43 +0900
Message-ID: <007f01c8300b$1b89ac40$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: AcgwCxrK2rKrQag9SdmKQPHRYX4uUg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

atm/ambassador: kmalloc + memset conversion to kzalloc

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>

Thanks.
Joonwoo

---
diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
index b34b382..4f99ba3 100644
--- a/drivers/atm/ambassador.c
+++ b/drivers/atm/ambassador.c
@@ -2163,7 +2163,6 @@ static int __devinit amb_init (amb_dev * dev)
 static void setup_dev(amb_dev *dev, struct pci_dev *pci_dev) 
 {
       unsigned char pool;
-      memset (dev, 0, sizeof(amb_dev));
       
       // set up known dev items straight away
       dev->pci_dev = pci_dev; 
@@ -2253,7 +2252,7 @@ static int __devinit amb_probe(struct pci_dev *pci_dev, const struct pci_device_
 		goto out_disable;
 	}
 
-	dev = kmalloc (sizeof(amb_dev), GFP_KERNEL);
+	dev = kzalloc(sizeof(amb_dev), GFP_KERNEL);
 	if (!dev) {
 		PRINTK (KERN_ERR, "out of memory!");
 		err = -ENOMEM;
---

