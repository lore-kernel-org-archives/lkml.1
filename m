Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbYD3Jul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbYD3Jul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbYD3Jub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:50:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34463 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163AbYD3Jua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:50:30 -0400
Date: Wed, 30 Apr 2008 11:50:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: [patch, -git] fix drivers/media/common/tuners/ build bug
Message-ID: <20080430095011.GA3993@elte.hu>
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


x86.git randconfig testing found a build failure on latest -git:

 drivers/built-in.o: In function `set_type':
 tuner-core.c:(.text+0x2a9a26): undefined reference to `tea5761_attach'
 tuner-core.c:(.text+0x2a9d05): undefined reference to `tda9887_attach'
 tuner-core.c:(.text+0x2a9d51): undefined reference to `xc2028_attach'
 tuner-core.c:(.text+0x2a9e22): undefined reference to `tda829x_attach'
 tuner-core.c:(.text+0x2a9e3f): undefined reference to `microtune_attach'
 drivers/built-in.o: In function `tuner_probe':
 tuner-core.c:(.text+0x2aa18a): undefined reference to `tda829x_probe'
 tuner-core.c:(.text+0x2aa302): undefined reference to `tea5761_autodetection'

with the following config:

 http://redhat.com/~mingo/misc/config-Wed_Apr_30_10_21_40_CEST_2008.bad

the problem is caused by the drivers/media/common/tuners/ subdirectory
not being part of the kbuild hierarchy anymore, due to commit
7c91f0624 ("V4L/DVB(7767): Move tuners to common/tuners").

this seems similar to the problem also reported by Mike Galbraith.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/common/Makefile |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/media/common/Makefile
===================================================================
--- linux.orig/drivers/media/common/Makefile
+++ linux/drivers/media/common/Makefile
@@ -2,6 +2,7 @@ saa7146-objs    := saa7146_i2c.o saa7146
 saa7146_vv-objs := saa7146_fops.o saa7146_video.o saa7146_hlp.o saa7146_vbi.o
 ir-common-objs  := ir-functions.o ir-keymaps.o
 
+obj-y += tuners/
 obj-$(CONFIG_VIDEO_SAA7146) += saa7146.o
 obj-$(CONFIG_VIDEO_SAA7146_VV) += saa7146_vv.o
 obj-$(CONFIG_VIDEO_IR) += ir-common.o
