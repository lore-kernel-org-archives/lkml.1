Return-Path: <linux-kernel-owner+w=401wt.eu-S1765936AbXJXRDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765936AbXJXRDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761812AbXJXQ6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:58:15 -0400
Received: from partizan.velesys.com ([213.184.230.195]:56152 "EHLO
	partizan.velesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761878AbXJXQ6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:58:14 -0400
From: "Kirill A. Shutemov" <k.shutemov@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, "Kirill A. Shutemov" <k.shutemov@gmail.com>
Subject: [PATCH] Unexport asm/user.h and linux/user.h
Date: Wed, 24 Oct 2007 19:36:01 +0300
Message-Id: <1193243762-31418-3-git-send-email-k.shutemov@gmail.com>
X-Mailer: git-send-email 1.5.3.4.GIT
In-Reply-To: <1193243762-31418-2-git-send-email-k.shutemov@gmail.com>
References: <1193243762-31418-1-git-send-email-k.shutemov@gmail.com>
 <1193243762-31418-2-git-send-email-k.shutemov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do not export asm/user.h and linux/user.h during make headers_install.

Signed-off-by: Kirill A. Shutemov <k.shutemov@gmail.com>
---
 include/asm-generic/Kbuild.asm |    1 -
 include/asm-x86/Kbuild         |    2 --
 include/linux/Kbuild           |    1 -
 include/linux/elfcore.h        |    2 ++
 4 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index d744ee3..57ba606 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -27,4 +27,3 @@ unifdef-y += termbits.h
 unifdef-y += termios.h
 unifdef-y += types.h
 unifdef-y += unistd.h
-unifdef-y += user.h
diff --git a/include/asm-x86/Kbuild b/include/asm-x86/Kbuild
index 828f9f8..f1b4dcb 100644
--- a/include/asm-x86/Kbuild
+++ b/include/asm-x86/Kbuild
@@ -21,7 +21,5 @@ unifdef-y += posix_types_64.h
 unifdef-y += ptrace.h
 unifdef-y += unistd_32.h
 unifdef-y += unistd_64.h
-unifdef-y += user_32.h
-unifdef-y += user_64.h
 unifdef-y += vm86.h
 unifdef-y += vsyscall.h
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index ee3276c..bace1ba 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -339,7 +339,6 @@ unifdef-y += uinput.h
 unifdef-y += uio.h
 unifdef-y += unistd.h
 unifdef-y += usbdevice_fs.h
-unifdef-y += user.h
 unifdef-y += utsname.h
 unifdef-y += videodev2.h
 unifdef-y += videodev.h
diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index e227719..5ca54d7 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -4,7 +4,9 @@
 #include <linux/types.h>
 #include <linux/signal.h>
 #include <linux/time.h>
+#ifdef __KERNEL__
 #include <linux/user.h>
+#endif
 #include <linux/ptrace.h>
 
 struct elf_siginfo
-- 
1.5.3.4.GIT

