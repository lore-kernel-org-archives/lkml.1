Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840Ab0AVVto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0AVVto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 16:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694Ab0AVVtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 16:49:11 -0500
Received: from server78.greatnet.de ([83.133.96.102]:48993 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab0AVVtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 16:49:10 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: jonathan@buzzard.org.uk
Cc: alan@linux.intel.com, tlinux-users@tce.toshiba-dme.co.jp,
       linux-kernel@vger.kernel.org,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 3/4] [DRIVERS] loglevel clenup in toshiba.c
Date: Fri, 22 Jan 2010 22:41:11 +0100
Message-Id: <1264196472-5387-3-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1264196472-5387-2-git-send-email-henne@nachtwindheim.de>
References: <1264196472-5387-1-git-send-email-henne@nachtwindheim.de>
 <1264196472-5387-2-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing loglevels and intorduce DEV_NAME to replace the
dispersed "toshiba" s.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 drivers/char/toshiba.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/char/toshiba.c b/drivers/char/toshiba.c
index 8e686ac..111baba 100644
--- a/drivers/char/toshiba.c
+++ b/drivers/char/toshiba.c
@@ -72,6 +72,7 @@
 #include <linux/smp_lock.h>
 #include <linux/toshiba.h>
 
+#define DRV_NAME "toshiba"
 #define TOSH_MINOR_DEV 181
 
 MODULE_LICENSE("GPL");
@@ -395,7 +396,8 @@ static int __init tosh_get_machine_id(void __iomem *bios)
 		   value. This has been verified on a Satellite Pro 430CDT,
 		   Tecra 750CDT, Tecra 780DVD and Satellite 310CDT. */
 #if TOSH_DEBUG
-		printk("toshiba: debugging ID ebx=0x%04x\n", regs.ebx);
+		printk(KERN_DEBUG DRV_NAME ": debugging ID ebx=0x%04x\n",
+		       regs.ebx);
 #endif
 		bx = 0xe6f5;
 
@@ -439,7 +441,8 @@ static int __init tosh_probe(void)
 
 	for (i=0;i<7;i++) {
 		if (readb(bios+0xe010+i)!=signature[i]) {
-			printk("toshiba: not a supported Toshiba laptop\n");
+			printk(KERN_WARNING DRV_NAME
+			       ": not a supported Toshiba laptop\n");
 			iounmap(bios);
 			return -ENODEV;
 		}
@@ -455,7 +458,8 @@ static int __init tosh_probe(void)
 	/* if this is not a Toshiba laptop carry flag is set and ah=0x86 */
 
 	if ((flag==1) || ((regs.eax & 0xff00)==0x8600)) {
-		printk("toshiba: not a supported Toshiba laptop\n");
+		printk(KERN_WARNING DRV_NAME
+		       ": not a supported Toshiba laptop\n");
 		iounmap(bios);
 		return -ENODEV;
 	}
@@ -523,7 +527,7 @@ static int __init toshiba_init(void)
 	{
 		struct proc_dir_entry *pde;
 
-		pde = proc_create("toshiba", 0, NULL, &proc_toshiba_fops);
+		pde = proc_create(DRV_NAME, 0, NULL, &proc_toshiba_fops);
 		if (!pde) {
 			misc_deregister(&tosh_device);
 			return -ENOMEM;
@@ -536,7 +540,7 @@ static int __init toshiba_init(void)
 
 static void __exit toshiba_exit(void)
 {
-	remove_proc_entry("toshiba", NULL);
+	remove_proc_entry(DRV_NAME, NULL);
 	misc_deregister(&tosh_device);
 }
 
-- 
1.6.5

