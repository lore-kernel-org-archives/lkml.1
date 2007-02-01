Return-Path: <linux-kernel-owner+w=401wt.eu-S1422881AbXBANxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422881AbXBANxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422885AbXBANww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:52:52 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51246 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422881AbXBANwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:52:39 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] ide section fixes
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org
Message-Id: <E1HCcMg-0007QC-Vk@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 01 Feb 2007 13:52:38 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


a) cleanup_module() should be __exit
b) externs should match reality

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/ide/ide.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 3b334af..6c9bd51 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1781,9 +1781,9 @@ done:
 	return 1;
 }
 
-extern void pnpide_init(void);
-extern void pnpide_exit(void);
-extern void h8300_ide_init(void);
+extern void __init pnpide_init(void);
+extern void __exit pnpide_exit(void);
+extern void __init h8300_ide_init(void);
 
 /*
  * probe_for_hwifs() finds/initializes "known" IDE interfaces
@@ -2088,7 +2088,7 @@ int __init init_module (void)
 	return ide_init();
 }
 
-void cleanup_module (void)
+void __exit cleanup_module (void)
 {
 	int index;
 
-- 
1.5.0-rc2.GIT


