Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbYAANty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbYAANty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbYAANsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:48:51 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37098 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbYAANsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:48:45 -0500
Date: Tue, 1 Jan 2008 15:48:31 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Subject: [RFC: 2.6 patch] make BINFMT_FLAT a bool
Message-ID: <20080101134831.GM2360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have not yet seen anyone saying he has a reasonable use case for using 
BINFMT_FLAT modular on his embedded device.

Considering that fs/binfmt_flat.c even lacks a MODULE_LICENSE() I really 
doubt there is any, and this patch therefore makes BINFMT_FLAT a bool.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/Kconfig.binfmt |    2 +-
 fs/binfmt_flat.c  |    6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

5437fb7517380d1b93dde3c09dbd3a2efaf276c3 
diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index d4fc609..c16a16c 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -37,7 +37,7 @@ config BINFMT_ELF_FDPIC
 	  It is also possible to run FDPIC ELF binaries on MMU linux also.
 
 config BINFMT_FLAT
-	tristate "Kernel support for flat binaries"
+	bool "Kernel support for flat binaries"
 	depends on !MMU
 	help
 	  Support uClinux FLAT format binaries.
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 33764fd..274d723 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -933,14 +933,8 @@ static int __init init_flat_binfmt(void)
 	return register_binfmt(&flat_format);
 }
 
-static void __exit exit_flat_binfmt(void)
-{
-	unregister_binfmt(&flat_format);
-}
-
 /****************************************************************************/
 
 core_initcall(init_flat_binfmt);
-module_exit(exit_flat_binfmt);
 
 /****************************************************************************/

