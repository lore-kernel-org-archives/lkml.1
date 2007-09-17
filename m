Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbXIQRBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbXIQRBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 13:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbXIQRBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 13:01:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:45056 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751918AbXIQRBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 13:01:16 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1+SOcVLAbSSbTyghiujKfVDDx4ECtm8NQJJ8TcXib
	kwFHHSHszYLUBR
Message-ID: <46EEB252.30003@gmx.net>
Date: Mon, 17 Sep 2007 18:58:58 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: davidel@xmailserver.org, vda.linux@googlemail.com, rdunlap@xenotime.net,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, drepper@redhat.com, stable@kernel.org,
       hch@lst.de, jengelh@computergmbh.de, corbet@lwn.net, stable@kernel.org
Subject: [PATCH] remove timerd() syscall number
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew

I hope I've done this right...  This patch, against 2.6.23-rc6,
removes the timerfd() syscall (which in any case had a bug
on its 2.6.22 release) from all architectures, so that we
can have some breathing space to think about the API design.
All of the existing timerfd() code is left intact.

Please apply, so that 2.6.23 does not expose timerfd().

Cheers,

Michael

diff -pur linux-2.6.23-rc6/include/asm/unistd.h linux-2.6.23-rc6-new/include/asm/unistd.h
--- linux-2.6.23-rc6/include/asm/unistd.h	2007-09-13 18:43:41.000000000 +0200
+++ linux-2.6.23-rc6-new/include/asm/unistd.h	2007-09-14 10:51:38.000000000 +0200
@@ -327,7 +327,8 @@
 #define __NR_epoll_pwait	319
 #define __NR_utimensat		320
 #define __NR_signalfd		321
-#define __NR_timerfd		322
+/* Let's pause a moment before we decide on the final timerfd API */
+/* #define __NR_timerfd		322 */
 #define __NR_eventfd		323
 #define __NR_fallocate		324

diff -pur linux-2.6.23-rc6/include/asm-alpha/unistd.h linux-2.6.23-rc6-new/include/asm-alpha/unistd.h
--- linux-2.6.23-rc6/include/asm-alpha/unistd.h	2007-07-28 23:59:39.000000000 +0200
+++ linux-2.6.23-rc6-new/include/asm-alpha/unistd.h	2007-09-13 22:12:18.000000000 +0200
@@ -431,7 +431,7 @@
 #define __NR_epoll_pwait		474
 #define __NR_utimensat			475
 #define __NR_signalfd			476
-#define __NR_timerfd			477
+/* #define __NR_timerfd			477 */
 #define __NR_eventfd			478

 #ifdef __KERNEL__
diff -pur linux-2.6.23-rc6/include/asm-arm/unistd.h linux-2.6.23-rc6-new/include/asm-arm/unistd.h
--- linux-2.6.23-rc6/include/asm-arm/unistd.h	2007-09-13 18:43:40.000000000 +0200
+++ linux-2.6.23-rc6-new/include/asm-arm/unistd.h	2007-09-13 22:12:22.000000000 +0200
@@ -376,7 +376,7 @@
 #define __NR_kexec_load			(__NR_SYSCALL_BASE+347)
 #define __NR_utimensat			(__NR_SYSCALL_BASE+348)
 #define __NR_signalfd			(__NR_SYSCALL_BASE+349)
-#define __NR_timerfd			(__NR_SYSCALL_BASE+350)
+/* #define __NR_timerfd			(__NR_SYSCALL_BASE+350) */
 #define __NR_eventfd			(__NR_SYSCALL_BASE+351)

 /*
diff -pur linux-2.6.23-rc6/include/asm-avr32/unistd.h linux-2.6.23-rc6-new/include/asm-avr32/unistd.h
--- linux-2.6.23-rc6/include/asm-avr32/unistd.h	2007-07-28 23:59:46.000000000 +0200
+++ linux-2.6.23-rc6-new/include/asm-avr32/unistd.h	2007-09-13 22:12:29.000000000 +0200
@@ -297,7 +297,7 @@

 #define __NR_utimensat		278
 #define __NR_signalfd		279
-#define __NR_timerfd		280
+/* #define __NR_timerfd		280 */
 #define __NR_eventfd		281

 #ifdef __KERNEL__
diff -pur linux-2.6.23-rc6/include/asm-frv/unistd.h linux-2.6.23-rc6-new/include/asm-frv/unistd.h
--- linux-2.6.23-rc6/include/asm-frv/unistd.h	2007-09-13 18:43:41.000000000 +0200
+++ linux-2.6.23-rc6-new/include/asm-frv/unistd.h	2007-09-13 22:12:53.000000000 +0200
@@ -328,7 +328,7 @@
 #define __NR_epoll_pwait	319
 #define __NR_utimensat		320
 #define __NR_signalfd		321
-#define __NR_timerfd		322
+/* #define __NR_timerfd		322 */
 #define __NR_eventfd		323
 #define __NR_fallocate		324

diff -pur linux-2.6.23-rc6/include/asm-i386/unistd.h linux-2.6.23-rc6-new/include/asm-i386/unistd.h
--- linux-2.6.23-rc6/include/asm-i386/unistd.h	2007-09-13 18:43:41.000000000 +0200
+++ linux-2.6.23-rc6-new/include/asm-i386/unistd.h	2007-09-14 10:51:38.000000000 +0200
@@ -327,7 +327,8 @@
 #define __NR_epoll_pwait	319
 #define __NR_utimensat		320
 #define __NR_signalfd		321
-#define __NR_timerfd		322
+/* Let's pause a moment before we decide on the final timerfd API */
+/* #define __NR_timerfd		322 */
 #define __NR_eventfd		323
 #define __NR_fallocate		324

diff -pur linux-2.6.23-rc6/include/asm-ia64/unistd.h linux-2.6.23-rc6-new/include/asm-ia64/unistd.h
--- linux-2.6.23-rc6/include/asm-ia64/unistd.h	2007-09-13 18:43:41.000000000 +0200
+++ linux-2.6.23-rc6-new/include/asm-ia64/unistd.h	2007-09-13 22:13:03.000000000 +0200
@@ -297,7 +297,7 @@
 #define __NR_epoll_pwait		1305
 #define __NR_utimensat			1306
 #define __NR_signalfd			1307
-#define __NR_timerfd			1308
+/* #define __NR_timerfd			1308 */
 #define __NR_eventfd			1309

 #ifdef __KERNEL__
diff -pur linux-2.6.23-rc6/include/asm-mips/unistd.h linux-2.6.23-rc6-new/include/asm-mips/unistd.h
--- linux-2.6.23-rc6/include/asm-mips/unistd.h	2007-09-13 18:43:42.000000000 +0200
+++ linux-2.6.23-rc6-new/include/asm-mips/unistd.h	2007-09-13 22:13:16.000000000 +0200
@@ -338,7 +338,7 @@
 #define __NR_ioprio_get			(__NR_Linux + 315)
 #define __NR_utimensat			(__NR_Linux + 316)
 #define __NR_signalfd			(__NR_Linux + 317)
-#define __NR_timerfd			(__NR_Linux + 318)
+/* #define __NR_timerfd			(__NR_Linux + 318) */
 #define __NR_eventfd			(__NR_Linux + 319)
 #define __NR_fallocate			(__NR_Linux + 320)

@@ -635,7 +635,7 @@
 #define __NR_ioprio_get			(__NR_Linux + 274)
 #define __NR_utimensat			(__NR_Linux + 275)
 #define __NR_signalfd			(__NR_Linux + 276)
-#define __NR_timerfd			(__NR_Linux + 277)
+/* #define __NR_timerfd			(__NR_Linux + 277) */
 #define __NR_eventfd			(__NR_Linux + 278)
 #define __NR_fallocate			(__NR_Linux + 279)

@@ -936,7 +936,7 @@
 #define __NR_ioprio_get			(__NR_Linux + 278)
 #define __NR_utimensat			(__NR_Linux + 279)
 #define __NR_signalfd			(__NR_Linux + 280)
-#define __NR_timerfd			(__NR_Linux + 281)
+/* #define __NR_timerfd			(__NR_Linux + 281) */
 #define __NR_eventfd			(__NR_Linux + 282)
 #define __NR_fallocate			(__NR_Linux + 283)

diff -pur linux-2.6.23-rc6/include/asm-parisc/unistd.h linux-2.6.23-rc6-new/include/asm-parisc/unistd.h
--- linux-2.6.23-rc6/include/asm-parisc/unistd.h	2007-07-28 23:59:57.000000000 +0200
+++ linux-2.6.23-rc6-new/include/asm-parisc/unistd.h	2007-09-13 22:13:23.000000000 +0200
@@ -795,7 +795,7 @@
 #define __NR_kexec_load		(__NR_Linux + 300)
 #define __NR_utimensat		(__NR_Linux + 301)
 #define __NR_signalfd		(__NR_Linux + 302)
-#define __NR_timerfd		(__NR_Linux + 303)
+/* #define __NR_timerfd		(__NR_Linux + 303) */
 #define __NR_eventfd		(__NR_Linux + 304)

 #define __NR_Linux_syscalls	(__NR_eventfd + 1)
diff -pur linux-2.6.23-rc6/include/asm-powerpc/unistd.h linux-2.6.23-rc6-new/include/asm-powerpc/unistd.h
--- linux-2.6.23-rc6/include/asm-powerpc/unistd.h	2007-09-13 18:43:43.000000000 +0200
+++ linux-2.6.23-rc6-new/include/asm-powerpc/unistd.h	2007-09-13 22:13:27.000000000 +0200
@@ -328,7 +328,7 @@
 #define __NR_epoll_pwait	303
 #define __NR_utimensat		304
 #define __NR_signalfd		305
-#define __NR_timerfd		306
+/* #define __NR_timerfd		306 */
 #define __NR_eventfd		307
 #define __NR_sync_file_range2	308
 #define __NR_fallocate		309
diff -pur linux-2.6.23-rc6/include/asm-s390/unistd.h linux-2.6.23-rc6-new/include/asm-s390/unistd.h
--- linux-2.6.23-rc6/include/asm-s390/unistd.h	2007-09-13 18:43:43.000000000 +0200
+++ linux-2.6.23-rc6-new/include/asm-s390/unistd.h	2007-09-13 22:13:30.000000000 +0200
@@ -254,7 +254,7 @@
 #define __NR_fallocate		314
 #define __NR_utimensat		315
 #define __NR_signalfd		316
-#define __NR_timerfd		317
+/* #define __NR_timerfd		317 */
 #define __NR_eventfd		318
 #define NR_syscalls 319

diff -pur linux-2.6.23-rc6/include/asm-sh/unistd.h linux-2.6.23-rc6-new/include/asm-sh/unistd.h
--- linux-2.6.23-rc6/include/asm-sh/unistd.h	2007-09-13 18:43:43.000000000 +0200
+++ linux-2.6.23-rc6-new/include/asm-sh/unistd.h	2007-09-13 22:13:34.000000000 +0200
@@ -330,7 +330,7 @@
 #define __NR_epoll_pwait	319
 #define __NR_utimensat		320
 #define __NR_signalfd		321
-#define __NR_timerfd		322
+/* #define __NR_timerfd		322 */
 #define __NR_eventfd		323
 #define __NR_fallocate		324

diff -pur linux-2.6.23-rc6/include/asm-sh64/unistd.h linux-2.6.23-rc6-new/include/asm-sh64/unistd.h
--- linux-2.6.23-rc6/include/asm-sh64/unistd.h	2007-09-13 18:43:43.000000000 +0200
+++ linux-2.6.23-rc6-new/include/asm-sh64/unistd.h	2007-09-13 22:13:43.000000000 +0200
@@ -372,7 +372,7 @@
 #define __NR_epoll_pwait	347
 #define __NR_utimensat		348
 #define __NR_signalfd		349
-#define __NR_timerfd		350
+/* #define __NR_timerfd		350 */
 #define __NR_eventfd		351
 #define __NR_fallocate		352

diff -pur linux-2.6.23-rc6/include/asm-sparc/unistd.h linux-2.6.23-rc6-new/include/asm-sparc/unistd.h
--- linux-2.6.23-rc6/include/asm-sparc/unistd.h	2007-09-13 18:43:43.000000000 +0200
+++ linux-2.6.23-rc6-new/include/asm-sparc/unistd.h	2007-09-13 22:13:48.000000000 +0200
@@ -327,7 +327,7 @@
 #define __NR_epoll_pwait	309
 #define __NR_utimensat		310
 #define __NR_signalfd		311
-#define __NR_timerfd		312
+/* #define __NR_timerfd		312 */
 #define __NR_eventfd		313
 #define __NR_fallocate		314

diff -pur linux-2.6.23-rc6/include/asm-sparc64/unistd.h linux-2.6.23-rc6-new/include/asm-sparc64/unistd.h
--- linux-2.6.23-rc6/include/asm-sparc64/unistd.h	2007-09-13 18:43:43.000000000 +0200
+++ linux-2.6.23-rc6-new/include/asm-sparc64/unistd.h	2007-09-13 22:13:59.000000000 +0200
@@ -329,7 +329,7 @@
 #define __NR_epoll_pwait	309
 #define __NR_utimensat		310
 #define __NR_signalfd		311
-#define __NR_timerfd		312
+/* #define __NR_timerfd		312 */
 #define __NR_eventfd		313
 #define __NR_fallocate		314

diff -pur linux-2.6.23-rc6/include/asm-x86_64/unistd.h linux-2.6.23-rc6-new/include/asm-x86_64/unistd.h
--- linux-2.6.23-rc6/include/asm-x86_64/unistd.h	2007-09-13 18:43:44.000000000 +0200
+++ linux-2.6.23-rc6-new/include/asm-x86_64/unistd.h	2007-09-13 22:14:09.000000000 +0200
@@ -626,8 +626,8 @@ __SYSCALL(__NR_utimensat, sys_utimensat)
 __SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
 #define __NR_signalfd		282
 __SYSCALL(__NR_signalfd, sys_signalfd)
-#define __NR_timerfd		283
-__SYSCALL(__NR_timerfd, sys_timerfd)
+/* #define __NR_timerfd		283
+__SYSCALL(__NR_timerfd, sys_timerfd) */
 #define __NR_eventfd		284
 __SYSCALL(__NR_eventfd, sys_eventfd)
 #define __NR_fallocate		285



