Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbZIPUhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbZIPUhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760004AbZIPUg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:36:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57602 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760001AbZIPUgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:36:53 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200909161036.346507799@firstfloor.org>
In-Reply-To: <200909161036.346507799@firstfloor.org>
To: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/2] kbuild: Check if linker supports the -X option
Message-Id: <20090916203655.6DD73B1755@basil.firstfloor.org>
Date: Wed, 16 Sep 2009 22:36:55 +0200 (CEST)
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

Index: linux-2.6.31-rc3-ak/Makefile
===================================================================
--- linux-2.6.31-rc3-ak.orig/Makefile
+++ linux-2.6.31-rc3-ak/Makefile
@@ -600,7 +600,7 @@ LDFLAGS_MODULE += $(LDFLAGS_BUILD_ID)
 LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)
 
 ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
-LDFLAGS_vmlinux	+= -X
+LDFLAGS_vmlinux	+= $(call really-ld-option, -X,)
 endif
 
 # Default kernel image to build when no specific target is given.
