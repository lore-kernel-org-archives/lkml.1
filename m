Return-Path: <linux-kernel-owner+w=401wt.eu-S1751378AbZKUHK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbZKUHK2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 02:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbZKUHK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 02:10:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:33107 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbZKUHK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 02:10:26 -0500
Date: Sat, 21 Nov 2009 07:09:48 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkenisto@us.ibm.com, rdunlap@xenotime.net, tglx@linutronix.de,
       sfr@canb.auug.org.au, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkenisto@us.ibm.com, sfr@canb.auug.org.au, tglx@linutronix.de,
       rdunlap@xenotime.net, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20091120171307.6715.66099.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091120171307.6715.66099.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] x86: Fix insn decoder test typos
Message-ID: <tip-80509e27e40d7554e576405ed9f5b7966c567112@git.kernel.org>
Git-Commit-ID: 80509e27e40d7554e576405ed9f5b7966c567112
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80509e27e40d7554e576405ed9f5b7966c567112
Gitweb:     http://git.kernel.org/tip/80509e27e40d7554e576405ed9f5b7966c567112
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 20 Nov 2009 12:13:08 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Nov 2009 22:59:36 -0800

x86: Fix insn decoder test typos

Fix postest_verbose to posttest_verbose, and add posttest_64bit option
for CONFIG_64BIT != y, since old command just passed '-' instead
of '-n' when CONFIG_64BIT is not set.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jim Keniston <jkenisto@us.ibm.com>
LKML-Reference: <20091120171307.6715.66099.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/tools/Makefile |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index 4688f90..c80b079 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -1,13 +1,19 @@
 PHONY += posttest
 
 ifeq ($(KBUILD_VERBOSE),1)
-  postest_verbose = -v
+  posttest_verbose = -v
 else
-  postest_verbose =
+  posttest_verbose =
+endif
+
+ifeq ($(CONFIG_64BIT),y)
+  posttest_64bit = -y
+else
+  posttest_64bit = -n
 endif
 
 quiet_cmd_posttest = TEST    $@
-      cmd_posttest = $(OBJDUMP) -d -j .text $(objtree)/vmlinux | awk -f $(srctree)/arch/x86/tools/distill.awk | $(obj)/test_get_len -$(CONFIG_64BIT) $(posttest_verbose)
+      cmd_posttest = $(OBJDUMP) -d -j .text $(objtree)/vmlinux | $(AWK) -f $(srctree)/arch/x86/tools/distill.awk | $(obj)/test_get_len $(posttest_64bit) $(posttest_verbose)
 
 posttest: $(obj)/test_get_len vmlinux
 	$(call cmd,posttest)
