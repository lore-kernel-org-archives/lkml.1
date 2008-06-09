Return-Path: <linux-kernel-owner+w=401wt.eu-S1762070AbYFIW2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762070AbYFIW2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760663AbYFIWZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:25:13 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54033 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760523AbYFIWZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:25:10 -0400
Date: Tue, 10 Jun 2008 01:24:16 +0300
From: Adrian Bunk <bunk@kernel.org>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] drivers/video/amifb.c cleanups
Message-ID: <20080609222416.GU1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the needlessly global amifb_init() static
- rename cleanup_module() to amifb_exit(),
  make it static __exit,
  use module_exit(),
  there's no need to #ifdef MODULE it

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/video/amifb.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

65ed788eed9849172f7dcf0522a4794e5ef3d804 diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index 05a328c..6dea095 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -1136,7 +1136,6 @@ static int amifb_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg
 	 * Interface to the low level console driver
 	 */
 
-int amifb_init(void);
 static void amifb_deinit(void);
 
 	/*
@@ -2245,7 +2244,7 @@ static inline void chipfree(void)
 	 * Initialisation
 	 */
 
-int __init amifb_init(void)
+static int __init amifb_init(void)
 {
 	int tag, i, err = 0;
 	u_long chipptr;
@@ -3787,16 +3786,14 @@ static void ami_rebuild_copper(void)
 	}
 }
 
-
-module_init(amifb_init);
-
-#ifdef MODULE
-MODULE_LICENSE("GPL");
-
-void cleanup_module(void)
+static void __exit amifb_exit(void)
 {
 	unregister_framebuffer(&fb_info);
 	amifb_deinit();
 	amifb_video_off();
 }
-#endif /* MODULE */
+
+module_init(amifb_init);
+module_exit(amifb_exit);
+
+MODULE_LICENSE("GPL");

