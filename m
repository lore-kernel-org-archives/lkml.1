Return-Path: <linux-kernel-owner+w=401wt.eu-S934291AbYBHFHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291AbYBHFHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 00:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYBHFH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 00:07:27 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:32978 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbYBHFHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 00:07:25 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: sam@ravnborg.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: silence CHK/UPD messages according to $(quiet)
Date: Fri,  8 Feb 2008 00:05:52 -0500
Message-Id: <1202447152-29083-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 init/Makefile          |    4 +++-
 scripts/Kbuild.include |    8 ++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/init/Makefile b/init/Makefile
index 633392f..c5f157c 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -27,7 +27,9 @@ $(obj)/version.o: include/linux/compile.h
 # mkcompile_h will make sure to only update the
 # actual file if its content has changed.
 
+ quiet_chk_compile.h = echo '  CHK     $@'
+silent_chk_compile.h = :
 include/linux/compile.h: FORCE
-	@echo '  CHK     $@'
+	@$($(quiet)chk_compile.h)
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkcompile_h $@ \
 	"$(UTS_MACHINE)" "$(CONFIG_SMP)" "$(CONFIG_PREEMPT)" "$(CC) $(KBUILD_CFLAGS)"
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index b96ea8d..da3559e 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -39,15 +39,19 @@ escsq = $(subst $(squote),'\$(squote)',$1)
 # - If they are equal no change, and no timestamp update
 # - stdin is piped in from the first prerequisite ($<) so one has
 #   to specify a valid file as first prerequisite (often the kbuild file)
+ quiet_chk_filechk = echo '  CHK     $@'
+silent_chk_filechk = :
+ quiet_upd_filechk = echo '  UPD     $@'
+silent_upd_filechk = :
 define filechk
 	$(Q)set -e;				\
-	echo '  CHK     $@';			\
+	$($(quiet)chk_filechk);			\
 	mkdir -p $(dir $@);			\
 	$(filechk_$(1)) < $< > $@.tmp;		\
 	if [ -r $@ ] && cmp -s $@ $@.tmp; then	\
 		rm -f $@.tmp;			\
 	else					\
-		echo '  UPD     $@';		\
+		$($(quiet)upd_filechk);		\
 		mv -f $@.tmp $@;		\
 	fi
 endef
-- 
1.5.4

