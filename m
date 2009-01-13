Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbZAMMJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbZAMMJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZAMMJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:09:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:9199 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbZAMMJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:09:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=IkLAtdlBx0VNCc8YkAcpdwBOaGsRKok2uXe95gp4ZTxDMGPMP+oo1G66TpsCz3se42
         Bj9HTu8XGjQ+NaIwm0XqyL3zYMGd5a3TzpKI0ignod9+cW42ZdNwXxjNlSealh94EWDW
         qEYRu7YUXqYL9a6iycyY/iKbihey4UN+frng8=
Date: Tue, 13 Jan 2009 15:09:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Subject: [PATCH -tip] x86: headers - include linux/types.h instead of
	asm/types.h
Message-ID: <20090113120905.GB7682@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

'make headers_check' warns that linux/types.h is
preferred over asm/types.h. So be it.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
CC: Sam Ravnborg <sam@ravnborg.org>
CC: Harvey Harrison <harvey.harrison@gmail.com>
---

 arch/x86/include/asm/e820.h       |    2 ++
 arch/x86/include/asm/kvm.h        |    2 +-
 arch/x86/include/asm/mce.h        |    2 +-
 arch/x86/include/asm/mtrr.h       |    1 +
 arch/x86/include/asm/ptrace-abi.h |    2 +-
 arch/x86/include/asm/sigcontext.h |    2 +-
 arch/x86/include/asm/swab.h       |    2 +-
 7 files changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/e820.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/e820.h
+++ linux-2.6.git/arch/x86/include/asm/e820.h
@@ -1,5 +1,6 @@
 #ifndef _ASM_X86_E820_H
 #define _ASM_X86_E820_H
+
 #define E820MAP	0x2d0		/* our map */
 #define E820MAX	128		/* number of entries in E820MAP */
 
@@ -49,6 +50,7 @@
 #define E820_RESERVED_KERN        128
 
 #ifndef __ASSEMBLY__
+#include <linux/types.h>
 struct e820entry {
 	__u64 addr;	/* start of memory segment */
 	__u64 size;	/* size of memory segment */
Index: linux-2.6.git/arch/x86/include/asm/kvm.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/kvm.h
+++ linux-2.6.git/arch/x86/include/asm/kvm.h
@@ -6,7 +6,7 @@
  *
  */
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/ioctl.h>
 
 /* Architectural interrupt line count. */
Index: linux-2.6.git/arch/x86/include/asm/mce.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/mce.h
+++ linux-2.6.git/arch/x86/include/asm/mce.h
@@ -4,7 +4,7 @@
 #ifdef __x86_64__
 
 #include <asm/ioctls.h>
-#include <asm/types.h>
+#include <linux/types.h>
 
 /*
  * Machine Check support for x86
Index: linux-2.6.git/arch/x86/include/asm/mtrr.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/mtrr.h
+++ linux-2.6.git/arch/x86/include/asm/mtrr.h
@@ -23,6 +23,7 @@
 #ifndef _ASM_X86_MTRR_H
 #define _ASM_X86_MTRR_H
 
+#include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/errno.h>
 
Index: linux-2.6.git/arch/x86/include/asm/ptrace-abi.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/ptrace-abi.h
+++ linux-2.6.git/arch/x86/include/asm/ptrace-abi.h
@@ -83,7 +83,7 @@
 #ifdef CONFIG_X86_PTRACE_BTS
 
 #ifndef __ASSEMBLY__
-#include <asm/types.h>
+#include <linux/types.h>
 
 /* configuration/status structure used in PTRACE_BTS_CONFIG and
    PTRACE_BTS_STATUS commands.
Index: linux-2.6.git/arch/x86/include/asm/sigcontext.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/sigcontext.h
+++ linux-2.6.git/arch/x86/include/asm/sigcontext.h
@@ -2,7 +2,7 @@
 #define _ASM_X86_SIGCONTEXT_H
 
 #include <linux/compiler.h>
-#include <asm/types.h>
+#include <linux/types.h>
 
 #define FP_XSTATE_MAGIC1	0x46505853U
 #define FP_XSTATE_MAGIC2	0x46505845U
Index: linux-2.6.git/arch/x86/include/asm/swab.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/swab.h
+++ linux-2.6.git/arch/x86/include/asm/swab.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_SWAB_H
 #define _ASM_X86_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/compiler.h>
 
 static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
