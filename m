Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbXFILkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbXFILkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 07:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbXFILkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 07:40:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43774 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbXFILkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 07:40:13 -0400
Date: Sat, 09 Jun 2007 08:13:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes
Message-Id: <1181388473.3877.87.camel@gaivota>
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

For the following:

   - Fixes the V4L ABI breakage as reported on http://lkml.org/lkml/2007/5/14/42
	(required several changes on ivtv code);
   - A building fix for architectures where USB doesn't depend on PCI;
   - The Kconfig changes introduced some bugs, fixed on this series;
   - Fix ia64 printk format warnings;
   - Driver fixes on saa7111, cinergyt2, tda10086, tda82x, usbvision and 
	ivtv.

Cheers,
Mauro.

---

 drivers/media/common/Kconfig                   |    1 +
 drivers/media/dvb/b2c2/Makefile                |    7 +-
 drivers/media/dvb/cinergyT2/cinergyT2.c        |    3 +-
 drivers/media/dvb/frontends/tda10086.c         |   21 ++-
 drivers/media/dvb/frontends/tda826x.c          |    4 +-
 drivers/media/video/Kconfig                    |    2 +-
 drivers/media/video/ivtv/ivtv-cards.h          |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c         |    1 +
 drivers/media/video/ivtv/ivtv-driver.h         |   16 ++-
 drivers/media/video/ivtv/ivtv-fileops.c        |   16 ++
 drivers/media/video/ivtv/ivtv-ioctl.c          |   45 +++++-
 drivers/media/video/ivtv/ivtv-irq.c            |  204 ++++++++++++++++--------
 drivers/media/video/ivtv/ivtv-queue.c          |   31 +++-
 drivers/media/video/ivtv/ivtv-queue.h          |   39 ++++-
 drivers/media/video/ivtv/ivtv-streams.c        |    2 +-
 drivers/media/video/ivtv/ivtv-vbi.c            |    2 +-
 drivers/media/video/ivtv/ivtv-vbi.h            |    2 +-
 drivers/media/video/saa7111.c                  |   49 +++----
 drivers/media/video/usbvision/usbvision-core.c |   82 ++++++----
 drivers/media/video/usbvision/usbvision.h      |    1 -
 include/linux/videodev2.h                      |    7 +-
 21 files changed, 368 insertions(+), 169 deletions(-)

Andrew Morton (1):
      V4L/DVB (5699): Cinergyt2: fix file release handler

Hans Verkuil (6):
      V4L/DVB (5675): Move big PIO accesses from the interrupt handler to a workhandler
      V4L/DVB (5730): Remove unused V4L2_CAP_VIDEO_OUTPUT_POS
      V4L/DVB (5732): Add ivtv CROPCAP support and fix ivtv S_CROP for video output.
      V4L/DVB (5736): Add V4L2_FBUF_CAP/FLAG_LOCAL/GLOBAL_INV_ALPHA
      V4L/DVB (5673): Fix audio stuttering for saa711x/ivtv when in radio mode.
      V4L/DVB (5751): Ivtv: fix ia64 printk format warnings.

Mauro Carvalho Chehab (2):
      V4L/DVB (5702): Fix Kconfig items to avoid linkedition errors
      V4L/DVB (5761): Fix broken b2c2 dependency on non x86 architectures

Oliver Endriss (1):
      V4L/DVB (5716): Tda10086,tda826x: fix tuning, STR/SNR values

Russell King (1):
      V4L/DVB (5700): Saa7111: fix picture settings cache bug

Thierry Merle (1):
      V4L/DVB (5720): Usbvision: fix urb allocation and submits

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

