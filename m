Return-Path: <linux-kernel-owner+w=401wt.eu-S1766001AbXJXRDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766001AbXJXRDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761878AbXJXQ6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:58:17 -0400
Received: from partizan.velesys.com ([213.184.230.195]:56215 "EHLO
	partizan.velesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763033AbXJXQ6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:58:14 -0400
From: "Kirill A. Shutemov" <k.shutemov@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, "Kirill A. Shutemov" <k.shutemov@gmail.com>
Subject: [PATCH] Unexport asm/elf.h
Date: Wed, 24 Oct 2007 19:36:00 +0300
Message-Id: <1193243762-31418-2-git-send-email-k.shutemov@gmail.com>
X-Mailer: git-send-email 1.5.3.4.GIT
In-Reply-To: <1193243762-31418-1-git-send-email-k.shutemov@gmail.com>
References: <1193243762-31418-1-git-send-email-k.shutemov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do not export asm/elf.h during make headers_install.

Signed-off-by: Kirill A. Shutemov <k.shutemov@gmail.com>
---
 include/asm-generic/Kbuild.asm |    3 ---
 include/linux/Kbuild           |    2 +-
 include/linux/elf.h            |    2 ++
 include/linux/elfcore.h        |    2 ++
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index a10583a..d744ee3 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -28,6 +28,3 @@ unifdef-y += termios.h
 unifdef-y += types.h
 unifdef-y += unistd.h
 unifdef-y += user.h
-
-# These probably shouldn't be exported
-unifdef-y += elf.h
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index e41809b..ee3276c 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -57,7 +57,6 @@ header-y += dqblk_v2.h
 header-y += dqblk_xfs.h
 header-y += efs_fs_sb.h
 header-y += elf-fdpic.h
-header-y += elf.h
 header-y += elf-em.h
 header-y += fadvise.h
 header-y += fd.h
@@ -187,6 +186,7 @@ unifdef-y += dccp.h
 unifdef-y += dirent.h
 unifdef-y += dlm.h
 unifdef-y += edd.h
+unifdef-y += elf.h
 unifdef-y += elfcore.h
 unifdef-y += errno.h
 unifdef-y += errqueue.h
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 576e83b..3fad88b 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -3,7 +3,9 @@
 
 #include <linux/types.h>
 #include <linux/elf-em.h>
+#ifdef __KERNEL__
 #include <asm/elf.h>
+#endif
 
 struct file;
 
diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index 9631ddd..e227719 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -14,7 +14,9 @@ struct elf_siginfo
 	int	si_errno;			/* errno */
 };
 
+#ifdef __KERNEL__
 #include <asm/elf.h>
+#endif
 
 #ifndef __KERNEL__
 typedef elf_greg_t greg_t;
-- 
1.5.3.4.GIT

