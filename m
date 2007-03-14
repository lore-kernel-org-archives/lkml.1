Return-Path: <linux-kernel-owner+w=401wt.eu-S1030757AbXCNJSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030757AbXCNJSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030764AbXCNJRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:17:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60782 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030744AbXCNJRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:17:05 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 13/13] fix ps3fb glue allowing a modular build
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <E1HRPbU-0003Ha-Oq@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:17:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/platforms/ps3/htab.c |    2 ++
 drivers/video/Kconfig             |    2 +-
 include/asm-powerpc/ps3fb.h       |    5 -----
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/ps3/htab.c b/arch/powerpc/platforms/ps3/htab.c
index e12e59f..67d6f58 100644
--- a/arch/powerpc/platforms/ps3/htab.c
+++ b/arch/powerpc/platforms/ps3/htab.c
@@ -235,7 +235,9 @@ static void ps3_hpte_invalidate(unsigned long slot, unsigned long va,
 static void ps3_hpte_clear(void)
 {
 	/* Make sure to clean up the frame buffer device first */
+#ifdef CONFIG_PS3_FB
 	ps3fb_cleanup();
+#endif
 
 	lv1_unmap_htab(htab_addr);
 }
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 7f5a598..ab43a32 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1615,7 +1615,7 @@ config FB_IBM_GXT4500
 	  adaptor, found on some IBM System P (pSeries) machines.
 
 config FB_PS3
-	bool "PS3 GPU framebuffer driver"
+	tristate "PS3 GPU framebuffer driver"
 	depends on FB && PS3_PS3AV
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
diff --git a/include/asm-powerpc/ps3fb.h b/include/asm-powerpc/ps3fb.h
index ad81cf4..a447387 100644
--- a/include/asm-powerpc/ps3fb.h
+++ b/include/asm-powerpc/ps3fb.h
@@ -43,13 +43,8 @@ struct ps3fb_ioctl_res {
 
 #ifdef __KERNEL__
 
-#ifdef CONFIG_FB_PS3
 extern void ps3fb_flip_ctl(int on);
 extern void ps3fb_cleanup(void);
-#else
-static inline void ps3fb_flip_ctl(int on) {}
-static inline void ps3fb_cleanup(void) {}
-#endif
 
 #endif /* __KERNEL__ */
 
-- 
1.5.0-rc2.GIT

