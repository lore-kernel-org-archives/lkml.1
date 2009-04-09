Return-Path: <linux-kernel-owner+w=401wt.eu-S1758423AbZDIIlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423AbZDIIlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 04:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZDIIlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 04:41:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbZDIIlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 04:41:21 -0400
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] Fix compiler warning unused clean_rootfs when CONFIG_BLK_DEV_RAM is not defined
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Content-Disposition: inline
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
Date: Thu, 9 Apr 2009 14:08:55 +0530
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200904091408.56401.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending as I missed the list, earlier.

Thanks
Nikanth

Fix gcc warning, "unused clean_rootfs", when CONFIG_BLK_DEV_RAM not defined.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---
diff --git a/init/initramfs.c b/init/initramfs.c
index 80cd713..e44f2d9 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -515,6 +515,7 @@ skip:
 	initrd_end = 0;
 }
 
+#ifdef CONFIG_BLK_DEV_RAM
 #define BUF_SIZE 1024
 static void __init clean_rootfs(void)
 {
@@ -561,6 +562,7 @@ static void __init clean_rootfs(void)
 	sys_close(fd);
 	kfree(buf);
 }
+#endif
 
 static int __init populate_rootfs(void)
 {



