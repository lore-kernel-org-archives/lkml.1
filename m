Return-Path: <linux-kernel-owner+w=401wt.eu-S933777AbXGLBk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777AbXGLBk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760353AbXGLBkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 21:40:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58708 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758055AbXGLBkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 21:40:18 -0400
Date: Thu, 12 Jul 2007 03:40:04 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kai@germaschewski.name
Subject: [PATCH] mkmakefile: include ARCH on O= builds
Message-ID: <Pine.LNX.4.58.0707120331530.28774@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+MekxwJ5iHTBw0RJKcILJTsFiwrtuuddBMjK2
 v+ptXtK2NBYZjav8gQ6EeNai9Y2CVlUSYtFtXw4Zsh7ODuhqul
 9Yq8incAmRZakDzslE3vg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If you build using O=builddir ARCH=bar, you'll currently need to supply
ARCH= on builds from the builddir, too. With this patch, the generated
Makefile will do that instead.

make ARCH= will still override the Makefile default, allowing existing 
scripts to work correctly.

Signed-Off-By: Bodo Eggert <7eggert@gmx.de>

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
+# $5 - patchlevel
 
 
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
