Return-Path: <linux-kernel-owner+w=401wt.eu-S933820AbZINUTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820AbZINUTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933540AbZINUTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:19:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42024 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112AbZINUSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:18:08 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200909141018.915641783@firstfloor.org>
In-Reply-To: <200909141018.915641783@firstfloor.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, sam@ravnborg.org
Subject: [PATCH] [5/5] kbuild: Set -fconserve-stack option for gcc 4.5
Message-Id: <20090914201811.187B3B1757@basil.firstfloor.org>
Date: Mon, 14 Sep 2009 22:18:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The upcomming gcc 4.5 has a new -fconserve-stack option 
that tells the inliner to take stack frame size in account.
Set it if the compiler supports it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Makefile |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.31-rc3-ak/Makefile
===================================================================
--- linux-2.6.31-rc3-ak.orig/Makefile
+++ linux-2.6.31-rc3-ak/Makefile
@@ -575,6 +575,9 @@ KBUILD_CFLAGS	+= $(call cc-option,-fno-s
 # revert to pre-gcc-4.4 behaviour of .eh_frame
 KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
 
+# conserve stack if available
+KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)
+
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
 # But warn user when we do so
 warn-assign = \
