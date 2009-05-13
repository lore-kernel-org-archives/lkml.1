Return-Path: <linux-kernel-owner+w=401wt.eu-S1761651AbZEMW6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651AbZEMW6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761345AbZEMW4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:56:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:65408 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZEMW4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:56:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: [PATCH 01/15] asm-generic: rename termios.h, signal.h and mman.h
Date: Wed, 13 May 2009 22:56:24 +0000
Message-Id: <1242255398-23779-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242255398-23779-1-git-send-email-arnd@arndb.de>
References: <1242255398-23779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/h2fELuvwFxEtobpeMHH+bjMbOu7kBYa3kkwE
 QKkQkMVwrv5sNDBNtUFrMjd5wlMLiG2uz3Xuz3CfK6fCeNdNWt
 U2ZsgIpcmR6vtd2FokJLg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing asm-generic versions are incomplete and included
by some architectures. New architectures should be able
to use a generic version, so rename the existing files and
change all users, which lets us add the new files.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 arch/alpha/include/asm/signal.h                   |    2 +-
 arch/arm/include/asm/mman.h                       |    2 +-
 arch/arm/include/asm/signal.h                     |    2 +-
 arch/avr32/include/asm/mman.h                     |    2 +-
 arch/avr32/include/asm/signal.h                   |    2 +-
 arch/avr32/include/asm/termios.h                  |    2 +-
 arch/blackfin/include/asm/signal.h                |    2 +-
 arch/cris/include/asm/mman.h                      |    2 +-
 arch/cris/include/asm/signal.h                    |    2 +-
 arch/frv/include/asm/mman.h                       |    2 +-
 arch/frv/include/asm/termios.h                    |    2 +-
 arch/h8300/include/asm/mman.h                     |    2 +-
 arch/h8300/include/asm/signal.h                   |    2 +-
 arch/ia64/include/asm/mman.h                      |    2 +-
 arch/ia64/include/asm/signal.h                    |    2 +-
 arch/m32r/include/asm/mman.h                      |    2 +-
 arch/m32r/include/asm/signal.h                    |    2 +-
 arch/m68k/include/asm/mman.h                      |    2 +-
 arch/m68k/include/asm/signal.h                    |    2 +-
 arch/microblaze/include/asm/signal.h              |    2 +-
 arch/microblaze/include/asm/termios.h             |    2 +-
 arch/mips/include/asm/signal.h                    |    2 +-
 arch/mn10300/include/asm/mman.h                   |    2 +-
 arch/mn10300/include/asm/signal.h                 |    2 +-
 arch/powerpc/include/asm/mman.h                   |    2 +-
 arch/powerpc/include/asm/signal.h                 |    2 +-
 arch/powerpc/include/asm/termios.h                |    2 +-
 arch/s390/include/asm/mman.h                      |    2 +-
 arch/s390/include/asm/signal.h                    |    2 +-
 arch/s390/include/asm/termios.h                   |    2 +-
 arch/sh/include/asm/mman.h                        |    2 +-
 arch/sh/include/asm/signal.h                      |    2 +-
 arch/sparc/include/asm/mman.h                     |    2 +-
 arch/sparc/include/asm/signal.h                   |    2 +-
 arch/x86/include/asm/mman.h                       |    2 +-
 arch/x86/include/asm/signal.h                     |    2 +-
 include/asm-generic/Kbuild                        |    4 ++--
 include/asm-generic/{mman.h => mman-common.h}     |    6 +++---
 include/asm-generic/{signal.h => signal-defs.h}   |    6 +++---
 include/asm-generic/{termios.h => termios-base.h} |    6 +++---
 40 files changed, 47 insertions(+), 47 deletions(-)
 rename include/asm-generic/{mman.h => mman-common.h} (93%)
 rename include/asm-generic/{signal.h => signal-defs.h} (85%)
 rename include/asm-generic/{termios.h => termios-base.h} (94%)

diff --git a/arch/alpha/include/asm/signal.h b/arch/alpha/include/asm/signal.h
index 13c2305..a938830 100644
--- a/arch/alpha/include/asm/signal.h
+++ b/arch/alpha/include/asm/signal.h
@@ -111,7 +111,7 @@ typedef unsigned long sigset_t;
 #define SIG_UNBLOCK        2	/* for unblocking signals */
 #define SIG_SETMASK        3	/* for setting the signal mask */
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct osf_sigaction {
diff --git a/arch/arm/include/asm/mman.h b/arch/arm/include/asm/mman.h
index 54570d2..fc26976 100644
--- a/arch/arm/include/asm/mman.h
+++ b/arch/arm/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef __ARM_MMAN_H__
 #define __ARM_MMAN_H__
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
diff --git a/arch/arm/include/asm/signal.h b/arch/arm/include/asm/signal.h
index d0fb487..43ba0fb 100644
--- a/arch/arm/include/asm/signal.h
+++ b/arch/arm/include/asm/signal.h
@@ -111,7 +111,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
diff --git a/arch/avr32/include/asm/mman.h b/arch/avr32/include/asm/mman.h
index 648f91e..9a92b15 100644
--- a/arch/avr32/include/asm/mman.h
+++ b/arch/avr32/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_AVR32_MMAN_H__
 #define __ASM_AVR32_MMAN_H__
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
diff --git a/arch/avr32/include/asm/signal.h b/arch/avr32/include/asm/signal.h
index caffefe..8790dfc 100644
--- a/arch/avr32/include/asm/signal.h
+++ b/arch/avr32/include/asm/signal.h
@@ -112,7 +112,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
diff --git a/arch/avr32/include/asm/termios.h b/arch/avr32/include/asm/termios.h
index 0152aba..dd7e9da 100644
--- a/arch/avr32/include/asm/termios.h
+++ b/arch/avr32/include/asm/termios.h
@@ -55,7 +55,7 @@ struct termio {
 */
 #define INIT_C_CC "\003\034\177\025\004\0\1\0\021\023\032\0\022\017\027\026\0"
 
-#include <asm-generic/termios.h>
+#include <asm-generic/termios-base.h>
 
 #endif	/* __KERNEL__ */
 
diff --git a/arch/blackfin/include/asm/signal.h b/arch/blackfin/include/asm/signal.h
index 87951d2..2eea907 100644
--- a/arch/blackfin/include/asm/signal.h
+++ b/arch/blackfin/include/asm/signal.h
@@ -104,7 +104,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
diff --git a/arch/cris/include/asm/mman.h b/arch/cris/include/asm/mman.h
index 1c35e1b..b7f0afb 100644
--- a/arch/cris/include/asm/mman.h
+++ b/arch/cris/include/asm/mman.h
@@ -3,7 +3,7 @@
 
 /* verbatim copy of asm-i386/ version */
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
diff --git a/arch/cris/include/asm/signal.h b/arch/cris/include/asm/signal.h
index 349ae68..ea6af9a 100644
--- a/arch/cris/include/asm/signal.h
+++ b/arch/cris/include/asm/signal.h
@@ -106,7 +106,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
diff --git a/arch/frv/include/asm/mman.h b/arch/frv/include/asm/mman.h
index b4371e9..58c1d11 100644
--- a/arch/frv/include/asm/mman.h
+++ b/arch/frv/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_MMAN_H__
 #define __ASM_MMAN_H__
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
diff --git a/arch/frv/include/asm/termios.h b/arch/frv/include/asm/termios.h
index a62fb58..b4868aa 100644
--- a/arch/frv/include/asm/termios.h
+++ b/arch/frv/include/asm/termios.h
@@ -52,7 +52,7 @@ struct termio {
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
 #ifdef __KERNEL__
-#include <asm-generic/termios.h>
+#include <asm-generic/termios-base.h>
 #endif
 
 #endif /* _ASM_TERMIOS_H */
diff --git a/arch/h8300/include/asm/mman.h b/arch/h8300/include/asm/mman.h
index b9f104f..cf35f0a 100644
--- a/arch/h8300/include/asm/mman.h
+++ b/arch/h8300/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef __H8300_MMAN_H__
 #define __H8300_MMAN_H__
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
diff --git a/arch/h8300/include/asm/signal.h b/arch/h8300/include/asm/signal.h
index 7bc1504..fd8b66e 100644
--- a/arch/h8300/include/asm/signal.h
+++ b/arch/h8300/include/asm/signal.h
@@ -105,7 +105,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
diff --git a/arch/ia64/include/asm/mman.h b/arch/ia64/include/asm/mman.h
index c73b878..48cf8b9 100644
--- a/arch/ia64/include/asm/mman.h
+++ b/arch/ia64/include/asm/mman.h
@@ -8,7 +8,7 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co
  */
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x00100		/* stack-like segment */
 #define MAP_GROWSUP	0x00200		/* register stack-like segment */
diff --git a/arch/ia64/include/asm/signal.h b/arch/ia64/include/asm/signal.h
index 4f5ca56..b166248 100644
--- a/arch/ia64/include/asm/signal.h
+++ b/arch/ia64/include/asm/signal.h
@@ -114,7 +114,7 @@
 
 #endif /* __KERNEL__ */
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 # ifndef __ASSEMBLY__
 
diff --git a/arch/m32r/include/asm/mman.h b/arch/m32r/include/asm/mman.h
index 516a897..04a5f40 100644
--- a/arch/m32r/include/asm/mman.h
+++ b/arch/m32r/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef __M32R_MMAN_H__
 #define __M32R_MMAN_H__
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
diff --git a/arch/m32r/include/asm/signal.h b/arch/m32r/include/asm/signal.h
index 1a60706..9c1acb2 100644
--- a/arch/m32r/include/asm/signal.h
+++ b/arch/m32r/include/asm/signal.h
@@ -107,7 +107,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
diff --git a/arch/m68k/include/asm/mman.h b/arch/m68k/include/asm/mman.h
index 1626d37..9f5c4c4 100644
--- a/arch/m68k/include/asm/mman.h
+++ b/arch/m68k/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef __M68K_MMAN_H__
 #define __M68K_MMAN_H__
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
diff --git a/arch/m68k/include/asm/signal.h b/arch/m68k/include/asm/signal.h
index 08788fd..5bc09c7 100644
--- a/arch/m68k/include/asm/signal.h
+++ b/arch/m68k/include/asm/signal.h
@@ -103,7 +103,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
diff --git a/arch/microblaze/include/asm/signal.h b/arch/microblaze/include/asm/signal.h
index 9676fad..46bc226 100644
--- a/arch/microblaze/include/asm/signal.h
+++ b/arch/microblaze/include/asm/signal.h
@@ -90,7 +90,7 @@
 
 # ifndef __ASSEMBLY__
 # include <linux/types.h>
-# include <asm-generic/signal.h>
+# include <asm-generic/signal-defs.h>
 
 /* Avoid too many header ordering problems. */
 struct siginfo;
diff --git a/arch/microblaze/include/asm/termios.h b/arch/microblaze/include/asm/termios.h
index 102d772..47a46d1 100644
--- a/arch/microblaze/include/asm/termios.h
+++ b/arch/microblaze/include/asm/termios.h
@@ -81,7 +81,7 @@ struct termio {
 
 #ifdef __KERNEL__
 
-#include <asm-generic/termios.h>
+#include <asm-generic/termios-base.h>
 
 #endif	/* __KERNEL__ */
 
diff --git a/arch/mips/include/asm/signal.h b/arch/mips/include/asm/signal.h
index bee5153..c783f36 100644
--- a/arch/mips/include/asm/signal.h
+++ b/arch/mips/include/asm/signal.h
@@ -109,7 +109,7 @@ typedef unsigned long old_sigset_t;		/* at least 32 bits */
 #define SIG_UNBLOCK	2	/* for unblocking signals */
 #define SIG_SETMASK	3	/* for setting the signal mask */
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 struct sigaction {
 	unsigned int	sa_flags;
diff --git a/arch/mn10300/include/asm/mman.h b/arch/mn10300/include/asm/mman.h
index b7986b6..d04fac1 100644
--- a/arch/mn10300/include/asm/mman.h
+++ b/arch/mn10300/include/asm/mman.h
@@ -12,7 +12,7 @@
 #ifndef _ASM_MMAN_H
 #define _ASM_MMAN_H
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
diff --git a/arch/mn10300/include/asm/signal.h b/arch/mn10300/include/asm/signal.h
index e98817c..7e891fc 100644
--- a/arch/mn10300/include/asm/signal.h
+++ b/arch/mn10300/include/asm/signal.h
@@ -115,7 +115,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
diff --git a/arch/powerpc/include/asm/mman.h b/arch/powerpc/include/asm/mman.h
index e7b99ba..7b1c498 100644
--- a/arch/powerpc/include/asm/mman.h
+++ b/arch/powerpc/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_POWERPC_MMAN_H
 #define _ASM_POWERPC_MMAN_H
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 /*
  * This program is free software; you can redistribute it and/or
diff --git a/arch/powerpc/include/asm/signal.h b/arch/powerpc/include/asm/signal.h
index 69f709d..3eb13be 100644
--- a/arch/powerpc/include/asm/signal.h
+++ b/arch/powerpc/include/asm/signal.h
@@ -94,7 +94,7 @@ typedef struct {
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 struct old_sigaction {
 	__sighandler_t sa_handler;
diff --git a/arch/powerpc/include/asm/termios.h b/arch/powerpc/include/asm/termios.h
index 2c14fea..a24f487 100644
--- a/arch/powerpc/include/asm/termios.h
+++ b/arch/powerpc/include/asm/termios.h
@@ -78,7 +78,7 @@ struct termio {
 
 #ifdef __KERNEL__
 
-#include <asm-generic/termios.h>
+#include <asm-generic/termios-base.h>
 
 #endif	/* __KERNEL__ */
 
diff --git a/arch/s390/include/asm/mman.h b/arch/s390/include/asm/mman.h
index da01432..f63fe7b 100644
--- a/arch/s390/include/asm/mman.h
+++ b/arch/s390/include/asm/mman.h
@@ -9,7 +9,7 @@
 #ifndef __S390_MMAN_H__
 #define __S390_MMAN_H__
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
diff --git a/arch/s390/include/asm/signal.h b/arch/s390/include/asm/signal.h
index f6cfddb..cdf5cb2 100644
--- a/arch/s390/include/asm/signal.h
+++ b/arch/s390/include/asm/signal.h
@@ -115,7 +115,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ     2048
 #define SIGSTKSZ        8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
diff --git a/arch/s390/include/asm/termios.h b/arch/s390/include/asm/termios.h
index 67f6627..bc3a35c 100644
--- a/arch/s390/include/asm/termios.h
+++ b/arch/s390/include/asm/termios.h
@@ -60,7 +60,7 @@ struct termio {
 #define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
 #define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
 
-#include <asm-generic/termios.h>
+#include <asm-generic/termios-base.h>
 
 #endif	/* __KERNEL__ */
 
diff --git a/arch/sh/include/asm/mman.h b/arch/sh/include/asm/mman.h
index 156eb02..7d8b72c 100644
--- a/arch/sh/include/asm/mman.h
+++ b/arch/sh/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_SH_MMAN_H
 #define __ASM_SH_MMAN_H
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
diff --git a/arch/sh/include/asm/signal.h b/arch/sh/include/asm/signal.h
index 5c5c1e8..9cc5f01 100644
--- a/arch/sh/include/asm/signal.h
+++ b/arch/sh/include/asm/signal.h
@@ -106,7 +106,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifdef __KERNEL__
 struct old_sigaction {
diff --git a/arch/sparc/include/asm/mman.h b/arch/sparc/include/asm/mman.h
index fdfbbf0..988192e 100644
--- a/arch/sparc/include/asm/mman.h
+++ b/arch/sparc/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef __SPARC_MMAN_H__
 #define __SPARC_MMAN_H__
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 /* SunOS'ified... */
 
diff --git a/arch/sparc/include/asm/signal.h b/arch/sparc/include/asm/signal.h
index cba4520..e49b828 100644
--- a/arch/sparc/include/asm/signal.h
+++ b/arch/sparc/include/asm/signal.h
@@ -176,7 +176,7 @@ struct sigstack {
 #define SA_STATIC_ALLOC         0x8000
 #endif
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 struct __new_sigaction {
 	__sighandler_t		sa_handler;
diff --git a/arch/x86/include/asm/mman.h b/arch/x86/include/asm/mman.h
index 90bc410..751af25 100644
--- a/arch/x86/include/asm/mman.h
+++ b/arch/x86/include/asm/mman.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_MMAN_H
 #define _ASM_X86_MMAN_H
 
-#include <asm-generic/mman.h>
+#include <asm-generic/mman-common.h>
 
 #define MAP_32BIT	0x40		/* only give out 32bit addresses */
 
diff --git a/arch/x86/include/asm/signal.h b/arch/x86/include/asm/signal.h
index 7761a5d..598457c 100644
--- a/arch/x86/include/asm/signal.h
+++ b/arch/x86/include/asm/signal.h
@@ -117,7 +117,7 @@ typedef unsigned long sigset_t;
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
-#include <asm-generic/signal.h>
+#include <asm-generic/signal-defs.h>
 
 #ifndef __ASSEMBLY__
 
diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index 4c9932a..460b08d 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -2,9 +2,9 @@ header-y += errno-base.h
 header-y += errno.h
 header-y += fcntl.h
 header-y += ioctl.h
-header-y += mman.h
+header-y += mman-common.h
 header-y += poll.h
-header-y += signal.h
+header-y += signal-defs.h
 header-y += statfs.h
 
 unifdef-y += int-l64.h
diff --git a/include/asm-generic/mman.h b/include/asm-generic/mman-common.h
similarity index 93%
rename from include/asm-generic/mman.h
rename to include/asm-generic/mman-common.h
index 5e3dde2..3b69ad3 100644
--- a/include/asm-generic/mman.h
+++ b/include/asm-generic/mman-common.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_GENERIC_MMAN_H
-#define _ASM_GENERIC_MMAN_H
+#ifndef __ASM_GENERIC_MMAN_COMMON_H
+#define __ASM_GENERIC_MMAN_COMMON_H
 
 /*
  Author: Michael S. Tsirkin <mst@mellanox.co.il>, Mellanox Technologies Ltd.
@@ -38,4 +38,4 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
-#endif
+#endif /* __ASM_GENERIC_MMAN_COMMON_H */
diff --git a/include/asm-generic/signal.h b/include/asm-generic/signal-defs.h
similarity index 85%
rename from include/asm-generic/signal.h
rename to include/asm-generic/signal-defs.h
index dae1d87..00f95df 100644
--- a/include/asm-generic/signal.h
+++ b/include/asm-generic/signal-defs.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_GENERIC_SIGNAL_H
-#define __ASM_GENERIC_SIGNAL_H
+#ifndef __ASM_GENERIC_SIGNAL_DEFS_H
+#define __ASM_GENERIC_SIGNAL_DEFS_H
 
 #include <linux/compiler.h>
 
@@ -25,4 +25,4 @@ typedef __restorefn_t __user *__sigrestore_t;
 #define SIG_ERR	((__force __sighandler_t)-1)	/* error return from signal */
 #endif
 
-#endif /* __ASM_GENERIC_SIGNAL_H */
+#endif /* __ASM_GENERIC_SIGNAL_DEFS_H */
diff --git a/include/asm-generic/termios.h b/include/asm-generic/termios-base.h
similarity index 94%
rename from include/asm-generic/termios.h
rename to include/asm-generic/termios-base.h
index 7d39ecc..0a769fe 100644
--- a/include/asm-generic/termios.h
+++ b/include/asm-generic/termios-base.h
@@ -1,8 +1,8 @@
 /* termios.h: generic termios/termio user copying/translation
  */
 
-#ifndef _ASM_GENERIC_TERMIOS_H
-#define _ASM_GENERIC_TERMIOS_H
+#ifndef _ASM_GENERIC_TERMIOS_BASE_H
+#define _ASM_GENERIC_TERMIOS_BASE_H
 
 #include <asm/uaccess.h>
 
@@ -74,4 +74,4 @@ static inline int kernel_termios_to_user_termio(struct termio __user *termio,
 
 #endif	/* __ARCH_TERMIO_GETPUT */
 
-#endif /* _ASM_GENERIC_TERMIOS_H */
+#endif /* _ASM_GENERIC_TERMIOS_BASE_H */
-- 
1.6.0.4

