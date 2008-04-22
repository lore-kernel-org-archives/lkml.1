Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbYDVMN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbYDVMN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 08:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbYDVMNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 08:13:44 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:3641 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYDVMNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 08:13:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=dE79zvltucLICO142XS3cnlOkuodxA+TLFiCgVybuiJ+HnSMIrtOUAmSyIKbBeEVvTqgQLDTqXMaeEUvQAItK9fgxyN1gGXFVuK0bTOUszgvsjSJHnzxWN5SNSHw2LFjQXPg6NnEiI4p6fuC+jjdDNzyKXCR7dZefEZJgOZ2lTs=
Message-ID: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com>
Date: Tue, 22 Apr 2008 13:13:39 +0100
From: "Will Newton" <will.newton@gmail.com>
To: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_3718_22986760.1208866419938"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_3718_22986760.1208866419938
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

This patch introduces a __ARCH_WANT_SYS_SYSFS #define for
architectures that support the sysfs(2) system call. At the moment
that's everybody but blackfin, but future architectures may want to
save the (admittedly small) code size that it adds to the kernel as
well.

(patch attached as well as inline because gmail seems to mangle my whitespace)

---
>From d0746366e8ccb5fbaa6c9945540cecbe0c421222 Mon Sep 17 00:00:00 2001
From: Will Newton <will.newton@imgtec.com>
Date: Tue, 22 Apr 2008 12:57:03 +0100
Subject: [PATCH] Introduce __ARCH_WANT_SYS_SYSFS.

Signed-off-by: Will Newton <will.newton@imgtec.com>

All arches that want the sysfs(2) system call should define this symbol.
Arches such as blackfin that do not implement the system call don't compile
the code and save some small amount of space.
---
 fs/filesystems.c               |    5 +++++
 include/asm-alpha/unistd.h     |    1 +
 include/asm-arm/unistd.h       |    1 +
 include/asm-avr32/unistd.h     |    1 +
 include/asm-cris/unistd.h      |    1 +
 include/asm-frv/unistd.h       |    1 +
 include/asm-h8300/unistd.h     |    1 +
 include/asm-ia64/unistd.h      |    1 +
 include/asm-m32r/unistd.h      |    1 +
 include/asm-m68k/unistd.h      |    1 +
 include/asm-m68knommu/unistd.h |    1 +
 include/asm-mips/unistd.h      |    1 +
 include/asm-mn10300/unistd.h   |    1 +
 include/asm-parisc/unistd.h    |    1 +
 include/asm-powerpc/unistd.h   |    1 +
 include/asm-s390/unistd.h      |    1 +
 include/asm-sh/unistd_32.h     |    1 +
 include/asm-sh/unistd_64.h     |    1 +
 include/asm-sparc/unistd.h     |    1 +
 include/asm-sparc64/unistd.h   |    1 +
 include/asm-v850/unistd.h      |    1 +
 include/asm-x86/unistd_32.h    |    1 +
 include/asm-x86/unistd_64.h    |    1 +
 include/asm-xtensa/unistd.h    |    1 +
 24 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/fs/filesystems.c b/fs/filesystems.c
index f37f872..cd57e41 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -12,6 +12,7 @@
 #include <linux/kmod.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/unistd.h>
 #include <asm/uaccess.h>

 /*
@@ -118,6 +119,8 @@ int unregister_filesystem(struct file_system_type * fs)

 EXPORT_SYMBOL(unregister_filesystem);

+#ifdef __ARCH_WANT_SYS_SYSFS
+
 static int fs_index(const char __user * __name)
 {
 	struct file_system_type * tmp;
@@ -197,6 +200,8 @@ asmlinkage long sys_sysfs(int option, unsigned
long arg1, unsigned long arg2)
 	return retval;
 }

+#endif
+
 int get_filesystem_list(char * buf)
 {
 	int len = 0;
diff --git a/include/asm-alpha/unistd.h b/include/asm-alpha/unistd.h
index 5b5c174..0b6c920 100644
--- a/include/asm-alpha/unistd.h
+++ b/include/asm-alpha/unistd.h
@@ -447,6 +447,7 @@
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
+#define __ARCH_WANT_SYS_SYSFS

 /* "Conditional" syscalls.  What we want is

diff --git a/include/asm-arm/unistd.h b/include/asm-arm/unistd.h
index 88e868b..d70b815 100644
--- a/include/asm-arm/unistd.h
+++ b/include/asm-arm/unistd.h
@@ -420,6 +420,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_SYSFS

 #if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
 #define __ARCH_WANT_SYS_TIME
diff --git a/include/asm-avr32/unistd.h b/include/asm-avr32/unistd.h
index 89861a2..d77cabc 100644
--- a/include/asm-avr32/unistd.h
+++ b/include/asm-avr32/unistd.h
@@ -331,6 +331,7 @@
 #define __ARCH_WANT_SYS_GETPGRP
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_SYSFS

 /*
  * "Conditional" syscalls
diff --git a/include/asm-cris/unistd.h b/include/asm-cris/unistd.h
index 76398ef..02b8833 100644
--- a/include/asm-cris/unistd.h
+++ b/include/asm-cris/unistd.h
@@ -361,6 +361,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_SYSFS

 /*
  * "Conditional" syscalls
diff --git a/include/asm-frv/unistd.h b/include/asm-frv/unistd.h
index f184eb8..cccbb33 100644
--- a/include/asm-frv/unistd.h
+++ b/include/asm-frv/unistd.h
@@ -361,6 +361,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_SYSFS

 /*
  * "Conditional" syscalls
diff --git a/include/asm-h8300/unistd.h b/include/asm-h8300/unistd.h
index 99f3c35..047b073 100644
--- a/include/asm-h8300/unistd.h
+++ b/include/asm-h8300/unistd.h
@@ -352,6 +352,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_SYSFS

 /*
  * "Conditional" syscalls
diff --git a/include/asm-ia64/unistd.h b/include/asm-ia64/unistd.h
index e603147..d7594e6 100644
--- a/include/asm-ia64/unistd.h
+++ b/include/asm-ia64/unistd.h
@@ -323,6 +323,7 @@

 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_SYSFS

 #ifdef CONFIG_IA32_SUPPORT
 # define __ARCH_WANT_SYS_FADVISE64
diff --git a/include/asm-m32r/unistd.h b/include/asm-m32r/unistd.h
index cf701c9..dda43d4 100644
--- a/include/asm-m32r/unistd.h
+++ b/include/asm-m32r/unistd.h
@@ -350,6 +350,7 @@
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT /*will be unused*/
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_SYSFS

 #define __IGNORE_lchown
 #define __IGNORE_setuid
diff --git a/include/asm-m68k/unistd.h b/include/asm-m68k/unistd.h
index e72ba56..c578622 100644
--- a/include/asm-m68k/unistd.h
+++ b/include/asm-m68k/unistd.h
@@ -352,6 +352,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_SYSFS

 /* whitelist for checksyscalls */
 #define __IGNORE_restart_syscall
diff --git a/include/asm-m68knommu/unistd.h b/include/asm-m68knommu/unistd.h
index 4ba98b9..7148ba1 100644
--- a/include/asm-m68knommu/unistd.h
+++ b/include/asm-m68knommu/unistd.h
@@ -353,6 +353,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_SYSFS

 /*
  * "Conditional" syscalls
diff --git a/include/asm-mips/unistd.h b/include/asm-mips/unistd.h
index 4964c82..22e3d13 100644
--- a/include/asm-mips/unistd.h
+++ b/include/asm-mips/unistd.h
@@ -981,6 +981,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_SYSFS
 # ifdef CONFIG_32BIT
 #  define __ARCH_WANT_STAT64
 #  define __ARCH_WANT_SYS_TIME
diff --git a/include/asm-mn10300/unistd.h b/include/asm-mn10300/unistd.h
index 3721aa9..a1ccfdf 100644
--- a/include/asm-mn10300/unistd.h
+++ b/include/asm-mn10300/unistd.h
@@ -369,6 +369,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_SYSFS

 /*
  * "Conditional" syscalls
diff --git a/include/asm-parisc/unistd.h b/include/asm-parisc/unistd.h
index a7d857f..d480f23 100644
--- a/include/asm-parisc/unistd.h
+++ b/include/asm-parisc/unistd.h
@@ -974,6 +974,7 @@ type name(type1 arg1, type2 arg2, type3 arg3,
type4 arg4, type5 arg5)	\
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_SYSFS

 #endif /* __ASSEMBLY__ */

diff --git a/include/asm-powerpc/unistd.h b/include/asm-powerpc/unistd.h
index ce91bb6..763f056 100644
--- a/include/asm-powerpc/unistd.h
+++ b/include/asm-powerpc/unistd.h
@@ -371,6 +371,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_SYSFS
 #ifdef CONFIG_PPC32
 #define __ARCH_WANT_OLD_STAT
 #endif
diff --git a/include/asm-s390/unistd.h b/include/asm-s390/unistd.h
index 583da80..afd9e19 100644
--- a/include/asm-s390/unistd.h
+++ b/include/asm-s390/unistd.h
@@ -384,6 +384,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_SYSFS
 # ifndef CONFIG_64BIT
 #   define __ARCH_WANT_STAT64
 #   define __ARCH_WANT_SYS_TIME
diff --git a/include/asm-sh/unistd_32.h b/include/asm-sh/unistd_32.h
index 0b07212..d010bd0 100644
--- a/include/asm-sh/unistd_32.h
+++ b/include/asm-sh/unistd_32.h
@@ -363,6 +363,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_SYSFS

 /*
  * "Conditional" syscalls
diff --git a/include/asm-sh/unistd_64.h b/include/asm-sh/unistd_64.h
index 9d21eab..d69090b 100644
--- a/include/asm-sh/unistd_64.h
+++ b/include/asm-sh/unistd_64.h
@@ -402,6 +402,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_SYSFS

 /*
  * "Conditional" syscalls
diff --git a/include/asm-sparc/unistd.h b/include/asm-sparc/unistd.h
index 2338a02..c7e7123 100644
--- a/include/asm-sparc/unistd.h
+++ b/include/asm-sparc/unistd.h
@@ -365,6 +365,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_SYSFS

 /*
  * "Conditional" syscalls
diff --git a/include/asm-sparc64/unistd.h b/include/asm-sparc64/unistd.h
index 77559da..891683c 100644
--- a/include/asm-sparc64/unistd.h
+++ b/include/asm-sparc64/unistd.h
@@ -370,6 +370,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_SYSFS

 /*
  * "Conditional" syscalls
diff --git a/include/asm-v850/unistd.h b/include/asm-v850/unistd.h
index 2241ed4..b030a78 100644
--- a/include/asm-v850/unistd.h
+++ b/include/asm-v850/unistd.h
@@ -226,6 +226,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_SYSFS

 /*
  * "Conditional" syscalls
diff --git a/include/asm-x86/unistd_32.h b/include/asm-x86/unistd_32.h
index 984123a..35f611e 100644
--- a/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
@@ -358,6 +358,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_SYSFS

 /*
  * "Conditional" syscalls
diff --git a/include/asm-x86/unistd_64.h b/include/asm-x86/unistd_64.h
index 3883ceb..6c46395 100644
--- a/include/asm-x86/unistd_64.h
+++ b/include/asm-x86/unistd_64.h
@@ -664,6 +664,7 @@ __SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_COMPAT_SYS_TIME
+#define __ARCH_WANT_SYS_SYSFS
 #endif	/* __NO_STUBS */

 #ifdef __KERNEL__
diff --git a/include/asm-xtensa/unistd.h b/include/asm-xtensa/unistd.h
index c092c8f..0a1bdae 100644
--- a/include/asm-xtensa/unistd.h
+++ b/include/asm-xtensa/unistd.h
@@ -718,6 +718,7 @@ __SYSCALL(306, sys_eventfd, 1)
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_SYS_GETPGRP
+#define __ARCH_WANT_SYS_SYSFS

 /*
  * Ignore legacy system calls in the checksyscalls.sh script
-- 
1.5.3.5

------=_Part_3718_22986760.1208866419938
Content-Type: text/x-patch; name=0001-Introduce-__ARCH_WANT_SYS_SYSFS.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ffcfqkc60
Content-Disposition: attachment;
 filename=0001-Introduce-__ARCH_WANT_SYS_SYSFS.patch

RnJvbSBkMDc0NjM2NmU4Y2NiNWZiYWE2Yzk5NDU1NDBjZWNiZTBjNDIxMjIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AaW1ndGVjLmNvbT4K
RGF0ZTogVHVlLCAyMiBBcHIgMjAwOCAxMjo1NzowMyArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIElu
dHJvZHVjZSBfX0FSQ0hfV0FOVF9TWVNfU1lTRlMuCgpTaWduZWQtb2ZmLWJ5OiBXaWxsIE5ld3Rv
biA8d2lsbC5uZXd0b25AaW1ndGVjLmNvbT4KCkFsbCBhcmNoZXMgdGhhdCB3YW50IHRoZSBzeXNm
cygyKSBzeXN0ZW0gY2FsbCBzaG91bGQgZGVmaW5lIHRoaXMgc3ltYm9sLgpBcmNoZXMgc3VjaCBh
cyBibGFja2ZpbiB0aGF0IGRvIG5vdCBpbXBsZW1lbnQgdGhlIHN5c3RlbSBjYWxsIGRvbid0IGNv
bXBpbGUKdGhlIGNvZGUgYW5kIHNhdmUgc29tZSBzbWFsbCBhbW91bnQgb2Ygc3BhY2UuCi0tLQog
ZnMvZmlsZXN5c3RlbXMuYyAgICAgICAgICAgICAgIHwgICAgNSArKysrKwogaW5jbHVkZS9hc20t
YWxwaGEvdW5pc3RkLmggICAgIHwgICAgMSArCiBpbmNsdWRlL2FzbS1hcm0vdW5pc3RkLmggICAg
ICAgfCAgICAxICsKIGluY2x1ZGUvYXNtLWF2cjMyL3VuaXN0ZC5oICAgICB8ICAgIDEgKwogaW5j
bHVkZS9hc20tY3Jpcy91bmlzdGQuaCAgICAgIHwgICAgMSArCiBpbmNsdWRlL2FzbS1mcnYvdW5p
c3RkLmggICAgICAgfCAgICAxICsKIGluY2x1ZGUvYXNtLWg4MzAwL3VuaXN0ZC5oICAgICB8ICAg
IDEgKwogaW5jbHVkZS9hc20taWE2NC91bmlzdGQuaCAgICAgIHwgICAgMSArCiBpbmNsdWRlL2Fz
bS1tMzJyL3VuaXN0ZC5oICAgICAgfCAgICAxICsKIGluY2x1ZGUvYXNtLW02OGsvdW5pc3RkLmgg
ICAgICB8ICAgIDEgKwogaW5jbHVkZS9hc20tbTY4a25vbW11L3VuaXN0ZC5oIHwgICAgMSArCiBp
bmNsdWRlL2FzbS1taXBzL3VuaXN0ZC5oICAgICAgfCAgICAxICsKIGluY2x1ZGUvYXNtLW1uMTAz
MDAvdW5pc3RkLmggICB8ICAgIDEgKwogaW5jbHVkZS9hc20tcGFyaXNjL3VuaXN0ZC5oICAgIHwg
ICAgMSArCiBpbmNsdWRlL2FzbS1wb3dlcnBjL3VuaXN0ZC5oICAgfCAgICAxICsKIGluY2x1ZGUv
YXNtLXMzOTAvdW5pc3RkLmggICAgICB8ICAgIDEgKwogaW5jbHVkZS9hc20tc2gvdW5pc3RkXzMy
LmggICAgIHwgICAgMSArCiBpbmNsdWRlL2FzbS1zaC91bmlzdGRfNjQuaCAgICAgfCAgICAxICsK
IGluY2x1ZGUvYXNtLXNwYXJjL3VuaXN0ZC5oICAgICB8ICAgIDEgKwogaW5jbHVkZS9hc20tc3Bh
cmM2NC91bmlzdGQuaCAgIHwgICAgMSArCiBpbmNsdWRlL2FzbS12ODUwL3VuaXN0ZC5oICAgICAg
fCAgICAxICsKIGluY2x1ZGUvYXNtLXg4Ni91bmlzdGRfMzIuaCAgICB8ICAgIDEgKwogaW5jbHVk
ZS9hc20teDg2L3VuaXN0ZF82NC5oICAgIHwgICAgMSArCiBpbmNsdWRlL2FzbS14dGVuc2EvdW5p
c3RkLmggICAgfCAgICAxICsKIDI0IGZpbGVzIGNoYW5nZWQsIDI4IGluc2VydGlvbnMoKyksIDAg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvZmlsZXN5c3RlbXMuYyBiL2ZzL2ZpbGVzeXN0
ZW1zLmMKaW5kZXggZjM3Zjg3Mi4uY2Q1N2U0MSAxMDA2NDQKLS0tIGEvZnMvZmlsZXN5c3RlbXMu
YworKysgYi9mcy9maWxlc3lzdGVtcy5jCkBAIC0xMiw2ICsxMiw3IEBACiAjaW5jbHVkZSA8bGlu
dXgva21vZC5oPgogI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KICNpbmNsdWRlIDxsaW51eC9tb2R1
bGUuaD4KKyNpbmNsdWRlIDxsaW51eC91bmlzdGQuaD4KICNpbmNsdWRlIDxhc20vdWFjY2Vzcy5o
PgogCiAvKgpAQCAtMTE4LDYgKzExOSw4IEBAIGludCB1bnJlZ2lzdGVyX2ZpbGVzeXN0ZW0oc3Ry
dWN0IGZpbGVfc3lzdGVtX3R5cGUgKiBmcykKIAogRVhQT1JUX1NZTUJPTCh1bnJlZ2lzdGVyX2Zp
bGVzeXN0ZW0pOwogCisjaWZkZWYgX19BUkNIX1dBTlRfU1lTX1NZU0ZTCisKIHN0YXRpYyBpbnQg
ZnNfaW5kZXgoY29uc3QgY2hhciBfX3VzZXIgKiBfX25hbWUpCiB7CiAJc3RydWN0IGZpbGVfc3lz
dGVtX3R5cGUgKiB0bXA7CkBAIC0xOTcsNiArMjAwLDggQEAgYXNtbGlua2FnZSBsb25nIHN5c19z
eXNmcyhpbnQgb3B0aW9uLCB1bnNpZ25lZCBsb25nIGFyZzEsIHVuc2lnbmVkIGxvbmcgYXJnMikK
IAlyZXR1cm4gcmV0dmFsOwogfQogCisjZW5kaWYKKwogaW50IGdldF9maWxlc3lzdGVtX2xpc3Qo
Y2hhciAqIGJ1ZikKIHsKIAlpbnQgbGVuID0gMDsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvYXNtLWFs
cGhhL3VuaXN0ZC5oIGIvaW5jbHVkZS9hc20tYWxwaGEvdW5pc3RkLmgKaW5kZXggNWI1YzE3NC4u
MGI2YzkyMCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9hc20tYWxwaGEvdW5pc3RkLmgKKysrIGIvaW5j
bHVkZS9hc20tYWxwaGEvdW5pc3RkLmgKQEAgLTQ0Nyw2ICs0NDcsNyBAQAogI2RlZmluZSBfX0FS
Q0hfV0FOVF9TWVNfT0xEX0dFVFJMSU1JVAogI2RlZmluZSBfX0FSQ0hfV0FOVF9TWVNfT0xEVU1P
VU5UCiAjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19TSUdQRU5ESU5HCisjZGVmaW5lIF9fQVJDSF9X
QU5UX1NZU19TWVNGUwogCiAvKiAiQ29uZGl0aW9uYWwiIHN5c2NhbGxzLiAgV2hhdCB3ZSB3YW50
IGlzCiAKZGlmZiAtLWdpdCBhL2luY2x1ZGUvYXNtLWFybS91bmlzdGQuaCBiL2luY2x1ZGUvYXNt
LWFybS91bmlzdGQuaAppbmRleCA4OGU4NjhiLi5kNzBiODE1IDEwMDY0NAotLS0gYS9pbmNsdWRl
L2FzbS1hcm0vdW5pc3RkLmgKKysrIGIvaW5jbHVkZS9hc20tYXJtL3VuaXN0ZC5oCkBAIC00MjAs
NiArNDIwLDcgQEAKICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NJR1BFTkRJTkcKICNkZWZpbmUg
X19BUkNIX1dBTlRfU1lTX1NJR1BST0NNQVNLCiAjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19SVF9T
SUdBQ1RJT04KKyNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NZU0ZTCiAKICNpZiAhZGVmaW5lZChD
T05GSUdfQUVBQkkpIHx8IGRlZmluZWQoQ09ORklHX09BQklfQ09NUEFUKQogI2RlZmluZSBfX0FS
Q0hfV0FOVF9TWVNfVElNRQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9hc20tYXZyMzIvdW5pc3RkLmgg
Yi9pbmNsdWRlL2FzbS1hdnIzMi91bmlzdGQuaAppbmRleCA4OTg2MWEyLi5kNzdjYWJjIDEwMDY0
NAotLS0gYS9pbmNsdWRlL2FzbS1hdnIzMi91bmlzdGQuaAorKysgYi9pbmNsdWRlL2FzbS1hdnIz
Mi91bmlzdGQuaApAQCAtMzMxLDYgKzMzMSw3IEBACiAjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19H
RVRQR1JQCiAjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19SVF9TSUdBQ1RJT04KICNkZWZpbmUgX19B
UkNIX1dBTlRfU1lTX1JUX1NJR1NVU1BFTkQKKyNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NZU0ZT
CiAKIC8qCiAgKiAiQ29uZGl0aW9uYWwiIHN5c2NhbGxzCmRpZmYgLS1naXQgYS9pbmNsdWRlL2Fz
bS1jcmlzL3VuaXN0ZC5oIGIvaW5jbHVkZS9hc20tY3Jpcy91bmlzdGQuaAppbmRleCA3NjM5OGVm
Li4wMmI4ODMzIDEwMDY0NAotLS0gYS9pbmNsdWRlL2FzbS1jcmlzL3VuaXN0ZC5oCisrKyBiL2lu
Y2x1ZGUvYXNtLWNyaXMvdW5pc3RkLmgKQEAgLTM2MSw2ICszNjEsNyBAQAogI2RlZmluZSBfX0FS
Q0hfV0FOVF9TWVNfU0lHUFJPQ01BU0sKICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1JUX1NJR0FD
VElPTgogI2RlZmluZSBfX0FSQ0hfV0FOVF9TWVNfUlRfU0lHU1VTUEVORAorI2RlZmluZSBfX0FS
Q0hfV0FOVF9TWVNfU1lTRlMKIAogLyoKICAqICJDb25kaXRpb25hbCIgc3lzY2FsbHMKZGlmZiAt
LWdpdCBhL2luY2x1ZGUvYXNtLWZydi91bmlzdGQuaCBiL2luY2x1ZGUvYXNtLWZydi91bmlzdGQu
aAppbmRleCBmMTg0ZWI4Li5jY2NiYjMzIDEwMDY0NAotLS0gYS9pbmNsdWRlL2FzbS1mcnYvdW5p
c3RkLmgKKysrIGIvaW5jbHVkZS9hc20tZnJ2L3VuaXN0ZC5oCkBAIC0zNjEsNiArMzYxLDcgQEAK
ICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NJR1BST0NNQVNLCiAjZGVmaW5lIF9fQVJDSF9XQU5U
X1NZU19SVF9TSUdBQ1RJT04KICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1JUX1NJR1NVU1BFTkQK
KyNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NZU0ZTCiAKIC8qCiAgKiAiQ29uZGl0aW9uYWwiIHN5
c2NhbGxzCmRpZmYgLS1naXQgYS9pbmNsdWRlL2FzbS1oODMwMC91bmlzdGQuaCBiL2luY2x1ZGUv
YXNtLWg4MzAwL3VuaXN0ZC5oCmluZGV4IDk5ZjNjMzUuLjA0N2IwNzMgMTAwNjQ0Ci0tLSBhL2lu
Y2x1ZGUvYXNtLWg4MzAwL3VuaXN0ZC5oCisrKyBiL2luY2x1ZGUvYXNtLWg4MzAwL3VuaXN0ZC5o
CkBAIC0zNTIsNiArMzUyLDcgQEAKICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NJR1BFTkRJTkcK
ICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NJR1BST0NNQVNLCiAjZGVmaW5lIF9fQVJDSF9XQU5U
X1NZU19SVF9TSUdBQ1RJT04KKyNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NZU0ZTCiAKIC8qCiAg
KiAiQ29uZGl0aW9uYWwiIHN5c2NhbGxzCmRpZmYgLS1naXQgYS9pbmNsdWRlL2FzbS1pYTY0L3Vu
aXN0ZC5oIGIvaW5jbHVkZS9hc20taWE2NC91bmlzdGQuaAppbmRleCBlNjAzMTQ3Li5kNzU5NGU2
IDEwMDY0NAotLS0gYS9pbmNsdWRlL2FzbS1pYTY0L3VuaXN0ZC5oCisrKyBiL2luY2x1ZGUvYXNt
LWlhNjQvdW5pc3RkLmgKQEAgLTMyMyw2ICszMjMsNyBAQAogCiAjZGVmaW5lIF9fQVJDSF9XQU5U
X1NZU19SVF9TSUdBQ1RJT04KICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1JUX1NJR1NVU1BFTkQK
KyNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NZU0ZTCiAKICNpZmRlZiBDT05GSUdfSUEzMl9TVVBQ
T1JUCiAjIGRlZmluZSBfX0FSQ0hfV0FOVF9TWVNfRkFEVklTRTY0CmRpZmYgLS1naXQgYS9pbmNs
dWRlL2FzbS1tMzJyL3VuaXN0ZC5oIGIvaW5jbHVkZS9hc20tbTMyci91bmlzdGQuaAppbmRleCBj
ZjcwMWM5Li5kZGE0M2Q0IDEwMDY0NAotLS0gYS9pbmNsdWRlL2FzbS1tMzJyL3VuaXN0ZC5oCisr
KyBiL2luY2x1ZGUvYXNtLW0zMnIvdW5pc3RkLmgKQEAgLTM1MCw2ICszNTAsNyBAQAogI2RlZmlu
ZSBfX0FSQ0hfV0FOVF9TWVNfT0xEX0dFVFJMSU1JVCAvKndpbGwgYmUgdW51c2VkKi8KICNkZWZp
bmUgX19BUkNIX1dBTlRfU1lTX09MRFVNT1VOVAogI2RlZmluZSBfX0FSQ0hfV0FOVF9TWVNfUlRf
U0lHQUNUSU9OCisjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19TWVNGUwogCiAjZGVmaW5lIF9fSUdO
T1JFX2xjaG93bgogI2RlZmluZSBfX0lHTk9SRV9zZXR1aWQKZGlmZiAtLWdpdCBhL2luY2x1ZGUv
YXNtLW02OGsvdW5pc3RkLmggYi9pbmNsdWRlL2FzbS1tNjhrL3VuaXN0ZC5oCmluZGV4IGU3MmJh
NTYuLmM1Nzg2MjIgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvYXNtLW02OGsvdW5pc3RkLmgKKysrIGIv
aW5jbHVkZS9hc20tbTY4ay91bmlzdGQuaApAQCAtMzUyLDYgKzM1Miw3IEBACiAjZGVmaW5lIF9f
QVJDSF9XQU5UX1NZU19TSUdQRU5ESU5HCiAjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19TSUdQUk9D
TUFTSwogI2RlZmluZSBfX0FSQ0hfV0FOVF9TWVNfUlRfU0lHQUNUSU9OCisjZGVmaW5lIF9fQVJD
SF9XQU5UX1NZU19TWVNGUwogCiAvKiB3aGl0ZWxpc3QgZm9yIGNoZWNrc3lzY2FsbHMgKi8KICNk
ZWZpbmUgX19JR05PUkVfcmVzdGFydF9zeXNjYWxsCmRpZmYgLS1naXQgYS9pbmNsdWRlL2FzbS1t
Njhrbm9tbXUvdW5pc3RkLmggYi9pbmNsdWRlL2FzbS1tNjhrbm9tbXUvdW5pc3RkLmgKaW5kZXgg
NGJhOThiOS4uNzE0OGJhMSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9hc20tbTY4a25vbW11L3VuaXN0
ZC5oCisrKyBiL2luY2x1ZGUvYXNtLW02OGtub21tdS91bmlzdGQuaApAQCAtMzUzLDYgKzM1Myw3
IEBACiAjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19TSUdQRU5ESU5HCiAjZGVmaW5lIF9fQVJDSF9X
QU5UX1NZU19TSUdQUk9DTUFTSwogI2RlZmluZSBfX0FSQ0hfV0FOVF9TWVNfUlRfU0lHQUNUSU9O
CisjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19TWVNGUwogCiAvKgogICogIkNvbmRpdGlvbmFsIiBz
eXNjYWxscwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9hc20tbWlwcy91bmlzdGQuaCBiL2luY2x1ZGUv
YXNtLW1pcHMvdW5pc3RkLmgKaW5kZXggNDk2NGM4Mi4uMjJlM2QxMyAxMDA2NDQKLS0tIGEvaW5j
bHVkZS9hc20tbWlwcy91bmlzdGQuaAorKysgYi9pbmNsdWRlL2FzbS1taXBzL3VuaXN0ZC5oCkBA
IC05ODEsNiArOTgxLDcgQEAKICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NJR1BFTkRJTkcKICNk
ZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NJR1BST0NNQVNLCiAjZGVmaW5lIF9fQVJDSF9XQU5UX1NZ
U19SVF9TSUdBQ1RJT04KKyNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NZU0ZTCiAjIGlmZGVmIENP
TkZJR18zMkJJVAogIyAgZGVmaW5lIF9fQVJDSF9XQU5UX1NUQVQ2NAogIyAgZGVmaW5lIF9fQVJD
SF9XQU5UX1NZU19USU1FCmRpZmYgLS1naXQgYS9pbmNsdWRlL2FzbS1tbjEwMzAwL3VuaXN0ZC5o
IGIvaW5jbHVkZS9hc20tbW4xMDMwMC91bmlzdGQuaAppbmRleCAzNzIxYWE5Li5hMWNjZmRmIDEw
MDY0NAotLS0gYS9pbmNsdWRlL2FzbS1tbjEwMzAwL3VuaXN0ZC5oCisrKyBiL2luY2x1ZGUvYXNt
LW1uMTAzMDAvdW5pc3RkLmgKQEAgLTM2OSw2ICszNjksNyBAQAogI2RlZmluZSBfX0FSQ0hfV0FO
VF9TWVNfU0lHUFJPQ01BU0sKICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1JUX1NJR0FDVElPTgog
I2RlZmluZSBfX0FSQ0hfV0FOVF9TWVNfUlRfU0lHU1VTUEVORAorI2RlZmluZSBfX0FSQ0hfV0FO
VF9TWVNfU1lTRlMKIAogLyoKICAqICJDb25kaXRpb25hbCIgc3lzY2FsbHMKZGlmZiAtLWdpdCBh
L2luY2x1ZGUvYXNtLXBhcmlzYy91bmlzdGQuaCBiL2luY2x1ZGUvYXNtLXBhcmlzYy91bmlzdGQu
aAppbmRleCBhN2Q4NTdmLi5kNDgwZjIzIDEwMDY0NAotLS0gYS9pbmNsdWRlL2FzbS1wYXJpc2Mv
dW5pc3RkLmgKKysrIGIvaW5jbHVkZS9hc20tcGFyaXNjL3VuaXN0ZC5oCkBAIC05NzQsNiArOTc0
LDcgQEAgdHlwZSBuYW1lKHR5cGUxIGFyZzEsIHR5cGUyIGFyZzIsIHR5cGUzIGFyZzMsIHR5cGU0
IGFyZzQsIHR5cGU1IGFyZzUpCVwKICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1JUX1NJR0FDVElP
TgogI2RlZmluZSBfX0FSQ0hfV0FOVF9TWVNfUlRfU0lHU1VTUEVORAogI2RlZmluZSBfX0FSQ0hf
V0FOVF9DT01QQVRfU1lTX1JUX1NJR1NVU1BFTkQKKyNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NZ
U0ZTCiAKICNlbmRpZiAvKiBfX0FTU0VNQkxZX18gKi8KIApkaWZmIC0tZ2l0IGEvaW5jbHVkZS9h
c20tcG93ZXJwYy91bmlzdGQuaCBiL2luY2x1ZGUvYXNtLXBvd2VycGMvdW5pc3RkLmgKaW5kZXgg
Y2U5MWJiNi4uNzYzZjA1NiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9hc20tcG93ZXJwYy91bmlzdGQu
aAorKysgYi9pbmNsdWRlL2FzbS1wb3dlcnBjL3VuaXN0ZC5oCkBAIC0zNzEsNiArMzcxLDcgQEAK
ICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NJR1BST0NNQVNLCiAjZGVmaW5lIF9fQVJDSF9XQU5U
X1NZU19SVF9TSUdBQ1RJT04KICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1JUX1NJR1NVU1BFTkQK
KyNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NZU0ZTCiAjaWZkZWYgQ09ORklHX1BQQzMyCiAjZGVm
aW5lIF9fQVJDSF9XQU5UX09MRF9TVEFUCiAjZW5kaWYKZGlmZiAtLWdpdCBhL2luY2x1ZGUvYXNt
LXMzOTAvdW5pc3RkLmggYi9pbmNsdWRlL2FzbS1zMzkwL3VuaXN0ZC5oCmluZGV4IDU4M2RhODAu
LmFmZDllMTkgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvYXNtLXMzOTAvdW5pc3RkLmgKKysrIGIvaW5j
bHVkZS9hc20tczM5MC91bmlzdGQuaApAQCAtMzg0LDYgKzM4NCw3IEBACiAjZGVmaW5lIF9fQVJD
SF9XQU5UX1NZU19TSUdQUk9DTUFTSwogI2RlZmluZSBfX0FSQ0hfV0FOVF9TWVNfUlRfU0lHQUNU
SU9OCiAjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19SVF9TSUdTVVNQRU5ECisjZGVmaW5lIF9fQVJD
SF9XQU5UX1NZU19TWVNGUwogIyBpZm5kZWYgQ09ORklHXzY0QklUCiAjICAgZGVmaW5lIF9fQVJD
SF9XQU5UX1NUQVQ2NAogIyAgIGRlZmluZSBfX0FSQ0hfV0FOVF9TWVNfVElNRQpkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9hc20tc2gvdW5pc3RkXzMyLmggYi9pbmNsdWRlL2FzbS1zaC91bmlzdGRfMzIu
aAppbmRleCAwYjA3MjEyLi5kMDEwYmQwIDEwMDY0NAotLS0gYS9pbmNsdWRlL2FzbS1zaC91bmlz
dGRfMzIuaAorKysgYi9pbmNsdWRlL2FzbS1zaC91bmlzdGRfMzIuaApAQCAtMzYzLDYgKzM2Myw3
IEBACiAjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19TSUdQUk9DTUFTSwogI2RlZmluZSBfX0FSQ0hf
V0FOVF9TWVNfUlRfU0lHQUNUSU9OCiAjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19SVF9TSUdTVVNQ
RU5ECisjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19TWVNGUwogCiAvKgogICogIkNvbmRpdGlvbmFs
IiBzeXNjYWxscwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9hc20tc2gvdW5pc3RkXzY0LmggYi9pbmNs
dWRlL2FzbS1zaC91bmlzdGRfNjQuaAppbmRleCA5ZDIxZWFiLi5kNjkwOTBiIDEwMDY0NAotLS0g
YS9pbmNsdWRlL2FzbS1zaC91bmlzdGRfNjQuaAorKysgYi9pbmNsdWRlL2FzbS1zaC91bmlzdGRf
NjQuaApAQCAtNDAyLDYgKzQwMiw3IEBACiAjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19TSUdQRU5E
SU5HCiAjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19TSUdQUk9DTUFTSwogI2RlZmluZSBfX0FSQ0hf
V0FOVF9TWVNfUlRfU0lHQUNUSU9OCisjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19TWVNGUwogCiAv
KgogICogIkNvbmRpdGlvbmFsIiBzeXNjYWxscwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9hc20tc3Bh
cmMvdW5pc3RkLmggYi9pbmNsdWRlL2FzbS1zcGFyYy91bmlzdGQuaAppbmRleCAyMzM4YTAyLi5j
N2U3MTIzIDEwMDY0NAotLS0gYS9pbmNsdWRlL2FzbS1zcGFyYy91bmlzdGQuaAorKysgYi9pbmNs
dWRlL2FzbS1zcGFyYy91bmlzdGQuaApAQCAtMzY1LDYgKzM2NSw3IEBACiAjZGVmaW5lIF9fQVJD
SF9XQU5UX1NZU19TSUdQRU5ESU5HCiAjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19TSUdQUk9DTUFT
SwogI2RlZmluZSBfX0FSQ0hfV0FOVF9TWVNfUlRfU0lHU1VTUEVORAorI2RlZmluZSBfX0FSQ0hf
V0FOVF9TWVNfU1lTRlMKIAogLyoKICAqICJDb25kaXRpb25hbCIgc3lzY2FsbHMKZGlmZiAtLWdp
dCBhL2luY2x1ZGUvYXNtLXNwYXJjNjQvdW5pc3RkLmggYi9pbmNsdWRlL2FzbS1zcGFyYzY0L3Vu
aXN0ZC5oCmluZGV4IDc3NTU5ZGEuLjg5MTY4M2MgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvYXNtLXNw
YXJjNjQvdW5pc3RkLmgKKysrIGIvaW5jbHVkZS9hc20tc3BhcmM2NC91bmlzdGQuaApAQCAtMzcw
LDYgKzM3MCw3IEBACiAjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19TSUdQUk9DTUFTSwogI2RlZmlu
ZSBfX0FSQ0hfV0FOVF9TWVNfUlRfU0lHU1VTUEVORAogI2RlZmluZSBfX0FSQ0hfV0FOVF9DT01Q
QVRfU1lTX1JUX1NJR1NVU1BFTkQKKyNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NZU0ZTCiAKIC8q
CiAgKiAiQ29uZGl0aW9uYWwiIHN5c2NhbGxzCmRpZmYgLS1naXQgYS9pbmNsdWRlL2FzbS12ODUw
L3VuaXN0ZC5oIGIvaW5jbHVkZS9hc20tdjg1MC91bmlzdGQuaAppbmRleCAyMjQxZWQ0Li5iMDMw
YTc4IDEwMDY0NAotLS0gYS9pbmNsdWRlL2FzbS12ODUwL3VuaXN0ZC5oCisrKyBiL2luY2x1ZGUv
YXNtLXY4NTAvdW5pc3RkLmgKQEAgLTIyNiw2ICsyMjYsNyBAQAogI2RlZmluZSBfX0FSQ0hfV0FO
VF9TWVNfU0lHUEVORElORwogI2RlZmluZSBfX0FSQ0hfV0FOVF9TWVNfU0lHUFJPQ01BU0sKICNk
ZWZpbmUgX19BUkNIX1dBTlRfU1lTX1JUX1NJR0FDVElPTgorI2RlZmluZSBfX0FSQ0hfV0FOVF9T
WVNfU1lTRlMKIAogLyoKICAqICJDb25kaXRpb25hbCIgc3lzY2FsbHMKZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvYXNtLXg4Ni91bmlzdGRfMzIuaCBiL2luY2x1ZGUvYXNtLXg4Ni91bmlzdGRfMzIuaApp
bmRleCA5ODQxMjNhLi4zNWY2MTFlIDEwMDY0NAotLS0gYS9pbmNsdWRlL2FzbS14ODYvdW5pc3Rk
XzMyLmgKKysrIGIvaW5jbHVkZS9hc20teDg2L3VuaXN0ZF8zMi5oCkBAIC0zNTgsNiArMzU4LDcg
QEAKICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NJR1BST0NNQVNLCiAjZGVmaW5lIF9fQVJDSF9X
QU5UX1NZU19SVF9TSUdBQ1RJT04KICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1JUX1NJR1NVU1BF
TkQKKyNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NZU0ZTCiAKIC8qCiAgKiAiQ29uZGl0aW9uYWwi
IHN5c2NhbGxzCmRpZmYgLS1naXQgYS9pbmNsdWRlL2FzbS14ODYvdW5pc3RkXzY0LmggYi9pbmNs
dWRlL2FzbS14ODYvdW5pc3RkXzY0LmgKaW5kZXggMzg4M2NlYi4uNmM0NjM5NSAxMDA2NDQKLS0t
IGEvaW5jbHVkZS9hc20teDg2L3VuaXN0ZF82NC5oCisrKyBiL2luY2x1ZGUvYXNtLXg4Ni91bmlz
dGRfNjQuaApAQCAtNjY0LDYgKzY2NCw3IEBAIF9fU1lTQ0FMTChfX05SX3RpbWVyZmRfZ2V0dGlt
ZSwgc3lzX3RpbWVyZmRfZ2V0dGltZSkKICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1JUX1NJR1NV
U1BFTkQKICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1RJTUUKICNkZWZpbmUgX19BUkNIX1dBTlRf
Q09NUEFUX1NZU19USU1FCisjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19TWVNGUwogI2VuZGlmCS8q
IF9fTk9fU1RVQlMgKi8KIAogI2lmZGVmIF9fS0VSTkVMX18KZGlmZiAtLWdpdCBhL2luY2x1ZGUv
YXNtLXh0ZW5zYS91bmlzdGQuaCBiL2luY2x1ZGUvYXNtLXh0ZW5zYS91bmlzdGQuaAppbmRleCBj
MDkyYzhmLi4wYTFiZGFlIDEwMDY0NAotLS0gYS9pbmNsdWRlL2FzbS14dGVuc2EvdW5pc3RkLmgK
KysrIGIvaW5jbHVkZS9hc20teHRlbnNhL3VuaXN0ZC5oCkBAIC03MTgsNiArNzE4LDcgQEAgX19T
WVNDQUxMKDMwNiwgc3lzX2V2ZW50ZmQsIDEpCiAjZGVmaW5lIF9fQVJDSF9XQU5UX1NZU19SVF9T
SUdBQ1RJT04KICNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1JUX1NJR1NVU1BFTkQKICNkZWZpbmUg
X19BUkNIX1dBTlRfU1lTX0dFVFBHUlAKKyNkZWZpbmUgX19BUkNIX1dBTlRfU1lTX1NZU0ZTCiAK
IC8qIAogICogSWdub3JlIGxlZ2FjeSBzeXN0ZW0gY2FsbHMgaW4gdGhlIGNoZWNrc3lzY2FsbHMu
c2ggc2NyaXB0Ci0tIAoxLjUuMy41Cgo=
------=_Part_3718_22986760.1208866419938--
