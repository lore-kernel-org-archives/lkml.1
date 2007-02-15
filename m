Return-Path: <linux-kernel-owner+w=401wt.eu-S1161450AbXBOV4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161450AbXBOV4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161448AbXBOV4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:56:33 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58053 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161450AbXBOV4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:56:32 -0500
Date: Thu, 15 Feb 2007 22:56:38 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Tilman Schmidt <tilman@imap.cc>, Hansjoerg Lipp <hjlipp@web.de>
Cc: gigaset307x-common@lists.sourceforge.net, kkeil@suse.de,
       kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/isdn/gigaset/: build asyncdata.o into the gigaset module
Message-ID: <20070215215638.GI13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error:

<--  snip  -->

...
  LD      drivers/isdn/gigaset/built-in.o
drivers/isdn/gigaset/ser_gigaset.o: In function `gigaset_m10x_send_skb':
(.text+0xe50): multiple definition of `gigaset_m10x_send_skb'
drivers/isdn/gigaset/usb_gigaset.o:(.text+0x0): first defined here
drivers/isdn/gigaset/ser_gigaset.o: In function `gigaset_m10x_input':
(.text+0x1121): multiple definition of `gigaset_m10x_input'
drivers/isdn/gigaset/usb_gigaset.o:(.text+0x2d1): first defined here
make[4]: *** [drivers/isdn/gigaset/built-in.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/isdn/gigaset/Makefile    |    6 +++---
 drivers/isdn/gigaset/asyncdata.c |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

--- linux-2.6.20-mm1/drivers/isdn/gigaset/Makefile.old	2007-02-15 19:35:30.000000000 +0100
+++ linux-2.6.20-mm1/drivers/isdn/gigaset/Makefile	2007-02-15 19:35:46.000000000 +0100
@@ -1,7 +1,7 @@
-gigaset-y := common.o interface.o proc.o ev-layer.o i4l.o
-usb_gigaset-y := usb-gigaset.o asyncdata.o
+gigaset-y := common.o interface.o proc.o ev-layer.o i4l.o asyncdata.o
+usb_gigaset-y := usb-gigaset.o
 bas_gigaset-y := bas-gigaset.o isocdata.o
-ser_gigaset-y := ser-gigaset.o asyncdata.o
+ser_gigaset-y := ser-gigaset.o
 
 obj-$(CONFIG_GIGASET_M105) += usb_gigaset.o gigaset.o
 obj-$(CONFIG_GIGASET_BASE) += bas_gigaset.o gigaset.o
--- linux-2.6.20-mm1/drivers/isdn/gigaset/asyncdata.c.old	2007-02-15 19:36:14.000000000 +0100
+++ linux-2.6.20-mm1/drivers/isdn/gigaset/asyncdata.c	2007-02-15 19:37:08.000000000 +0100
@@ -444,6 +444,7 @@
 		atomic_set(&inbuf->head, head);
 	}
 }
+EXPORT_SYMBOL_GPL(gigaset_m10x_input);
 
 
 /* == data output ========================================================== */
@@ -591,3 +592,4 @@
 
 	return len;	/* ok so far */
 }
+EXPORT_SYMBOL_GPL(gigaset_m10x_send_skb);

