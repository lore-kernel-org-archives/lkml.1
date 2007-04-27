Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbXD0Uld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbXD0Uld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbXD0Uld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:41:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50001 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215AbXD0Ul3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:41:29 -0400
Date: Fri, 27 Apr 2007 16:59:32 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB updates
Message-Id: <1177706435.5163.49.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

A short changelog:

   - New drivers:
        ivtv driver for Hauppauge PVR series and similar boards;
	ZR364xx USB driver;
        Opera S1 DVB USB driver;
        TDA10023 DVB frontend driver;
	TDA827x DVB tuner driver;

   - Add support for the following cards:
	AverMedia M102 miniPCI;
	Identify MSI TV@nywhere Duo;
        Pinnacle PCTV Sat Pro USB;
        Some missing Hauppauge and Belkin boards;
        Autodetect ADS Tech InstantTV DVB-S;
        Some ASUS hybrid boards;
        Anubis Electronics / MSI Digi Vox Mini II;
        Cisco VT Camera support;
        Remote of Asustech P7131 Hybrid LNA;
        Logitech ViewPort AV 100.

   - V4L API improvements;

   - Several cleanups, fixes and driver improvements.

Cheers,
Mauro.

---

 Documentation/feature-removal-schedule.txt         |   12 +
 Documentation/video4linux/CARDLIST.bttv            |    2 +
 Documentation/video4linux/CARDLIST.cx88            |    2 +-
 Documentation/video4linux/CARDLIST.ivtv            |   18 +
 Documentation/video4linux/CARDLIST.saa7134         |    8 +-
 Documentation/video4linux/CARDLIST.usbvision       |   64 +
 Documentation/video4linux/README.ivtv              |  187 +++
 .../video4linux/cx2341x/fw-decoder-regs.txt        |   12 +-
 .../video4linux/cx2341x/fw-encoder-api.txt         |   19 +-
 Documentation/video4linux/cx2341x/fw-osd-api.txt   |   12 +-
 Documentation/video4linux/sn9c102.txt              |   64 +-
 Documentation/video4linux/zr364xx.txt              |   65 +
 MAINTAINERS                                        |   46 +-
 drivers/media/common/ir-keymaps.c                  |   18 +-
 drivers/media/common/saa7146_video.c               |    6 +
 drivers/media/dvb/b2c2/Kconfig                     |    1 -
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c          |    3 +-
 drivers/media/dvb/b2c2/flexcop-pci.c               |    9 +-
 drivers/media/dvb/bt8xx/Kconfig                    |    2 +-
 drivers/media/dvb/bt8xx/bt878.c                    |    4 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c                |    3 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.h                |    2 +-
 drivers/media/dvb/dvb-core/dmxdev.c                |   56 +-
 drivers/media/dvb/dvb-core/dmxdev.h                |    2 +
 drivers/media/dvb/dvb-core/dvb_frontend.c          |   20 +-
 drivers/media/dvb/dvb-core/dvb_net.c               |   32 +-
 drivers/media/dvb/dvb-core/dvb_net.h               |    1 +
 drivers/media/dvb/dvb-core/dvbdev.c                |    1 +
 drivers/media/dvb/dvb-core/dvbdev.h                |    1 +
 drivers/media/dvb/dvb-usb/Kconfig                  |   12 +-
 drivers/media/dvb/dvb-usb/Makefile                 |    4 +
 drivers/media/dvb/dvb-usb/au6610.c                 |    6 +-
 drivers/media/dvb/dvb-usb/cxusb.c                  |    4 +-
 drivers/media/dvb/dvb-usb/dib0700_core.c           |    4 -
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    6 +
 drivers/media/dvb/dvb-usb/gl861.c                  |    8 +-
 drivers/media/dvb/dvb-usb/m920x.c                  |  235 ++-
 drivers/media/dvb/dvb-usb/m920x.h                  |   46 +-
 drivers/media/dvb/dvb-usb/opera1.c                 |  581 ++++++++
 drivers/media/dvb/dvb-usb/opera1.h                 |    9 +
 drivers/media/dvb/dvb-usb/ttusb2.c                 |    7 +-
 drivers/media/dvb/frontends/Kconfig                |   28 +-
 drivers/media/dvb/frontends/Makefile               |    3 +-
 drivers/media/dvb/frontends/dvb-pll.c              |  340 +++--
 drivers/media/dvb/frontends/dvb-pll.h              |   16 +-
 drivers/media/dvb/frontends/lgdt330x.c             |    4 +-
 drivers/media/dvb/frontends/lgh06xf.c              |  134 --
 drivers/media/dvb/frontends/lgh06xf.h              |   35 -
 drivers/media/dvb/frontends/or51132.c              |  305 ++---
 drivers/media/dvb/frontends/tda10021.c             |   47 +-
 drivers/media/dvb/frontends/tda10023.c             |  540 +++++++
 .../media/dvb/frontends/{tda10021.h => tda1002x.h} |   33 +-
 drivers/media/dvb/frontends/tda1004x.c             |   98 +-
 drivers/media/dvb/frontends/tda1004x.h             |   54 +-
 drivers/media/dvb/frontends/tda827x.c              |  512 +++++++
 drivers/media/dvb/frontends/tda827x.h              |   62 +
 drivers/media/dvb/pluto2/Kconfig                   |    1 -
 drivers/media/dvb/ttpci/Kconfig                    |    6 +-
 drivers/media/dvb/ttpci/av7110.c                   |   17 +-
 drivers/media/dvb/ttpci/av7110.h                   |   28 +-
 drivers/media/dvb/ttpci/av7110_av.c                |   24 +-
 drivers/media/dvb/ttpci/av7110_hw.h                |   10 +-
 drivers/media/dvb/ttpci/av7110_ir.c                |  365 +++--
 drivers/media/dvb/ttpci/budget-av.c                |  147 +-
 drivers/media/dvb/ttpci/budget-ci.c                |   96 +-
 drivers/media/dvb/ttpci/budget-core.c              |   58 +-
 drivers/media/dvb/ttpci/budget.h                   |    3 +
 drivers/media/dvb/ttusb-budget/Kconfig             |    1 -
 drivers/media/radio/radio-aimslab.c                |  240 ++--
 drivers/media/radio/radio-gemtek-pci.c             |  253 ++--
 drivers/media/radio/radio-gemtek.c                 |  260 ++--
 drivers/media/radio/radio-maestro.c                |  266 ++--
 drivers/media/radio/radio-rtrack2.c                |  255 ++--
 drivers/media/radio/radio-sf16fmi.c                |  262 ++--
 drivers/media/radio/radio-sf16fmr2.c               |  350 +++--
 drivers/media/radio/radio-terratec.c               |  247 ++--
 drivers/media/radio/radio-trust.c                  |  256 ++--
 drivers/media/radio/radio-typhoon.c                |  239 ++--
 drivers/media/radio/radio-zoltrix.c                |  256 ++--
 drivers/media/video/Kconfig                        |   14 +
 drivers/media/video/Makefile                       |    2 +
 drivers/media/video/bt8xx/bttv-cards.c             |   53 +-
 drivers/media/video/bt8xx/bttv-driver.c            |   24 +-
 drivers/media/video/bt8xx/bttv-gpio.c              |    5 -
 drivers/media/video/bt8xx/bttv-i2c.c               |    2 +-
 drivers/media/video/bt8xx/bttv-if.c                |   48 -
 drivers/media/video/bt8xx/bttv.h                   |   25 +-
 drivers/media/video/bt8xx/bttvp.h                  |    3 +
 drivers/media/video/cafe_ccic.c                    |   79 +-
 drivers/media/video/cpia_pp.c                      |   49 +-
 drivers/media/video/cs53l32a.c                     |    4 +
 drivers/media/video/cx2341x.c                      |   72 +-
 drivers/media/video/cx25840/cx25840-core.c         |    9 +-
 drivers/media/video/cx25840/cx25840-core.h         |    3 +-
 drivers/media/video/cx25840/cx25840-firmware.c     |    1 -
 drivers/media/video/cx88/Kconfig                   |    1 -
 drivers/media/video/cx88/cx88-alsa.c               |    9 +-
 drivers/media/video/cx88/cx88-cards.c              |   37 +-
 drivers/media/video/cx88/cx88-core.c               |    8 +-
 drivers/media/video/cx88/cx88-dvb.c                |   31 +-
 drivers/media/video/cx88/cx88-i2c.c                |    3 +-
 drivers/media/video/cx88/cx88-mpeg.c               |   29 +-
 drivers/media/video/cx88/cx88-video.c              |    5 +-
 drivers/media/video/cx88/cx88.h                    |    4 +-
 drivers/media/video/em28xx/em28xx-i2c.c            |    2 +-
 drivers/media/video/ir-kbd-i2c.c                   |    2 +-
 drivers/media/video/ivtv/Kconfig                   |   26 +
 drivers/media/video/ivtv/Makefile                  |    7 +
 drivers/media/video/ivtv/ivtv-audio.c              |   74 +
 drivers/media/video/ivtv/ivtv-audio.h              |   23 +
 drivers/media/video/ivtv/ivtv-cards.c              |  964 ++++++++++++
 drivers/media/video/ivtv/ivtv-cards.h              |  207 +++
 drivers/media/video/ivtv/ivtv-controls.c           |  303 ++++
 drivers/media/video/ivtv/ivtv-controls.h           |   21 +
 drivers/media/video/ivtv/ivtv-driver.c             | 1374 +++++++++++++++++
 drivers/media/video/ivtv/ivtv-driver.h             |  868 +++++++++++
 drivers/media/video/ivtv/ivtv-fileops.c            |  921 ++++++++++++
 drivers/media/video/ivtv/ivtv-fileops.h            |   44 +
 drivers/media/video/ivtv/ivtv-firmware.c           |  272 ++++
 drivers/media/video/ivtv/ivtv-firmware.h           |   25 +
 drivers/media/video/ivtv/ivtv-gpio.c               |  307 ++++
 drivers/media/video/ivtv/ivtv-gpio.h               |   25 +
 drivers/media/video/ivtv/ivtv-i2c.c                |  748 ++++++++++
 drivers/media/video/ivtv/ivtv-i2c.h                |   36 +
 drivers/media/video/ivtv/ivtv-ioctl.c              | 1567 ++++++++++++++++++++
 drivers/media/video/ivtv/ivtv-ioctl.h              |   28 +
 drivers/media/video/ivtv/ivtv-irq.c                |  838 +++++++++++
 drivers/media/video/ivtv/ivtv-irq.h                |   26 +
 drivers/media/video/ivtv/ivtv-mailbox.c            |  360 +++++
 drivers/media/video/ivtv/ivtv-mailbox.h            |   25 +
 drivers/media/video/ivtv/ivtv-queue.c              |  262 ++++
 drivers/media/video/ivtv/ivtv-queue.h              |   64 +
 drivers/media/video/ivtv/ivtv-streams.c            |  977 ++++++++++++
 drivers/media/video/ivtv/ivtv-streams.h            |   31 +
 drivers/media/video/ivtv/ivtv-udma.c               |  200 +++
 drivers/media/video/ivtv/ivtv-udma.h               |   43 +
 drivers/media/video/ivtv/ivtv-vbi.c                |  538 +++++++
 drivers/media/video/ivtv/ivtv-vbi.h                |   26 +
 drivers/media/video/ivtv/ivtv-version.h            |   26 +
 drivers/media/video/ivtv/ivtv-video.c              |  142 ++
 drivers/media/video/ivtv/ivtv-video.h              |   24 +
 drivers/media/video/ivtv/ivtv-yuv.c                | 1129 ++++++++++++++
 drivers/media/video/ivtv/ivtv-yuv.h                |   24 +
 drivers/media/video/msp3400-driver.c               |    5 +
 drivers/media/video/msp3400-driver.h               |    1 +
 drivers/media/video/ov7670.c                       |   40 +-
 drivers/media/video/planb.c                        |    6 +-
 drivers/media/video/planb.h                        |    1 +
 drivers/media/video/pvrusb2/pvrusb2-encoder.c      |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    2 +
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |   16 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.h          |    3 +
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c        |   30 +
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    2 +
 drivers/media/video/pwc/pwc-ctrl.c                 |   61 +-
 drivers/media/video/pwc/pwc-if.c                   |   16 +-
 drivers/media/video/pwc/pwc-ioctl.h                |   36 +-
 drivers/media/video/pwc/pwc-kiara.c                |    2 +
 drivers/media/video/pwc/pwc-kiara.h                |    5 +-
 drivers/media/video/pwc/pwc-timon.c                |    4 +-
 drivers/media/video/pwc/pwc-timon.h                |    6 +-
 drivers/media/video/pwc/pwc-v4l.c                  |   60 +-
 drivers/media/video/pwc/pwc.h                      |    5 +-
 drivers/media/video/saa7115.c                      |   10 +-
 drivers/media/video/saa7127.c                      |   12 +-
 drivers/media/video/saa7134/Kconfig                |    1 +
 drivers/media/video/saa7134/saa7134-cards.c        |  204 +++-
 drivers/media/video/saa7134/saa7134-core.c         |  125 +-
 drivers/media/video/saa7134/saa7134-dvb.c          | 1027 +++++--------
 drivers/media/video/saa7134/saa7134-i2c.c          |    4 +-
 drivers/media/video/saa7134/saa7134-input.c        |    1 +
 drivers/media/video/saa7134/saa7134-video.c        |   85 +-
 drivers/media/video/saa7134/saa7134.h              |   10 +-
 drivers/media/video/se401.c                        |   36 +-
 drivers/media/video/sn9c102/Kconfig                |    2 +-
 drivers/media/video/sn9c102/Makefile               |   17 +-
 drivers/media/video/sn9c102/sn9c102.h              |   17 +-
 drivers/media/video/sn9c102/sn9c102_core.c         |  274 +++--
 drivers/media/video/sn9c102/sn9c102_devtable.h     |   14 +-
 drivers/media/video/sn9c102/sn9c102_hv7131d.c      |   25 +-
 drivers/media/video/sn9c102/sn9c102_hv7131r.c      |  366 +++++
 drivers/media/video/sn9c102/sn9c102_mi0343.c       |  130 +-
 drivers/media/video/sn9c102/sn9c102_mi0360.c       |  338 +++++
 drivers/media/video/sn9c102/sn9c102_ov7630.c       |  121 +-
 drivers/media/video/sn9c102/sn9c102_ov7660.c       |  234 +--
 drivers/media/video/sn9c102/sn9c102_pas106b.c      |   23 +-
 drivers/media/video/sn9c102/sn9c102_pas202bcb.c    |   77 +-
 drivers/media/video/sn9c102/sn9c102_sensor.h       |   12 +-
 drivers/media/video/sn9c102/sn9c102_tas5110c1b.c   |   18 +-
 drivers/media/video/sn9c102/sn9c102_tas5110d.c     |  118 ++
 drivers/media/video/sn9c102/sn9c102_tas5130d1b.c   |   19 +-
 drivers/media/video/tda7432.c                      |    1 -
 drivers/media/video/tda8290.c                      |  144 ++-
 drivers/media/video/tda9875.c                      |    1 -
 drivers/media/video/tuner-core.c                   |   28 +-
 drivers/media/video/tvaudio.c                      |    5 +-
 drivers/media/video/tveeprom.c                     |   45 +-
 drivers/media/video/upd64031a.c                    |    4 +
 drivers/media/video/upd64083.c                     |    5 +
 drivers/media/video/usbvideo/usbvideo.c            |   18 +-
 drivers/media/video/usbvision/usbvision-cards.c    | 1165 +++++++++++++--
 drivers/media/video/usbvision/usbvision-cards.h    |   66 +
 drivers/media/video/usbvision/usbvision-core.c     |   10 +-
 drivers/media/video/usbvision/usbvision-i2c.c      |  104 +-
 drivers/media/video/usbvision/usbvision-video.c    |  173 +--
 drivers/media/video/usbvision/usbvision.h          |   39 +-
 drivers/media/video/v4l2-common.c                  |   41 +-
 drivers/media/video/videocodec.c                   |    3 +
 drivers/media/video/videodev.c                     |   40 +-
 drivers/media/video/wm8739.c                       |    4 +
 drivers/media/video/wm8775.c                       |    4 +
 drivers/media/video/zr364xx.c                      |  929 ++++++++++++
 include/linux/dvb/audio.h                          |    5 +-
 include/linux/dvb/version.h                        |    2 +-
 include/linux/dvb/video.h                          |   62 +
 include/linux/videodev2.h                          |   83 +-
 include/media/cx2341x.h                            |    6 +-
 include/media/ivtv.h                               |   65 +
 include/media/tuner.h                              |    5 +
 include/media/v4l2-chip-ident.h                    |  149 ++
 include/media/v4l2-common.h                        |   47 +-
 include/media/v4l2-dev.h                           |   10 +
 222 files changed, 23073 insertions(+), 4357 deletions(-)
 create mode 100644 Documentation/video4linux/CARDLIST.ivtv
 create mode 100644 Documentation/video4linux/CARDLIST.usbvision
 create mode 100644 Documentation/video4linux/README.ivtv
 create mode 100644 Documentation/video4linux/zr364xx.txt
 create mode 100644 drivers/media/dvb/dvb-usb/opera1.c
 create mode 100644 drivers/media/dvb/dvb-usb/opera1.h
 delete mode 100644 drivers/media/dvb/frontends/lgh06xf.c
 delete mode 100644 drivers/media/dvb/frontends/lgh06xf.h
 create mode 100644 drivers/media/dvb/frontends/tda10023.c
 rename drivers/media/dvb/frontends/{tda10021.h => tda1002x.h} (66%)
 create mode 100644 drivers/media/dvb/frontends/tda827x.c
 create mode 100644 drivers/media/dvb/frontends/tda827x.h
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
 create mode 100644 drivers/media/video/sn9c102/sn9c102_hv7131r.c
 create mode 100644 drivers/media/video/sn9c102/sn9c102_mi0360.c
 create mode 100644 drivers/media/video/sn9c102/sn9c102_tas5110d.c
 create mode 100644 drivers/media/video/usbvision/usbvision-cards.h
 create mode 100644 drivers/media/video/zr364xx.c
 create mode 100644 include/media/ivtv.h
 create mode 100644 include/media/v4l2-chip-ident.h

Aapo Tahkola (5):
      V4L/DVB (5423): M920x: i2c cleanups
      V4L/DVB (5424): Fix i2c implementation for gl861 and au6610
      V4L/DVB (5425): M920x: rework driver code to allow for different devices
      V4L/DVB (5426): M920x: remove unneeded code
      V4L/DVB (5448): M920x: rename megasky_identify_state to m920x_identify_state

Adrian Bunk (5):
      V4L/DVB (5278): Bt8xx/: possible cleanups
      V4L/DVB (5293): Make dvb_usb_gl861_debug static
      V4L/DVB (5294): Make pvr2_encoder_prep_config() static
      V4L/DVB (5397): Saa7134: fix MODULES=n compilation
      V4L/DVB (5471): Cpia_pp.c: convert to module_{init,exit}

Akinobu Mita (1):
      V4L/DVB (5513): Bt878: prevent probing wrong card entry

Alan Cox (2):
      V4L/DVB (5551): Plan-b: header change
      V4L/DVB (5552): Plan-b: Switch to refcounting PCI API

Amit Choudhary (2):
      V4L/DVB (5489): Codec.c: check kmalloc() return value.
      V4L/DVB (5490): Drivers/media/video/se401.c: check kmalloc() return value.

Andrew Morton (1):
      V4L/DVB (5388): Ivtv warning fix

Antoine Jacquet (2):
      V4L/DVB (5257): USB: add zr364xx V4L2 driver
      V4L/DVB (5385): Fix compilation issue with zr364xx when V4L1 is disabled

Christophe Cattelain (1):
      V4L/DVB (5371): [PATCH] Pinnacle PCTV Sat Pro USB (450e) support by ttusb2.c (400e driver)

Damian Minkov (1):
      V4L/DVB (5481): Fix audio input for AverTv Go 007

David Härdeman (1):
      V4L/DVB (5335): Budget-ci: Use the repeat handling of the input subsystem

Dennis Ranke (1):
      V4L/DVB (5373): [PATCH] Hauppauge Nova-T endianess problem on powerpc

Douglas Landgraf (12):
      V4L/DVB (5534): Radio-rtrack2.c Replace rt_ioctl to use video_ioctl2
      V4L/DVB (5539): Radio-rtrack2.c Added VIDIOC_[GS]_AUDIO and VIDIOC_[S|G]_INPUT
      V4L/DVB (5540): Radio-trust.c Replace tr_do_ioctl to use video_ioctl2
      V4L/DVB (5541): Radio-zoltrix.c Replace zol_do_ioctl to use video_ioctl2
      V4L/DVB (5546): Radio-terratec.c Replace tt_do_ioctl to use video_ioctl2
      V4L/DVB (5549): Radio-sf16fmr2.c Replace fmr2_do_ioctl to use video_ioctl2
      V4L/DVB (5550): Radio-sf16fmi.c Replace fmi_do_ioctl to use video_ioctl2
      V4L/DVB (5553): Replace typhoon_do_ioctl to use video_ioctl2
      V4L/DVB (5555): Radio-aimslab.c Replace rt_ioctl to use video_ioctl2
      V4L/DVB (5556): Radio-gemtek.c Replace gemtek_ioctl to use video_ioctl2
      V4L/DVB (5562): Radio-gemtek-pci.c Replace gemtek_pci_ioctl to use video_ioctl2
      V4L/DVB (5563): Radio-maestro.c Replace radio_ioctl to use video_ioctl2

Dwaine P. Garden (1):
      V4L/DVB (5386): Add some missing Hauppauge and Belkin devices to the driver

Ed Vipas (1):
      V4L/DVB (5486): Add support for remote of Asustech P7131 Hybrid	LNA

Emil Georgiev (1):
      V4L/DVB (5383): Fix duplicated codes in Pinnacle Grey remote

Hans Verkuil (36):
      V4L/DVB (5268): Add support for three new MPEG controls.
      V4L/DVB (5272): Add V4L2_CAP_VIDEO_OUTPUT_POS capability
      V4L/DVB (5289): Add support for video output overlays.
      V4L/DVB (5290): Add support for VIDIOC_INT_G/S_STD_OUTPUT
      V4L/DVB (5306): Add support for VIDIOC_G_CHIP_IDENT
      V4L/DVB (5307): Add support for the cx23415 MPEG decoding features.
      V4L/DVB (5336): Cx23416 doc updates + rename CX2341X_ENC_UNKNOWN
      V4L/DVB (5341): Add cx23415/6 chip idents.
      V4L/DVB (5345): ivtv driver for Conexant cx23416/cx23415 MPEG encoder/decoder
      V4L/DVB (5355): Add VIDIOC_G_CHIP_IDENT to various i2c modules
      V4L/DVB (5356): Fix bogus error messages in ivtv for VIDIOC_G_CHIP_IDENT
      V4L/DVB (5375): Add missing VIDEO_CX25840 dep, remove unused VIDEO_TLV320AIC23B dep
      V4L/DVB (5376): Add dependency on VIDEO_V4L1
      V4L/DVB (5377): Replace SA_* with IRQF_*
      V4L/DVB (5378): Add missing IVTV_FB_WARN #define
      V4L/DVB (5379): If possible make vars/functions static.
      V4L/DVB (5389): Add tveeprom entry for tuner LG S701D MK3
      V4L/DVB (5402): Add vsync_field to the union in video_event for VIDEO_EVENT_VSYNC
      V4L/DVB (5403): Set vsync_field correctly in ivtv.
      V4L/DVB (5404): Merges VBI & YUV handling into a single work queue.
      V4L/DVB (5405): Add missing includes.
      V4L/DVB (5406): Add comment why the symbols are exported.
      V4L/DVB (5407a): Update feature-removal-schedule.txt: remove VIDIOC_S/G_MPEGCOMP
      V4L/DVB (5409): Add CARDLIST.ivtv and README.ivtv
      V4L/DVB (5410): Add VIDIOC_G/S_PRIORITY support to ivtv.
      V4L/DVB (5411): Use v4l_printk_ioctl for debug
      V4L/DVB (5412): Fix VIDIOC_TRY_ENCODER_CMD and VIDEO_TRY_COMMAND
      V4L/DVB (5413): Use spin_lock_init to fix lockdep warnings.
      V4L/DVB (5414): Add missing kfree in early exit of saa7115.
      V4L/DVB (5416): Use pci_register_driver instead of pci_module_init in ivtv.
      V4L/DVB (5417): First unregister the driver, and then free the memory.
      V4L/DVB (5418): Speed is a signed 32-bit integer, not unsigned.
      V4L/DVB (5419): Add comment how the speed field is interpreted.
      V4L/DVB (5420): Initialize the inputs before registering the devices.
      V4L/DVB (5436): Fix TV output initialization
      V4L/DVB (5560): Ivtv: fix incorrect bitwise-and for command flags.

Hartmut Birr (4):
      V4L/DVB (5542): Budget-av: Remove polarity switching of the clock for DVB-C
      V4L/DVB (5543): Tda10023: Add support for frontend TDA10023
      V4L/DVB (5544): Budget-av: Make inversion setting configurable, add KNC ONE V1.0 card
      V4L/DVB (5545): Saa7146: Release capture buffers on device close

Hartmut Hackmann (20):
      V4L/DVB (5311): Tda1004x driver updates
      V4L/DVB (5312): Saa713x: added a GPIO handler function
      V4L/DVB (5313): Added a config entry and a gpio function pointer to tuner struct
      V4L/DVB (5314): Added support for tda827x tuners with preamlifiers
      V4L/DVB (5315): Tda1004x: check request firmware for NULL ponter again
      V4L/DVB (5318): Fix tda8290 code for tda827x module
      V4L/DVB (5319): Set tda827x to sleep mode after attach
      V4L/DVB (5320): Filled in limiting values in tda827x.c
      V4L/DVB (5321): Saa7134-dvb: initialize the dvb frontend in dvb_init
      V4L/DVB (5322): Removed board naming code in saa7134-dvb
      V4L/DVB (5323): Updated support for tuner callbacks
      V4L/DVB (5326): Allow to set tuner_config in attach inform
      V4L/DVB (5369): Fixed 1 byte too short buffer in tda827x.c
      V4L/DVB (5443): Saa7134: put tuner to sleep mode after board initialization
      V4L/DVB (5444): Saa7134-dvb fix sleep function of the fmd1216 tuner.
      V4L/DVB (5445): Added / corrected support for some ASUS hybrid boards
      V4L/DVB (5446): Renamed ASUStek P7131 card [1043:4876]
      V4L/DVB (5458): Tda1004x: add ts_mode option to config struct
      V4L/DVB (5484): Set tda8290 to analog mode after init
      V4L/DVB (5485): Tda827x: delayed probing of tuner version

Heikki Orsila (1):
      V4L/DVB (5329): Some saa7134 cleanups

Hendrik Borghorst (1):
      V4L/DVB (5505): Fix Kernel Bugzilla #8301: spinlock fix for flexcop-pci

Ian Armstrong (2):
      V4L/DVB (5437): Update cx23415 documentation
      V4L/DVB (5438): Fix ivtv yuv threshold handling

Jarod Wilson (1):
      V4L/DVB (5482): Bttv: automatically load dvb-bt8xx for bttv cards with dvb

Jean Delvare (3):
      V4L/DVB (5380): Cx25840-firmware include cleanup
      V4L/DVB (5491): Cx88: Support the DTV1000 T analog inputs
      V4L/DVB (5492): Remove useless includes of i2c-algo-bit.h

Jean Tourrilhes (1):
      V4L/DVB (5461): Pwc: cisco VT Camera support

Jonathan Corbet (7):
      V4L/DVB (5464): Set the PCI device in the V4L2 device
      V4L/DVB (5465): Remove an obsolete PCI ID
      V4L/DVB (5466): Fix up some Cafe CCIC delay issues
      V4L/DVB (5467): Add suspend/resume support to the Cafe CCIC
      V4L/DVB (5468): Don't mirror ov7670 images by default
      V4L/DVB (5469a): Copyright and maintainer tweaks
      V4L/DVB (5469): Add raw bayer support to the ov7670 driver

Luc Saillard (2):
      V4L/DVB (5547): Add ENUM_FRAMESIZES and ENUM_FRAMEINTERVALS ioctls
      V4L/DVB (5548): Fix v4l2 buffer to the length

Luca Risolia (1):
      V4L/DVB (5474): SN9C1xx driver updates

Marco Gittler (2):
      V4L/DVB (5532): Add support for Opera S1- DVB-USB
      V4L/DVB (5558): Opera: use 7-bit i2c addresses

Markus Rechberger (7):
      V4L/DVB (5298): Added support for deferred module requesting to cx88
      V4L/DVB (5299): Added support for loading cx88-dvb and cx88-blackbird
      V4L/DVB (5324): This patch fixes request_module_depend()
      V4L/DVB (5330): Added card definition for AverMedia M102 miniPCI
      V4L/DVB (5510): Fix 1/3 for bug 7819: fixed frontend hotplug issue
      V4L/DVB (5511): Fix 2/3 for bug 7819: demux and dvr
      V4L/DVB (5512): Fix 3/3 for bug 7819: fixed hotplugging for dvbnet

Mauro Carvalho Chehab (14):
      V4L/DVB (5297): Fix identation on tda10021.c
      V4L/DVB (5462): Add Logitech ViewPort AV 100
      V4L/DVB (5476): Fix gpiomux array size
      V4L/DVB (5477): CodingStyle cleanups on for loops at bttv-cards.c
      V4L/DVB (5478): Use ARRAY_SIZE and a cleaner logic for initializing tuner
      V4L/DVB (5479): Use ARRAY_SIZE instead of a magic number
      V4L/DVB (5480): Fix cx88_print_irqbits calls to use ARRAY_SIZE
      V4L/DVB (5488): Replace DMA magic mask for its aliases
      V4L/DVB (5500): Add a CARDLIST for the supported devices by usbvision driver
      V4L/DVB (5515): Use a better format to represent usbvision supported boards
      V4L/DVB (5516): Reduce usbvision data size
      V4L/DVB (5518): Fix a bug on device detection
      V4L/DVB (5521): Usb_get_dev were called twice. Removing the extra call.
      V4L/DVB (5554): Fix: vidioc_g_parm were not zeroing the memory

Michael Krufky (3):
      V4L/DVB (5317): Create tda827x dvb tuner module
      V4L/DVB (5431): Cx88: autodetect ADS Tech InstantTV DVB-S
      V4L/DVB (5432): Cx88: whitespace cleanup

Mike Isely (2):
      V4L/DVB (5367): Pvrusb2: (trivial) Fix too-wide source line
      V4L/DVB (5507): Pvrusb2: Gather USB bus address info and report it

Oleg Nesterov (1):
      V4L/DVB (5398): Cpia_pp.c: don't use _WORK_NAR

Oliver Endriss (4):
      V4L/DVB (5334): Dvb-ttpci: Infrared remote control refactoring
      V4L/DVB (5344): Dvb-ttpci: Support for MSC_RAW and MSC_SCAN RC events
      V4L/DVB (5381): Dvb-ttpci: Update frontend lock status in transfer mode (bugfix)
      V4L/DVB (5440): Dvb-ttpci: Infrared remote initialization fix

Oliver Neukum (1):
      V4L/DVB (5399): Usbvideo module handling

Peter Missel (2):
      V4L/DVB (5316): Add radio support for the Lifeview FlyDVB-T Duo
      V4L/DVB (5331): Identify MSI TV@nywhere Duo

Pierre Willenbrock (2):
      V4L/DVB (5449): M920x: add error messages for debugging purposes
      V4L/DVB (5459): M920x: add support for Anubis Electronics / MSI Digi Vox Mini II

Scott Alfter (1):
      V4L/DVB (5497): Additional card support for bttv driver

Steven Toth (1):
      V4L/DVB (5434): Updates to the tveeprom tuner, video decoder and audio chip

Thierry MERLE (6):
      V4L/DVB (5522): Usbvision: i2c function cleanups
      V4L/DVB (5523): Usbvision: fix a debug message in usb probe function
      V4L/DVB (5524): Usbvision: fix TDA9887 detection
      V4L/DVB (5528): Usbvision: reverting some i2c cleanups
      V4L/DVB (5529): Usbvision: remove not needed TUNER_SET_TYPE_ADDR call
      V4L/DVB (5530): Usbvision: remove CustomDevice facility

Trent Piepho (20):
      V4L/DVB (5360): Dvb-pll: Use sizeof() to get name length
      V4L/DVB (5361): Dvb-pll: Fix Kconfig files and allow dvb-pll to be optional
      V4L/DVB (5362): Dvb-pll: add code for doing tuner initialization
      V4L/DVB (5363): Dvb: Remove lgh06xf driver
      V4L/DVB (5374): Or51132: refactor i2c code, improve error resilience
      V4L/DVB (5391): Saa7134: Clean up printk()s
      V4L/DVB (5392): Zr364xx: Use kernel's byte-swapping function
      V4L/DVB (5427): M920x: Improve I2C operations
      V4L/DVB (5428): M920x: Detect zero-length I2C messages and fix a typo
      V4L/DVB (5452): Cx88: merge identical boards
      V4L/DVB (5455): Dvb-pll: Adjust rounding to be consistent
      V4L/DVB (5456): Dvb-pll: Move IF frequency from per-band data to per-tuner data
      V4L/DVB (5457): Dvb-pll: Replace sleep function with a more capable one
      V4L/DVB (5494): Lgdt330x: Fix some warnings
      V4L/DVB (5502): Sn9c102: more efficient register writing code
      V4L/DVB (5503): Sn9c102: declare constant byte sequences as static const
      V4L/DVB (5504): Sn9c102: Make driver V4L2 not V4L1
      V4L/DVB (5517): Usbvision: store the device database more efficiently
      V4L/DVB (5525): Usbvision: fix confusion over 7-bit vs 8-bit TDDA9887 addresses
      V4L/DVB (5557): Cafe_ccic: check return value of pci_enable_device

Ville-Pekka Vainio (1):
      V4L/DVB (5520): Add support for the extra keys in the black Technotrend 1500 IR

vignesh.babu@wipro.com (1):
      V4L/DVB (5526): Cx88-alsa.c: Use kzalloc

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

