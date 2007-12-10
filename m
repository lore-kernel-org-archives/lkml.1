Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbXLJP0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbXLJP0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 10:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbXLJP0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 10:26:14 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:23833
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752743AbXLJP0N convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 10:26:13 -0500
Message-Id: <475D68D0.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 10 Dec 2007 15:26:56 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: small build adjustment
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use build target when creating compatibility link, and use $(boot)
where possible.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/x86/Makefile_32 |    4 ++--
 arch/x86/Makefile_64 |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.24-rc4/arch/x86/Makefile_32	2007-12-10 16:11:18.000000000 +0100
+++ 2.6.24-rc4-x86-link-compat/arch/x86/Makefile_32	2007-12-05 12:14:08.000000000 +0100
@@ -134,12 +134,12 @@ all: bzImage
 
 # KBUILD_IMAGE specify target image being built
                     KBUILD_IMAGE := $(boot)/bzImage
-zImage zlilo zdisk: KBUILD_IMAGE := arch/x86/boot/zImage
+zImage zlilo zdisk: KBUILD_IMAGE := $(boot)/zImage
 
 zImage bzImage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
 	$(Q)mkdir -p $(objtree)/arch/i386/boot
-	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/i386/boot/bzImage
+	$(Q)ln -fsn ../../x86/boot/$@ $(objtree)/arch/i386/boot/$@
 
 compressed: zImage
 
--- linux-2.6.24-rc4/arch/x86/Makefile_64	2007-12-10 16:11:18.000000000 +0100
+++ 2.6.24-rc4-x86-link-compat/arch/x86/Makefile_64	2007-12-05 09:50:26.000000000 +0100
@@ -96,13 +96,13 @@ PHONY += bzImage bzlilo install archmrpr
 #Default target when executing "make"
 all: bzImage
 
-BOOTIMAGE                     := arch/x86/boot/bzImage
+BOOTIMAGE                     := $(boot)/bzImage
 KBUILD_IMAGE                  := $(BOOTIMAGE)
 
 bzImage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(BOOTIMAGE)
 	$(Q)mkdir -p $(objtree)/arch/x86_64/boot
-	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/x86_64/boot/bzImage
+	$(Q)ln -fsn ../../x86/boot/$@ $(objtree)/arch/x86_64/boot/$@
 
 bzlilo: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) zlilo



