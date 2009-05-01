Return-Path: <linux-kernel-owner+w=401wt.eu-S1758992AbZEACO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992AbZEACO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 22:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbZEACOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 22:14:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:39536 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbZEACOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 22:14:47 -0400
Message-ID: <49FA5AD5.3070804@kernel.org>
Date: Thu, 30 Apr 2009 19:13:41 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi: ses check name in enclosure_component_register -v2
References: <49F6678D.3080207@kernel.org> <1240957589.3380.67.camel@mulgrave.int.hansenpartnership.com> <49F7979A.8040302@kernel.org> <1240964289.3380.73.camel@mulgrave.int.hansenpartnership.com> <49F7A71F.5040709@kernel.org> <20090429020331.GF21648@parisc-linux.org> <49F7CA9A.5000701@kernel.org> <20090429110846.GG21648@parisc-linux.org>
In-Reply-To: <20090429110846.GG21648@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


dev_set_name will use sprintf to copy the name.
need to check if the name does valid.

otherwise will error from device_add later.

v2: add %s in dev_set_name according to James

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/misc/enclosure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/misc/enclosure.c
===================================================================
--- linux-2.6.orig/drivers/misc/enclosure.c
+++ linux-2.6/drivers/misc/enclosure.c
@@ -119,7 +119,7 @@ enclosure_register(struct device *dev, c
 	edev->edev.class = &enclosure_class;
 	edev->edev.parent = get_device(dev);
 	edev->cb = cb;
-	dev_set_name(&edev->edev, name);
+	dev_set_name(&edev->edev, "%s", name);
 	err = device_register(&edev->edev);
 	if (err)
 		goto err;
@@ -255,8 +255,8 @@ enclosure_component_register(struct encl
 	ecomp->number = number;
 	cdev = &ecomp->cdev;
 	cdev->parent = get_device(&edev->edev);
-	if (name)
-		dev_set_name(cdev, name);
+	if (name && name[0])
+		dev_set_name(cdev, "%s", name);
 	else
 		dev_set_name(cdev, "%u", number);
 
