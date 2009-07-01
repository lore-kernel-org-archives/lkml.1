Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbZGAJZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbZGAJZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZGAJZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:25:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZGAJZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:25:40 -0400
From: Michal Marek <mmarek@suse.cz>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: fix generating of *.symtypes files
Date: Wed,  1 Jul 2009 11:25:30 +0200
Message-Id: <1246440330-21290-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 37a8d9f ("kbuild: simplify use of genksyms") broke generating of
*.symtypes files during build (with KBUILD_SYMTYPES set). This patch
fixes it.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/Makefile.build |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 5c4b7a4..fb749dd 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -156,9 +156,9 @@ $(obj)/%.i: $(src)/%.c FORCE
 
 cmd_gensymtypes =                                                           \
     $(CPP) -D__GENKSYMS__ $(c_flags) $< |                                   \
-    $(GENKSYMS) -T $@ -a $(ARCH)                                            \
+    $(GENKSYMS) $(if $(strip $(1)), -T $(@:.o=.symtypes)) -a $(ARCH)        \
      $(if $(KBUILD_PRESERVE),-p)                                            \
-     $(if $(1),-r $(firstword $(wildcard $(@:.symtypes=.symref) /dev/null)))
+     -r $(firstword $(wildcard $(basename $@).symref /dev/null))
 
 quiet_cmd_cc_symtypes_c = SYM $(quiet_modtag) $@
 cmd_cc_symtypes_c =                                                         \
-- 
1.6.3.2

