Return-Path: <linux-kernel-owner+w=401wt.eu-S933408AbXJPK2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbXJPK2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760671AbXJPK2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:28:09 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:53809 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759454AbXJPK2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:28:08 -0400
Date: Tue, 16 Oct 2007 00:28:06 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] kbuild: fix typo SRCARCH in find_sources
To: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200710160028.06468.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] kbuild: fix typo SRCARCH in find_sources

otherwise get the two copy file list in SRCARCH

for cscope:
C symbol: start_kernel

  File           Function            Line
0 proto.h        <global>              11 extern void start_kernel(void );
1 start_kernel.h <global>              10 extern asmlinkage void __init start_kernel(void );
2 head32.c       i386_start_kernel     37 start_kernel();
3 head32.c       i386_start_kernel     37 start_kernel();
4 head64.c       x86_64_start_kernel   85 start_kernel();
5 head64.c       x86_64_start_kernel   85 start_kernel();
6 head_32.S      options              199 cmpb $0,%cl #the first CPU calls start_kernel
7 head_32.S      options              199 cmpb $0,%cl #the first CPU calls start_kernel
8 enlighten.c    xen_start_kernel    1145 start_kernel();
9 enlighten.c    xen_start_kernel    1145 start_kernel();
a lguest.c       lguest_init         1095 start_kernel();
b main.c         start_kernel         513 asmlinkage void __init start_kernel(void )

after the patch:
C symbol: start_kernel

  File           Function            Line
0 proto.h        <global>              11 extern void start_kernel(void );
1 start_kernel.h <global>              10 extern asmlinkage void __init start_kernel(void );
2 head32.c       i386_start_kernel     37 start_kernel();
3 head64.c       x86_64_start_kernel   85 start_kernel();
4 head_32.S      options              199 cmpb $0,%cl #the first CPU calls start_kernel
5 enlighten.c    xen_start_kernel    1145 start_kernel();
6 lguest.c       lguest_init         1095 start_kernel();
7 main.c         start_kernel         513 asmlinkage void __init start_kernel(void )

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/Makefile b/Makefile
index 1274084..7ee4c04 100644
--- a/Makefile
+++ b/Makefile
@@ -1309,8 +1309,8 @@ ALLSOURCE_ARCHS := $(ARCH) $(SRCARCH)
 endif
 
 define find-sources
-        ( for ARCH in $(ALLSOURCE_ARCHS) ; do \
-	       find $(__srctree)arch/$${SRCARCH} $(RCS_FIND_IGNORE) \
+        ( for arch in $(ALLSOURCE_ARCHS) ; do \
+	       find $(__srctree)arch/$${arch} $(RCS_FIND_IGNORE) \
 	            -name $1 -print; \
 	  done ; \
 	  find $(__srctree)security/selinux/include $(RCS_FIND_IGNORE) \
@@ -1318,8 +1318,8 @@ define find-sources
 	  find $(__srctree)include $(RCS_FIND_IGNORE) \
 	       \( -name config -o -name 'asm-*' \) -prune \
 	       -o -name $1 -print; \
-	  for ARCH in $(ALLINCLUDE_ARCHS) ; do \
-	       find $(__srctree)include/asm-$${SRCARCH} $(RCS_FIND_IGNORE) \
+	  for arch in $(ALLINCLUDE_ARCHS) ; do \
+	       find $(__srctree)include/asm-$${arch} $(RCS_FIND_IGNORE) \
 	            -name $1 -print; \
 	  done ; \
 	  find $(__srctree)include/asm-generic $(RCS_FIND_IGNORE) \
