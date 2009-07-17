Return-Path: <linux-kernel-owner+w=401wt.eu-S933755AbZGQAJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755AbZGQAJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933685AbZGQAJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:09:53 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39109 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933640AbZGQAFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:05:49 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 02/21] Blackfin: drop dead flash_probe call
Date: Thu, 16 Jul 2009 20:05:27 -0400
Message-Id: <1247789146-18786-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no CONFIG_{BLK,CHR}_DEV_FLASH Kconfig options, and there is no
flash_probe() function, so not really sure what this code is all about.
Seems to be dead code that stretches way back to the start of the Blackfin
port.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/setup.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 6136c33..6e150d9 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -868,13 +868,6 @@ void __init setup_arch(char **cmdline_p)
 	else
 		printk(KERN_CONT "and Disabled\n");
 
-#if defined(CONFIG_CHR_DEV_FLASH) || defined(CONFIG_BLK_DEV_FLASH)
-	/* we need to initialize the Flashrom device here since we might
-	 * do things with flash early on in the boot
-	 */
-	flash_probe();
-#endif
-
 	printk(KERN_INFO "Boot Mode: %i\n", bfin_read_SYSCR() & 0xF);
 
 	/* Newer parts mirror SWRST bits in SYSCR */
-- 
1.6.3.3

