Return-Path: <linux-kernel-owner+w=401wt.eu-S936640AbXGMSRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936640AbXGMSRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934944AbXGMSRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:17:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:53633 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422AbXGMSQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:16:58 -0400
Date: Fri, 13 Jul 2007 20:16:34 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: kai@germaschewski.name, Tony Breeds <tony@bakeyournoodle.com>
Subject: [PATCH] mkmakefile: include ARCH on O= builds
Message-ID: <Pine.LNX.4.58.0707132012220.3037@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+lw9iZI5d1fPkNz5WaFd5daTBhVM1E/SYVkUZ
 jew1/Upsn6uw5UT2RuXeUMrumhobAJhOnsQOXWnMYpUrDU5llZ
 /8s9S9wFwuIQA9oIbVXNA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If you build using O=builddir ARCH=bar, you'll currently need to supply
ARCH= on builds from the builddir, too. With this patch, the generated
Makefile will do that instead.

make ARCH= will still override the Makefile default, allowing existing 
scripts to work correctly.

Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
---
Changed from previous submission: Documentation is now as intended

diff -X dontdiff -pruN linux-2.6.22/Makefile linux-2.6.22.changed/Makefile
--- linux-2.6.22/Makefile	2007-07-11 23:15:33.000000000 +0200
+++ linux-2.6.22.changed/Makefile	2007-07-12 02:59:39.000000000 +0200
@@ -357,7 +357,7 @@ PHONY += outputmakefile
 outputmakefile:
 ifneq ($(KBUILD_SRC),)
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkmakefile \
-	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
+	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL) $(ARCH)
 endif
 
 # To make sure we do not include .config for any of the *config targets
diff -X dontdiff -pruN linux-2.6.22/scripts/mkmakefile linux-2.6.22.changed/scripts/mkmakefile
--- linux-2.6.22/scripts/mkmakefile	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6.22.changed/scripts/mkmakefile	2007-07-12 03:03:49.000000000 +0200
@@ -8,6 +8,7 @@
 # $2 - Output directory
 # $3 - version
 # $4 - patchlevel
+# $5 - arch
 
 
 test ! -r $2/Makefile -o -O $2/Makefile || exit 0
@@ -21,16 +22,17 @@ PATCHLEVEL = $4
 
 KERNELSRC    := $1
 KERNELOUTPUT := $2
+ARCH         := $5
 
 MAKEFLAGS += --no-print-directory
 
 .PHONY: all \$(MAKECMDGOALS)
 
 all:
-	\$(MAKE) -C \$(KERNELSRC) O=\$(KERNELOUTPUT)
+	\$(MAKE) -C \$(KERNELSRC) O=\$(KERNELOUTPUT) ARCH=\$(ARCH)
 
 Makefile:;
 
 \$(filter-out all Makefile,\$(MAKECMDGOALS)) %/:
-	\$(MAKE) -C \$(KERNELSRC) O=\$(KERNELOUTPUT) \$@
+	\$(MAKE) -C \$(KERNELSRC) O=\$(KERNELOUTPUT) ARCH=\$(ARCH) \$@
 EOF
-- 
The tough part about being an officer is that the troops don't know what
they want, but they know for certain what they DON'T want.
