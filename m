Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbXJJWWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbXJJWWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 18:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXJJWWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 18:22:25 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:34250
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755496AbXJJWWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 18:22:24 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] Make m68k cross compile like every other architecture.
Date: Wed, 10 Oct 2007 17:22:21 -0500
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710101722.21126.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Rip out hardwired cross compiler name assumption that only m68k makes.

Signed-off-by: Rob Landley <rob@landley.net>
---
When you cross compile, you have to set the prefix CROSS_COMPILE to your
cross compiler prefix.  You need to do this for all targets (arm, mips, ppc,
x86-64 on x86, etc).  This is not specific to m68k, and this value is
supplied _to_ the build, not supplied _by_ the build.

The build shouldn't unconditionally overwrite the existing value of this
variable with one it makes up.  It has no idea what I called my cross compiler.

 arch/m68k/Makefile |    7 -------
 1 file changed, 7 deletions(-)

diff -r 79f0ea1e0e70 arch/m68k/Makefile
--- a/arch/m68k/Makefile	Tue Oct 09 21:00:40 2007 +0000
+++ b/arch/m68k/Makefile	Wed Oct 10 17:02:17 2007 -0500
@@ -13,17 +13,10 @@
 # Copyright (C) 1994 by Hamish Macdonald
 #
 
-# test for cross compiling
-COMPILE_ARCH = $(shell uname -m)
-
 # override top level makefile
 AS += -m68020
 LDFLAGS := -m m68kelf
 LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
-ifneq ($(COMPILE_ARCH),$(ARCH))
-	# prefix for cross-compiling binaries
-	CROSS_COMPILE = m68k-linux-gnu-
-endif
 
 ifdef CONFIG_SUN3
 LDFLAGS_vmlinux = -N

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
