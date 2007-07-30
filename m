Return-Path: <linux-kernel-owner+w=401wt.eu-S934214AbXG3TY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214AbXG3TY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbXG3TYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:24:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51356 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbXG3TYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:24:50 -0400
Date: Mon, 30 Jul 2007 16:15:14 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes
Message-Id: <1185823468.8997.91.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For some fixes at V4L/DVB drivers:

   - zr36067: proper standard handling, proper raw capture, fix at 
     poll(), V4L2 API compliance for image size and video formats;
   - bttv: fix for Viewcast Osprey 440;
   - usbvision: fix a regression caused by [sg]_register functions;
   - ivtv: fix pause/continue/play handling, mailbox responsiveness, 
     TV-out VBI handling, and reports fw size correcltly;
   - Af9005: fix tuner module unload and fixes error checking;
   - dvb-pll: make struct dvb_pll_fcv1236d static

Also, one fix at a DVB API header:
   - video.h: fix includes for userspace;

Cheers,
Mauro.

---

 drivers/media/dvb/dvb-usb/af9005-fe.c           |   47 ++---
 drivers/media/dvb/frontends/dvb-pll.c           |    2 +-
 drivers/media/video/bt8xx/bttv-cards.c          |  238 +++++++++++++----------
 drivers/media/video/ivtv/ivtv-driver.h          |    1 +
 drivers/media/video/ivtv/ivtv-fileops.c         |   10 +
 drivers/media/video/ivtv/ivtv-firmware.c        |    2 +-
 drivers/media/video/ivtv/ivtv-ioctl.c           |   11 +-
 drivers/media/video/ivtv/ivtv-mailbox.c         |   14 +-
 drivers/media/video/ivtv/ivtv-streams.c         |   11 +-
 drivers/media/video/usbvision/usbvision-video.c |    5 +-
 drivers/media/video/zoran.h                     |    5 +
 drivers/media/video/zoran_device.c              |   50 ++----
 drivers/media/video/zoran_driver.c              |  233 +++++++++++++----------
 include/linux/dvb/video.h                       |    1 +
 sound/pci/bt87x.c                               |    2 +
 15 files changed, 343 insertions(+), 289 deletions(-)

Adrian Bunk (2):
      V4L/DVB (5933): Dvb-usb/af9005-fe.c: error check fixes
      V4L/DVB (5939): dvb-pll: make struct dvb_pll_fcv1236d static

Anssi Hannula (1):
      V4L/DVB (5893): DVB: fix includes of video.h when __KERNEL__ is undefined

Hans Verkuil (4):
      V4L/DVB (5916): ivtv: fix pause/continue/play handling
      V4L/DVB (5917): ivtv: improve mailbox responsiveness.
      V4L/DVB (5918): ivtv: fix TV-out VBI handling, only reset on last close.
      V4L/DVB (5920): ivtv: fix incorrect fw size report.

Luca Olivetti (1):
      V4L/DVB (5932): Af9005 fix tuner module unload

Trent Piepho (7):
      V4L/DVB (5886): zr36067: Fix problem setting norms
      V4L/DVB (5887): zr36067: Fix poll() operation
      V4L/DVB (5888): zr36067: Driver was not returning correct image size
      V4L/DVB (5890): zr36067: Add UYVY, RGB555X, RGB565X, and RGB32 formats
      V4L/DVB (5891): zr36067: Turn off raw capture properly
      V4L/DVB (5899): bttv: Fix Viewcast Osprey 440 support
      V4L/DVB (5900): usbvision: fix bugs [sg]_register functions

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

