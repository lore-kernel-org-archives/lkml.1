Return-Path: <linux-kernel-owner+w=401wt.eu-S1762033AbYGFRt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762033AbYGFRt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759152AbYGFRgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:36:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:7314 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759190AbYGFRfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=SRgEMtyeM0AFQp1A/9YWriHVO3LnUpEvxPKS+L82l69uAdbFAhPeHJVfODIJ4DnrT1
         JB8kvZKMclTkwbAEzVcKZsDopqFSlWCfcgqvbJ3CGNJQvUENrmTuezmBrB+7KF4cKilz
         M85zx809aWnVNoZAlfF4XfPRQxVuS+m2dHdfQ=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:21:00 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH 50/50] rapide: add module_exit()
Content-Disposition: inline; filename=rapide-add-module_exit.patch
Message-ID: <4871026e.1ade660a.3458.62ed@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/rapide.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -95,7 +95,13 @@ static int __init rapide_init(void)
 	return ecard_register_driver(&rapide_driver);
 }
 
+static void __exit rapide_exit(void)
+{
+	ecard_unregister_driver(&rapide_driver);
+}
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Yellowstone RAPIDE driver");
 
 module_init(rapide_init);
+module_exit(rapide_exit);

-- 

