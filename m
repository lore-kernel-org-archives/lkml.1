Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbYEPHKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbYEPHKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 03:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbYEPHKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 03:10:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51198 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbYEPHKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 03:10:40 -0400
Date: Fri, 16 May 2008 09:10:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [patch] drivers/media/video build fix for certain modular builds
Message-ID: <20080516071029.GA13147@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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


testing of the -tip tree found the following missing symbols build bug:

    LD      init/built-in.o
    LD      .tmp_vmlinux1
    drivers/built-in.o: In function `vidioc_g_ctrl':
    radio-maxiradio.c:(.text+0xd3337): undefined reference to `video_devdata'
    drivers/built-in.o: In function `vidioc_g_frequency':
    radio-maxiradio.c:(.text+0xd3368): undefined reference to `video_devdata'
    drivers/built-in.o: In function `vidioc_s_ctrl':
    [...]

which happens if certain media drivers are modular:

    http://redhat.com/~mingo/misc/config-Thu_May_15_18_10_27_CEST_2008.bad

the problem is:

    CONFIG_VIDEO_MEDIA=m
    CONFIG_VIDEO_DEV=y
    CONFIG_RADIO_MAXIRADIO=y
    CONFIG_VIDEO_V4L2=y

Connecting the build dependencies tree from drivers/media/ to 
drivers/media/video/ allows the built-in drivers(s) to pick up the 
CONFIG_VIDEO_DEV=y symbols.

---
 drivers/media/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/media/Makefile
===================================================================
--- linux.orig/drivers/media/Makefile
+++ linux/drivers/media/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
-obj-y := common/
+obj-y := common/ video/
 
 obj-$(CONFIG_VIDEO_MEDIA) += common/
 
