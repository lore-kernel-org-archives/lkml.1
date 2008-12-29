Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbYL2Nw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbYL2Nw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbYL2Nvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:51:53 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:43007 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbYL2Nvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:51:49 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 13/13] kbuild: document environment variables
Date: Mon, 29 Dec 2008 14:53:23 +0100
Message-Id: <1230558803-7168-13-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081229134402.GA7069@uranus.ravnborg.org>
References: <20081229134402.GA7069@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kbuild.txt to Documentation/kbuild
More stuff can be added later - at least we have
som of the varous environment variables documented now.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/kbuild/00-INDEX   |    8 ++-
 Documentation/kbuild/kbuild.txt |  126 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 131 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/kbuild/kbuild.txt

diff --git a/Documentation/kbuild/00-INDEX b/Documentation/kbuild/00-INDEX
index 54a118a..e8d2b6d 100644
--- a/Documentation/kbuild/00-INDEX
+++ b/Documentation/kbuild/00-INDEX
@@ -1,10 +1,12 @@
 00-INDEX
-    	- this file: info on the kernel build process
+	- this file: info on the kernel build process
+kbuild.txt
+	- developer information on kbuild
+kconfig.txt
+	- usage help for make *config
 kconfig-language.txt
 	- specification of Config Language, the language in Kconfig files
 makefiles.txt
 	- developer information for linux kernel makefiles
-kconfig.txt
-	- usage help for make *config
 modules.txt
 	- how to build modules and to install them
diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
new file mode 100644
index 0000000..5177184
--- /dev/null
+++ b/Documentation/kbuild/kbuild.txt
@@ -0,0 +1,126 @@
+Environment variables
+
+KCPPFLAGS
+--------------------------------------------------
+Additional options to pass when preprocessing. The preprocessing options
+will be used in all cases where kbuild do preprocessing including
+building C files and assembler files.
+
+KAFLAGS
+--------------------------------------------------
+Additional options to the assembler.
+
+KCFLAGS
+--------------------------------------------------
+Additional options to the C compiler.
+
+KBUILD_VERBOSE
+--------------------------------------------------
+Set the kbuild verbosity. Can be assinged same values as "V=...".
+See make help for the full list.
+Setting "V=..." takes precedence over KBUILD_VERBOSE.
+
+KBUILD_EXTMOD
+--------------------------------------------------
+Set the directory to look for the kernel source when building external
+modules.
+The directory can be specified in several ways:
+1) Use "M=..." on the command line
+2) Environmnet variable KBUILD_EXTMOD
+3) Environmnet variable SUBDIRS
+The possibilities are listed in the order they take precedence.
+Using "M=..." will always override the others.
+
+KBUILD_OUTPUT
+--------------------------------------------------
+Specify the output directory when building the kernel.
+The output directory can also be specificed using "O=...".
+Setting "O=..." takes precedence over KBUILD_OUTPUT
+
+ARCH
+--------------------------------------------------
+Set ARCH to the architecture to be built.
+In most cases the name of the architecture is the same as the
+directory name found in the arch/ directory.
+But some architectures suach as x86 and sparc has aliases.
+x86: i386 for 32 bit, x86_64 for 64 bit
+sparc: sparc for 32 bit, sparc64 for 64 bit
+
+CROSS_COMPILE
+--------------------------------------------------
+Specify an optional fixed part of the binutils filename.
+CROSS_COMPILE can be a part of the filename or the full path.
+
+CROSS_COMPILE is also used for ccache is some setups.
+
+CF
+--------------------------------------------------
+Additional options for sparse.
+CF is often used on the command-line like this:
+
+    make CF=-Wbitwise C=2
+
+INSTALL_PATH
+--------------------------------------------------
+INSTALL_PATH specifies where to place the updated kernel and system map
+images. Default is /boot, but you can set it to other values
+
+
+MODLIB
+--------------------------------------------------
+Specify where to install modules.
+The default value is:
+
+     $(INSTALL_MOD_PATH)/lib/modules/$(KERNELRELEASE)
+
+The value can be overridden in which case the default value is ignored.
+
+INSTALL_MOD_PATH
+--------------------------------------------------
+INSTALL_MOD_PATH specifies a prefix to MODLIB for module directory
+relocations required by build roots.  This is not defined in the
+makefile but the argument can be passed to make if needed.
+
+INSTALL_MOD_STRIP
+--------------------------------------------------
+INSTALL_MOD_STRIP, if defined, will cause modules to be
+stripped after they are installed.  If INSTALL_MOD_STRIP is '1', then
+the default option --strip-debug will be used.  Otherwise,
+INSTALL_MOD_STRIP will used as the options to the strip command.
+
+INSTALL_FW_PATH
+--------------------------------------------------
+INSTALL_FW_PATH specify where to install the firmware blobs.
+The default value is:
+
+    $(INSTALL_MOD_PATH)/lib/firmware
+
+The value can be overridden in which case the default value is ignored.
+
+INSTALL_HDR_PATH
+--------------------------------------------------
+INSTALL_HDR_PATH specify where to install user space headers when
+executing "make headers_*".
+The default value is:
+
+    $(objtree)/usr
+
+$(objtree) is the directory where output files are saved.
+The output directory is often set using "O=..." on the commandline.
+
+The value can be overridden in which case the default value is ignored.
+
+KBUILD_MODPOST_WARN
+--------------------------------------------------
+KBUILD_MODPOST_WARN can be set to avoid error out in case of undefined
+symbols in the final module linking stage.
+
+KBUILD_MODPOST_FINAL
+--------------------------------------------------
+KBUILD_MODPOST_NOFINAL can be set to skip the final link of modules.
+This is solely usefull to speed up test compiles.
+
+KBUILD_EXTRA_SYMBOLS
+--------------------------------------------------
+For modules use symbols from another modules.
+See more details in modules.txt.
-- 
1.6.0.2.GIT

