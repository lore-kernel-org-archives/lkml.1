Return-Path: <linux-kernel-owner+w=401wt.eu-S1750945AbZHTPOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945AbZHTPOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 11:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750728AbZHTPOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 11:14:14 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:23817 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbZHTPON convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:14:13 -0400
Message-Id: <4A8D84670200007800010D31@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 20 Aug 2009 16:14:15 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: adjust targets specification in
	 arch/x86/boot/compressed/Makefile
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The absence of vmlinux.lds here keeps .vmlinux.lds.cmd from being
included, which in turn leads to it and all its dependents always
getting rebuilt independent of whether they are already up-to-date.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/boot/compressed/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.31-rc6/arch/x86/boot/compressed/Makefile	2009-08-18 15:31:15.000000000 +0200
+++ 2.6.31-rc6-x86-boot-compressed-targets/arch/x86/boot/compressed/Makefile	2009-08-20 16:56:53.000000000 +0200
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
+targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC



