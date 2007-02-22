Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbXBVWuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbXBVWuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 17:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbXBVWux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 17:50:53 -0500
Received: from lx1.pxnet.com ([195.227.45.3]:60186 "EHLO lx1.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbXBVWux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 17:50:53 -0500
Date: Thu, 22 Feb 2007 23:49:19 +0100
Message-Id: <200702222249.l1MMnJte016266@lx1.pxnet.com>
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH] drivers/isdn/gigaset: build asyncdata.o into the gigaset module (fix)
To: Andrew Morton <akpm@osdl.org>, Karsten Keil <kkeil@suse.de>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i4ldeveloper@listserv.isdn4linux.de
CC: Hansjoerg Lipp <hjlipp@web.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

a) Remove #define acrobatics that have become unnecessary by
the move of asyncdata.o into the common part.

b) Correct the rule for building the common part into the kernel when
some or all hardware specific parts are built as modules.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>

---

This patch applies to 2.6.20-rc1. It is the delta between Adrian Bunk's
[PATCH] drivers/isdn/gigaset/: build asyncdata.o into the gigaset module
which has already been merged, and my
[PATCH] drivers/isdn/gigaset: build asyncdata.o into the gigaset module (v2)
which came too late to replace it. Please merge.

 Makefile    |    9 +++++----
 asyncdata.c |    5 -----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff -purX linux-2.6.20-work/Documentation/dontdiff linux-2.6.21-rc1-orig/drivers/isdn/gigaset/asyncdata.c linux-2.6.21-rc1-work/drivers/isdn/gigaset/asyncdata.c
--- linux-2.6.21-rc1-orig/drivers/isdn/gigaset/asyncdata.c	2007-02-22 23:15:53.000000000 +0100
+++ linux-2.6.21-rc1-work/drivers/isdn/gigaset/asyncdata.c	2007-02-21 13:27:40.000000000 +0100
@@ -13,11 +13,6 @@
  * =====================================================================
  */
 
-/* not set by Kbuild when building both ser_gigaset and usb_gigaset */
-#ifndef KBUILD_MODNAME
-#define KBUILD_MODNAME "asy_gigaset"
-#endif
-
 #include "gigaset.h"
 #include <linux/crc-ccitt.h>
 #include <linux/bitrev.h>
diff -purX linux-2.6.20-work/Documentation/dontdiff linux-2.6.21-rc1-orig/drivers/isdn/gigaset/Makefile linux-2.6.21-rc1-work/drivers/isdn/gigaset/Makefile
--- linux-2.6.21-rc1-orig/drivers/isdn/gigaset/Makefile	2007-02-22 23:15:53.000000000 +0100
+++ linux-2.6.21-rc1-work/drivers/isdn/gigaset/Makefile	2007-02-21 13:25:47.000000000 +0100
@@ -1,8 +1,9 @@
 gigaset-y := common.o interface.o proc.o ev-layer.o i4l.o asyncdata.o
 usb_gigaset-y := usb-gigaset.o
-bas_gigaset-y := bas-gigaset.o isocdata.o
 ser_gigaset-y := ser-gigaset.o
+bas_gigaset-y := bas-gigaset.o isocdata.o
 
-obj-$(CONFIG_GIGASET_M105) += usb_gigaset.o gigaset.o
-obj-$(CONFIG_GIGASET_BASE) += bas_gigaset.o gigaset.o
-obj-$(CONFIG_GIGASET_M101) += ser_gigaset.o gigaset.o
+obj-$(CONFIG_ISDN_DRV_GIGASET) += gigaset.o
+obj-$(CONFIG_GIGASET_M105) += usb_gigaset.o
+obj-$(CONFIG_GIGASET_BASE) += bas_gigaset.o
+obj-$(CONFIG_GIGASET_M101) += ser_gigaset.o
