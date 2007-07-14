Return-Path: <linux-kernel-owner+w=401wt.eu-S1763859AbXGNTib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763859AbXGNTib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 15:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763319AbXGNTiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 15:38:23 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:52870 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762613AbXGNTiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 15:38:21 -0400
Date: Sat, 14 Jul 2007 21:38:34 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Cc: stable@kernel.org
Subject: [PATCH] unexport asm/shmparam.h
Message-ID: <20070714193834.GA9140@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


SHMLBA cant possible be used in userspace, see sparc versions of that header.

Do not export asm/shmparam.h during make headers_install_all
This removes another uservisible place of PAGE_SIZE


Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 include/asm-generic/Kbuild.asm |    1 -
 include/asm-powerpc/Kbuild     |    1 -
 include/asm-sparc64/shmparam.h |    2 --
 include/linux/shm.h            |    2 ++
 4 files changed, 2 insertions(+), 4 deletions(-)

--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -30,6 +30,5 @@ unifdef-y += unistd.h
 unifdef-y += user.h
 
 # These probably shouldn't be exported
-unifdef-y += shmparam.h
 unifdef-y += elf.h
 unifdef-y += page.h
--- a/include/asm-powerpc/Kbuild
+++ b/include/asm-powerpc/Kbuild
@@ -15,7 +15,6 @@ header-y += termbits.h
 header-y += fcntl.h
 header-y += ipc.h
 header-y += poll.h
-header-y += shmparam.h
 header-y += sockios.h
 header-y += ucontext.h
 header-y += ioctl.h
--- a/include/asm-sparc64/shmparam.h
+++ b/include/asm-sparc64/shmparam.h
@@ -1,7 +1,6 @@
 /* $Id: shmparam.h,v 1.5 2001/09/24 21:17:57 kanoj Exp $ */
 #ifndef _ASMSPARC64_SHMPARAM_H
 #define _ASMSPARC64_SHMPARAM_H
-#ifdef __KERNEL__
 
 #include <asm/spitfire.h>
 
@@ -9,5 +8,4 @@
 /* attach addr a multiple of this */
 #define	SHMLBA	((PAGE_SIZE > L1DCACHE_SIZE) ? PAGE_SIZE : L1DCACHE_SIZE)
 
-#endif /* __KERNEL__ */
 #endif /* _ASMSPARC64_SHMPARAM_H */
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -16,7 +16,9 @@
 #define SHMALL (SHMMAX/PAGE_SIZE*(SHMMNI/16)) /* max shm system wide (pages) */
 #define SHMSEG SHMMNI			 /* max shared segs per process */
 
+#ifdef __KERNEL__
 #include <asm/shmparam.h>
+#endif
 
 /* Obsolete, used only for backwards compatibility and libc5 compiles */
 struct shmid_ds {
