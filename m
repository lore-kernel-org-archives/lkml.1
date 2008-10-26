Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYJZFkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYJZFkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 01:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYJZFkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 01:40:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43391 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYJZFka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 01:40:30 -0400
Date: Sun, 26 Oct 2008 05:40:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bzolnier@gmail.com, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH] arm ide breakage
Message-ID: <20081026054026.GO28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a) semicolon before the function body is a bad idea
b) it's const struct foo, not struct const foo
c) incidentally, it's ecard_remove_driver(), not ecard_unregister_driver()
d) compiling is occasionally useful.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---

diff --git a/drivers/ide/icside.c b/drivers/ide/icside.c
index 76bdc9a..2d84801 100644
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -690,9 +690,9 @@ static int __init icside_init(void)
 	return ecard_register_driver(&icside_driver);
 }
 
-static void __exit icside_exit(void);
+static void __exit icside_exit(void)
 {
-	ecard_unregister_driver(&icside_driver);
+	ecard_remove_driver(&icside_driver);
 }
 
 MODULE_AUTHOR("Russell King <rmk@arm.linux.org.uk>");
diff --git a/drivers/ide/rapide.c b/drivers/ide/rapide.c
index 78d27d9..d5003ca 100644
--- a/drivers/ide/rapide.c
+++ b/drivers/ide/rapide.c
@@ -11,7 +11,7 @@
 
 #include <asm/ecard.h>
 
-static struct const ide_port_info rapide_port_info = {
+static const struct ide_port_info rapide_port_info = {
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
 };
 
@@ -97,7 +97,7 @@ static int __init rapide_init(void)
 
 static void __exit rapide_exit(void)
 {
-	ecard_unregister_driver(&rapide_driver);
+	ecard_remove_driver(&rapide_driver);
 }
 
 MODULE_LICENSE("GPL");
