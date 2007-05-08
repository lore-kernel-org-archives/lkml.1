Return-Path: <linux-kernel-owner+w=401wt.eu-S968204AbXEHTxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968204AbXEHTxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967103AbXEHTxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:53:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34646 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967325AbXEHTxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:53:39 -0400
Date: Tue, 08 May 2007 15:05:11 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB updates
Message-Id: <1178653966.18383.311.camel@localhost>
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

There are several cleanups, driver updates and fixes on this series, including some
important fixes on handling V4L1 calls.

This series also adds support for a few newer saa7134 cards, some newer webcams based
on Sonix sn9c1xx chips, and support for a newer m920x board.

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.saa7134       |    5 +-
 Documentation/video4linux/sn9c102.txt            |   18 +-
 drivers/media/Kconfig                            |    9 +
 drivers/media/Makefile                           |    2 +-
 drivers/media/common/saa7146_core.c              |   54 ++-
 drivers/media/common/saa7146_fops.c              |    1 -
 drivers/media/dvb/Kconfig                        |   24 +-
 drivers/media/dvb/dvb-core/Kconfig               |   14 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h          |    5 +
 drivers/media/dvb/dvb-usb/dvb-usb.h              |    2 +-
 drivers/media/dvb/dvb-usb/m920x.c                |  565 ++++++++++++++++------
 drivers/media/dvb/dvb-usb/m920x.h                |   13 +-
 drivers/media/dvb/dvb-usb/vp702x-fe.c            |   14 +-
 drivers/media/dvb/pluto2/pluto2.c                |    8 +
 drivers/media/dvb/ttpci/av7110.c                 |    9 +-
 drivers/media/dvb/ttpci/budget-ci.c              |    2 +-
 drivers/media/dvb/ttpci/budget-core.c            |   37 +-
 drivers/media/radio/Kconfig                      |   11 +-
 drivers/media/radio/dsbr100.c                    |  345 +++++++------
 drivers/media/radio/radio-cadet.c                |  297 +++++++-----
 drivers/media/radio/radio-maestro.c              |    3 -
 drivers/media/radio/radio-zoltrix.c              |    1 -
 drivers/media/video/Kconfig                      |   45 +-
 drivers/media/video/cx25840/cx25840-core.c       |    4 +-
 drivers/media/video/cx88/cx88-mpeg.c             |    5 +-
 drivers/media/video/cx88/cx88-video.c            |    1 +
 drivers/media/video/cx88/cx88-vp3054-i2c.c       |    7 -
 drivers/media/video/cx88/cx88-vp3054-i2c.h       |    1 -
 drivers/media/video/em28xx/Kconfig               |    2 +-
 drivers/media/video/et61x251/Kconfig             |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c           |    2 +-
 drivers/media/video/ivtv/ivtv-fileops.c          |    2 +-
 drivers/media/video/pvrusb2/Kconfig              |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-encoder.c    |   13 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c        |   10 +-
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c   |   23 +-
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c      |   14 -
 drivers/media/video/pwc/Kconfig                  |    2 +-
 drivers/media/video/saa7134/saa7134-cards.c      |  123 +++++-
 drivers/media/video/saa7134/saa7134-dvb.c        |   17 +
 drivers/media/video/saa7134/saa7134.h            |    3 +
 drivers/media/video/sn9c102/Kconfig              |    2 +-
 drivers/media/video/sn9c102/sn9c102.h            |    2 +-
 drivers/media/video/sn9c102/sn9c102_core.c       |   91 ++--
 drivers/media/video/sn9c102/sn9c102_devtable.h   |    4 +-
 drivers/media/video/sn9c102/sn9c102_hv7131d.c    |    6 +-
 drivers/media/video/sn9c102/sn9c102_hv7131r.c    |    8 +-
 drivers/media/video/sn9c102/sn9c102_mi0343.c     |   51 +-
 drivers/media/video/sn9c102/sn9c102_mi0360.c     |  220 +++++++--
 drivers/media/video/sn9c102/sn9c102_ov7630.c     |   25 +-
 drivers/media/video/sn9c102/sn9c102_ov7660.c     |   63 ++-
 drivers/media/video/sn9c102/sn9c102_pas106b.c    |   14 +-
 drivers/media/video/sn9c102/sn9c102_pas202bcb.c  |   48 +-
 drivers/media/video/sn9c102/sn9c102_sensor.h     |   33 +-
 drivers/media/video/sn9c102/sn9c102_tas5110c1b.c |    2 +-
 drivers/media/video/sn9c102/sn9c102_tas5110d.c   |    2 +-
 drivers/media/video/sn9c102/sn9c102_tas5130d1b.c |    2 +-
 drivers/media/video/usbvideo/Kconfig             |    8 +-
 drivers/media/video/usbvision/Kconfig            |    2 +-
 drivers/media/video/v4l1-compat.c                |   62 ++-
 drivers/media/video/video-buf.c                  |    4 +-
 drivers/media/video/videodev.c                   |   50 ++-
 drivers/media/video/zc0301/Kconfig               |    2 +-
 include/media/saa7146.h                          |    2 +
 include/media/saa7146_vv.h                       |    2 +
 65 files changed, 1580 insertions(+), 842 deletions(-)

Aapo Tahkola (4):
      V4L/DVB (5607): M920x: Initial support for devices likely manufactured by Dposh
      V4L/DVB (5611): M920x: replace deb_rc with deb
      V4L/DVB (5612): M920x: rename function prefixes from m9206_foo to m920x_foo
      V4L/DVB (5613): M920x: loosen up 80-col limit

Adrian Bunk (2):
      V4L/DVB (5567): Cx88-mpeg.c: make 2 functions static
      V4L/DVB (5591): Saa7146: proper prototype for saa7146_video_do_ioctl()

Alexey Dobriyan (1):
      V4L/DVB (5565): Cx88: fix compilation on alpha

Douglas Landgraf (4):
      V4L/DVB (5621): Radio-cadet.c Replace cadet_do_ioctl to use video_ioctl2
      V4L/DVB (5622): Radio-zoltrix.c cleanup
      V4L/DVB (5623): Dsbr100.c Replace usb_dsbr100_do_ioctl to use video_ioctl2
      V4L/DVB (5624): Radio-maestro.c cleanup

James T Klaas (1):
      V4L/DVB (5582): Added support for Sabrent TV-PCB05 card.

Jan Engelhardt (2):
      V4L/DVB (5586): Use menuconfig objects II - V4L
      V4L/DVB (5599): Use menuconfig objects II - DVB

Jean Delvare (1):
      V4L/DVB (5618): Cx88: Drop the generic i2c client from cx88-vp3054-i2c

Jiri Slaby (1):
      V4L/DVB (5617): V4L2: videodev, allow debugging

Jon Burgess (1):
      V4L/DVB (5592): DMA: Correctly free resources on error, sync PCI streamed data

Luca Risolia (1):
      V4L/DVB (5585): SN9C1xx driver updates

Matthias Kaehlcke (1):
      V4L/DVB (5572): Pvrusb2: use mutex instead of semaphore

Mauro Carvalho Chehab (4):
      V4L/DVB (5569): Fix: v4l1_compat should be called only if V4L1_COMPAT
      V4L/DVB (5587): Add help for RADIO_ADAPTERS and VIDEO_CAPTURE_DRIVERS
      V4L/DVB (5600): Allow compiling just DVB CORE
      V4L/DVB (5601): Create a menu for DAB

Michael Krufky (5):
      V4L/DVB (5606): M920x: add "c-basic-offset: 8" to help emacs to enforce tabbing
      V4L/DVB (5608): M920x: various whitespace cleanups
      V4L/DVB (5609): M920x: group like functions together
      V4L/DVB (5610): M920x: remove duplicated code
      V4L/DVB (5619): Dvb-usb: fix typo

Mike Isely (2):
      V4L/DVB (5574): Pvrusb2: Improve handling of PAL-60 video standard
      V4L/DVB (5575): Pvrusb2: Implement ability to disable IR receiver

Nick Andrew (2):
      V4L/DVB (5605): M920x: Add support for LifeView TV Walker Twin
      V4L/DVB (5614): M920x: Disable second adapter on LifeView TV Walker Twin

Oliver Endriss (1):
      V4L/DVB (5593): Budget-ci: Fix tuning for TDM 1316 (160..200 MHz)

Pat Erley (1):
      V4L/DVB (5602): Enable DiSEqC in Starbox II (vp7021a)

Robert P. J. Day (1):
      V4L/DVB (5583): VIDEO4LINUX-2: Replace MINOR() with a call to iminor().

Sakari Ailus (1):
      V4L/DVB (5603): V4L: Prevent queueing queued buffers.

Sam Revitch (1):
      V4L/DVB (5568): VIDIOCGMBUF handling in video_ioctl2()

Servaas Vandenberghe (1):
      V4L/DVB (5576): Improve / fix support for PAL-60 in cx25840

Simon Farnsworth (1):
      V4L/DVB (5580): Add support for three cards to saa7134 driver

Tejun Heo (1):
      V4L/DVB (5573): Pvrusb2: kill unnecessary attribute->owner

Thomas Gleixner (1):
      V4L/DVB (5566): MEDIA: Spinlock initializer cleanup

Trent Piepho (2):
      V4L/DVB (5570): V4l1-compat: misc fixes for pixelformat function
      V4L/DVB (5571): V4l1-compat:  Make VIDIOCSPICT return errors in a useful way

holger@muscate-magnussen.de (1):
      V4L/DVB (5578): Workaround for bad hardare/firmware on some pluto2 devices

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

