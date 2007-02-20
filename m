Return-Path: <linux-kernel-owner+w=401wt.eu-S965581AbXBTALI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965581AbXBTALI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:11:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbXBTAIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:08:14 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36142 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965600AbXBTAIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:08:01 -0500
Date: Tue, 20 Feb 2007 01:08:00 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, adaplas@pol.net
Subject: [-mm patch] drivers/video/sm501fb.c: make 4 functions static
Message-ID: <20070220000800.GH13958@stusta.de>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 09:51:46PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-mm1:
>...
> +fb-sm501-framebuffer-driver-5.patch
>...
>  fbdev updates
>...


This patch makes four needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/video/sm501fb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.20-mm2/drivers/video/sm501fb.c.old	2007-02-19 12:15:43.000000000 +0100
+++ linux-2.6.20-mm2/drivers/video/sm501fb.c	2007-02-19 12:16:48.000000000 +0100
@@ -136,8 +136,8 @@
 #define SM501_MEMF_CRT			(4)
 #define SM501_MEMF_ACCEL		(8)
 
-int sm501_alloc_mem(struct sm501fb_info *inf, struct sm501_mem *mem,
-		    unsigned int why, size_t size)
+static int sm501_alloc_mem(struct sm501fb_info *inf, struct sm501_mem *mem,
+			   unsigned int why, size_t size)
 {
 	unsigned int ptr = 0;
 
@@ -926,7 +926,7 @@
  * set or change the hardware cursor parameters
 */
 
-int sm501fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
+static int sm501fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 {
 	struct sm501fb_par  *par = info->par;
 	struct sm501fb_info *fbi = par->info;
@@ -1225,7 +1225,7 @@
  * initialise hw cursor parameters
 */
 
-int sm501_init_cursor(struct fb_info *fbi, unsigned int reg_base)
+static int sm501_init_cursor(struct fb_info *fbi, unsigned int reg_base)
 {
 	struct sm501fb_par *par = fbi->par;
 	struct sm501fb_info *info = par->info;
@@ -1768,7 +1768,7 @@
 	},
 };
 
-int __devinit sm501fb_init(void)
+static int __devinit sm501fb_init(void)
 {
 	return platform_driver_register(&sm501fb_driver);
 }

