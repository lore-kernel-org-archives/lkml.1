Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbYC1AKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbYC1AKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbYC1AKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:10:34 -0400
Received: from mail.queued.net ([207.210.101.209]:1609 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756550AbYC1AKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:10:33 -0400
Date: Thu, 27 Mar 2008 20:11:15 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com
Subject: [PATCH 7/7] lxfb: disable suspend VT switch by default
Message-ID: <20080327201115.04dacac5@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By default disable VT switch, but allow it to be overridden via the
'vt_switch' module arg.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 Documentation/fb/lxfb.txt       |    2 ++
 drivers/video/geode/lxfb_core.c |    7 +++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/fb/lxfb.txt b/Documentation/fb/lxfb.txt
index dc501da..379d9c6 100644
--- a/Documentation/fb/lxfb.txt
+++ b/Documentation/fb/lxfb.txt
@@ -45,6 +45,8 @@ Accepted options:
 mode_option	- specify the video mode.  Of the form
 		  <x>x<y>[-<bpp>][@<refresh>]
 vram		- size of video ram (normally auto-detected)
+vt_switch	- enable vt switching during suspend/resume.  The vt
+		  switch is slow, but harmless.
 
 --
 Andres Salomon <dilinger@debian.org>
diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/geode/lxfb_core.c
index d0502a5..e290981 100644
--- a/drivers/video/geode/lxfb_core.c
+++ b/drivers/video/geode/lxfb_core.c
@@ -17,6 +17,7 @@
 #include <linux/console.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/suspend.h>
 #include <linux/delay.h>
 #include <linux/fb.h>
 #include <linux/init.h>
@@ -28,6 +29,7 @@
 static char *mode_option;
 static int noclear, nopanel, nocrt;
 static int vram;
+static int vt_switch;
 
 /* Most of these modes are sorted in ascending order, but
  * since the first entry in this table is the "default" mode,
@@ -526,6 +528,8 @@ static int __init lxfb_probe(struct pci_dev *pdev,
 	lxfb_check_var(&info->var, info);
 	lxfb_set_par(info);
 
+	pm_set_vt_switch(vt_switch);
+
 	if (register_framebuffer(info) < 0) {
 		ret = -EINVAL;
 		goto err;
@@ -653,5 +657,8 @@ MODULE_PARM_DESC(mode_option, "video mode (<x>x<y>[-<bpp>][@<refr>])");
 module_param(vram, int, 0);
 MODULE_PARM_DESC(vram, "video memory size");
 
+module_param(vt_switch, int, 0);
+MODULE_PARM_DESC(vt_switch, "enable VT switch during suspend/resume");
+
 MODULE_DESCRIPTION("Framebuffer driver for the AMD Geode LX");
 MODULE_LICENSE("GPL");
-- 
1.5.3.7

