Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbYECTvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbYECTvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYECTvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:51:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57472 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbYECTvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:51:08 -0400
Date: Sat, 3 May 2008 21:50:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [patch] video: build fix for drivers/media/video/mt9v022.c
Message-ID: <20080503195054.GD25097@elte.hu>
References: <20080503163058.GA15272@elte.hu> <Pine.LNX.4.64.0805031853180.5182@axis700.grange> <20080503175807.GC5292@elte.hu> <Pine.LNX.4.64.0805032004130.5182@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805032004130.5182@axis700.grange>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Ok, right, sorry, the patch was indeed correct, just the reason for 
> the compilation breakage was not quite what you suggested. So, I'll 
> apply your putch, but please fix mt9m001.c in the same patch too - it 
> also includes gpio.h conditionally. Although, it does test the correct 
> macro.
> 
> Actually, this CONFIG option might disappear completely in the future, 
> if we decide to switch to a module parameter instead. So that one 
> kernel can be used on systems with and without the GPIO.

ok - untested patch for mt9m001.c attached.

	Ingo

Index: linux/drivers/media/video/mt9m001.c
===================================================================
--- linux.orig/drivers/media/video/mt9m001.c
+++ linux/drivers/media/video/mt9m001.c
@@ -12,15 +12,12 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/log2.h>
+#include <linux/gpio.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
 
-#ifdef CONFIG_MT9M001_PCA9536_SWITCH
-#include <asm/gpio.h>
-#endif
-
 /* mt9m001 i2c address 0x5d
  * The platform has to define i2c_board_info
  * and call i2c_register_board_info() */
