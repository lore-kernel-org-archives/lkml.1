Return-Path: <linux-kernel-owner+w=401wt.eu-S1751841AbXA0QYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbXA0QYM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 11:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXA0QYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 11:24:12 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:45954 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbXA0QYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 11:24:11 -0500
Date: Sat, 27 Jan 2007 17:22:14 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: akpm@osdl.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070127162421.13115.33482.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] Convert pci_module_init() to pci_register_driver()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert pci_module_init() to pci_register_driver().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with "allyes", "allmod" & "allno" on i386
Diff'ed against the unpatched object-files, no difference
Has previously been sent to the maintainers, without respons

 crypto/geode-aes.c |    2 +-
 net/hp100.c        |    2 +-
 scsi/megaraid.c    |    2 +-
 scsi/tmscsim.c     |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 43a6839..31ea405 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -457,7 +457,7 @@ static struct pci_driver geode_aes_driver = {
 static int __init
 geode_aes_init(void)
 {
-	return pci_module_init(&geode_aes_driver);
+	return pci_register_driver(&geode_aes_driver);
 }
 
 static void __exit
diff --git a/drivers/net/hp100.c b/drivers/net/hp100.c
index 844c136..ff3663d 100644
--- a/drivers/net/hp100.c
+++ b/drivers/net/hp100.c
@@ -3034,7 +3034,7 @@ static int __init hp100_module_init(void)
 		goto out2;
 #endif
 #ifdef CONFIG_PCI
-	err = pci_module_init(&hp100_pci_driver);
+	err = pci_register_driver(&hp100_pci_driver);
 	if (err && err != -ENODEV)
 		goto out3;
 #endif
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 77d9d38..4fd4960 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -5072,7 +5072,7 @@ static int __init megaraid_init(void)
 				"megaraid: failed to create megaraid root\n");
 	}
 #endif
-	error = pci_module_init(&megaraid_pci_driver);
+	error = pci_register_driver(&megaraid_pci_driver);
 	if (error) {
 #ifdef CONFIG_PROC_FS
 		remove_proc_entry("megaraid", &proc_root);
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index fa5382e..ce8845e 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2681,7 +2681,7 @@ static int __init dc390_module_init(void)
 		printk (KERN_INFO "DC390: Using safe settings.\n");
 	}
 
-	return pci_module_init(&dc390_driver);
+	return pci_register_driver(&dc390_driver);
 }
 
 static void __exit dc390_module_exit(void)
