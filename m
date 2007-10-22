Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbXJVS6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbXJVS6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbXJVS6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:58:25 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38511 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbXJVS6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:58:24 -0400
Date: Mon, 22 Oct 2007 20:59:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] 3 kbuild fixes
Message-ID: <20071022185956.GA15304@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A few kbuild related fixes.
Please pull from:

	ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git


Full diff below.
I had originally postponed any pull until after -rc1 but the module_install
thing will annoy too much.

	Sam
 

 Documentation/kbuild/makefiles.txt |   10 +++++-----
 Makefile                           |    7 ++++---
 2 files changed, 9 insertions(+), 8 deletions(-)


Geert Uytterhoeven (1):
      kbuild: cc-cross-prefix spelling

Sam Ravnborg (2):
      kbuild: fix modules_install after a 'make vmlinux'
      kbuild: allow depmod in cross builds again



diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 6166e2d..7a77533 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -519,17 +519,17 @@ more details, with real examples.
 	to the user why it stops.
 
     cc-cross-prefix
-	cc-cross-prefix is used to check if there exist a $(CC) in path with
+	cc-cross-prefix is used to check if there exists a $(CC) in path with
 	one of the listed prefixes. The first prefix where there exist a
 	prefix$(CC) in the PATH is returned - and if no prefix$(CC) is found
 	then nothing is returned.
 	Additional prefixes are separated by a single space in the
 	call of cc-cross-prefix.
-	This functionality is usefull for architecture Makefile that try
-	to set CROSS_COMPILE to well know values but may have several
+	This functionality is useful for architecture Makefiles that try
+	to set CROSS_COMPILE to well-known values but may have several
 	values to select between.
-	It is recommended only to try to set CROSS_COMPILE is it is a cross
-	build (host arch is different from target arch). And is CROSS_COMPILE
+	It is recommended only to try to set CROSS_COMPILE if it is a cross
+	build (host arch is different from target arch). And if CROSS_COMPILE
 	is already set then leave it with the old value.
 
 	Example:
diff --git a/Makefile b/Makefile
index 50bb50d..264f37b 100644
--- a/Makefile
+++ b/Makefile
@@ -1505,15 +1505,16 @@ quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files))
 # and we build for the host arch
 quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
       cmd_depmod = \
-	if [ -r System.map -a -x $(DEPMOD) -a "$(SUBARCH)" = "$(ARCH)" ]; then \
+	if [ -r System.map -a -x $(DEPMOD) ]; then                              \
 		$(DEPMOD) -ae -F System.map                                     \
 		$(if $(strip $(INSTALL_MOD_PATH)), -b $(INSTALL_MOD_PATH) -r)   \
 		$(KERNELRELEASE);                                               \
 	fi
 
 # Create temporary dir for module support files
-cmd_crmodverdir = $(Q)mkdir -p $(MODVERDIR); rm -f $(MODVERDIR)/*
-
+# clean it up only when building all modules
+cmd_crmodverdir = $(Q)mkdir -p $(MODVERDIR) \
+                  $(if $(KBUILD_MODULES),; rm -f $(MODVERDIR)/*)
 
 a_flags = -Wp,-MD,$(depfile) $(KBUILD_AFLAGS) $(AFLAGS_KERNEL) \
 	  $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
