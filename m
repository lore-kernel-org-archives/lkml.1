Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbYGAOMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbYGAOMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbYGAOL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:11:56 -0400
Received: from n1.cetrtapot.si ([89.212.80.162]:65219 "EHLO n1.cetrtapot.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbYGAOLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:11:55 -0400
Message-ID: <486A3A6C.4000506@cetrtapot.si>
Date: Tue, 01 Jul 2008 16:08:44 +0200
From: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.14 (X11/20080508)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: dev-etrax@axis.com
Subject: Re: [PATCH linux-next 1/1] cris: look for linker scripts in srctree
 not in objtree
References: <4849213A.4080001@cetrtapot.si>
In-Reply-To: <4849213A.4080001@cetrtapot.si>
Content-Type: multipart/mixed;
 boundary="------------050907030002080004010404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050907030002080004010404
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

When building kernel with O= linker looks for linker scripts in output tree, while they are located in source tree.

Signed-off-by: Hinko Kocevar <hinko.kocevar@cetrtapot.si>

---



--------------050907030002080004010404
Content-Type: text/x-patch;
 name="cris-look-for-linker-scripts-in-srctree.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cris-look-for-linker-scripts-in-srctree.patch"

diff --git a/arch/cris/arch-v10/boot/compressed/Makefile b/arch/cris/arch-v10/boot/compressed/Makefile
index 9ec5f87..cc6527d 100644
--- a/arch/cris/arch-v10/boot/compressed/Makefile
+++ b/arch/cris/arch-v10/boot/compressed/Makefile
@@ -4,7 +4,7 @@
 
 asflags-y += $(LINUXINCLUDE)
 ccflags-y += -O2 $(LINUXINCLUDE)
-ldflags-y += -T $(obj)/decompress.ld
+ldflags-y += -T $(srctree)/arch/$(ARCH)/boot/compressed/decompress.ld
 OBJECTS = $(obj)/head.o $(obj)/misc.o
 OBJCOPYFLAGS = -O binary --remove-section=.bss
 
diff --git a/arch/cris/arch-v10/boot/rescue/Makefile b/arch/cris/arch-v10/boot/rescue/Makefile
index bea8b9c..476007d 100644
--- a/arch/cris/arch-v10/boot/rescue/Makefile
+++ b/arch/cris/arch-v10/boot/rescue/Makefile
@@ -4,7 +4,7 @@
 
 ccflags-y += -O2 $(LINUXINCLUDE)
 asflags-y += $(LINUXINCLUDE)
-ldflags-y += -T $(obj)/rescue.ld
+ldflags-y += -T $(srctree)/arch/$(ARCH)/boot/rescue/rescue.ld
 OBJCOPYFLAGS = -O binary --remove-section=.bss
 obj-$(CONFIG_ETRAX_AXISFLASHMAP) = head.o
 OBJECT := $(obj)/head.o

--------------050907030002080004010404--
