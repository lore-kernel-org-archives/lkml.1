Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbYBKAnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbYBKAnV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 19:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYBKAnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 19:43:06 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44280 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196AbYBKAnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 19:43:04 -0500
Date: Mon, 11 Feb 2008 11:38:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: paulus@samba.org
Cc: ppc-dev <linuxppc-dev@ozlabs.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] [POWERPC] Wire up new timerfd syscalls
Message-Id: <20080211113840.154a3de5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/asm-powerpc/systbl.h |    4 +++-
 include/asm-powerpc/unistd.h |    6 ++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

Kernel built for ppc64_defconfig, pseries_defconfig, iseries_defconfig,
cell_defconfig and pmac32_defconfig.  The latter failed because
check_media_bay is still undefined (i.e. for unrelated reasons).

This has been tested on a pseries_defconfig kernel using the posted test
program built for 64 and 32 bit.

diff --git a/include/asm-powerpc/systbl.h b/include/asm-powerpc/systbl.h
index e996521..ae7085c 100644
--- a/include/asm-powerpc/systbl.h
+++ b/include/asm-powerpc/systbl.h
@@ -309,8 +309,10 @@ SYSCALL_SPU(getcpu)
 COMPAT_SYS(epoll_pwait)
 COMPAT_SYS_SPU(utimensat)
 COMPAT_SYS_SPU(signalfd)
-SYSCALL(ni_syscall)
+SYSCALL_SPU(timerfd_create)
 SYSCALL_SPU(eventfd)
 COMPAT_SYS_SPU(sync_file_range2)
 COMPAT_SYS(fallocate)
 SYSCALL(subpage_prot)
+COMPAT_SYS_SPU(timerfd_settime)
+COMPAT_SYS_SPU(timerfd_gettime)
diff --git a/include/asm-powerpc/unistd.h b/include/asm-powerpc/unistd.h
index fedc4b8..ce91bb6 100644
--- a/include/asm-powerpc/unistd.h
+++ b/include/asm-powerpc/unistd.h
@@ -328,15 +328,17 @@
 #define __NR_epoll_pwait	303
 #define __NR_utimensat		304
 #define __NR_signalfd		305
-#define __NR_timerfd		306
+#define __NR_timerfd_create	306
 #define __NR_eventfd		307
 #define __NR_sync_file_range2	308
 #define __NR_fallocate		309
 #define __NR_subpage_prot	310
+#define __NR_timerfd_settime	311
+#define __NR_timerfd_gettime	312
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		311
+#define __NR_syscalls		313
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
-- 
1.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
