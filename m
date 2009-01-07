Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbZAGXxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbZAGXxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbZAGXx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:53:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55070 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbZAGXxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:53:25 -0500
Date: Wed, 7 Jan 2009 21:52:52 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES for 2.6.29] V4L/DVB fixes
Message-ID: <20090107215252.6e843e29@pedra.chehab.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For the following changes (mostly fixes):

   - switch remaining clear_user_page users over to clear_user_highpage,
     in order to compile some drivers on non x86_64 archs;
   - pxa-camera: fix redefinition warnings and missing DMA definitions;
   - tda8290: fix TDA8290 + TDA18271 initialization;
   - two Kbuild fixes (for dm1105 and cx88);
   - update MAINTAINERS entries on media drivers, due to the ML change 
     to vger.kernel.org;
   - some sparse warnings/error fixes;
   - use negated usb_endpoint_xfer_control, etc.

Cheers,
Mauro.

---

 MAINTAINERS                                     |   65 ++++++++++------
 drivers/media/common/tuners/tda8290.c           |    6 +-
 drivers/media/dvb/dm1105/Kconfig                |    1 +
 drivers/media/dvb/dvb-core/dvb_frontend.c       |   26 ++++---
 drivers/media/dvb/dvb-usb/anysee.c              |    2 +-
 drivers/media/dvb/frontends/cx24116.c           |    2 +-
 drivers/media/dvb/frontends/stb0899_algo.c      |    4 +-
 drivers/media/dvb/frontends/stb0899_drv.c       |    6 +-
 drivers/media/dvb/ttpci/budget-ci.c             |    2 +-
 drivers/media/video/cx88/Kconfig                |    5 +
 drivers/media/video/cx88/Makefile               |    3 +-
 drivers/media/video/cx88/cx88-dvb.c             |   46 +++++++++++
 drivers/media/video/cx88/cx88-i2c.c             |   24 +-----
 drivers/media/video/cx88/cx88-mpeg.c            |   30 +------
 drivers/media/video/cx88/cx88.h                 |    4 +-
 drivers/media/video/em28xx/em28xx-cards.c       |    5 +-
 drivers/media/video/em28xx/em28xx-core.c        |    2 +-
 drivers/media/video/em28xx/em28xx-input.c       |    2 +-
 drivers/media/video/gspca/m5602/m5602_s5k83a.c  |    2 +-
 drivers/media/video/pxa_camera.c                |    4 +-
 drivers/media/video/pxa_camera.h                |   95 -----------------------
 drivers/media/video/usbvideo/ibmcam.c           |    2 +-
 drivers/media/video/usbvideo/konicawc.c         |    2 +-
 drivers/media/video/usbvideo/ultracam.c         |    2 +-
 drivers/media/video/usbvision/usbvision-video.c |    3 +-
 drivers/media/video/v4l2-device.c               |    4 +-
 drivers/media/video/videobuf-dma-sg.c           |    3 +-
 drivers/staging/go7007/go7007-v4l2.c            |    3 +-
 28 files changed, 148 insertions(+), 207 deletions(-)
 delete mode 100644 drivers/media/video/pxa_camera.h

Eric Miao (1):
      V4L/DVB (10176b): pxa-camera: fix redefinition warnings and missing DMA definitions

Guennadi Liakhovetski (1):
      V4L/DVB (10176a): Switch remaining clear_user_page users over to clear_user_highpage

Julia Lawall (1):
      V4L/DVB (10185): Use negated usb_endpoint_xfer_control, etc

Mauro Carvalho Chehab (8):
      V4L/DVB (10177): Fix sparse warnings on em28xx
      V4L/DVB (10178): dvb_frontend: Fix some sparse warnings due to static symbols
      V4L/DVB (10179): tda8290: Fix two sparse warnings
      V4L/DVB (10180): drivers/media: Fix a number of sparse warnings
      V4L/DVB (10181): v4l2-device: Fix some sparse warnings
      V4L/DVB (10189): dm1105: Fix build with INPUT=m and DVB_DM1105=y
      V4L/DVB (10190): cx88: Fix some Kbuild troubles
      V4L/DVB (10191a): Update MAINTAINERS entries on media drivers

Michael Krufky (1):
      V4L/DVB (10182): tda8290: fix TDA8290 + TDA18271 initialization

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
