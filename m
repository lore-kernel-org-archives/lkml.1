Return-Path: <linux-kernel-owner+w=401wt.eu-S1762099AbYBBCzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762099AbYBBCzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 21:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbYBBCzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 21:55:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:15709 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYBBCzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 21:55:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tGrWIPEWokcftIZBYMIgrRsBYpnafxbsD5mpSeWloimvPiQ2Im/l3souu9MRqdWBN28WAF7FJinCKqRqinRkwNidNO5phLpwtbPJIt4xyU2oBlHBTd65E/Lzh6Y+0AqDXvwT3wf1/ofWhzxrpx488HC9+XcTm/C/uWT3MsltDSg=
From: Denis Cheng <crquan@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] wireless/ath5k: renamed to ath5k_pci_driver to fix Section mismatch warnings
Date: Sat,  2 Feb 2008 10:55:10 +0800
Message-Id: <1201920910-6649-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the struct pci_driver refered ath5k_pci_id_table which in __devinit section,
the sparse tool suggest this renamed to "*driver", kills mismatch warnings.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/net/wireless/ath5k/base.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index d6599d2..ddc8714 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -153,7 +153,7 @@ static int		ath5k_pci_resume(struct pci_dev *pdev);
 #define ath5k_pci_resume NULL
 #endif /* CONFIG_PM */
 
-static struct pci_driver ath5k_pci_drv_id = {
+static struct pci_driver ath5k_pci_driver = {
 	.name		= "ath5k_pci",
 	.id_table	= ath5k_pci_id_table,
 	.probe		= ath5k_pci_probe,
@@ -329,7 +329,7 @@ init_ath5k_pci(void)
 
 	ath5k_debug_init();
 
-	ret = pci_register_driver(&ath5k_pci_drv_id);
+	ret = pci_register_driver(&ath5k_pci_driver);
 	if (ret) {
 		printk(KERN_ERR "ath5k_pci: can't register pci driver\n");
 		return ret;
@@ -341,7 +341,7 @@ init_ath5k_pci(void)
 static void __exit
 exit_ath5k_pci(void)
 {
-	pci_unregister_driver(&ath5k_pci_drv_id);
+	pci_unregister_driver(&ath5k_pci_driver);
 
 	ath5k_debug_finish();
 }
-- 
1.5.3.8

