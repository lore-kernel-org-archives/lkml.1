Return-Path: <linux-kernel-owner+w=401wt.eu-S1763152AbYD3MFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763152AbYD3MFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759639AbYD3MFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:05:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50397 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759643AbYD3MFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:05:32 -0400
Date: Wed, 30 Apr 2008 14:05:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [patch, -git] media/video/sound build fix, TEA5761/TEA5767
Message-ID: <20080430120509.GA30596@elte.hu>
References: <20080430110115.GA5633@elte.hu> <s5hiqxzwqak.wl%tiwai@suse.de> <20080430111516.GA9954@elte.hu> <20080430111803.GA11628@elte.hu> <20080430112138.GA11844@elte.hu> <s5hej8nwo4x.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hej8nwo4x.wl%tiwai@suse.de>
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


* Takashi Iwai <tiwai@suse.de> wrote:

> >  	default SND_FM801
> > +	select VIDEO_V4L1_COMPAT
> >  
> >  config SND_HDA_INTEL
> >  	tristate "Intel HD Audio"
> 
> This one shouldn't be needed with my patch.

ok, removed it, we'll see.

I also have the one below, of similar pattern. (so it's 8 fixlets, 
otherwise it's a vanilla kernel in this area)

	Ingo

--------------->
Subject: video: STKWEBCAM fixes
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Apr 29 15:11:29 CEST 2008

x86.git randconfig testing found these build bugs in -git:

 drivers/media/video/stk-webcam.c: In function 'stk_create_sysfs_files':
 drivers/media/video/stk-webcam.c:340: error: implicit declaration of function 'video_device_create_file'
 drivers/media/video/stk-webcam.c: In function 'stk_remove_sysfs_files':
 [...]
 drivers/media/video/stk-webcam.c: In function 'v4l_stk_mmap':
 drivers/media/video/stk-webcam.c:846: error: 'VM_WRITE' undeclared (first use in this function)
 [...]

config at:

  http://redhat.com/~mingo/misc/config-Tue_Apr_29_15_00_47_CEST_2008.bad

the reason was a missing include file, and a dependency on a deprecated
(but still in use) VIDEO_V4L1_COMPAT API.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/video/Kconfig      |    1 +
 drivers/media/video/stk-webcam.c |    1 +
 2 files changed, 2 insertions(+)

Index: linux/drivers/media/video/Kconfig
===================================================================
--- linux.orig/drivers/media/video/Kconfig
+++ linux/drivers/media/video/Kconfig
@@ -883,6 +883,7 @@ config USB_ZR364XX
 config USB_STKWEBCAM
 	tristate "USB Syntek DC1125 Camera support"
 	depends on VIDEO_V4L2 && EXPERIMENTAL
+	select VIDEO_V4L1_COMPAT
 	---help---
 	  Say Y here if you want to use this type of camera.
 	  Supported devices are typically found in some Asus laptops,
Index: linux/drivers/media/video/stk-webcam.c
===================================================================
--- linux.orig/drivers/media/video/stk-webcam.c
+++ linux/drivers/media/video/stk-webcam.c
@@ -28,6 +28,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/kref.h>
+#include <linux/mm.h>
 
 #include <linux/usb.h>
 #include <linux/vmalloc.h>

