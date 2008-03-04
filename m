Return-Path: <linux-kernel-owner+w=401wt.eu-S933340AbYCDWmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340AbYCDWmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 17:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759493AbYCDWmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 17:42:25 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46292 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759365AbYCDWmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 17:42:24 -0500
Date: Wed, 5 Mar 2008 00:39:58 +0200
From: Adrian Bunk <adrian.bunk@movial.fi>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sh_ksyms_32.c update for gcc 4.3
Message-ID: <20080304223958.GA2136@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error with landisk_defconfig when 
using gcc 4.3:

<--  snip  -->

...
  MODPOST 50 modules
ERROR: "__udivsi3_i4i" [net/sunrpc/sunrpc.ko] undefined!
ERROR: "__udivsi3_i4i" [net/appletalk/appletalk.ko] undefined!
ERROR: "__udivsi3_i4i" [fs/ufs/ufs.ko] undefined!
ERROR: "__udivsi3_i4i" [fs/ntfs/ntfs.ko] undefined!
ERROR: "__sdivsi3_i4i" [fs/ntfs/ntfs.ko] undefined!
ERROR: "__udivsi3_i4i" [fs/nfsd/nfsd.ko] undefined!
ERROR: "__sdivsi3_i4i" [fs/nfsd/nfsd.ko] undefined!
ERROR: "__udivsi3_i4i" [fs/nfs/nfs.ko] undefined!
ERROR: "__udivsi3_i4i" [fs/lockd/lockd.ko] undefined!
ERROR: "__udivsi3_i4i" [drivers/usb/storage/usb-storage.ko] undefined!
ERROR: "__sdivsi3_i4i" [drivers/usb/serial/pl2303.ko] undefined!
ERROR: "__udivsi3_i4i" [drivers/usb/serial/pl2303.ko] undefined!
ERROR: "__sdivsi3_i4i" [drivers/usb/serial/ftdi_sio.ko] undefined!
ERROR: "__udivsi3_i4i" [drivers/usb/misc/sisusbvga/sisusbvga.ko] undefined!
ERROR: "__sdivsi3_i4i" [drivers/usb/misc/sisusbvga/sisusbvga.ko] undefined!
ERROR: "__udivsi3_i4i" [drivers/media/video/v4l1-compat.ko] undefined!
ERROR: "__sdivsi3_i4i" [drivers/media/video/v4l1-compat.ko] undefined!
ERROR: "__sdivsi3_i4i" [drivers/media/video/usbvideo/vicam.ko] undefined!
ERROR: "__udivsi3_i4i" [drivers/media/video/usbvideo/usbvideo.ko] undefined!
ERROR: "__sdivsi3_i4i" [drivers/media/video/usbvideo/usbvideo.ko] undefined!
ERROR: "__udivsi3_i4i" [drivers/media/video/sn9c102/sn9c102.ko] undefined!
ERROR: "__sdivsi3_i4i" [drivers/media/video/sn9c102/sn9c102.ko] undefined!
ERROR: "__sdivsi3_i4i" [drivers/media/video/se401.ko] undefined!
ERROR: "__sdivsi3_i4i" [drivers/media/video/pwc/pwc.ko] undefined!
ERROR: "__udivsi3_i4i" [drivers/md/raid0.ko] undefined!
ERROR: "__udivsi3_i4i" [drivers/md/md-mod.ko] undefined!
ERROR: "__sdivsi3_i4i" [drivers/md/md-mod.ko] undefined!
ERROR: "__udivsi3_i4i" [drivers/md/linear.ko] undefined!
ERROR: "__sdivsi3_i4i" [drivers/hid/usbhid/usbhid.ko] undefined!
make[2]: *** [__modpost] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

---
d8726fd3d9224aaf1000054f32438f03d6e1a915 foobar
diff --git a/arch/sh/kernel/sh_ksyms_32.c b/arch/sh/kernel/sh_ksyms_32.c
index e1a6de9..a12f115 100644
--- a/arch/sh/kernel/sh_ksyms_32.c
+++ b/arch/sh/kernel/sh_ksyms_32.c
@@ -111,9 +111,9 @@ DECLARE_EXPORT(__movmem_i4_even);
 DECLARE_EXPORT(__movmem_i4_odd);
 DECLARE_EXPORT(__movmemSI12_i4);
 
-#if (__GNUC_MINOR__ == 2 || defined(__GNUC_STM_RELEASE__))
+#if (__GNUC_MINOR__ >= 2 || defined(__GNUC_STM_RELEASE__))
 /*
- * GCC 4.2 emits these for division, as do GCC 4.1.x versions of the ST
+ * GCC >= 4.2 emits these for division, as do GCC 4.1.x versions of the ST
  * compiler which include backported patches.
  */
 DECLARE_EXPORT(__sdivsi3_i4i);

