Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbZINUT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbZINUT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933819AbZINUTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:19:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42014 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124AbZINUSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:18:06 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200909141018.915641783@firstfloor.org>
In-Reply-To: <200909141018.915641783@firstfloor.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, sam@ravnborg.org
Subject: [PATCH] [2/5] kbuild: Check if linker supports the -X option
Message-Id: <20090914201807.F1214B1757@basil.firstfloor.org>
Date: Mon, 14 Sep 2009 22:18:07 +0200 (CEST)
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
