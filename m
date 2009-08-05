Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbZHEVvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbZHEVvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbZHEVvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:51:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42942 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbZHEVvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:51:31 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200908051151.557035535@firstfloor.org>
In-Reply-To: <200908051151.557035535@firstfloor.org>
To: sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [5/5] kbuild: Set -fconserve-stack option for gcc 4.5
Message-Id: <20090805215131.BD7D2B15D8@basil.firstfloor.org>
Date: Wed,  5 Aug 2009 23:51:31 +0200 (CEST)
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
