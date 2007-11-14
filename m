Return-Path: <linux-kernel-owner+w=401wt.eu-S1763590AbXKNS7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763590AbXKNS7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:59:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762916AbXKNS62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:58:28 -0500
Received: from mx1.suse.de ([195.135.220.2]:60320 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762876AbXKNS61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:58:27 -0500
Subject: patch uml-stop-using-libc-asm-user.h.patch queued to -stable tree
To: jdike@addtoit.com, akpm@linux-foundation.org, gregkh@suse.de,
       jdike@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       user-mode-linux-devel@lists.sourceforge.net
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Wed, 14 Nov 2007 10:58:16 -0800
In-Reply-To: <20071101195326.GA8877@c2.user-mode-linux.org>
Message-Id: <20071114185824.DA3A514540D0@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

     Subject: UML - stop using libc asm/user.h

to the 2.6.23-stable tree.  Its filename is

     uml-stop-using-libc-asm-user.h.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Thu Nov  1 12:54:17 2007
From: Jeff Dike <jdike@addtoit.com>
Date: Thu, 1 Nov 2007 15:53:26 -0400
Subject: UML - stop using libc asm/user.h
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Message-ID: <20071101195326.GA8877@c2.user-mode-linux.org>
Content-Disposition: inline

From: Jeff Dike <jdike@addtoit.com>

commit 189872f968def833727b6bfef83ebd7440c538e6 in mainline.

uml: don't use glibc asm/user.h

Stop including asm/user.h from libc - it seems to be disappearing from
distros.  It's replaced with sys/user.h which defines user_fpregs_struct and
user_fpxregs_struct instead of user_i387_struct and struct user_fxsr_struct on
i386.

As a bonus, on x86_64, I get to dump some stupid typedefs which were needed in
order to get asm/user.h to compile.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/sys-i386/user-offsets.c   |    6 +++---
 arch/um/sys-x86_64/user-offsets.c |    9 +--------
 2 files changed, 4 insertions(+), 11 deletions(-)

--- a/arch/um/sys-i386/user-offsets.c
+++ b/arch/um/sys-i386/user-offsets.c
@@ -2,9 +2,9 @@
 #include <stddef.h>
 #include <signal.h>
 #include <sys/poll.h>
+#include <sys/user.h>
 #include <sys/mman.h>
 #include <asm/ptrace.h>
-#include <asm/user.h>
 
 #define DEFINE(sym, val) \
 	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -48,8 +48,8 @@ void foo(void)
 	OFFSET(HOST_SC_FP_ST, _fpstate, _st);
 	OFFSET(HOST_SC_FXSR_ENV, _fpstate, _fxsr_env);
 
-	DEFINE_LONGS(HOST_FP_SIZE, sizeof(struct user_i387_struct));
-	DEFINE_LONGS(HOST_XFP_SIZE, sizeof(struct user_fxsr_struct));
+	DEFINE_LONGS(HOST_FP_SIZE, sizeof(struct user_fpregs_struct));
+	DEFINE_LONGS(HOST_XFP_SIZE, sizeof(struct user_fpxregs_struct));
 
 	DEFINE(HOST_IP, EIP);
 	DEFINE(HOST_SP, UESP);
--- a/arch/um/sys-x86_64/user-offsets.c
+++ b/arch/um/sys-x86_64/user-offsets.c
@@ -3,17 +3,10 @@
 #include <signal.h>
 #include <sys/poll.h>
 #include <sys/mman.h>
+#include <sys/user.h>
 #define __FRAME_OFFSETS
 #include <asm/ptrace.h>
 #include <asm/types.h>
-/* For some reason, x86_64 defines u64 and u32 only in <pci/types.h>, which I
- * refuse to include here, even though they're used throughout the headers.
- * These are used in asm/user.h, and that include can't be avoided because of
- * the sizeof(struct user_regs_struct) below.
- */
-typedef __u64 u64;
-typedef __u32 u32;
-#include <asm/user.h>
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))


Patches currently in stable-queue which might be from jdike@addtoit.com are

queue-2.6.23/uml-stop-using-libc-asm-page.h.patch
queue-2.6.23/uml-fix-kernel-vs-libc-symbols-clash.patch
queue-2.6.23/uml-stop-using-libc-asm-user.h.patch
