Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbZJXBEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbZJXBEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZJXBEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:04:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:51722 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbZJXBEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:44 -0400
Date: Sat, 24 Oct 2009 01:03:58 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkenisto@us.ibm.com, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkenisto@us.ibm.com, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
In-Reply-To: <20091020165531.4145.21872.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091020165531.4145.21872.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] x86, instruction decoder: Fix test_get_len build rules
Message-ID: <tip-9bf4e7fba8006d19846fec877b6da0616b2772de@git.kernel.org>
Git-Commit-ID: 9bf4e7fba8006d19846fec877b6da0616b2772de
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9bf4e7fba8006d19846fec877b6da0616b2772de
Gitweb:     http://git.kernel.org/tip/9bf4e7fba8006d19846fec877b6da0616b2772de
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 21 Oct 2009 14:39:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Oct 2009 14:42:56 +0200

x86, instruction decoder: Fix test_get_len build rules

Add the kernel source include file as well to the include files
search path, to fix this build bug:

 In file included from arch/x86/tools/test_get_len.c:28:
   arch/x86/lib/insn.c:21:26: error: linux/string.h: No such file or directory

Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap<systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091020165531.4145.21872.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/tools/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index 1bd006c..5e295d9 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -8,8 +8,8 @@ posttest: $(obj)/test_get_len vmlinux
 hostprogs-y	:= test_get_len
 
 # -I needed for generated C source and C source which in the kernel tree.
-HOSTCFLAGS_test_get_len.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include/ -I$(srctree)/arch/x86/lib/
+HOSTCFLAGS_test_get_len.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include/ -I$(srctree)/arch/x86/lib/ -I$(srctree)/include/
 
-# Dependancies are also needed.
+# Dependencies are also needed.
 $(obj)/test_get_len.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
 
