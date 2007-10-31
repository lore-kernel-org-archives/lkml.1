Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbXJaPt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbXJaPt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758756AbXJaPss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:48:48 -0400
Received: from partizan.velesys.com ([213.184.230.195]:56254 "EHLO
	partizan.velesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758192AbXJaPsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:48:46 -0400
From: "Kirill A. Shutemov" <k.shutemov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] Unexport asm/user.h and linux/user.h
Date: Wed, 31 Oct 2007 17:49:36 +0200
Message-Id: <1193845777-2007-3-git-send-email-k.shutemov@gmail.com>
X-Mailer: git-send-email 1.5.3.4.GIT
In-Reply-To: <1193845777-2007-1-git-send-email-k.shutemov@gmail.com>
References: <1193845777-2007-1-git-send-email-k.shutemov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do not export asm/user.h and linux/user.h during make headers_install.

Signed-off-by: Kirill A. Shutemov <k.shutemov@gmail.com>
Reviewed-By: David Woodhouse <dwmw2@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
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
index c482561..fa3297a 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -340,7 +340,6 @@ unifdef-y += uinput.h
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

