Return-Path: <linux-kernel-owner+w=401wt.eu-S933300AbXJRPes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbXJRPes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbXJRPel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:34:41 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:3361 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756766AbXJRPek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:34:40 -0400
Message-ID: <47177C28.5010609@panasas.com>
Date: Thu, 18 Oct 2007 17:30:48 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Use relative symbolic links for bzImge in x86 ARCHs
References: <4715F2E5.6000104@panasas.com> <20071017191633.GB11837@uranus.ravnborg.org>
In-Reply-To: <20071017191633.GB11837@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Oct 2007 15:30:49.0461 (UTC) FILETIME=[DC5AF250:01C8119B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK One more problem with a patch this time

---
From: Benny Halevy <bhalevy@panasas.com>

use relative paths in the symlink to bzImage
to make it NFS export safe.

Signed-off-by: Benny Halevy <bhalevy@panasas.com>

diff --git a/arch/i386/Makefile b/arch/i386/Makefile
index f036d2d..396146e 100644
--- a/arch/i386/Makefile
+++ b/arch/i386/Makefile
@@ -132,7 +132,7 @@ zImage zlilo zdisk: KBUILD_IMAGE := arch/x86/boot/zImage
 
 zImage bzImage: vmlinux
 	$(Q)mkdir -p $(objtree)/arch/i386/boot
-	$(Q)ln -fsn $(objtree)/arch/x86/boot/bzImage $(objtree)/arch/i386/boot/bzImage
+	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/i386/boot/bzImage
 	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
 
 compressed: zImage
diff --git a/arch/x86_64/Makefile b/arch/x86_64/Makefile
index 9daa32d..8048f4f 100644
--- a/arch/x86_64/Makefile
+++ b/arch/x86_64/Makefile
@@ -98,7 +98,7 @@ KBUILD_IMAGE                  := $(BOOTIMAGE)
 
 bzImage: vmlinux
 	$(Q)mkdir -p $(objtree)/arch/x86_64/boot
-	$(Q)ln -fsn $(objtree)/arch/x86/boot/bzImage $(objtree)/arch/x86_64/boot/bzImage
+	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/x86_64/boot/bzImage
 	$(Q)$(MAKE) $(build)=$(boot) $(BOOTIMAGE)
 
 bzlilo: vmlinux

