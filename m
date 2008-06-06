Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbYFFLkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbYFFLkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 07:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYFFLj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 07:39:58 -0400
Received: from n1.cetrtapot.si ([89.212.80.162]:55339 "EHLO n1.cetrtapot.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbYFFLj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 07:39:57 -0400
Message-ID: <484921B9.7010707@cetrtapot.si>
Date: Fri, 06 Jun 2008 13:38:33 +0200
From: =?UTF-8?B?SGlua28gS2/EjWV2YXI=?= <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.14 (X11/20080508)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: dev-etrax@axis.com
Subject: Re: [PATCH 2.6.26-rc5 2/2] cris: compile fixes for 2.6.26-rc5
References: <4849213A.4080001@cetrtapot.si>
In-Reply-To: <4849213A.4080001@cetrtapot.si>
Content-Type: multipart/mixed;
 boundary="------------000705010906010008010604"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000705010906010008010604
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Make compile succeed when building with O= (srctree != objtree).

Signed-off-by: Hinko Kocevar <hinko.kocevar@cetrtapot.si>

---


--------------000705010906010008010604
Content-Type: text/x-patch;
 name="002-cris-compile-with-src-ne-obj-dir.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="002-cris-compile-with-src-ne-obj-dir.patch"

diff --git a/arch/cris/arch-v10/boot/compressed/Makefile b/arch/cris/arch-v10/boot/compressed/Makefile
index 4a031cb..89ad821 100644
--- a/arch/cris/arch-v10/boot/compressed/Makefile
+++ b/arch/cris/arch-v10/boot/compressed/Makefile
@@ -5,7 +5,7 @@
 CC = gcc-cris -melf $(LINUXINCLUDE)
 ccflags-y += -O2
 LD = ld-cris
-ldflags-y += -T $(obj)/decompress.ld
+ldflags-y += -T $(srctree)/$(src)/decompress.ld
 OBJECTS = $(obj)/head.o $(obj)/misc.o
 OBJCOPY = objcopy-cris
 OBJCOPYFLAGS = -O binary --remove-section=.bss
diff --git a/arch/cris/arch-v10/boot/rescue/Makefile b/arch/cris/arch-v10/boot/rescue/Makefile
index 2e5045b..32b9a91 100644
--- a/arch/cris/arch-v10/boot/rescue/Makefile
+++ b/arch/cris/arch-v10/boot/rescue/Makefile
@@ -6,7 +6,7 @@ CC = gcc-cris -mlinux $(LINUXINCLUDE)
 ccflags-y += -O2
 asflags-y += -traditional
 LD = gcc-cris -mlinux -nostdlib
-ldflags-y += -T $(obj)/rescue.ld
+ldflags-y += -T $(srctree)/$(src)/rescue.ld
 OBJCOPY = objcopy-cris
 OBJCOPYFLAGS = -O binary --remove-section=.bss
 obj-$(CONFIG_ETRAX_AXISFLASHMAP) = head.o

--------------000705010906010008010604--
