Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbYFHUH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbYFHUH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbYFHUHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:07:07 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42978 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833AbYFHUG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:06:57 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 4/6] kbuild: code refactoring in Makefile.headerinst
Date: Sun,  8 Jun 2008 22:07:36 +0200
Message-Id: <1212955658-32168-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080608094730.GA30098@uranus.ravnborg.org>
References: <20080608094730.GA30098@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes just improved readability

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/Makefile.headersinst |   64 +++++++++++++++++++++++-------------------
 1 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 1fb8c00..599adc6 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -10,7 +10,7 @@
 UNIFDEF := scripts/unifdef -U__KERNEL__
 
 # Eliminate the contents of (and inclusions of) compiler.h
-HDRSED  := sed 	-e "s/ inline / __inline__ /g" \
+HDRSED  := sed	-e "s/ inline / __inline__ /g" \
 		-e "s/[[:space:]]__user[[:space:]]\{1,\}/ /g" \
 		-e "s/(__user[[:space:]]\{1,\}/ (/g" \
 		-e "s/[[:space:]]__force[[:space:]]\{1,\}/ /g" \
@@ -37,6 +37,8 @@ ifeq ($(obj),include/asm-$(ARCH)$(BIASMDIR))
      _dst := include/asm
 endif
 
+install := $(INSTALL_HDR_PATH)/$(_dst)
+
 header-y	:= $(sort $(header-y) $(unifdef-y))
 subdir-y	:= $(patsubst %/,%,$(filter %/, $(header-y)))
 header-y	:= $(filter-out %/, $(header-y))
@@ -45,34 +47,34 @@ header-y	:= $(filter-out %/, $(header-y))
 check-y		:= $(patsubst %,.check.%,$(header-y) $(objhdr-y))
 
 # Work out what needs to be removed
-oldheaders	:= $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,%,$(wildcard $(INSTALL_HDR_PATH)/$(_dst)/*.h))
-unwanted	:= $(filter-out $(header-y) $(objhdr-y),$(oldheaders))
+oldheaders      := $(patsubst $(install)/%,%,$(wildcard $(install)/*.h))
+unwanted        := $(filter-out $(header-y) $(objhdr-y),$(oldheaders))
 
-oldcheckstamps	:= $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,%,$(wildcard $(INSTALL_HDR_PATH)/$(_dst)/.check.*.h))
-unwanted	+= $(filter-out $(check-y),$(oldcheckstamps))
+oldcheckstamps  := $(patsubst $(install)/%,%,$(wildcard $(install)/.check.*.h))
+unwanted        += $(filter-out $(check-y),$(oldcheckstamps))
 
 # Prefix them all with full paths to $(INSTALL_HDR_PATH)
-header-y 	:= $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(header-y))
-objhdr-y 	:= $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(objhdr-y))
-check-y 	:= $(patsubst %,$(INSTALL_HDR_PATH)/$(_dst)/%,$(check-y))
+header-y        := $(patsubst %,$(install)/%,$(header-y))
+objhdr-y        := $(patsubst %,$(install)/%,$(objhdr-y))
+check-y         := $(patsubst %,$(install)/%,$(check-y))
 
-quiet_cmd_o_hdr_install   = INSTALL $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
-      cmd_o_hdr_install   = cp $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,$(objtree)/$(obj)/%,$@) \
-			    $(INSTALL_HDR_PATH)/$(_dst)
+quiet_cmd_o_hdr_install = INSTALL $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
+      cmd_o_hdr_install = cp $(patsubst $(install)/%,$(objtree)/$(obj)/%,$@) \
+                             $(install)
 
-quiet_cmd_unifdef	  = UNIFDEF $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
-      cmd_unifdef	  = $(UNIFDEF) $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,$(srctree)/$(obj)/%,$@) \
-				   | $(HDRSED) > $@ || :
+quiet_cmd_unifdef = UNIFDEF $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
+      cmd_unifdef = $(UNIFDEF) $(patsubst $(install)/%,$(srctree)/$(obj)/%,$@)\
+                               | $(HDRSED) > $@ || :
 
-quiet_cmd_check		  = CHECK   $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/.check.%,$(_dst)/%,$@)
-      cmd_check		  = $(CONFIG_SHELL) $(srctree)/scripts/hdrcheck.sh \
-                              $(INSTALL_HDR_PATH)/include $(subst /.check.,/,$@) $@
+quiet_cmd_check = CHECK   $(patsubst $(install)/.check.%,$(_dst)/%,$@)
+      cmd_check = $(CONFIG_SHELL) $(srctree)/scripts/hdrcheck.sh \
+                  $(INSTALL_HDR_PATH)/include $(subst /.check.,/,$@) $@
 
-quiet_cmd_remove	  = REMOVE  $(_dst)/$@
-      cmd_remove	  = rm -f $(INSTALL_HDR_PATH)/$(_dst)/$@
+quiet_cmd_remove = REMOVE  $(_dst)/$@
+      cmd_remove = rm -f $(install)/$@
 
-quiet_cmd_mkdir		  = MKDIR   $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
-      cmd_mkdir		  = mkdir -p $@
+quiet_cmd_mkdir  = MKDIR   $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
+      cmd_mkdir  = mkdir -p $@
 
 .PHONY: __headersinst __headerscheck
 
@@ -80,13 +82,14 @@ ifdef HDRCHECK
 __headerscheck: $(subdir-y) $(check-y)
 	@true
 
-$(check-y) : $(INSTALL_HDR_PATH)/$(_dst)/.check.%.h : $(INSTALL_HDR_PATH)/$(_dst)/%.h 
+$(check-y) : $(install)/.check.%.h : $(install)/%.h
 	$(call cmd,check)
 
 # Other dependencies for $(check-y)
 include /dev/null $(wildcard $(check-y))
 
-# ... but leave $(check-y) as .PHONY for now until those deps are actually correct.
+# but leave $(check-y) as .PHONY for now until those
+# deps are actually correct.
 .PHONY: $(check-y)
 
 else
@@ -94,26 +97,29 @@ else
 __headersinst: $(subdir-y) $(header-y) $(objhdr-y)
 	@true
 
-$(objhdr-y) $(subdir-y) $(header-y): | $(INSTALL_HDR_PATH)/$(_dst) $(unwanted)
+$(objhdr-y) $(subdir-y) $(header-y): | $(install) $(unwanted)
 
-$(INSTALL_HDR_PATH)/$(_dst):
+$(install):
 	$(call cmd,mkdir)
 
+# Rules for removing unwanted header files
 .PHONY: $(unwanted)
 $(unwanted):
 	$(call cmd,remove)
 
-$(objhdr-y): $(INSTALL_HDR_PATH)/$(_dst)/%.h: $(objtree)/$(obj)/%.h $(kbuild-file)
+# Install generated files
+$(objhdr-y): $(install)/%.h: $(objtree)/$(obj)/%.h $(kbuild-file)
 	$(call cmd,o_hdr_install)
 
-$(header-y): $(INSTALL_HDR_PATH)/$(_dst)/%.h: $(srctree)/$(obj)/%.h $(kbuild-file)
+# Unifdef header files and install them
+$(header-y): $(install)/%.h: $(srctree)/$(obj)/%.h $(kbuild-file)
 	$(call cmd,unifdef)
 
 endif
 
-hdrinst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
+hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
 
 # Recursion
 .PHONY: $(subdir-y)
 $(subdir-y):
-	$(Q)$(MAKE) $(hdrinst)=$(obj)/$@ dst=$(_dst)/$@ rel=../$(rel)
+	$(Q)$(MAKE) $(hdr-inst)=$(obj)/$@ dst=$(_dst)/$@
-- 
1.5.4.1.143.ge7e51

