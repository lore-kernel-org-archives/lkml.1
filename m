Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbYJED1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbYJED1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 23:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYJED1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 23:27:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45822 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbYJED1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 23:27:18 -0400
Date: Sun, 5 Oct 2008 00:27:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES for 2.6.27] V4L/DVB fixes
Message-ID: <20081005002701.31a2ee5f@pedra.chehab.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
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
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git fixes

For a series of trivial fixes:

   - Several trivial fixes at gspca;
   - Several memory leak fixes at wm8739, w9968cf, em28xx-audio, cpia_usb,
     ov511, gspca;
   - pvrusb2: Add support for a missing USB ID;
   - cx88: add missing unlock_kernel;
   - ov511: fix exposure sysfs attribute bug;
   - cx18: Fix tuner audio input for Compro H900 cards;
   - em28xx: Remove duplicate entry, fix detection of Kworld 310u;
   - em28xx-alsa: fix clicking;
   - bttv: Prevent NULL pointer dereference in radio_open;
   - zr36067: several API non-conformance fixes;
   - drivers/media/video/cafe_ccic.c needs mm.h
   - s2255drv field count fix;
   - Use correct XC3028L firmware for AMD ATI TV Wonder 600 to avoid overheating;
   - sms1xxx: fix product name for Hauppauge and add proper USB ID for WinTV MiniStick;
   - Fix deadlock in demux code;
   - Fix support for Hauppauge Nova-S SE;
   - S5H1420: Fix size of shadow-array to avoid overflow;
   - fix buffer overflow in uvc-video.

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.em28xx     |    2 +-
 Documentation/video4linux/gspca.txt           |    1 +
 drivers/media/common/tuners/tuner-xc2028.h    |    1 +
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c     |    1 +
 drivers/media/dvb/dvb-core/dmxdev.c           |   16 ++++---
 drivers/media/dvb/dvb-core/dvb_demux.c        |   16 +++++---
 drivers/media/dvb/frontends/s5h1420.c         |   11 +++--
 drivers/media/dvb/frontends/s5h1420.h         |    8 ++-
 drivers/media/dvb/siano/sms-cards.c           |    4 +-
 drivers/media/video/bt8xx/bttv-driver.c       |    2 +-
 drivers/media/video/cafe_ccic.c               |    1 +
 drivers/media/video/cpia2/cpia2_usb.c         |    5 ++-
 drivers/media/video/cx18/cx18-cards.c         |    2 +-
 drivers/media/video/cx88/cx88-blackbird.c     |    1 +
 drivers/media/video/em28xx/em28xx-audio.c     |   12 ++++-
 drivers/media/video/em28xx/em28xx-cards.c     |   55 ++++++++++++-------------
 drivers/media/video/em28xx/em28xx-dvb.c       |    9 ++++
 drivers/media/video/gspca/gspca.c             |    3 +-
 drivers/media/video/gspca/pac7311.c           |    1 +
 drivers/media/video/gspca/sonixb.c            |    4 +-
 drivers/media/video/gspca/sonixj.c            |   19 ++++++--
 drivers/media/video/gspca/spca561.c           |    2 +-
 drivers/media/video/gspca/zc3xx.c             |    4 +-
 drivers/media/video/ov511.c                   |    6 ++-
 drivers/media/video/pvrusb2/pvrusb2-devattr.c |    2 +
 drivers/media/video/s2255drv.c                |    3 +-
 drivers/media/video/uvc/uvc_ctrl.c            |    2 +-
 drivers/media/video/w9968cf.c                 |    2 +-
 drivers/media/video/wm8739.c                  |    4 +-
 drivers/media/video/zoran_card.c              |    2 +-
 drivers/media/video/zoran_driver.c            |   15 +++----
 31 files changed, 130 insertions(+), 86 deletions(-)

Andreas Oberritter (1):
      V4L/DVB (9029): Fix deadlock in demux code

Andrew Morton (1):
      V4L/DVB (8960): drivers/media/video/cafe_ccic.c needs mm.h

Costantino Leandro (1):
      V4L/DVB (8933): gspca: Disable light frquency for zc3xx cs2102 Kokom.

Darron Broad (1):
      V4L/DVB (9099): em28xx: Add detection for K-WORLD DVB-T 310U

Dean Anderson (1):
      V4L/DVB (8963): s2255drv field count fix

Devin Heitmueller (1):
      V4L/DVB (8967): Use correct XC3028L firmware for AMD ATI TV Wonder 600

Douglas Schilling Landgraf (6):
      V4L/DVB (8883): w9968cf: Fix order of usb_alloc_urb validation
      V4L/DVB (8884): em28xx-audio: fix memory leak
      V4L/DVB (8885): cpia2_usb: fix memory leak
      V4L/DVB (8886): ov511: fix memory leak
      V4L/DVB (8887): gspca: fix memory leak
      V4L/DVB (8935): em28xx-cards: Remove duplicate entry (EM2800_BOARD_KWORLD_USB2800)

Hans Verkuil (4):
      V4L/DVB (8789): wm8739: remove wrong kfree
      V4L/DVB (8904): cx88: add missing unlock_kernel
      V4L/DVB (8905): ov511: fix exposure sysfs attribute bug
      V4L/DVB (8919): cx18: Fix tuner audio input for Compro H900 cards

Hans de Goede (1):
      V4L/DVB (8909): gspca: PAC 7302 webcam 093a:262a added.

Jean Delvare (4):
      V4L/DVB (8955): bttv: Prevent NULL pointer dereference in radio_open
      V4L/DVB (8957): zr36067: Restore the default pixel format
      V4L/DVB (8958): zr36067: Return proper bytes-per-line value
      V4L/DVB (8961): zr36067: Fix RGBR pixel format

Jean-Francois Moine (3):
      V4L/DVB (8926): gspca: Bad fix of leak memory (changeset 43d2ead315b1).
      V4L/DVB (9080): gspca: Add a delay after writing to the sonixj sensors.
      V4L/DVB (9092): gspca: Bad init values for sonixj ov7660.

Mauro Carvalho Chehab (1):
      V4L/DVB (8559a): Fix a merge conflict at gspca/sonixb

Michael Krufky (2):
      V4L/DVB (8978): sms1xxx: fix product name for Hauppauge WinTV MiniStick
      V4L/DVB (8979): sms1xxx: Add new USB product ID for Hauppauge WinTV MiniStick

Mike Isely (1):
      V4L/DVB (8892): pvrusb2: Handle USB ID 2040:2950 same as 2040:2900

Patrick Boettcher (2):
      V4L/DVB (9037): Fix support for Hauppauge Nova-S SE
      V4L/DVB (9043): S5H1420: Fix size of shadow-array to avoid overflow

Ralph Loader (1):
      V4L/DVB (9053): fix buffer overflow in uvc-video

Shane (1):
      V4L/DVB (9075): gspca: Bad check of returned status in i2c_read() spca561.

Wiktor Grebla (1):
      V4L/DVB (9103): em28xx: HVR-900 B3C0 - fix audio clicking issue

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
