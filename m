Return-Path: <linux-kernel-owner+w=401wt.eu-S1761094AbXHBVFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761094AbXHBVFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760816AbXHBVE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:04:59 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:43960 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbXHBVE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:04:58 -0400
Date: Thu, 2 Aug 2007 17:04:36 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/6] UML - Stop using libc asm/page.h
Message-ID: <20070802210436.GA11169@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove includes of asm/page.h from libc code.  This header seems to be
disappearing, and UML doesn't make much use of it anyway.

The one use, PAGE_SHIFT in stub.h, is handled by copying the constant
from the kernel side of the house in common_offsets.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/common-offsets.h   |    1 +
 arch/um/include/sysdep-i386/stub.h |    3 +--
 arch/um/os-Linux/main.c            |    1 -
 arch/um/os-Linux/skas/mem.c        |    1 -
 arch/um/os-Linux/start_up.c        |    1 -
 arch/um/os-Linux/tt.c              |    1 -
 6 files changed, 2 insertions(+), 6 deletions(-)

Index: linux-2.6.21-mm/arch/um/include/sysdep-i386/stub.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/sysdep-i386/stub.h	2007-08-02 16:43:17.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/sysdep-i386/stub.h	2007-08-02 16:43:20.000000000 -0400
@@ -9,7 +9,6 @@
 #include <sys/mman.h>
 #include <asm/ptrace.h>
 #include <asm/unistd.h>
-#include <asm/page.h>
 #include "stub-data.h"
 #include "kern_constants.h"
 #include "uml-config.h"
@@ -19,7 +18,7 @@ extern void stub_clone_handler(void);
 
 #define STUB_SYSCALL_RET EAX
 #define STUB_MMAP_NR __NR_mmap2
-#define MMAP_OFFSET(o) ((o) >> PAGE_SHIFT)
+#define MMAP_OFFSET(o) ((o) >> UM_KERN_PAGE_SHIFT)
 
 static inline long stub_syscall0(long syscall)
 {
Index: linux-2.6.21-mm/arch/um/os-Linux/main.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/main.c	2007-08-02 16:43:17.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/main.c	2007-08-02 16:43:20.000000000 -0400
@@ -12,7 +12,6 @@
 #include <sys/resource.h>
 #include <sys/mman.h>
 #include <sys/user.h>
-#include <asm/page.h>
 #include "kern_util.h"
 #include "as-layout.h"
 #include "mem_user.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/skas/mem.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/skas/mem.c	2007-08-02 16:43:17.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/skas/mem.c	2007-08-02 16:43:20.000000000 -0400
@@ -9,7 +9,6 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
-#include <asm/page.h>
 #include <asm/unistd.h>
 #include "mem_user.h"
 #include "mem.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/start_up.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/start_up.c	2007-08-02 16:43:17.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/start_up.c	2007-08-02 16:43:20.000000000 -0400
@@ -19,7 +19,6 @@
 #include <sys/mman.h>
 #include <sys/resource.h>
 #include <asm/unistd.h>
-#include <asm/page.h>
 #include <sys/types.h>
 #include "kern_util.h"
 #include "user.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/tt.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/tt.c	2007-08-02 16:43:17.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/tt.c	2007-08-02 16:43:20.000000000 -0400
@@ -17,7 +17,6 @@
 #include <sys/mman.h>
 #include <asm/ptrace.h>
 #include <asm/unistd.h>
-#include <asm/page.h>
 #include "kern_util.h"
 #include "user.h"
 #include "signal_kern.h"
Index: linux-2.6.21-mm/arch/um/include/common-offsets.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/common-offsets.h	2007-08-02 16:43:17.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/common-offsets.h	2007-08-02 16:43:20.000000000 -0400
@@ -10,6 +10,7 @@ OFFSET(HOST_TASK_PID, task_struct, pid);
 
 DEFINE(UM_KERN_PAGE_SIZE, PAGE_SIZE);
 DEFINE(UM_KERN_PAGE_MASK, PAGE_MASK);
+DEFINE(UM_KERN_PAGE_SHIFT, PAGE_SHIFT);
 DEFINE(UM_NSEC_PER_SEC, NSEC_PER_SEC);
 
 DEFINE_STR(UM_KERN_EMERG, KERN_EMERG);
