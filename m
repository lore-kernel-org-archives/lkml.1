Return-Path: <linux-kernel-owner+w=401wt.eu-S932172Ab0A0SWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab0A0SWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 13:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932162Ab0A0SWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 13:22:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:31604 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab0A0SWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 13:22:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=Hjo1vLqnJjr4wqys5HejzPda37nexd/t058HsY8zP5TkS2RuhN52oAvTRi/wKeJWtd
         W6TFsoEgnyHgS2r+/idl8Pz50t0Cqtjx99b3rzI5uSc8iztRQZZrMPCWe8YJ1tVfeT2L
         IOViqB8p4f2CVoFVCfhkw7iBdW3zMOO/pV5jQ=
From: Don Mullis <don.mullis@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: airlied@redhat.com, andi@firstfloor.org, david@fromorbit.com,
       dedekind@infradead.org
Subject: [PATCH v2 3/3] lib: Build list_sort() only if needed
References: <878wbja0h6.fsf@gmail.com>
Date: Wed, 27 Jan 2010 10:21:59 -0800
In-Reply-To: <878wbja0h6.fsf@gmail.com> (Don Mullis's message of "Wed, 27 Jan
	2010 10:04:05 -0800")
Message-ID: <87zl3z8l2w.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build list_sort() only for configs that need it -- those that don't
save ~581 bytes (i386).

Signed-off-by: Don Mullis <don.mullis@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>            
Cc: Andi Kleen <andi@firstfloor.org>            
Cc: Dave Chinner <david@fromorbit.com>          
Cc: Artem Bityutskiy <dedekind@infradead.org>   
---
 drivers/gpu/drm/Kconfig |    1 +
 fs/ubifs/Kconfig        |    1 +
 lib/Kconfig             |    3 +++
 lib/Makefile            |    3 ++-
 4 files changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/gpu/drm/Kconfig
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/Kconfig	2010-01-25 21:45:25.000000000 -0800
+++ linux-2.6/drivers/gpu/drm/Kconfig	2010-01-25 21:48:14.000000000 -0800
@@ -9,6 +9,7 @@ menuconfig DRM
 	depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG && MMU
 	select I2C
 	select I2C_ALGOBIT
+	select LIST_SORT
 	help
 	  Kernel-level support for the Direct Rendering Infrastructure (DRI)
 	  introduced in XFree86 4.0. If you say Y here, you need to select
Index: linux-2.6/fs/ubifs/Kconfig
===================================================================
--- linux-2.6.orig/fs/ubifs/Kconfig	2010-01-25 21:40:35.000000000 -0800
+++ linux-2.6/fs/ubifs/Kconfig	2010-01-25 21:47:54.000000000 -0800
@@ -7,6 +7,7 @@ config UBIFS_FS
 	select CRYPTO if UBIFS_FS_ZLIB
 	select CRYPTO_LZO if UBIFS_FS_LZO
 	select CRYPTO_DEFLATE if UBIFS_FS_ZLIB
+	select LIST_SORT
 	depends on MTD_UBI
 	help
 	  UBIFS is a file system for flash devices which works on top of UBI.
Index: linux-2.6/lib/Makefile
===================================================================
--- linux-2.6.orig/lib/Makefile	2010-01-25 21:39:23.000000000 -0800
+++ linux-2.6/lib/Makefile	2010-01-25 21:43:06.000000000 -0800
@@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o list_sort.o
+	 string_helpers.o gcd.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
@@ -42,6 +42,7 @@ obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += f
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
 obj-$(CONFIG_BTREE) += btree.o
+obj-$(CONFIG_LIST_SORT) += list_sort.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
Index: linux-2.6/lib/Kconfig
===================================================================
--- linux-2.6.orig/lib/Kconfig	2010-01-25 21:39:23.000000000 -0800
+++ linux-2.6/lib/Kconfig	2010-01-25 21:52:45.000000000 -0800
@@ -166,6 +166,9 @@ config TEXTSEARCH_FSM
 config BTREE
 	boolean
 
+config LIST_SORT
+	boolean
+
 config HAS_IOMEM
 	boolean
 	depends on !NO_IOMEM
