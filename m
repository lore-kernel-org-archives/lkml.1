Return-Path: <linux-kernel-owner+w=401wt.eu-S1946172AbXBIHT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946172AbXBIHT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 02:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946175AbXBIHT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 02:19:29 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:33357 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946172AbXBIHT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 02:19:29 -0500
Date: Fri, 9 Feb 2007 08:18:07 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: akpm@osdl.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070209071807.14937.72272.sendpatchset@thinktank.campus.ltu.se>
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
 scsi/megaraid.c    |    2 +-
 scsi/tmscsim.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


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
