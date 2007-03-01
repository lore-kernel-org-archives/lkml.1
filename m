Return-Path: <linux-kernel-owner+w=401wt.eu-S965489AbXCASe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965489AbXCASe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 13:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965490AbXCASe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 13:34:56 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33694 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965489AbXCASez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 13:34:55 -0500
Subject: [GIT PULL] V4L/DVB fixes
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       DVB ML <linux-dvb@linuxtv.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 01 Mar 2007 16:34:39 -0200
Message-Id: <1172774079.17625.51.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

We have some fixes for 2.6.21 on my -git tree.

There were also two newer drivers, one for zr364xx and another for ivtv.
Both drivers exists for some time out of kernel tree. 

The first one used to have, in the past, a mjpeg conversion routine at
kernel. His author removed this and cleaned up the driver according with
the best practices. It is contained just at the last patchset (V4L/DVB
5257) and just adds a newer driver, without touching on other files.

The second one is a very old driver (have about 2-3 years), long waited
to be on kernel, being maintained - until now - out of kernel tree. The
v4l development team, supported by the manufacturer, did a lot of
efforts to integrate it in kernel, generating several newer ABI
controls. 

This driver is for the very popular Hauppauge PVR hardware, supporting
maybe one of the most complex v4l/dvb device I've seen. There are
devices with IR decoding, IR encoding, MPEG decoding, MPEG encoding, TV
output, multiple tuners, as well as raw analog tv capture. Most of the
non-fix patches are adding some newer features at V4L2 and DVB API, to
allow controlling TVOut and mpeg encoding/decoding. Patchset V4L/DVB
5345 is a big one, just adding the driver itself.

I know we are late to submit this for 2.6.21, but I think this would be
interesting to be at kernel.

Just in case you don't agree with me, I've generated two different -git
trees. The first one with the two drivers. If you agree to pull it, it
is available at:
	==== ivtv branch (does contain the fixes also)
git://git.kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git ivtv
	====

otherwise, *if you nack* on pushing this too late, I've generated a tree
with just the required fixes for 2.6.21, available at:
	==== just the fixes branch
git://git.kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master
	====

Both trees are compiling fine with allmodconfig.

Cheers,
Mauro.

===============================================
ivtv branch does contain the following patches:
===============================================

V4L/DVB (5255): Fix cx25840 firmware loading.
V4L/DVB (5304): Improve chip matching in v4l2_register
V4L/DVB (5295): Digitv: open nxt6000 i2c_gate for TDED4 tuner handling
V4L/DVB (5258): Cafe_ccic: fix compiler warning
V4L/DVB (5276): Cxusb: fix firmware patch for big endian systems
V4L/DVB (5268): Add support for three new MPEG controls.
V4L/DVB (5270): Add VIDIOC_G_ENC_INDEX ioctl
V4L/DVB (5271): Add VIDIOC_TRY_ENCODER_CMD and VIDIOC_ENCODER_CMD ioctls.
V4L/DVB (5272): Add V4L2_CAP_VIDEO_OUTPUT_POS capability
V4L/DVB (5305): Mark VIDIOC_DBG_S/G_REGISTER as experimental
V4L/DVB (5289): Add support for video output overlays.
V4L/DVB (5290): Add support for VIDIOC_INT_G/S_STD_OUTPUT
V4L/DVB (5307): Add support for the cx23415 MPEG decoding features.
V4L/DVB (5336): Cx23416 doc updates + rename CX2341X_ENC_UNKNOWN
V4L/DVB (5306): Add support for VIDIOC_G_CHIP_IDENT
V4L/DVB (5341): Add cx23415/6 chip idents.
V4L/DVB (5345): ivtv driver for Conexant cx23416/cx23415 MPEG encoder/decoder
V4L/DVB (5257): USB: add zr364xx V4L2 driver

 .../video4linux/cx2341x/fw-encoder-api.txt         |   19 
 Documentation/video4linux/zr364xx.txt              |   65 +
 MAINTAINERS                                        |    8 
 drivers/media/dvb/dvb-usb/cxusb.c                  |    4 
 drivers/media/dvb/dvb-usb/digitv.c                 |    2 
 drivers/media/dvb/ttpci/av7110_av.c                |   24 
 drivers/media/dvb/ttpci/av7110_hw.h                |   10 
 drivers/media/video/Kconfig                        |   14 
 drivers/media/video/Makefile                       |    2 
 drivers/media/video/cafe_ccic.c                    |   12 
 drivers/media/video/cx2341x.c                      |   72 +
 drivers/media/video/cx25840/cx25840-core.c         |   15 
 drivers/media/video/cx25840/cx25840-core.h         |    3 
 drivers/media/video/cx25840/cx25840-firmware.c     |    2 
 drivers/media/video/cx88/cx88-video.c              |    4 
 drivers/media/video/ivtv/Kconfig                   |   26 
 drivers/media/video/ivtv/Makefile                  |    7 
 drivers/media/video/ivtv/ivtv-audio.c              |   74 +
 drivers/media/video/ivtv/ivtv-audio.h              |   23 
 drivers/media/video/ivtv/ivtv-cards.c              |  964 ++++++++++++
 drivers/media/video/ivtv/ivtv-cards.h              |  207 +++
 drivers/media/video/ivtv/ivtv-controls.c           |  303 ++++
 drivers/media/video/ivtv/ivtv-controls.h           |   21 
 drivers/media/video/ivtv/ivtv-driver.c             | 1385 ++++++++++++++++++
 drivers/media/video/ivtv/ivtv-driver.h             |  866 +++++++++++
 drivers/media/video/ivtv/ivtv-fileops.c            |  918 ++++++++++++
 drivers/media/video/ivtv/ivtv-fileops.h            |   45 +
 drivers/media/video/ivtv/ivtv-firmware.c           |  272 +++
 drivers/media/video/ivtv/ivtv-firmware.h           |   25 
 drivers/media/video/ivtv/ivtv-gpio.c               |  307 ++++
 drivers/media/video/ivtv/ivtv-gpio.h               |   25 
 drivers/media/video/ivtv/ivtv-i2c.c                |  752 ++++++++++
 drivers/media/video/ivtv/ivtv-i2c.h                |   38 
 drivers/media/video/ivtv/ivtv-ioctl.c              | 1555 ++++++++++++++++++++
 drivers/media/video/ivtv/ivtv-ioctl.h              |   28 
 drivers/media/video/ivtv/ivtv-irq.c                |  818 +++++++++++
 drivers/media/video/ivtv/ivtv-irq.h                |   24 
 drivers/media/video/ivtv/ivtv-mailbox.c            |  360 +++++
 drivers/media/video/ivtv/ivtv-mailbox.h            |   25 
 drivers/media/video/ivtv/ivtv-queue.c              |  262 +++
 drivers/media/video/ivtv/ivtv-queue.h              |   64 +
 drivers/media/video/ivtv/ivtv-streams.c            |  977 +++++++++++++
 drivers/media/video/ivtv/ivtv-streams.h            |   31 
 drivers/media/video/ivtv/ivtv-udma.c               |  200 +++
 drivers/media/video/ivtv/ivtv-udma.h               |   43 +
 drivers/media/video/ivtv/ivtv-vbi.c                |  545 +++++++
 drivers/media/video/ivtv/ivtv-vbi.h                |   27 
 drivers/media/video/ivtv/ivtv-version.h            |   26 
 drivers/media/video/ivtv/ivtv-video.c              |  150 ++
 drivers/media/video/ivtv/ivtv-video.h              |   25 
 drivers/media/video/ivtv/ivtv-yuv.c                | 1129 +++++++++++++++
 drivers/media/video/ivtv/ivtv-yuv.h                |   24 
 drivers/media/video/ov7670.c                       |    6 
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |   11 
 drivers/media/video/pvrusb2/pvrusb2-hdw.h          |    7 
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    4 
 drivers/media/video/saa7115.c                      |   11 
 drivers/media/video/saa7127.c                      |   14 
 drivers/media/video/tvp5150.c                      |    2 
 drivers/media/video/upd64031a.c                    |    2 
 drivers/media/video/upd64083.c                     |    2 
 drivers/media/video/usbvision/usbvision-video.c    |    4 
 drivers/media/video/v4l2-common.c                  |   84 +
 drivers/media/video/videodev.c                     |   69 +
 drivers/media/video/zr364xx.c                      |  929 ++++++++++++
 include/linux/dvb/audio.h                          |    5 
 include/linux/dvb/version.h                        |    2 
 include/linux/dvb/video.h                          |   49 +
 include/linux/videodev2.h                          |  154 ++
 include/media/cx2341x.h                            |    6 
 include/media/ivtv.h                               |   65 +
 include/media/v4l2-chip-ident.h                    |   66 +
 include/media/v4l2-common.h                        |   55 -
 include/media/v4l2-dev.h                           |   16 
 74 files changed, 14235 insertions(+), 155 deletions(-)
 create mode 100644 Documentation/video4linux/zr364xx.txt
 create mode 100644 drivers/media/video/ivtv/Kconfig
 create mode 100644 drivers/media/video/ivtv/Makefile
 create mode 100644 drivers/media/video/ivtv/ivtv-audio.c
 create mode 100644 drivers/media/video/ivtv/ivtv-audio.h
 create mode 100644 drivers/media/video/ivtv/ivtv-cards.c
 create mode 100644 drivers/media/video/ivtv/ivtv-cards.h
 create mode 100644 drivers/media/video/ivtv/ivtv-controls.c
 create mode 100644 drivers/media/video/ivtv/ivtv-controls.h
 create mode 100644 drivers/media/video/ivtv/ivtv-driver.c
 create mode 100644 drivers/media/video/ivtv/ivtv-driver.h
 create mode 100644 drivers/media/video/ivtv/ivtv-fileops.c
 create mode 100644 drivers/media/video/ivtv/ivtv-fileops.h
 create mode 100644 drivers/media/video/ivtv/ivtv-firmware.c
 create mode 100644 drivers/media/video/ivtv/ivtv-firmware.h
 create mode 100644 drivers/media/video/ivtv/ivtv-gpio.c
 create mode 100644 drivers/media/video/ivtv/ivtv-gpio.h
 create mode 100644 drivers/media/video/ivtv/ivtv-i2c.c
 create mode 100644 drivers/media/video/ivtv/ivtv-i2c.h
 create mode 100644 drivers/media/video/ivtv/ivtv-ioctl.c
 create mode 100644 drivers/media/video/ivtv/ivtv-ioctl.h
 create mode 100644 drivers/media/video/ivtv/ivtv-irq.c
 create mode 100644 drivers/media/video/ivtv/ivtv-irq.h
 create mode 100644 drivers/media/video/ivtv/ivtv-mailbox.c
 create mode 100644 drivers/media/video/ivtv/ivtv-mailbox.h
 create mode 100644 drivers/media/video/ivtv/ivtv-queue.c
 create mode 100644 drivers/media/video/ivtv/ivtv-queue.h
 create mode 100644 drivers/media/video/ivtv/ivtv-streams.c
 create mode 100644 drivers/media/video/ivtv/ivtv-streams.h
 create mode 100644 drivers/media/video/ivtv/ivtv-udma.c
 create mode 100644 drivers/media/video/ivtv/ivtv-udma.h
 create mode 100644 drivers/media/video/ivtv/ivtv-vbi.c
 create mode 100644 drivers/media/video/ivtv/ivtv-vbi.h
 create mode 100644 drivers/media/video/ivtv/ivtv-version.h
 create mode 100644 drivers/media/video/ivtv/ivtv-video.c
 create mode 100644 drivers/media/video/ivtv/ivtv-video.h
 create mode 100644 drivers/media/video/ivtv/ivtv-yuv.c
 create mode 100644 drivers/media/video/ivtv/ivtv-yuv.h
 create mode 100644 drivers/media/video/zr364xx.c
 create mode 100644 include/media/ivtv.h
 create mode 100644 include/media/v4l2-chip-ident.h

=============================================
master branch contains the following patches:
=============================================
V4L/DVB (5255): Fix cx25840 firmware loading.
V4L/DVB (5304): Improve chip matching in v4l2_register
V4L/DVB (5295): Digitv: open nxt6000 i2c_gate for TDED4 tuner handling
V4L/DVB (5258): Cafe_ccic: fix compiler warning
V4L/DVB (5276): Cxusb: fix firmware patch for big endian systems
V4L/DVB (5270): Add VIDIOC_G_ENC_INDEX ioctl
V4L/DVB (5271): Add VIDIOC_TRY_ENCODER_CMD and VIDIOC_ENCODER_CMD ioctls.
V4L/DVB (5305): Mark VIDIOC_DBG_S/G_REGISTER as experimental

 drivers/media/dvb/dvb-usb/cxusb.c               |    4 +
 drivers/media/dvb/dvb-usb/digitv.c              |    2 +
 drivers/media/video/cafe_ccic.c                 |    4 -
 drivers/media/video/cx25840/cx25840-core.c      |    6 +-
 drivers/media/video/cx25840/cx25840-firmware.c  |    2 -
 drivers/media/video/cx88/cx88-video.c           |    4 +
 drivers/media/video/pvrusb2/pvrusb2-hdw.c       |   11 ++--
 drivers/media/video/pvrusb2/pvrusb2-hdw.h       |    7 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c      |    4 +
 drivers/media/video/saa7115.c                   |    2 -
 drivers/media/video/saa7127.c                   |    2 -
 drivers/media/video/tvp5150.c                   |    2 -
 drivers/media/video/upd64031a.c                 |    2 -
 drivers/media/video/upd64083.c                  |    2 -
 drivers/media/video/usbvision/usbvision-video.c |    4 +
 drivers/media/video/v4l2-common.c               |   43 ++++++++++++--
 drivers/media/video/videodev.c                  |   36 ++++++++++++
 include/linux/videodev2.h                       |   71 +++++++++++++++++++++--
 include/media/v4l2-common.h                     |    8 +++
 include/media/v4l2-dev.h                        |    6 ++
 20 files changed, 184 insertions(+), 38 deletions(-)


