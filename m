Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbXHNVWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbXHNVWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbXHNVWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:22:00 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38387 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753075AbXHNVV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:21:59 -0400
Date: Tue, 14 Aug 2007 23:21:50 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Antonino Daplas <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make pm3fb_init() static again
Message-ID: <20070814212150.GS18945@stusta.de>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 11:09:32PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc1-mm1:
>...
> +pm3fb-mtrr-support-and-noaccel-option.patch
>...
>  fbdev updates
>...

pm3fb_init() needlessly became global.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/video/pm3fb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

9d0fd36d6429c19ac4377c19172d021b3aaa52e8 
diff --git a/drivers/video/pm3fb.c b/drivers/video/pm3fb.c
index 3f004e8..195bcdb 100644
--- a/drivers/video/pm3fb.c
+++ b/drivers/video/pm3fb.c
@@ -798,8 +798,6 @@ static void pm3fb_write_mode(struct fb_info *info)
 /*
  * hardware independent functions
  */
-int pm3fb_init(void);
-
 static int pm3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	u32 lpitch;
@@ -1419,7 +1417,7 @@ static int __init pm3fb_setup(char *options)
 }
 #endif /* MODULE */
 
-int __init pm3fb_init(void)
+static int __init pm3fb_init(void)
 {
 	/*
 	 *  For kernel boot options (in 'video=pm3fb:<options>' format)

