Return-Path: <linux-kernel-owner+w=401wt.eu-S1161358AbXBHCNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161358AbXBHCNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 21:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161515AbXBHCNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 21:13:12 -0500
Received: from raven.upol.cz ([158.194.120.4]:37730 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161391AbXBHCNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 21:13:11 -0500
To: Trond Myklebust <trond.myklebust@fys.uio.no>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: `-mcpu=' is deprecated. Use `-mtune=' or '-march=' instead.
In-Reply-To: <1170897212.7070.15.camel@lade.trondhjem.org>
References: <1170897212.7070.15.camel@lade.trondhjem.org>
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>, Oleg Verych <olecom@flower.upol.cz>
Date: Thu, 8 Feb 2007 03:22:03 +0100
Message-Id: <E1HEyvD-0007Cj-67@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Trond Myklebust
> Newsgroups: gmane.linux.kernel
> Subject: `-mcpu=' is deprecated. Use `-mtune=' or '-march=' instead.
> Date: Wed, 07 Feb 2007 17:13:32 -0800
> Archived-At: <http://permalink.gmane.org/gmane.linux.kernel/490940>

Hallo, Trond.

> The latest pull from the git tree spews out a torrent of the above
> warning on a recent Fedora Core 6 machine running gcc-4.1.1. config file
> is attached...

Current situation isn't known, this change may be reverted or not, but
patch to fix this now was already posted and got to Linus.

Here it is for you. Thanks for testing.


---
 scripts/Kbuild.include |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

Index: linux-2.6.20/scripts/Kbuild.include
===================================================================
--- linux-2.6.20.orig/scripts/Kbuild.include	2007-02-07 22:54:01.814467250 +0100
+++ linux-2.6.20/scripts/Kbuild.include	2007-02-07 22:54:17.099422500 +0100
@@ -58,5 +58,5 @@ endef
 
 # checker-shell
-# Usage: option = $(call checker-shell, $(CC)...-o $$OUT, option-ok, otherwise)
+# Usage: option = $(call checker-shell,$(CC)...-o $$OUT,option-ok,otherwise)
 # Exit code chooses option. $$OUT is safe location for needless output.
 define checker-shell
@@ -75,21 +75,21 @@ endef
 
 # as-option
-# Usage: cflags-y += $(call as-option, -Wa$(comma)-isa=foo,)
-as-option = $(call checker-shell, \
-   $(CC) $(CFLAGS) $(1) -c -xassembler /dev/null -o $$OUT, $(1), $(2))
+# Usage: cflags-y += $(call as-option,-Wa$(comma)-isa=foo,)
+as-option = $(call checker-shell,\
+   $(CC) $(CFLAGS) $(1) -c -xassembler /dev/null -o $$OUT,$(1),$(2))
 
 # as-instr
-# Usage: cflags-y += $(call as-instr, instr, option1, option2)
-as-instr = $(call checker-shell, \
-   printf "$(1)" | $(CC) $(AFLAGS) -c -xassembler -o $$OUT -, $(2), $(3))
+# Usage: cflags-y += $(call as-instr,instr,option1,option2)
+as-instr = $(call checker-shell,\
+   printf "$(1)" | $(CC) $(AFLAGS) -c -xassembler -o $$OUT -,$(2),$(3))
 
 # cc-option
-# Usage: cflags-y += $(call cc-option, -march=winchip-c6, -march=i586)
-cc-option = $(call checker-shell, \
-   $(CC) $(CFLAGS) $(if $(3),$(3),$(1)) -S -xc /dev/null -o $$OUT, $(1), $(2))
+# Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
+cc-option = $(call checker-shell,\
+   $(CC) $(CFLAGS) $(if $(3),$(3),$(1)) -S -xc /dev/null -o $$OUT,$(1),$(2))
 
 # cc-option-yn
-# Usage: flag := $(call cc-option-yn, -march=winchip-c6)
-cc-option-yn = $(call cc-option, "y", "n", $(1))
+# Usage: flag := $(call cc-option-yn,-march=winchip-c6)
+cc-option-yn = $(call cc-option,"y","n",$(1))
 
 # cc-option-align
@@ -99,5 +99,5 @@ cc-option-align = $(subst -functions=0,,
 
 # cc-version
-# Usage gcc-ver := $(call cc-version, $(CC))
+# Usage gcc-ver := $(call cc-version,$(CC))
 cc-version = $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-version.sh $(CC))
 
@@ -108,6 +108,6 @@ cc-ifversion = $(shell [ $(call cc-versi
 # ld-option
 # Usage: ldflags += $(call ld-option, -Wl$(comma)--hash-style=both)
-ld-option = $(call checker-shell, \
-   $(CC) $(1) -nostdlib -xc /dev/null -o $$OUT, $(1), $(2))
+ld-option = $(call checker-shell,\
+   $(CC) $(1) -nostdlib -xc /dev/null -o $$OUT,$(1),$(2))
 
 ######
@@ -121,13 +121,13 @@ build := -f $(if $(KBUILD_SRC),$(srctree
 # add original to the end
 addtree = $(if \
-	$(filter-out -I/%, $(1)), $(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
+	$(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
 
 # Find all -I options and call addtree
-flags = $(foreach o,$($(1)), \
-	$(if $(filter -I%,$(o)), $(call addtree, $(o)), $(o)))
+flags = $(foreach o,$($(1)),\
+	$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))
 
 # echo command.
 # Short version is used, if $(quiet) equals `quiet_', otherwise full one.
-echo-cmd = $(if $($(quiet)cmd_$(1)), \
+echo-cmd = $(if $($(quiet)cmd_$(1)),\
 	echo '  $(call escsq,$($(quiet)cmd_$(1)))$(echo-why)';)
 
@@ -136,5 +136,5 @@ cmd = @$(echo-cmd) $(cmd_$(1))
 
 # Add $(obj)/ for paths that are not absolute
-objectify = $(foreach o,$(1), $(if $(filter /%,$(o)), $(o), $(obj)/$(o)))
+objectify = $(foreach o,$(1),$(if $(filter /%,$(o)),$(o),$(obj)/$(o)))
 
 ###
