Return-Path: <linux-kernel-owner+w=401wt.eu-S1763068AbYBNDqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763068AbYBNDqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 22:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbYBNDpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 22:45:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756614AbYBNDpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 22:45:50 -0500
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] samples: build fix
X-Fcc: ~/Mail/linus
X-Windows: some voids are better left unfilled.
Message-Id: <20080214034541.EF1BD270192@magilla.localdomain>
Date: Wed, 13 Feb 2008 19:45:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The samples/ subdirectory contains only modules.
But the only make run done there is in commands for vmlinux.
I can't see why this was ever done in this nonstandard fashion.
As things stand, the modules don't get built by 'make modules'.

I didn't make the addition of the directory use core-$(CONFIG_SAMPLES)
because there is no other conditional like that in the top-level Makefile
and samples/Makefile already uses obj-$(CONFIG_SAMPLES) as if it expects
always to be included.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 Makefile |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index c162370..9e9ce33 100644
--- a/Makefile
+++ b/Makefile
@@ -602,7 +602,7 @@ export mod_strip_cmd
 
 
 ifeq ($(KBUILD_EXTMOD),)
-core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ samples/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
@@ -802,9 +802,6 @@ vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o $(kallsyms.o)
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
-ifdef CONFIG_SAMPLES
-	$(Q)$(MAKE) $(build)=samples
-endif
 	$(call vmlinux-modpost)
 	$(call if_changed_rule,vmlinux__)
 	$(Q)rm -f .old_version
