Return-Path: <linux-kernel-owner+w=401wt.eu-S1763064AbYDVP31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763064AbYDVP31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbYDVP3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:29:18 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16258 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYDVP3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:29:15 -0400
Message-Id: <480E2076.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 16:29:26 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: minor polishing to top-level arch Makefile
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

---
 arch/x86/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.25/arch/x86/Makefile	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-x86-target-image/arch/x86/Makefile	2008-04-15 10:49:20.000000000 +0200
@@ -211,12 +211,12 @@ all: bzImage
 
 # KBUILD_IMAGE specify target image being built
                     KBUILD_IMAGE := $(boot)/bzImage
-zImage zlilo zdisk: KBUILD_IMAGE := arch/x86/boot/zImage
+zImage zlilo zdisk: KBUILD_IMAGE := $(boot)/zImage
 
 zImage bzImage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
 	$(Q)mkdir -p $(objtree)/arch/$(UTS_MACHINE)/boot
-	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/$(UTS_MACHINE)/boot/bzImage
+	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/$(UTS_MACHINE)/boot/$@
 
 compressed: zImage
 



