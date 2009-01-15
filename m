Return-Path: <linux-kernel-owner+w=401wt.eu-S932704AbZAOWPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbZAOWPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933681AbZAOWCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:20 -0500
Received: from kroah.org ([198.145.64.141]:38292 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933600AbZAOWCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:12 -0500
Date: Thu, 15 Jan 2009 13:59:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 23/85] [PATCH 03/44] [CVE-2009-0029] Rename old_readdir to
	sys_old_readdir
Message-ID: <20090115215940.GX17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0003--CVE-2009-0029-Rename-old_readdir-to-sys_old_readdi.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit e55380edf68796d75bf41391a781c68ee678587d upstream.

This way it matches the generic system call name convention.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/kernel/calls.S              |    2 +-
 arch/cris/arch-v10/kernel/entry.S    |    2 +-
 arch/cris/arch-v32/kernel/entry.S    |    2 +-
 arch/h8300/kernel/syscalls.S         |    2 +-
 arch/m68k/kernel/entry.S             |    2 +-
 arch/m68knommu/kernel/syscalltable.S |    2 +-
 arch/mips/kernel/scall32-o32.S       |    2 +-
 arch/mn10300/kernel/entry.S          |    2 +-
 arch/powerpc/include/asm/systbl.h    |    2 +-
 arch/sh/kernel/syscalls_32.S         |    2 +-
 arch/sh/kernel/syscalls_64.S         |    2 +-
 arch/sparc/kernel/systbls.S          |    2 +-
 arch/x86/kernel/syscall_table_32.S   |    2 +-
 fs/readdir.c                         |    2 +-
 include/linux/syscalls.h             |    2 ++
 15 files changed, 16 insertions(+), 14 deletions(-)

--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -98,7 +98,7 @@
 		CALL(sys_uselib)
 		CALL(sys_swapon)
 		CALL(sys_reboot)
-		CALL(OBSOLETE(old_readdir))	/* used by libc4 */
+		CALL(OBSOLETE(sys_old_readdir))	/* used by libc4 */
 /* 90 */	CALL(OBSOLETE(old_mmap))	/* used by libc4 */
 		CALL(sys_munmap)
 		CALL(sys_truncate)
--- a/arch/cris/arch-v10/kernel/entry.S
+++ b/arch/cris/arch-v10/kernel/entry.S
@@ -691,7 +691,7 @@ sys_call_table:	
 	.long sys_uselib
 	.long sys_swapon
 	.long sys_reboot
-	.long old_readdir
+	.long sys_old_readdir
 	.long old_mmap		/* 90 */
 	.long sys_munmap
 	.long sys_truncate
--- a/arch/cris/arch-v32/kernel/entry.S
+++ b/arch/cris/arch-v32/kernel/entry.S
@@ -614,7 +614,7 @@ sys_call_table:
 	.long sys_uselib
 	.long sys_swapon
 	.long sys_reboot
-	.long old_readdir
+	.long sys_old_readdir
 	.long old_mmap		/* 90 */
 	.long sys_munmap
 	.long sys_truncate
--- a/arch/h8300/kernel/syscalls.S
+++ b/arch/h8300/kernel/syscalls.S
@@ -103,7 +103,7 @@ SYMBOL_NAME_LABEL(sys_call_table)	
 	.long SYMBOL_NAME(sys_uselib)
 	.long SYMBOL_NAME(sys_swapon)
 	.long SYMBOL_NAME(sys_reboot)
-	.long SYMBOL_NAME(old_readdir)
+	.long SYMBOL_NAME(sys_old_readdir)
 	.long SYMBOL_NAME(old_mmap)		/* 90 */
 	.long SYMBOL_NAME(sys_munmap)
 	.long SYMBOL_NAME(sys_truncate)
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -513,7 +513,7 @@ sys_call_table:
 	.long sys_uselib
 	.long sys_swapon
 	.long sys_reboot
-	.long old_readdir
+	.long sys_old_readdir
 	.long old_mmap		/* 90 */
 	.long sys_munmap
 	.long sys_truncate
--- a/arch/m68knommu/kernel/syscalltable.S
+++ b/arch/m68knommu/kernel/syscalltable.S
@@ -107,7 +107,7 @@ ENTRY(sys_call_table)
 	.long sys_uselib
 	.long sys_ni_syscall	/* sys_swapon */
 	.long sys_reboot
-	.long old_readdir
+	.long sys_old_readdir
 	.long old_mmap		/* 90 */
 	.long sys_munmap
 	.long sys_truncate
--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -401,7 +401,7 @@ einval:	li	v0, -EINVAL
 	sys	sys_uselib		1
 	sys	sys_swapon		2
 	sys	sys_reboot		3
-	sys	old_readdir		3
+	sys	sys_old_readdir		3
 	sys	old_mmap		6	/* 4090 */
 	sys	sys_munmap		2
 	sys	sys_truncate		2
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -477,7 +477,7 @@ ENTRY(sys_call_table)
 	.long sys_uselib
 	.long sys_swapon
 	.long sys_reboot
-	.long old_readdir
+	.long sys_old_readdir
 	.long old_mmap		/* 90 */
 	.long sys_munmap
 	.long sys_truncate
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -92,7 +92,7 @@ COMPAT_SYS_SPU(readlink)
 SYSCALL(uselib)
 SYSCALL(swapon)
 SYSCALL(reboot)
-SYSX(sys_ni_syscall,compat_sys_old_readdir,old_readdir)
+SYSX(sys_ni_syscall,compat_sys_old_readdir,sys_old_readdir)
 SYSCALL_SPU(mmap)
 SYSCALL_SPU(munmap)
 SYSCALL_SPU(truncate)
--- a/arch/sh/kernel/syscalls_32.S
+++ b/arch/sh/kernel/syscalls_32.S
@@ -105,7 +105,7 @@ ENTRY(sys_call_table)
 	.long sys_uselib
 	.long sys_swapon
 	.long sys_reboot
-	.long old_readdir
+	.long sys_old_readdir
 	.long old_mmap		/* 90 */
 	.long sys_munmap
 	.long sys_truncate
--- a/arch/sh/kernel/syscalls_64.S
+++ b/arch/sh/kernel/syscalls_64.S
@@ -109,7 +109,7 @@ sys_call_table:
 	.long sys_uselib
 	.long sys_swapon
 	.long sys_reboot
-	.long old_readdir
+	.long sys_old_readdir
 	.long old_mmap			/* 90 */
 	.long sys_munmap
 	.long sys_truncate
--- a/arch/sparc/kernel/systbls.S
+++ b/arch/sparc/kernel/systbls.S
@@ -56,7 +56,7 @@ sys_call_table:
 /*185*/	.long sys_setpgid, sys_fremovexattr, sys_tkill, sys_exit_group, sys_newuname
 /*190*/	.long sys_init_module, sys_personality, sparc_remap_file_pages, sys_epoll_create, sys_epoll_ctl
 /*195*/	.long sys_epoll_wait, sys_ioprio_set, sys_getppid, sparc_sigaction, sys_sgetmask
-/*200*/	.long sys_ssetmask, sys_sigsuspend, sys_newlstat, sys_uselib, old_readdir
+/*200*/	.long sys_ssetmask, sys_sigsuspend, sys_newlstat, sys_uselib, sys_old_readdir
 /*205*/	.long sys_readahead, sys_socketcall, sys_syslog, sys_lookup_dcookie, sys_fadvise64
 /*210*/	.long sys_fadvise64_64, sys_tgkill, sys_waitpid, sys_swapoff, sys_sysinfo
 /*215*/	.long sys_ipc, sys_sigreturn, sys_clone, sys_ioprio_get, sys_adjtimex
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -88,7 +88,7 @@ ENTRY(sys_call_table)
 	.long sys_uselib
 	.long sys_swapon
 	.long sys_reboot
-	.long old_readdir
+	.long sys_old_readdir
 	.long old_mmap		/* 90 */
 	.long sys_munmap
 	.long sys_truncate
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -102,7 +102,7 @@ efault:
 	return -EFAULT;
 }
 
-asmlinkage long old_readdir(unsigned int fd, struct old_linux_dirent __user * dirent, unsigned int count)
+asmlinkage long sys_old_readdir(unsigned int fd, struct old_linux_dirent __user * dirent, unsigned int count)
 {
 	int error;
 	struct file * file;
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -54,6 +54,7 @@ struct compat_stat;
 struct compat_timeval;
 struct robust_list_head;
 struct getcpu_cache;
+struct old_linux_dirent;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -609,6 +610,7 @@ asmlinkage long sys_timerfd_gettime(int 
 asmlinkage long sys_eventfd(unsigned int count);
 asmlinkage long sys_eventfd2(unsigned int count, int flags);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
+asmlinkage long sys_old_readdir(unsigned int, struct old_linux_dirent __user *, unsigned int);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 

