Return-Path: <linux-kernel-owner+w=401wt.eu-S1760908AbYBYALU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908AbYBYALU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYBYAJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:09:07 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44538 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170AbYBYAJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:09:06 -0500
Date: Mon, 25 Feb 2008 02:08:10 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       mchehab@infradead.org
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] VIDEO_VIVI must depend on VIDEO_DEV
Message-ID: <20080225000810.GI2088@cs181133002.pp.htv.fi>
References: <200802241433.30383.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802241433.30383.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error with
VIDEO_VIVI=y, VIDEO_DEV=m reported by Toralf Förster:

<--  snip  -->

...
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `vivi_release':
vivi.c:(.text+0x322f5): undefined reference to `video_unregister_device'
vivi.c:(.text+0x32337): undefined reference to `video_device_release'
drivers/built-in.o: In function `vivi_open':
vivi.c:(.text+0x32845): undefined reference to `v4l2_type_names'
drivers/built-in.o: In function `vivi_init':
vivi.c:(.init.text+0x1d20): undefined reference to `video_device_alloc'
vivi.c:(.init.text+0x1d48): undefined reference to `video_register_device'
drivers/built-in.o:(.rodata+0x1b40): undefined reference to 
`video_ioctl2'drivers/built-in.o:(.data+0x140c): undefined reference to 
`video_device_release'
make: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
0985a480a30ce903211cf285f543e4929007ef95 diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 37072a2..2c292ee 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -382,7 +382,7 @@ endmenu # encoder / decoder chips
 
 config VIDEO_VIVI
 	tristate "Virtual Video Driver"
-	depends on VIDEO_V4L2 && !SPARC32 && !SPARC64
+	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
 	select VIDEOBUF_VMALLOC
 	default n
 	---help---

