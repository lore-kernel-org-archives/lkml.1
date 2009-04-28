Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbZD1CUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbZD1CUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 22:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbZD1CTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 22:19:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:44308 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbZD1CTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 22:19:51 -0400
Message-ID: <49F6678D.3080207@kernel.org>
Date: Mon, 27 Apr 2009 19:18:53 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi: ses check name in enclosure_component_register
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


dev_set_name will use sprintf to copy the name.
need to check if the name does valid.

otherwise will error from device_add later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 3cf61ec..68743a9 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -255,7 +255,7 @@ enclosure_component_register(struct enclosure_device *edev,
 	ecomp->number = number;
 	cdev = &ecomp->cdev;
 	cdev->parent = get_device(&edev->edev);
-	if (name)
+	if (name && name[0])
 		dev_set_name(cdev, name);
 	else
 		dev_set_name(cdev, "%u", number);
