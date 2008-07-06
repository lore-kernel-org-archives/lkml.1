Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbYGFRvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbYGFRvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759315AbYGFRgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:36:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:9934 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759162AbYGFRfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=rG/Et9xShHCJjSntyOQhSdEaYKcexHGtBMDEWgA9I5vIHnDh8EEnZbFQfRdvLK4krI
         xJ/MhvPCCXTzegOgsXtMrmy77Go7wXbGU7ZI3ji22lasBscdMqHaQkLcuTi3enrOXoBl
         sbu3qxdXHZQfFlsEIYKEsYG40No9ff+cU8UDE=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:59 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH 49/50] icside: add module_exit()
Content-Disposition: inline; filename=icside-add-module_exit.patch
Message-ID: <4871026d.1ade660a.3458.62e9@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -710,8 +710,14 @@ static int __init icside_init(void)
 	return ecard_register_driver(&icside_driver);
 }
 
+static void __exit icside_exit(void);
+{
+	ecard_unregister_driver(&icside_driver);
+}
+
 MODULE_AUTHOR("Russell King <rmk@arm.linux.org.uk>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ICS IDE driver");
 
 module_init(icside_init);
+module_exit(icside_exit);

-- 

