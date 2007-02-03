Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbXBCNV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbXBCNV6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 08:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbXBCNV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 08:21:58 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:42309 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbXBCNV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 08:21:57 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 3 Feb 2007 07:28:48 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, rth@twiddle.net,
       Ralf Baechle <ralf@linux-mips.org>, matthew@wil.cx, chris@zankel.net
Subject: [PATCH] Remove final references to deprecated "MAP_ANON" page
 protection flag.
Message-ID: <Pine.LNX.4.64.0702030724210.6922@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Remove the last vestiges of the long-deprecated "MAP_ANON" page
protection flag:  use "MAP_ANONYMOUS" instead.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

 fs/aio.c                   |    2 +-
 fs/binfmt_elf_fdpic.c      |    2 +-
 include/asm-alpha/mman.h   |    1 -
 include/asm-generic/mman.h |    1 -
 include/asm-mips/mman.h    |    1 -
 include/asm-parisc/mman.h  |    1 -
 include/asm-xtensa/mman.h  |    1 -
 7 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index ee20fc4..72e66e1 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -132,7 +132,7 @@ static int aio_setup_ring(struct kioctx *ctx)
 	dprintk("attempting mmap of %lu bytes\n", info->mmap_size);
 	down_write(&ctx->mm->mmap_sem);
 	info->mmap_base = do_mmap(NULL, 0, info->mmap_size,
-				  PROT_READ|PROT_WRITE, MAP_ANON|MAP_PRIVATE,
+				  PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE,
 				  0);
 	if (IS_ERR((void *)info->mmap_base)) {
 		up_write(&ctx->mm->mmap_sem);
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index a4d933a..5810aa1 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -372,7 +372,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 	down_write(&current->mm->mmap_sem);
 	current->mm->start_brk = do_mmap(NULL, 0, stack_size,
 					 PROT_READ | PROT_WRITE | PROT_EXEC,
-					 MAP_PRIVATE | MAP_ANON | MAP_GROWSDOWN,
+					 MAP_PRIVATE | MAP_ANONYMOUS | MAP_GROWSDOWN,
 					 0);

 	if (IS_ERR_VALUE(current->mm->start_brk)) {
diff --git a/include/asm-alpha/mman.h b/include/asm-alpha/mman.h
index 5f24c75..90d7c35 100644
--- a/include/asm-alpha/mman.h
+++ b/include/asm-alpha/mman.h
@@ -49,7 +49,6 @@
 #define MADV_DOFORK	11		/* do inherit across fork */

 /* compatibility flags */
-#define MAP_ANON	MAP_ANONYMOUS
 #define MAP_FILE	0

 #endif /* __ALPHA_MMAN_H__ */
diff --git a/include/asm-generic/mman.h b/include/asm-generic/mman.h
index 3b41d2b..5e3dde2 100644
--- a/include/asm-generic/mman.h
+++ b/include/asm-generic/mman.h
@@ -36,7 +36,6 @@
 #define MADV_DOFORK	11		/* do inherit across fork */

 /* compatibility flags */
-#define MAP_ANON	MAP_ANONYMOUS
 #define MAP_FILE	0

 #endif
diff --git a/include/asm-mips/mman.h b/include/asm-mips/mman.h
index 046cf68..e4d6f1f 100644
--- a/include/asm-mips/mman.h
+++ b/include/asm-mips/mman.h
@@ -72,7 +72,6 @@
 #define MADV_DOFORK	11		/* do inherit across fork */

 /* compatibility flags */
-#define MAP_ANON	MAP_ANONYMOUS
 #define MAP_FILE	0

 #endif /* _ASM_MMAN_H */
diff --git a/include/asm-parisc/mman.h b/include/asm-parisc/mman.h
index 0ef15ee..defe752 100644
--- a/include/asm-parisc/mman.h
+++ b/include/asm-parisc/mman.h
@@ -55,7 +55,6 @@
 #define MADV_64M_PAGES  26              /* Use 64 Megabyte pages */

 /* compatibility flags */
-#define MAP_ANON	MAP_ANONYMOUS
 #define MAP_FILE	0
 #define MAP_VARIABLE	0

diff --git a/include/asm-xtensa/mman.h b/include/asm-xtensa/mman.h
index ba394cb..9b92620 100644
--- a/include/asm-xtensa/mman.h
+++ b/include/asm-xtensa/mman.h
@@ -79,7 +79,6 @@
 #define MADV_DOFORK	11		/* do inherit across fork */

 /* compatibility flags */
-#define MAP_ANON	MAP_ANONYMOUS
 #define MAP_FILE	0

 #endif /* _XTENSA_MMAN_H */

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
