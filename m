Return-Path: <linux-kernel-owner+w=401wt.eu-S1759279AbXKATyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbXKATyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 15:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbXKATxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 15:53:53 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55241 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbXKATxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 15:53:50 -0400
Date: Thu, 1 Nov 2007 15:53:25 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/4] UML - Stop using libc asm/page.h
Message-ID: <20071101195325.GA8871@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit cd56e0945db8a5cd3176dcff2319f9e0c96bcb50
Author: Jeff Dike <jdike@addtoit.com>
Date:   Tue Oct 16 01:26:44 2007 -0700

    uml: stop using libc asm/page.h
    
    Remove includes of asm/page.h from libc code.  This header seems to be
    disappearing, and UML doesn't make much use of it anyway.
    
    The one use, PAGE_SHIFT in stub.h, is handled by copying the constant from the
    kernel side of the house in common_offsets.h.
    
    [ jdike - added arch/um/kernel/skas/clone.c for -stable ]
    
    Signed-off-by: Jeff Dike <jdike@linux.intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/um/include/common-offsets.h   |    1 +
 arch/um/include/sysdep-i386/stub.h |    3 +--
 arch/um/kernel/skas/clone.c        |    1 -
 arch/um/os-Linux/main.c            |    1 -
 arch/um/os-Linux/skas/mem.c        |    1 -
 arch/um/os-Linux/start_up.c        |    1 -
 arch/um/os-Linux/tt.c              |    1 -
 7 files changed, 2 insertions(+), 7 deletions(-)
diff --git a/arch/um/include/common-offsets.h b/arch/um/include/common-offsets.h
index 6eee343..2378ff4 100644
--- a/arch/um/include/common-offsets.h
+++ b/arch/um/include/common-offsets.h
@@ -10,6 +10,7 @@ OFFSET(HOST_TASK_PID, task_struct, pid);
 
 DEFINE(UM_KERN_PAGE_SIZE, PAGE_SIZE);
 DEFINE(UM_KERN_PAGE_MASK, PAGE_MASK);
+DEFINE(UM_KERN_PAGE_SHIFT, PAGE_SHIFT);
 DEFINE(UM_NSEC_PER_SEC, NSEC_PER_SEC);
 
 DEFINE_STR(UM_KERN_EMERG, KERN_EMERG);
diff --git a/arch/um/include/sysdep-i386/stub.h b/arch/um/include/sysdep-i386/stub.h
index 4fffae7..19c85f3 100644
--- a/arch/um/include/sysdep-i386/stub.h
+++ b/arch/um/include/sysdep-i386/stub.h
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
diff --git a/arch/um/kernel/skas/clone.c b/arch/um/kernel/skas/clone.c
index 47b812b..885a125 100644
--- a/arch/um/kernel/skas/clone.c
+++ b/arch/um/kernel/skas/clone.c
@@ -3,7 +3,6 @@
 #include <sys/mman.h>
 #include <sys/time.h>
 #include <asm/unistd.h>
-#include <asm/page.h>
 #include "ptrace_user.h"
 #include "skas.h"
 #include "stub-data.h"
diff --git a/arch/um/os-Linux/main.c b/arch/um/os-Linux/main.c
index e85f499..919c25b 100644
--- a/arch/um/os-Linux/main.c
+++ b/arch/um/os-Linux/main.c
@@ -12,7 +12,6 @@
 #include <sys/resource.h>
 #include <sys/mman.h>
 #include <sys/user.h>
-#include <asm/page.h>
 #include "kern_util.h"
 #include "as-layout.h"
 #include "mem_user.h"
diff --git a/arch/um/os-Linux/skas/mem.c b/arch/um/os-Linux/skas/mem.c
index 0f7df4e..9fbf210 100644
--- a/arch/um/os-Linux/skas/mem.c
+++ b/arch/um/os-Linux/skas/mem.c
@@ -9,7 +9,6 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
-#include <asm/page.h>
 #include <asm/unistd.h>
 #include "mem_user.h"
 #include "mem.h"
diff --git a/arch/um/os-Linux/start_up.c b/arch/um/os-Linux/start_up.c
index 46f6139..f4f2981 100644
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -19,7 +19,6 @@
 #include <sys/mman.h>
 #include <sys/resource.h>
 #include <asm/unistd.h>
-#include <asm/page.h>
 #include <sys/types.h>
 #include "kern_util.h"
 #include "user.h"
diff --git a/arch/um/os-Linux/tt.c b/arch/um/os-Linux/tt.c
index bcf9359..5dc113d 100644
--- a/arch/um/os-Linux/tt.c
+++ b/arch/um/os-Linux/tt.c
@@ -17,7 +17,6 @@
 #include <sys/mman.h>
 #include <asm/ptrace.h>
 #include <asm/unistd.h>
-#include <asm/page.h>
 #include "kern_util.h"
 #include "user.h"
 #include "signal_kern.h"
