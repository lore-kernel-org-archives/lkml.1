Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbYE2IUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbYE2IUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYE2IU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:20:28 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35484 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbYE2IU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:20:27 -0400
Date: Thu, 29 May 2008 10:20:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Dave Airlie <airlied@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.sourceforge.net>
Subject: Re: in-kernel DRM tree move around....
In-Reply-To: <20080529042335.GA10636@uranus.ravnborg.org>
Message-ID: <alpine.LNX.1.10.0805291015280.19264@fbirervta.pbzchgretzou.qr>
References: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com> <20080529042335.GA10636@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 2008-05-29 06:23, Sam Ravnborg wrote:
>On Thu, May 29, 2008 at 10:46:22AM +1000, Dave Airlie wrote:
>> Hi,
>> 
>> So I've been growing more annoyed with the current layout of the drm
>> tree in the kernel,
>> 
>> a) it lives under char.
>> b) everything in one directory.
>> c) header files in one directory.
>> d) no header files exposed to userspace.
>> 
>> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdiff;h=7df9a948d0f849466e3de259cccb49bc54cbad68
>> 
>> is a proposal to create drivers/gpu/drm, (I may move AGP in there as
>> well later). It also creates per-driver subdirs.
>
>Like it.

You have Makefile content in a file called "Kconfig":


diff --git a/drivers/char/drm/Kconfig b/drivers/gpu/drm/Kconfig
similarity index 100%
rename from drivers/char/drm/Kconfig
drivers/gpu/drm/Kconfig
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
new file mode 100644 (file)
index
0000000000000000000000000000000000000000..3f50d8fb25b915d66aef74b175e49fbb1964d6b1
--- a/drivers/char/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -0,0 +1,27 @@
+#
+# Makefile for the drm device driver.  This driver provides support for the
+# Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
+
+EXTRA_CFLAGS = -Iinclude/drm
+drm-objs    := drm_auth.o drm_bufs.o drm_context.o drm_dma.o drm_drawable.o \
+               drm_drv.o drm_fops.o drm_ioctl.o drm_irq.o \
+               drm_lock.o drm_memory.o drm_proc.o drm_stub.o drm_vm.o \
+               drm_agpsupport.o drm_scatter.o ati_pcigart.o drm_pci.o \
+               drm_sysfs.o drm_hashtab.o drm_sman.o drm_mm.o
+
+ifeq ($(CONFIG_COMPAT),y)
+drm-objs    += drm_ioc32.o
+endif
+
+obj-$(CONFIG_DRM)      += drm.o
+obj-$(CONFIG_DRM_TDFX) += tdfx/
+obj-$(CONFIG_DRM_R128) += r128/
+obj-$(CONFIG_DRM_RADEON)+= radeon/
+obj-$(CONFIG_DRM_MGA)  += mga/
+obj-$(CONFIG_DRM_I810) += i810/
+obj-$(CONFIG_DRM_I830) += i830/
+obj-$(CONFIG_DRM_I915)  += i915/
+obj-$(CONFIG_DRM_SIS)   += sis/
+obj-$(CONFIG_DRM_SAVAGE)+= savage/
+obj-$(CONFIG_DRM_VIA)  +=via/
+

In fact, since this happened for lots of files, I pulled the repo
with git, and like I suspected, it seems to be a gitweb issue.
