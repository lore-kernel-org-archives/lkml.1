Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbXJYOpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbXJYOpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 10:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbXJYOpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 10:45:43 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:41532 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbXJYOpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 10:45:42 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 25 Oct 2007 16:23:32 +0530
Message-Id: <20071025105332.18472.58436.sendpatchset@balbir-laptop>
Subject: [x86 patch] Fix UML init/do_mounts.h build failure
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Fix stat.h to not use __i386__, but use BITS_PER_LONG. The UML architecture
in turn includes this file. This helps resolve one build failure in the
current UML code

Before the fix, the failure was

In file included from init/do_mounts.c:19:
init/do_mounts.h: In function 'bstat':
init/do_mounts.h:25: error: storage size of 'stat' isn't known
init/do_mounts.h:25: warning: unused variable 'stat'
init/do_mounts.h:33: warning: control reaches end of non-void function
make[1]: *** [init/do_mounts.o] Error 1
make: *** [init/do_mounts.o] Error 2


Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/asm-x86/stat.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN init/do_mounts.h~uml-fix-init-domounts init/do_mounts.h
diff -puN include/asm-x86/stat.h~uml-fix-init-domounts include/asm-x86/stat.h
--- 2.6.24-rc1/include/asm-x86/stat.h~uml-fix-init-domounts	2007-10-25 16:23:04.000000000 +0530
+++ 2.6.24-rc1-balbir/include/asm-x86/stat.h	2007-10-25 16:23:04.000000000 +0530
@@ -1,9 +1,11 @@
 #ifndef _ASM_X86_STAT_H
 #define _ASM_X86_STAT_H
 
+#include <asm/types.h>
+
 #define STAT_HAVE_NSEC 1
 
-#ifdef __i386__
+#if BITS_PER_LONG == 32
 struct stat {
 	unsigned long  st_dev;
 	unsigned long  st_ino;
@@ -63,7 +65,7 @@ struct stat64 {
 	unsigned long long	st_ino;
 };
 
-#else /* __i386__ */
+#else /* BITS_PER_LONG == 32 */
 
 struct stat {
 	unsigned long	st_dev;
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
