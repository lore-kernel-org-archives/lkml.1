Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbZBOSVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbZBOSVx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 13:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbZBOSUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 13:20:40 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:41661 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbZBOSUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 13:20:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=h3WlvyytJw7iBP7r/FgsMoBhSVPJpF4sVHAEsnRkCNCRr7Fn/ONLpycVAi/Maiar5o
         4vjHclUoJ9DbTyvu203vMx/RxK/7B4yCzmEERqkidBI+axmlrYzV0K3N2/Sa6pqcCdx0
         CUsPmVf359k/WquSDgmQqduOJ9kJTxTs3aAqM=
From: Andreas Robinson <andr345@gmail.com>
To: sam@ravnborg.org, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/6] kbuild: allow linking of an external object into vmlinux
Date: Sun, 15 Feb 2009 19:20:26 +0100
Message-Id: <1234722028-8110-5-git-send-email-andr345@gmail.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1234722028-8110-1-git-send-email-andr345@gmail.com>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 Makefile |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 22d7584..921d6b4 100644
--- a/Makefile
+++ b/Makefile
@@ -651,7 +651,8 @@ libs-y		:= $(libs-y1) $(libs-y2)
 # Build vmlinux
 # ---------------------------------------------------------------------------
 # vmlinux is built from the objects selected by $(vmlinux-init) and
-# $(vmlinux-main). Most are built-in.o files from top-level directories
+# $(vmlinux-main) and an optional object $(EXTOBJ) specified when
+# running make. Most are built-in.o files from top-level directories
 # in the kernel tree, others are specified in arch/$(ARCH)/Makefile.
 # Ordering when linking is important, and $(vmlinux-init) must be first.
 #
@@ -664,6 +665,8 @@ libs-y		:= $(libs-y1) $(libs-y2)
 #   +--< $(vmlinux-main)
 #   |    +--< driver/built-in.o mm/built-in.o + more
 #   |
+#   +--< $(EXTOBJ) (optional)
+#   |
 #   +-< kallsyms.o (see description in CONFIG_KALLSYMS section)
 #
 # vmlinux version (uname -v) cannot be updated during normal
@@ -686,7 +689,7 @@ export KBUILD_VMLINUX_OBJS := $(vmlinux-all)
 quiet_cmd_vmlinux__ ?= LD      $@
       cmd_vmlinux__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux) -o $@ \
       -T $(vmlinux-lds) $(vmlinux-init)                          \
-      --start-group $(vmlinux-main) --end-group                  \
+      --start-group $(vmlinux-main) $(EXTOBJ) --end-group        \
       $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o FORCE ,$^)
 
 # Generate new vmlinux version
-- 
1.5.6.3

