Return-Path: <linux-kernel-owner+w=401wt.eu-S935989AbXJQRZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935989AbXJQRZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935323AbXJQRZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:25:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37834 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935164AbXJQRZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:25:36 -0400
Date: Wed, 17 Oct 2007 15:17:34 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes
Message-Id: <1192641913.5745.77.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git devel

For the following fixes:

   - removal of the unused .hardware field, that were causing
        compilation troubles when V4L1 compat were not selected;

   - misc fixes at several parts of V4L/DVB: tuner-core, cinergyT2,
        saa7134, cx23885, ivtv, cx88, pvrusb2, dib0700, ir-kdb-i2c,
        dvb_ca_en50221 and em28xx;

Additionally, there are two pending patches for:

   - Two cx88-alsa patches that were waiting for -ALSA merge;

And the removal of an obsolete, unused set of ioctls:

   - Remove the obsolete VIDIOC_S/G_MPEGCOMP ioctls;

Also, feature-removal-schedule.txt V4L entries were updated.

Cheers,
Mauro.

---

 Documentation/feature-removal-schedule.txt         |   22 +--
 drivers/media/dvb/cinergyT2/cinergyT2.c            |   42 ++++--
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c        |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |    2 +-
 drivers/media/radio/miropcm20-radio.c              |    1 -
 drivers/media/radio/radio-gemtek.c                 |    1 -
 drivers/media/video/arv.c                          |    1 -
 drivers/media/video/bt8xx/bttv-driver.c            |    3 -
 drivers/media/video/bw-qcam.c                      |    1 -
 drivers/media/video/c-qcam.c                       |    1 -
 drivers/media/video/cpia.c                         |    5 -
 drivers/media/video/cpia2/cpia2_v4l.c              |    5 -
 drivers/media/video/cx23885/cx23885-core.c         |    6 +-
 drivers/media/video/cx88/cx88-alsa.c               |   86 +++++++++--
 drivers/media/video/cx88/cx88-blackbird.c          |   57 -------
 drivers/media/video/cx88/cx88-dvb.c                |    3 +-
 drivers/media/video/cx88/cx88-mpeg.c               |  133 +++++++----------
 drivers/media/video/cx88/cx88-video.c              |    1 -
 drivers/media/video/cx88/cx88-vp3054-i2c.c         |   16 +-
 drivers/media/video/cx88/cx88.h                    |   24 ++-
 drivers/media/video/em28xx/em28xx-core.c           |    3 +-
 drivers/media/video/em28xx/em28xx-video.c          |    2 -
 drivers/media/video/et61x251/et61x251_core.c       |    1 -
 drivers/media/video/ir-kbd-i2c.c                   |    1 +
 drivers/media/video/ivtv/ivtv-driver.c             |   11 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |    8 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |   13 +-
 drivers/media/video/ivtv/ivtv-streams.c            |  116 +++++++++------
 drivers/media/video/ivtv/ivtv-streams.h            |    1 +
 drivers/media/video/ivtv/ivtv-yuv.c                |  160 ++++++++++---------
 drivers/media/video/ivtv/ivtv-yuv.h                |    1 +
 drivers/media/video/ivtv/ivtvfb.c                  |   19 +--
 drivers/media/video/meye.c                         |    1 -
 drivers/media/video/ov511.c                        |    1 -
 drivers/media/video/planb.c                        |    1 -
 drivers/media/video/pms.c                          |    1 -
 drivers/media/video/pvrusb2/pvrusb2-encoder.c      |    6 +
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |   11 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |    3 +
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    3 -
 drivers/media/video/pwc/pwc-if.c                   |    1 -
 drivers/media/video/saa7134/saa6752hs.c            |  111 --------------
 drivers/media/video/saa7134/saa7134-core.c         |   42 ++++-
 drivers/media/video/saa7134/saa7134-empress.c      |   12 --
 drivers/media/video/saa7134/saa7134-input.c        |    4 +-
 drivers/media/video/saa7134/saa7134-tvaudio.c      |   32 +++-
 drivers/media/video/saa7134/saa7134-video.c        |   28 ++--
 drivers/media/video/saa7134/saa7134.h              |    7 +-
 drivers/media/video/se401.c                        |    1 -
 drivers/media/video/sn9c102/sn9c102_core.c         |    1 -
 drivers/media/video/stradis.c                      |    1 -
 drivers/media/video/stv680.c                       |    1 -
 drivers/media/video/tuner-core.c                   |    2 +-
 drivers/media/video/usbvideo/usbvideo.c            |    1 -
 drivers/media/video/usbvideo/vicam.c               |    1 -
 drivers/media/video/usbvision/usbvision-video.c    |    3 -
 drivers/media/video/v4l2-common.c                  |    2 -
 drivers/media/video/videobuf-core.c                |    2 +-
 drivers/media/video/videocodec.c                   |    4 +-
 drivers/media/video/videodev.c                     |   42 -----
 drivers/media/video/vivi.c                         |    1 -
 drivers/media/video/w9966.c                        |    1 -
 drivers/media/video/w9968cf.c                      |    1 -
 drivers/media/video/zc0301/zc0301_core.c           |    1 -
 drivers/media/video/zoran_card.c                   |   10 +-
 drivers/media/video/zoran_driver.c                 |    2 -
 include/linux/videodev.h                           |   42 -----
 include/linux/videodev2.h                          |   92 -----------
 include/media/v4l2-dev.h                           |    5 -
 sound/i2c/other/tea575x-tuner.c                    |    1 -
 70 files changed, 485 insertions(+), 744 deletions(-)

Adrian Bunk (1):
      V4L/DVB (6328): ivtv: fix NULL dereference

Florin Malita (2):
      V4L/DVB (6325): Double-free in cx23885_initdev
      V4L/DVB (6350): V4L: possible leak in em28xx_init_isoc

Hans Verkuil (8):
      V4L/DVB (6321): Remove obsolete VIDIOC_S/G_MPEGCOMP ioctls
      V4L/DVB (6338): ivtv: fix incorrect EBUSY return
      V4L/DVB (6339): ivtv: set the video color to black instead of green when capturing from the radio
      V4L/DVB (6341): ivtv: fix resizing MPEG1 streams
      V4L/DVB (6342): ivtv: fix circular locking (bug 9037)
      V4L/DVB (6343): ivtvfb: check return value of unregister_framebuffer
      V4L/DVB (6347): ivtv: fix video mute when radio is used
      V4L/DVB (6348): ivtv: undo video mute when closing the radio

Ian Armstrong (3):
      V4L/DVB (6340): ivtvfb: screen mode change sometimes goes wrong
      V4L/DVB (6345): ivtvfb: YUV handling of an image which is not visible in the display area
      V4L/DVB (6346): ivtvfb: YUV output size fix when ivtvfb is not loaded

Jiri Slaby (1):
      V4L/DVB (6323): V4L: cinergyT2, remove bad usage of ERESTARTSYS

Marco Schluessler (1):
      V4L/DVB (6356): "while (!ca->wakeup)" breaks the CAM initialisation

Mauro Carvalho Chehab (3):
      V4L/DVB (6320): v4l core: remove the unused .hardware V4L1 field
      V4L/DVB (6378a): Removal of VIDIOC_[G|S]_MPEGCOMP from feature-removal-schedule.txt
      V4L/DVB (6378b): Updates info about the removal of V4L1 at feature-removal-schedule.txt

Maxim Levitsky (2):
      V4L/DVB (6329): Additional Fixes for saa7134 suspend/resume
      V4L/DVB (6330): V4L: saa7134: Fix interaction between tvaudio thread and the freezer

Michael Krufky (1):
      V4L/DVB (6326): tuner-core.c: fe_has_signal() can return uninitialized value

Mike Isely (1):
      V4L/DVB (6357): pvrusb2: Improve encoder chip health tracking

Patrick Boettcher (1):
      V4L/DVB (6378): DiB0700-device: Using 1.10 firmware

Pekka Enberg (1):
      V4L/DVB (6324): fix videobuf_cgmbuf export

Pekka Seppänen (1):
      V4L/DVB (6319): radio-gemtek: fix 'VID_HARDWARE_GEMTEK' undeclared

Trent Piepho (8):
      V4L/DVB (6185): cx88-alsa: Add mute controls, change control names
      V4L/DVB (6187): cx88-alsa: Add TLV support
      V4L/DVB (6332): cx88: Only include the blackbird fields if blackbird is selected
      V4L/DVB (6333): cx88: Change void* card_priv to struct vp3054_i2c_state
      V4L/DVB (6334): cx88: Change (struct cx8802_dev)->drvlist to a list_head and fix bugs
      V4L/DVB (6335): cx8802: Replace list_for_each+list_entry with list_for_each_entry
      V4L/DVB (6336): cx8802: Plug memory leak when unregistering a driver
      V4L/DVB (6352): ir-kbd-i2c: Missing break statement

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

