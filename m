Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbXIISVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbXIISVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 14:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbXIISVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 14:21:12 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33861 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751099AbXIISVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 14:21:11 -0400
Date: Sun, 9 Sep 2007 20:21:17 +0200
From: Adrian Bunk <bunk@kernel.org>
To: paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [2.6 patch] powerpc: proper defconfig for crosscompiles
Message-ID: <20070909182117.GJ3563@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The trick for finding the right defconfig is neat, but you forgot to 
provide an i686_defconfig.  ;-)

More seriously, cross compiling the defconfig is often useful, e.g. for 
testing the compilation of patches that touch multiple architectures, 
and this patch therefore chooses g5_defconfig if $(CROSS_COMPILE) is 
non-empty.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
0b0e6e0e3a16f48348cb9c40ef1bb55ef42f92eb 
diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 2065138..a39bac4 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -35,7 +35,11 @@ endif
 
 export CROSS32CC CROSS32AS CROSS32LD CROSS32AR CROSS32OBJCOPY
 
+ifeq ($(CROSS_COMPILE),)
 KBUILD_DEFCONFIG := $(shell uname -m)_defconfig
+else
+KBUILD_DEFCONFIG := g5_defconfig
+endif
 
 ifeq ($(CONFIG_PPC64),y)
 OLDARCH	:= ppc64

