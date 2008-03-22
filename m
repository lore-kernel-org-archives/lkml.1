Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYCVDSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYCVDSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 23:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYCVDSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 23:18:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:50825 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYCVDSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 23:18:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=nbVWc5g/9q2StmffzenZXdOa78JdKFAwb4pfUjqq7wyBF/fZsW8ru8AV4PUsNzK4FKGIfx0G/PE8oooqgZGUF9hPBfkRQFKu/+5EfNIy6DJ9qmO+EvXBDZsF1DR7Q5IY0tAaeJXteAYMNcsR1Z3/6hmf/BxQBlkNL59W0T7koTY=
Date: Sat, 22 Mar 2008 12:09:51 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] cdrom: remove ifdef CONFIG_SYSCTL
Message-ID: <20080322030948.GA3665@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes #ifdef for CONFIG_SYSCTL by defining empty
cdrom_sysctl_register and cdrom_sysctl_unregister when CONFIG_SYSCTL
is not defined.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/cdrom/cdrom.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

Index: 2.6-git/drivers/cdrom/cdrom.c
===================================================================
--- 2.6-git.orig/drivers/cdrom/cdrom.c
+++ 2.6-git/drivers/cdrom/cdrom.c
@@ -360,9 +360,8 @@ static int cdrom_mrw_exit(struct cdrom_d
 
 static int cdrom_get_disc_info(struct cdrom_device_info *cdi, disc_information *di);
 
-#ifdef CONFIG_SYSCTL
 static void cdrom_sysctl_register(void);
-#endif /* CONFIG_SYSCTL */ 
+
 static struct cdrom_device_info *topCdromPtr;
 
 static int cdrom_dummy_generic_packet(struct cdrom_device_info *cdi,
@@ -398,9 +397,7 @@ int register_cdrom(struct cdrom_device_i
 	if (!banner_printed) {
 		printk(KERN_INFO "Uniform CD-ROM driver " REVISION "\n");
 		banner_printed = 1;
-#ifdef CONFIG_SYSCTL
 		cdrom_sysctl_register();
-#endif /* CONFIG_SYSCTL */ 
 	}
 
 	ENSURE(drive_status, CDC_DRIVE_STATUS );
@@ -3571,22 +3568,29 @@ static void cdrom_sysctl_unregister(void
 		unregister_sysctl_table(cdrom_sysctl_header);
 }
 
+#else /* CONFIG_SYSCTL */
+
+static void cdrom_sysctl_register(void)
+{
+}
+
+static void cdrom_sysctl_unregister(void)
+{
+}
+
 #endif /* CONFIG_SYSCTL */
 
 static int __init cdrom_init(void)
 {
-#ifdef CONFIG_SYSCTL
 	cdrom_sysctl_register();
-#endif
+
 	return 0;
 }
 
 static void __exit cdrom_exit(void)
 {
 	printk(KERN_INFO "Uniform CD-ROM driver unloaded\n");
-#ifdef CONFIG_SYSCTL
 	cdrom_sysctl_unregister();
-#endif
 }
 
 module_init(cdrom_init);
