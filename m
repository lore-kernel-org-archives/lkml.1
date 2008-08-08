Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYHHGxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYHHGxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbYHHGwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:52:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:19239 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065AbYHHGwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:52:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,325,1215414000"; 
   d="scan'208";a="368829739"
Subject: [PATCH -v2 2/8] kexec jump: rename KEXEC_CONTROL_CODE_SIZE to
	KEXEC_CONTROL_PAGE_SIZE
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 14:52:33 +0800
Message-Id: <1218178353.22039.75.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename KEXEC_CONTROL_CODE_SIZE to KEXEC_CONTROL_PAGE_SIZE, because
control page is used for not only code on some platform. For example
in kexec jump, it is used for data and stack too.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/arm/include/asm/kexec.h     |    2 +-
 arch/ia64/include/asm/kexec.h    |    2 +-
 arch/powerpc/include/asm/kexec.h |    2 +-
 arch/s390/include/asm/kexec.h    |    2 +-
 arch/sh/include/asm/kexec.h      |    2 +-
 include/asm-mips/kexec.h         |    2 +-
 include/asm-x86/kexec.h          |    4 ++--
 include/linux/kexec.h            |    4 ++--
 kernel/kexec.c                   |    4 ++--
 9 files changed, 12 insertions(+), 12 deletions(-)

--- a/include/asm-x86/kexec.h
+++ b/include/asm-x86/kexec.h
@@ -63,7 +63,7 @@
 /* Maximum address we can use for the control code buffer */
 # define KEXEC_CONTROL_MEMORY_LIMIT TASK_SIZE
 
-# define KEXEC_CONTROL_CODE_SIZE	4096
+# define KEXEC_CONTROL_PAGE_SIZE	4096
 
 /* The native architecture */
 # define KEXEC_ARCH KEXEC_ARCH_386
@@ -79,7 +79,7 @@
 # define KEXEC_CONTROL_MEMORY_LIMIT     (0xFFFFFFFFFFUL)
 
 /* Allocate one page for the pdp and the second for the code */
-# define KEXEC_CONTROL_CODE_SIZE  (4096UL + 4096UL)
+# define KEXEC_CONTROL_PAGE_SIZE  (4096UL + 4096UL)
 
 /* The native architecture */
 # define KEXEC_ARCH KEXEC_ARCH_X86_64
--- a/arch/sh/include/asm/kexec.h
+++ b/arch/sh/include/asm/kexec.h
@@ -21,7 +21,7 @@
 /* Maximum address we can use for the control code buffer */
 #define KEXEC_CONTROL_MEMORY_LIMIT TASK_SIZE
 
-#define KEXEC_CONTROL_CODE_SIZE	4096
+#define KEXEC_CONTROL_PAGE_SIZE	4096
 
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_SH
--- a/arch/powerpc/include/asm/kexec.h
+++ b/arch/powerpc/include/asm/kexec.h
@@ -22,7 +22,7 @@
 #define KEXEC_CONTROL_MEMORY_LIMIT TASK_SIZE
 #endif
 
-#define KEXEC_CONTROL_CODE_SIZE 4096
+#define KEXEC_CONTROL_PAGE_SIZE 4096
 
 /* The native architecture */
 #ifdef __powerpc64__
--- a/arch/ia64/include/asm/kexec.h
+++ b/arch/ia64/include/asm/kexec.h
@@ -9,7 +9,7 @@
 /* Maximum address we can use for the control code buffer */
 #define KEXEC_CONTROL_MEMORY_LIMIT TASK_SIZE
 
-#define KEXEC_CONTROL_CODE_SIZE (8192 + 8192 + 4096)
+#define KEXEC_CONTROL_PAGE_SIZE (8192 + 8192 + 4096)
 
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_IA_64
--- a/arch/s390/include/asm/kexec.h
+++ b/arch/s390/include/asm/kexec.h
@@ -31,7 +31,7 @@
 #define KEXEC_CONTROL_MEMORY_LIMIT (1UL<<31)
 
 /* Allocate one page for the pdp and the second for the code */
-#define KEXEC_CONTROL_CODE_SIZE 4096
+#define KEXEC_CONTROL_PAGE_SIZE 4096
 
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_S390
--- a/arch/arm/include/asm/kexec.h
+++ b/arch/arm/include/asm/kexec.h
@@ -10,7 +10,7 @@
 /* Maximum address we can use for the control code buffer */
 #define KEXEC_CONTROL_MEMORY_LIMIT (-1UL)
 
-#define KEXEC_CONTROL_CODE_SIZE	4096
+#define KEXEC_CONTROL_PAGE_SIZE	4096
 
 #define KEXEC_ARCH KEXEC_ARCH_ARM
 
--- a/include/asm-mips/kexec.h
+++ b/include/asm-mips/kexec.h
@@ -16,7 +16,7 @@
  /* Maximum address we can use for the control code buffer */
 #define KEXEC_CONTROL_MEMORY_LIMIT (0x20000000)
 
-#define KEXEC_CONTROL_CODE_SIZE 4096
+#define KEXEC_CONTROL_PAGE_SIZE 4096
 
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_MIPS
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -242,7 +242,7 @@ static int kimage_normal_alloc(struct ki
 	 */
 	result = -ENOMEM;
 	image->control_code_page = kimage_alloc_control_pages(image,
-					   get_order(KEXEC_CONTROL_CODE_SIZE));
+					   get_order(KEXEC_CONTROL_PAGE_SIZE));
 	if (!image->control_code_page) {
 		printk(KERN_ERR "Could not allocate control_code_buffer\n");
 		goto out;
@@ -317,7 +317,7 @@ static int kimage_crash_alloc(struct kim
 	 */
 	result = -ENOMEM;
 	image->control_code_page = kimage_alloc_control_pages(image,
-					   get_order(KEXEC_CONTROL_CODE_SIZE));
+					   get_order(KEXEC_CONTROL_PAGE_SIZE));
 	if (!image->control_code_page) {
 		printk(KERN_ERR "Could not allocate control_code_buffer\n");
 		goto out;
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -25,8 +25,8 @@
 #error KEXEC_CONTROL_MEMORY_LIMIT not defined
 #endif
 
-#ifndef KEXEC_CONTROL_CODE_SIZE
-#error KEXEC_CONTROL_CODE_SIZE not defined
+#ifndef KEXEC_CONTROL_PAGE_SIZE
+#error KEXEC_CONTROL_PAGE_SIZE not defined
 #endif
 
 #ifndef KEXEC_ARCH


