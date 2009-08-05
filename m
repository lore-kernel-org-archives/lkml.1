Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbZHEVwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbZHEVwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZHEVva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:51:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42937 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbZHEVv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:51:29 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200908051151.557035535@firstfloor.org>
In-Reply-To: <200908051151.557035535@firstfloor.org>
To: sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [2/5] kbuild: Check if linker supports the -X option
Message-Id: <20090805215128.B5C08B15D8@basil.firstfloor.org>
Date: Wed,  5 Aug 2009 23:51:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The new alternative `gold' linker in recent binutils doesn't support
the -X option. This breaks allyesconfig builds that have 
CONFIG_STRIP_ASM_SYMS enabled. Check if the linker really supports
the option using ld-option.

This requires fixes in earlier patches.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.31-rc1-ak/Makefile
===================================================================
--- linux-2.6.31-rc1-ak.orig/Makefile
+++ linux-2.6.31-rc1-ak/Makefile
@@ -599,7 +599,7 @@ LDFLAGS_MODULE += $(LDFLAGS_BUILD_ID)
 LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)
 
 ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
-LDFLAGS_vmlinux	+= -X
+LDFLAGS_vmlinux	+= $(call ld-option, -X,)
 endif
 
 # Default kernel image to build when no specific target is given.
