Return-Path: <linux-kernel-owner+w=401wt.eu-S934628AbZLGDxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934628AbZLGDxl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934555AbZLGDxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:53:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51485 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934554AbZLGDxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:53:34 -0500
Date: Mon, 07 Dec 2009 03:53:40 +0000
To: linux-arch@vger.kernel.org
Subject: [PATCH 11/19] arch_mmap_check() on mn10300
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NHUfM-0007wv-QV@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/mn10300/include/asm/mman.h   |    5 +++++
 arch/mn10300/kernel/sys_mn10300.c |    5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mn10300/include/asm/mman.h b/arch/mn10300/include/asm/mman.h
index 8eebf89..db5c53d 100644
--- a/arch/mn10300/include/asm/mman.h
+++ b/arch/mn10300/include/asm/mman.h
@@ -1 +1,6 @@
 #include <asm-generic/mman.h>
+
+#define MIN_MAP_ADDR	PAGE_SIZE	/* minimum fixed mmap address */
+
+#define arch_mmap_check(addr, len, flags) \
+	(((flags) & MAP_FIXED && (addr) < MIN_MAP_ADDR) ? -EINVAL : 0)
diff --git a/arch/mn10300/kernel/sys_mn10300.c b/arch/mn10300/kernel/sys_mn10300.c
index 8ca5af0..ec4100d 100644
--- a/arch/mn10300/kernel/sys_mn10300.c
+++ b/arch/mn10300/kernel/sys_mn10300.c
@@ -23,8 +23,6 @@
 
 #include <asm/uaccess.h>
 
-#define MIN_MAP_ADDR	PAGE_SIZE	/* minimum fixed mmap address */
-
 /*
  * memory mapping syscall
  */
@@ -37,9 +35,6 @@ asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 
 	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
 
-	if (flags & MAP_FIXED && addr < MIN_MAP_ADDR)
-		goto out;
-
 	error = -EBADF;
 	if (!(flags & MAP_ANONYMOUS)) {
 		file = fget(fd);
-- 
1.5.6.5


