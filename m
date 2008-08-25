Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYHYThr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYHYThr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 15:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbYHYThh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 15:37:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:17054 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022AbYHYThg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 15:37:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :mime-version:x-mailer:content-transfer-encoding:sender:message-id;
        b=LFvLjpAwWQpJ086x+g8xqyQmWhExaNmzUlGMlPrQzrgjWn3/E6szzolFXJQxyx8d1a
         UNni+kzLzSjWSfPUpt9OA9MEcBaywXXONYk+mUXqmaOlyLkVZWXjwG52nCfBDK46gqXc
         EHSeTFl5nAT+Glkqfps2pIM04kURR9e8S2udQ=
References: <20080825191427.728251800@bohmer.net>>
User-Agent: quilt/0.46-1
Date: Mon, 25 Aug 2008 21:14:28 +0200
From: Remy Bohmer <linux@bohmer.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       u-boot@lists.denx.de, sam@ravnborg.org
Cc: Stefan Roese <sr@denx.de>, Remy Bohmer <linux@bohmer.net>
Subject: [patch 1/2] Enable the use of an uncompressed kernel image for
	U-boot uImage
Content-Disposition: inline; filename=use-uncompressed-image-for-uboot.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Message-ID: <48b309fe.0a04d00a.527b.ffffa801@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally the 'zImage' is used as base for uImage.
Enable the capability to use the raw uncompressed 'Image' instead

Signed-off-by: Remy Bohmer <linux@bohmer.net>
---
 arch/arm/Kconfig       |   10 ++++++++++
 arch/arm/boot/Makefile |    6 +++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

Index: linux-2.6.27-rc4/arch/arm/Kconfig
===================================================================
--- linux-2.6.27-rc4.orig/arch/arm/Kconfig	2008-08-25 20:58:33.000000000 +0200
+++ linux-2.6.27-rc4/arch/arm/Kconfig	2008-08-25 20:58:36.000000000 +0200
@@ -967,6 +967,16 @@ config XIP_KERNEL
 
 	  If unsure, say N.
 
+config UNCOMPRESSED_UIMAGE
+	bool "Use uncompressed kernel image for uImage"
+	default n
+	help
+	  Enable this option if you want uImage to be based on the kernel
+	  'Image' instead of 'zImage'. This will increase the kernel image
+	  size, but it can improve kernel boot time in some situations.
+
+	  If unsure, say N.
+
 config XIP_PHYS_ADDR
 	hex "XIP Kernel Physical Location"
 	depends on XIP_KERNEL
Index: linux-2.6.27-rc4/arch/arm/boot/Makefile
===================================================================
--- linux-2.6.27-rc4.orig/arch/arm/boot/Makefile	2008-08-25 20:58:33.000000000 +0200
+++ linux-2.6.27-rc4/arch/arm/boot/Makefile	2008-08-25 20:58:36.000000000 +0200
@@ -70,7 +70,11 @@ else
 $(obj)/uImage: LOADADDR=$(ZRELADDR)
 endif
 
-$(obj)/uImage:	$(obj)/zImage FORCE
+ifeq ($(CONFIG_UNCOMPRESSED_UIMAGE),y)
+$(obj)/uImage: $(obj)/Image FORCE
+else
+$(obj)/uImage: $(obj)/zImage FORCE
+endif
 	$(call if_changed,uimage)
 	@echo '  Image $@ is ready'
 

-- 

