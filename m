Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbZKTRLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbZKTRLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbZKTRLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:11:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301AbZKTRLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:11:02 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/2] [BUGFIX] x86: Fix insn decoder test typos
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Randy Dunlap <rdunlap@xenotime.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Date: Fri, 20 Nov 2009 12:13:08 -0500
Message-ID: <20091120171307.6715.66099.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091120171301.6715.24229.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091120171301.6715.24229.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix postest_verbose to posttest_verbose, and add posttest_64bit option
for CONFIG_64BIT != y, since old command just passed '-' instead
of '-n' when CONFIG_64BIT is not set.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
