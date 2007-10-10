Return-Path: <linux-kernel-owner+w=401wt.eu-S1757677AbXJJWDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbXJJWDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 18:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbXJJWDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 18:03:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39000 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbXJJWDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 18:03:41 -0400
Date: Wed, 10 Oct 2007 18:50:34 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB changes for 2.6.24
Message-Id: <1192053794.15601.47.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

We have 300+ patches this time, covering lots of drivers improvements and fixes.

Also, there are several core changes:
	- Unified support for Hybrid tuners on both V4L and DVB core;
	- videobuf split into PCI DMA S/G specific and a generic module;
	- added a videobuf handler for drivers that need vmalloc'ed memory like 
	  USB devices).

And some driver additions:
	- cx23885 driver;
	- ivtv framebuffer driver;
	- tcm825x driver.

I still have two cx88-alsa patches pending, at devel tree. Those two are 
dependent from -ALSA merge. So, I should send you a pull request later, after 
being sure that you've already pulled from alsa.

Cheers,
Mauro.

---

 Documentation/dvb/faq.txt                          |    2 +-
 Documentation/video4linux/CARDLIST.bttv            |    1 +
 Documentation/video4linux/CARDLIST.cx23885         |    5 +
 Documentation/video4linux/CARDLIST.saa7134         |    5 +-
 drivers/media/Kconfig                              |   70 +-
 drivers/media/common/Kconfig                       |    2 +-
 drivers/media/common/ir-functions.c                |    1 -
 drivers/media/common/ir-keymaps.c                  |   62 +-
 drivers/media/common/saa7146_core.c                |   34 +-
 drivers/media/common/saa7146_fops.c                |    5 +-
 drivers/media/common/saa7146_i2c.c                 |   23 +-
 drivers/media/common/saa7146_vbi.c                 |    9 +-
 drivers/media/common/saa7146_video.c               |   11 +-
 drivers/media/dvb/bt8xx/bt878.c                    |    1 -
 drivers/media/dvb/bt8xx/bt878.h                    |    7 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c                |    1 -
 drivers/media/dvb/cinergyT2/cinergyT2.c            |    8 +-
 drivers/media/dvb/dvb-core/dmxdev.c                |    1 -
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c        |   93 +-
 drivers/media/dvb/dvb-core/dvb_demux.c             |    5 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c          |  125 ++-
 drivers/media/dvb/dvb-core/dvb_frontend.h          |   13 +-
 drivers/media/dvb/dvb-core/dvb_net.c               |   22 +-
 drivers/media/dvb/dvb-core/dvbdev.c                |   41 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |    2 +
 drivers/media/dvb/dvb-usb/dib0700.h                |    5 +-
 drivers/media/dvb/dvb-usb/dib0700_core.c           |   23 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  676 +++++++++-
 drivers/media/dvb/dvb-usb/dtt200u.c                |   28 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |   26 +-
 drivers/media/dvb/dvb-usb/dvb-usb-init.c           |    2 +-
 drivers/media/dvb/dvb-usb/gp8psk-fe.c              |   84 +-
 drivers/media/dvb/dvb-usb/gp8psk.c                 |   93 +-
 drivers/media/dvb/dvb-usb/gp8psk.h                 |   32 +-
 drivers/media/dvb/dvb-usb/vp7045.c                 |    2 +-
 drivers/media/dvb/frontends/Kconfig                |   33 +-
 drivers/media/dvb/frontends/Makefile               |    4 +
 drivers/media/dvb/frontends/bcm3510.c              |    1 -
 drivers/media/dvb/frontends/cx22700.c              |    1 -
 drivers/media/dvb/frontends/cx24110.c              |    1 -
 drivers/media/dvb/frontends/cx24123.c              |    1 -
 drivers/media/dvb/frontends/dib0070.c              |  580 ++++++++
 drivers/media/dvb/frontends/dib0070.h              |   44 +
 drivers/media/dvb/frontends/dib3000mb.c            |    1 -
 drivers/media/dvb/frontends/dib3000mc.c            |  192 ++-
 drivers/media/dvb/frontends/dib7000m.c             |  727 ++++++----
 drivers/media/dvb/frontends/dib7000p.c             |  908 ++++++++----
 drivers/media/dvb/frontends/dib7000p.h             |   14 +-
 drivers/media/dvb/frontends/dibx000_common.h       |   57 +-
 drivers/media/dvb/frontends/dvb-pll.c              |  147 ++-
 drivers/media/dvb/frontends/dvb_dummy_fe.c         |    1 -
 drivers/media/dvb/frontends/isl6421.c              |    1 -
 drivers/media/dvb/frontends/l64781.c               |    1 -
 drivers/media/dvb/frontends/lgdt330x.c             |    1 -
 drivers/media/dvb/frontends/lnbp21.c               |    1 -
 drivers/media/dvb/frontends/mt2060.c               |    1 -
 drivers/media/dvb/frontends/mt2131.c               |  314 ++++
 drivers/media/dvb/frontends/mt2131.h               |   54 +
 drivers/media/dvb/frontends/mt2131_priv.h          |   49 +
 drivers/media/dvb/frontends/mt2266.c               |  287 ++++
 drivers/media/dvb/frontends/mt2266.h               |   37 +
 drivers/media/dvb/frontends/mt312.c                |    1 -
 drivers/media/dvb/frontends/mt352.c                |    1 -
 drivers/media/dvb/frontends/nxt200x.c              |    1 -
 drivers/media/dvb/frontends/or51132.c              |    1 -
 drivers/media/dvb/frontends/or51211.c              |    1 -
 drivers/media/dvb/frontends/s5h1409.c              |  729 ++++++++++
 drivers/media/dvb/frontends/s5h1409.h              |   73 +
 drivers/media/dvb/frontends/sp8870.c               |    1 -
 drivers/media/dvb/frontends/sp887x.c               |    1 -
 drivers/media/dvb/frontends/stv0297.c              |    4 +-
 drivers/media/dvb/frontends/stv0299.c              |    1 -
 drivers/media/dvb/frontends/tda10021.c             |    4 +-
 drivers/media/dvb/frontends/tda10023.c             |   10 +-
 drivers/media/dvb/frontends/tda1004x.c             |    1 -
 drivers/media/dvb/frontends/tda10086.c             |    1 -
 drivers/media/dvb/frontends/tda8083.c              |    9 +-
 drivers/media/dvb/frontends/ves1820.c              |    4 +-
 drivers/media/dvb/frontends/zl10353.c              |    1 -
 drivers/media/dvb/ttpci/av7110.c                   |    3 +-
 drivers/media/dvb/ttpci/av7110_hw.c                |   28 +-
 drivers/media/dvb/ttpci/av7110_ir.c                |    3 +-
 drivers/media/dvb/ttpci/av7110_v4l.c               |    6 +-
 drivers/media/dvb/ttpci/budget-av.c                |    2 +-
 drivers/media/dvb/ttpci/budget-ci.c                |    2 +-
 drivers/media/dvb/ttpci/budget-core.c              |    1 -
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c  |    1 -
 drivers/media/dvb/ttusb-dec/ttusb_dec.c            |    1 -
 drivers/media/radio/Kconfig                        |   24 +-
 drivers/media/radio/radio-gemtek.c                 |  618 ++++++---
 drivers/media/radio/radio-terratec.c               |    2 +-
 drivers/media/video/Kconfig                        |   29 +-
 drivers/media/video/Makefile                       |   28 +-
 drivers/media/video/arv.c                          |    3 +-
 drivers/media/video/bt8xx/Kconfig                  |    2 +-
 drivers/media/video/bt8xx/bttv-cards.c             |   38 +-
 drivers/media/video/bt8xx/bttv-driver.c            |   31 +-
 drivers/media/video/bt8xx/bttv-gpio.c              |    6 +-
 drivers/media/video/bt8xx/bttv-i2c.c               |    1 -
 drivers/media/video/bt8xx/bttv-input.c             |    1 -
 drivers/media/video/bt8xx/bttv-risc.c              |   35 +-
 drivers/media/video/bt8xx/bttv-vbi.c               |    6 +-
 drivers/media/video/bt8xx/bttv.h                   |    2 +
 drivers/media/video/bt8xx/bttvp.h                  |    2 +-
 drivers/media/video/btcx-risc.c                    |    1 -
 drivers/media/video/bw-qcam.c                      |   18 +-
 drivers/media/video/cafe_ccic.c                    |   21 +-
 drivers/media/video/compat_ioctl32.c               |    5 +
 drivers/media/video/cpia.c                         |    1 -
 drivers/media/video/cpia2/cpia2_v4l.c              |    1 -
 drivers/media/video/cx2341x.c                      |   19 +-
 drivers/media/video/cx23885/Kconfig                |   20 +
 drivers/media/video/cx23885/Makefile               |    9 +
 drivers/media/video/cx23885/cx23885-cards.c        |  280 ++++
 drivers/media/video/cx23885/cx23885-core.c         | 1530 ++++++++++++++++++++
 drivers/media/video/cx23885/cx23885-dvb.c          |  213 +++
 drivers/media/video/cx23885/cx23885-i2c.c          |  382 +++++
 drivers/media/video/cx23885/cx23885-reg.h          |  431 ++++++
 drivers/media/video/cx23885/cx23885.h              |  301 ++++
 drivers/media/video/cx25840/cx25840-audio.c        |   75 +-
 drivers/media/video/cx25840/cx25840-core.c         |   98 +-
 drivers/media/video/cx25840/cx25840-core.h         |    6 +-
 drivers/media/video/cx88/Kconfig                   |    4 +-
 drivers/media/video/cx88/cx88-alsa.c               |  315 ++--
 drivers/media/video/cx88/cx88-blackbird.c          |   31 +-
 drivers/media/video/cx88/cx88-cards.c              |  219 +++-
 drivers/media/video/cx88/cx88-core.c               |  222 +---
 drivers/media/video/cx88/cx88-dvb.c                |   25 +-
 drivers/media/video/cx88/cx88-i2c.c                |   27 +-
 drivers/media/video/cx88/cx88-input.c              |   20 +-
 drivers/media/video/cx88/cx88-mpeg.c               |  142 +-
 drivers/media/video/cx88/cx88-reg.h                |   35 +
 drivers/media/video/cx88/cx88-tvaudio.c            |   22 +-
 drivers/media/video/cx88/cx88-vbi.c                |   13 +-
 drivers/media/video/cx88/cx88-video.c              |  169 +--
 drivers/media/video/cx88/cx88-vp3054-i2c.c         |    5 +-
 drivers/media/video/cx88/cx88.h                    |   39 +-
 drivers/media/video/dpc7146.c                      |    5 +-
 drivers/media/video/em28xx/em28xx-core.c           |    1 -
 drivers/media/video/em28xx/em28xx-input.c          |    1 -
 drivers/media/video/em28xx/em28xx-video.c          |    6 +-
 drivers/media/video/et61x251/et61x251_core.c       |   59 +-
 drivers/media/video/ir-kbd-i2c.c                   |   38 +-
 drivers/media/video/ivtv/Kconfig                   |   17 +
 drivers/media/video/ivtv/Makefile                  |    5 +-
 drivers/media/video/ivtv/ivtv-audio.c              |   74 -
 drivers/media/video/ivtv/ivtv-cards.c              |   84 +-
 drivers/media/video/ivtv/ivtv-cards.h              |   67 +-
 drivers/media/video/ivtv/ivtv-controls.c           |   16 +-
 drivers/media/video/ivtv/ivtv-controls.h           |    5 +
 drivers/media/video/ivtv/ivtv-driver.c             |  332 +++--
 drivers/media/video/ivtv/ivtv-driver.h             |  691 ++++------
 drivers/media/video/ivtv/ivtv-fileops.c            |  199 ++--
 drivers/media/video/ivtv/ivtv-fileops.h            |    5 +
 drivers/media/video/ivtv/ivtv-firmware.h           |    5 +
 drivers/media/video/ivtv/ivtv-gpio.c               |   24 -
 drivers/media/video/ivtv/ivtv-gpio.h               |    7 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |   17 +-
 drivers/media/video/ivtv/ivtv-i2c.h                |    5 +
 drivers/media/video/ivtv/ivtv-ioctl.c              |  191 ++-
 drivers/media/video/ivtv/ivtv-ioctl.h              |    5 +
 drivers/media/video/ivtv/ivtv-irq.c                |  321 +++--
 drivers/media/video/ivtv/ivtv-irq.h                |   27 +
 drivers/media/video/ivtv/ivtv-mailbox.c            |    6 +-
 drivers/media/video/ivtv/ivtv-mailbox.h            |    8 +
 drivers/media/video/ivtv/ivtv-queue.c              |  119 +-
 drivers/media/video/ivtv/ivtv-queue.h              |   13 +-
 .../video/ivtv/{ivtv-video.c => ivtv-routing.c}    |   90 +-
 .../video/ivtv/{ivtv-audio.h => ivtv-routing.h}    |   12 +-
 drivers/media/video/ivtv/ivtv-streams.c            |  131 +--
 drivers/media/video/ivtv/ivtv-streams.h            |    5 +
 drivers/media/video/ivtv/ivtv-udma.c               |   46 +-
 drivers/media/video/ivtv/ivtv-udma.h               |    5 +
 drivers/media/video/ivtv/ivtv-vbi.c                |  283 ++--
 drivers/media/video/ivtv/ivtv-vbi.h                |    9 +-
 drivers/media/video/ivtv/ivtv-version.h            |    7 +-
 drivers/media/video/ivtv/ivtv-video.h              |   24 -
 drivers/media/video/ivtv/ivtv-yuv.c                |   55 +-
 drivers/media/video/ivtv/ivtv-yuv.h                |   21 +
 drivers/media/video/ivtv/ivtvfb.c                  | 1190 +++++++++++++++
 drivers/media/video/msp3400-driver.c               |   19 +-
 drivers/media/video/mt20xx.c                       |  311 +++--
 drivers/media/video/mt20xx.h                       |   37 +
 drivers/media/video/mxb.c                          |    4 +-
 drivers/media/video/ov511.c                        |   81 +-
 drivers/media/video/ov7670.c                       |    1 -
 drivers/media/video/ovcamchip/ovcamchip_core.c     |    1 -
 drivers/media/video/planb.c                        |   30 +-
 drivers/media/video/pvrusb2/pvrusb2-context.c      |    6 +-
 drivers/media/video/pvrusb2/pvrusb2-debug.h        |   53 +-
 drivers/media/video/pvrusb2/pvrusb2-debugifc.c     |   16 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    1 +
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |  310 ++++-
 drivers/media/video/pvrusb2/pvrusb2-hdw.h          |   12 +-
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c     |   63 +-
 drivers/media/video/pvrusb2/pvrusb2-main.c         |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-std.c          |    8 +-
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c        |  216 ++--
 drivers/media/video/pwc/pwc-ctrl.c                 |    2 +-
 drivers/media/video/pwc/pwc-if.c                   |  132 ++-
 drivers/media/video/saa6588.c                      |    1 +
 drivers/media/video/saa7127.c                      |   10 +-
 drivers/media/video/saa7134/Kconfig                |    4 +-
 drivers/media/video/saa7134/saa7134-alsa.c         |    3 +-
 drivers/media/video/saa7134/saa7134-cards.c        |   57 +-
 drivers/media/video/saa7134/saa7134-core.c         |  214 ++-
 drivers/media/video/saa7134/saa7134-dvb.c          |   23 +-
 drivers/media/video/saa7134/saa7134-empress.c      |   18 +-
 drivers/media/video/saa7134/saa7134-i2c.c          |    1 -
 drivers/media/video/saa7134/saa7134-input.c        |    1 -
 drivers/media/video/saa7134/saa7134-oss.c          |   43 +-
 drivers/media/video/saa7134/saa7134-ts.c           |   30 +-
 drivers/media/video/saa7134/saa7134-tvaudio.c      |    5 +-
 drivers/media/video/saa7134/saa7134-vbi.c          |    7 +-
 drivers/media/video/saa7134/saa7134-video.c        |  210 ++--
 drivers/media/video/saa7134/saa7134.h              |   23 +-
 drivers/media/video/sn9c102/sn9c102_core.c         |  113 +-
 drivers/media/video/stv680.c                       |   51 +-
 drivers/media/video/tcm825x.c                      |  928 ++++++++++++
 drivers/media/video/tcm825x.h                      |  199 +++
 drivers/media/video/tda8290.c                      |  517 ++++---
 drivers/media/video/tda8290.h                      |   54 +
 drivers/media/video/tda9887.c                      |   62 +-
 drivers/media/video/tea5761.c                      |  187 ++-
 drivers/media/video/tea5761.h                      |   47 +
 drivers/media/video/tea5767.c                      |  203 ++-
 drivers/media/video/tea5767.h                      |   47 +
 drivers/media/video/tuner-core.c                   |  256 +++-
 drivers/media/video/tuner-driver.h                 |   44 +-
 drivers/media/video/tuner-i2c.h                    |   70 +
 drivers/media/video/tuner-simple.c                 |  397 ++++--
 drivers/media/video/tuner-simple.h                 |   46 +
 drivers/media/video/tuner-types.c                  |    8 +
 drivers/media/video/tvaudio.c                      |    1 -
 drivers/media/video/tveeprom.c                     |    1 -
 drivers/media/video/tvmixer.c                      |    6 +-
 drivers/media/video/usbvision/usbvision-core.c     |    1 -
 drivers/media/video/usbvision/usbvision-i2c.c      |    4 +-
 drivers/media/video/usbvision/usbvision-video.c    |  120 +-
 drivers/media/video/v4l1-compat.c                  |    1 -
 drivers/media/video/v4l2-common.c                  |    6 +-
 drivers/media/video/v4l2-int-device.c              |  158 ++
 drivers/media/video/video-buf.c                    | 1425 ------------------
 drivers/media/video/videobuf-core.c                | 1006 +++++++++++++
 drivers/media/video/videobuf-dma-sg.c              |  726 ++++++++++
 .../video/{video-buf-dvb.c => videobuf-dvb.c}      |    9 +-
 drivers/media/video/videobuf-vmalloc.c             |  370 +++++
 drivers/media/video/videodev.c                     |   39 +-
 drivers/media/video/vino.c                         |    1 -
 drivers/media/video/vivi.c                         |  185 +--
 drivers/media/video/vp27smpx.c                     |  212 +++
 drivers/media/video/w9968cf.c                      |    3 +-
 drivers/media/video/zc0301/zc0301_core.c           |    3 +-
 drivers/media/video/zoran_card.c                   |   64 +-
 drivers/media/video/zoran_card.h                   |    8 +
 drivers/media/video/zoran_device.c                 |   19 +-
 drivers/media/video/zoran_driver.c                 |   31 +-
 drivers/media/video/zoran_procfs.c                 |    9 +-
 drivers/media/video/zr36016.c                      |    4 +-
 drivers/media/video/zr36050.c                      |    6 +-
 drivers/media/video/zr36060.c                      |    6 +-
 include/linux/i2c-id.h                             |    2 +
 include/{media => linux}/ivtv.h                    |   11 +-
 .../ivtv/ivtv-audio.h => include/linux/ivtvfb.h    |   31 +-
 include/linux/videodev2.h                          |    7 +-
 include/media/cx2341x.h                            |    2 +-
 include/media/ir-common.h                          |    1 +
 include/media/saa7146.h                            |    1 -
 include/media/saa7146_vv.h                         |    2 +-
 include/media/tuner-types.h                        |    4 +
 include/media/tuner.h                              |    1 +
 include/media/v4l2-chip-ident.h                    |    3 +
 include/media/v4l2-dev.h                           |   16 +-
 include/media/v4l2-int-device.h                    |  278 ++++
 include/media/{video-buf.h => videobuf-core.h}     |  181 +--
 include/media/videobuf-dma-sg.h                    |  122 ++
 include/media/{video-buf-dvb.h => videobuf-dvb.h}  |    0 
 include/media/videobuf-vmalloc.h                   |   41 +
 278 files changed, 19304 insertions(+), 6634 deletions(-)
 create mode 100644 Documentation/video4linux/CARDLIST.cx23885
 create mode 100644 drivers/media/dvb/frontends/dib0070.c
 create mode 100644 drivers/media/dvb/frontends/dib0070.h
 create mode 100644 drivers/media/dvb/frontends/mt2131.c
 create mode 100644 drivers/media/dvb/frontends/mt2131.h
 create mode 100644 drivers/media/dvb/frontends/mt2131_priv.h
 create mode 100644 drivers/media/dvb/frontends/mt2266.c
 create mode 100644 drivers/media/dvb/frontends/mt2266.h
 create mode 100644 drivers/media/dvb/frontends/s5h1409.c
 create mode 100644 drivers/media/dvb/frontends/s5h1409.h
 create mode 100644 drivers/media/video/cx23885/Kconfig
 create mode 100644 drivers/media/video/cx23885/Makefile
 create mode 100644 drivers/media/video/cx23885/cx23885-cards.c
 create mode 100644 drivers/media/video/cx23885/cx23885-core.c
 create mode 100644 drivers/media/video/cx23885/cx23885-dvb.c
 create mode 100644 drivers/media/video/cx23885/cx23885-i2c.c
 create mode 100644 drivers/media/video/cx23885/cx23885-reg.h
 create mode 100644 drivers/media/video/cx23885/cx23885.h
 delete mode 100644 drivers/media/video/ivtv/ivtv-audio.c
 rename drivers/media/video/ivtv/{ivtv-video.c => ivtv-routing.c} (59%)
 copy drivers/media/video/ivtv/{ivtv-audio.h => ivtv-routing.h} (80%)
 delete mode 100644 drivers/media/video/ivtv/ivtv-video.h
 create mode 100644 drivers/media/video/ivtv/ivtvfb.c
 create mode 100644 drivers/media/video/mt20xx.h
 create mode 100644 drivers/media/video/tcm825x.c
 create mode 100644 drivers/media/video/tcm825x.h
 create mode 100644 drivers/media/video/tda8290.h
 create mode 100644 drivers/media/video/tea5761.h
 create mode 100644 drivers/media/video/tea5767.h
 create mode 100644 drivers/media/video/tuner-i2c.h
 create mode 100644 drivers/media/video/tuner-simple.h
 create mode 100644 drivers/media/video/v4l2-int-device.c
 delete mode 100644 drivers/media/video/video-buf.c
 create mode 100644 drivers/media/video/videobuf-core.c
 create mode 100644 drivers/media/video/videobuf-dma-sg.c
 rename drivers/media/video/{video-buf-dvb.c => videobuf-dvb.c} (97%)
 create mode 100644 drivers/media/video/videobuf-vmalloc.c
 create mode 100644 drivers/media/video/vp27smpx.c
 rename include/{media => linux}/ivtv.h (93%)
 rename drivers/media/video/ivtv/ivtv-audio.h => include/linux/ivtvfb.h (56%)
 create mode 100644 include/media/v4l2-int-device.h
 rename include/media/{video-buf.h => videobuf-core.h} (56%)
 create mode 100644 include/media/videobuf-dma-sg.h
 rename include/media/{video-buf-dvb.h => videobuf-dvb.h} (100%)
 create mode 100644 include/media/videobuf-vmalloc.h

Adrian Bunk (5):
      V4L/DVB (5940): Export v4l2_int_device_{, un}register
      V4L/DVB (5965): Frontend_ioctl(): fix check-after-use
      V4L/DVB (6009): Bt8xx: "extern inline" -> "static inline"
      V4L/DVB (6025): Net_ule(): fix check-after-use
      V4L/DVB (6122): ivtvfb: fix an obvious bug in ivtvfb_release_buffers()

Alan Nisota (1):
      V4L/DVB (6037): Updated GenPix USB driver

Andi Drebes (2):
      V4L/DVB (5941): Ttpci/budget-av.c: ARRAY_SIZE()
      V4L/DVB (5942): Usb/vp7045.c: ARRAY_SIZE()

Andres Salomon (1):
      V4L/DVB (6235): cafe_ccic: default to allocating DMA buffers at probe time

Brandon Philips (5):
      V4L/DVB (6273): V4L: vivi.c vidioc_try_fmt_cap() negotiate a valid field
      V4L/DVB (6274): V4L: vivi.c replace logic in vivi_poll with videobuf_poll_stream
      V4L/DVB (6275): V4L: vivi.c remove the "resource" locking
      V4L/DVB (6276): V4L: videobuf-core.c lock before streaming check
      V4L/DVB (6305): V4L: videobuf-core.c avoid NULL dereferences in videobuf-core

Brett Warden (2):
      V4L/DVB (6238): bw-qcam: use data_reverse instead of manually poking the control register
      V4L/DVB (6250): bw-qcam use data_reverse instead of manually poking the control register fix

Chaogui Zhang (1):
      V4L/DVB (6178): add IR remote support for FusionHDTV 5 RT Gold

Christoph Hellwig (1):
      V4L/DVB (6279): en_50221: convert to kthread API

Darren Salt (2):
      V4L/DVB (6039): Typo fix in Nova-TD description
      V4L/DVB (6040): Add IR support for Nova-T Stick

Edgar Simo (2):
      V4L/DVB (6071): saa7134-dvb: add missing newline
      V4L/DVB (6072): saa7134: add DVB-T support for Avermedia Super 007

Eric Sandeen (1):
      V4L/DVB (6295): saa7134: add autodetection for KWorld ATSC-115

Hans Verkuil (63):
      V4L/DVB (5881): ivtv: init channel for NTSC_M_JP standard.
      V4L/DVB (5902): Add ivtv-fb framebuffer driver.
      V4L/DVB (5904): ivtv-fb: cleanups
      V4L/DVB (5905): ivtv-fb: Use proper ioctl value
      V4L/DVB (5906): ivtv-fb: replace HZ with msecs_to_jiffies
      V4L/DVB (5909): ivtv: update version to 1.1 to mark ivtv-fb support
      V4L/DVB (5910): ivtv-fb: improve debug message
      V4L/DVB (5919): ivtv: remove dead code
      V4L/DVB (5921): ivtv: add missing composite input line for ivtv_pci_pg600v2
      V4L/DVB (5922): ivtv, cx25840: postpone fw load until first use
      V4L/DVB (5924): ivtv-fb: initializing the fb should trigger ivtv firmware load
      V4L/DVB (5927): ivtv: set correct crystal frequency of the GVMVPRX cards
      V4L/DVB (5928): tuner: fix TOP values for the Panasonic VP27 tuner.
      V4L/DVB (5929): Add vp27smpx driver
      V4L/DVB (5992): ivtv: show card name as well in the LOG_STATUS output.
      V4L/DVB (5993): cx25840: resetting also requires reloading the firmware
      V4L/DVB (5994): ivtv: make VIDIOC_INT_RESET support smarter.
      V4L/DVB (5995): ivtv: add AverMedia M116
      V4L/DVB (5997): cx25840: fix audio mute handling and reporting
      V4L/DVB (5998): ivtv: no need to mute the audio input
      V4L/DVB (5999): cx25840: add radio support.
      V4L/DVB (6002): ivtv: remove unused struct field.
      V4L/DVB (6003): vp27smpx: correctly attribute the origin of the driver
      V4L/DVB (6043): ivtv: fix incorrect round-robin implementation
      V4L/DVB (6045): ivtv: fix handling of INITIALIZE_INPUT fw call
      V4L/DVB (6046): ivtv: always steal full frames if out of buffers.
      V4L/DVB (6047): ivtv: Fix scatter/gather DMA timeouts
      V4L/DVB (6048): ivtv: fix stop stream locking
      V4L/DVB (6049): ivtv: fix VBI reinsertion decoding
      V4L/DVB (6050): ivtv: retry/timer improvements
      V4L/DVB (6051): cx25840: make proper use of SOFT_RESET
      V4L/DVB (6053): ivtv: setup TV output standard on init to prevent flicker
      V4L/DVB (6054): ivtv: specify some stream sizes in kB instead of MB
      V4L/DVB (6055): ivtv: improve debug messages
      V4L/DVB (6056): ivtv: move serialization to the fileops level
      V4L/DVB (6057): ivtv-fb: remove unused header includes
      V4L/DVB (6058): ivtv: add support for highmem udma
      V4L/DVB (6059): ivtv: log stereo/bilingual audio modes
      V4L/DVB (6060): ivtv: fix IVTV_IOC_DMA_FRAME bug introduced by highmem bugfix
      V4L/DVB (6061): ivtv: add VIDIOC_OVERLAY
      V4L/DVB (6086): ivtv: fix output mode processing: UDMA_YUV wasn't cleared
      V4L/DVB (6087): ivtv: prevent changing VBI format while capture is in progress
      V4L/DVB (6088): cx2341x: some controls can't be changed while the device is busy
      V4L/DVB (6089): ivtv: log in status if framebuffer uses YUV instead of RGB
      V4L/DVB (6090): ivtv-fb: correct transparency bit reporting
      V4L/DVB (6091): ivtv: header cleanup
      V4L/DVB (6092): ivtv: more cleanups, merged ivtv-audio.c and ivtv-video.c into ivtv-routing.c
      V4L/DVB (6093): ivtv: reorganized and cleanup ivtv struct
      V4L/DVB (6094): ivtv: more ivtv-driver.h cleanups
      V4L/DVB (6096): ivtv: fix V4L2_ENC_CMD_STOP_AT_GOP_END support
      V4L/DVB (6097): ivtv: set correct pixel format and alpha properties
      V4L/DVB (6108): videodev2.h: add new pixel formats for the cx23415 OSD
      V4L/DVB (6109): ivtv: use new videodev2.h pixel formats
      V4L/DVB (6112): cx25840: use a workqueue to load the firmware
      V4L/DVB (6113): ivtv: udelay for the i2c bus was set too high
      V4L/DVB (6115): ivtv/ivtv-fb: improve locking to avoid initialization problems
      V4L/DVB (6116): ivtv: VBI cleanups and fixes
      V4L/DVB (6117): ivtv: finish VBI related cleanup
      V4L/DVB (6118): ivtv-fb: add missing FBIO_WAITFORVSYNC ioctl define
      V4L/DVB (6119): ivtvfb: renamed ivtv-fb to ivtvfb, move header to include/linux
      V4L/DVB (6120): ivtvfb: rename some missed ivtv-fb references to ivtvfb
      V4L/DVB (6121): ivtvfb: replace ivtv_fb prefix to ivtvfb
      V4L/DVB (6123): ivtv: move ivtv.h public header to include/linux

Hans-Jürgen Koch (1):
      V4L/DVB (6215): Bugfix for saa6588.c, add forgotten spin_lock_init()

Hartmut Birr (1):
      V4L/DVB (5985): Fix the min/max frequencies of some DVB-C frontends

Ian Armstrong (5):
      V4L/DVB (5908): ivtv-fb: cleanups, prevent fw calls in some cases
      V4L/DVB (5970): ivtv: prevent vertical overflow of yuv output
      V4L/DVB (5971): ivtv-fb: framebuffer timings no longer locked on module load
      V4L/DVB (5972): ivtv: prevent yuv register updates from being missed
      V4L/DVB (5973): ivtv: attach yuv field order to each frame

Janne Grunau (4):
      V4L/DVB (5956): Add remote control support for the Hauppauge Nova-T 500
      V4L/DVB (5957): Add remote keymap for the Hauppauge Nova-TD Stick
      V4L/DVB (5962): Fix line-break in err output
      V4L/DVB (5964): Fixed remote control for dib0700 with new firmware

Jean Delvare (4):
      V4L/DVB (5884): zr36067: clean up debug function
      V4L/DVB (6081): ivtv: Fix static structure initialization
      V4L/DVB (6212): pvrusb2: I2C adapter tweaks from Jean Delvare
      V4L/DVB (6214): usbvision: Don't support I2C_M_REV_DIR_ADDR

Jesper Juhl (5):
      V4L/DVB (5912): Clean up duplicate includes in drivers/media/
      V4L/DVB (5913): Clean up duplicate includes in include/media/
      V4L/DVB (6098): ivtv: kzalloc() returns void pointer, no need to cast
      V4L/DVB (6102): dvb: remove some unneeded vmalloc() return value casts from av7110
      V4L/DVB (6285): Remove pointless kmalloc() return value cast in Zoran PCI controller driver

Jiri Slaby (2):
      V4L/DVB (6307): V4L: w9968cf, remove bad usage of ERESTARTSYS
      V4L/DVB (6308): V4L: zc0301, remove bad usage of ERESTARTSYS

Joachim Steiger (1):
      V4L/DVB (6296): dib0700: add support for AverMedia DVB-T Express card

Kay Sievers (2):
      V4L/DVB (6015): DVB: convert struct class_device to struct device
      V4L/DVB (6293): V4L: convert struct class_device to struct device

Kazuhiko Kawakami (1):
      V4L/DVB (6044): vp27smpx: clarify history of this source.

Kumar Gala (1):
      V4L/DVB (6010): Use inline functions instead of inline asm for powerpc

Marco Schluessler (2):
      V4L/DVB (6103): dvb_ca_en50221: return correct error code value
      V4L/DVB (6104): dvb_ca_en50221: decrement module use count on error

Mariusz Kozlowski (4):
      V4L/DVB (5953): msp3400-driver.c: kmalloc + memset conversion to kzalloc
      V4L/DVB (5981): Zoran_driver.c: fix memset in ioctl
      V4L/DVB (5982): Dev.c: memset fix
      V4L/DVB (5983): Arv.c: fix memset in ioctl

Matt Doran (1):
      V4L/DVB (5960): Add module parameter to enable SFN workaround

Matthias Kaehlcke (1):
      V4L/DVB (5946): Use mutex instead of semaphore in the DVB frontend tuning interface

Mauro Carvalho Chehab (25):
      V4L/DVB (6014): vivi: use videobuf_read_stream()
      V4L/DVB (6079): Cleanup: remove linux/moduleparam.h from drivers/media files
      V4L/DVB (6111): Fix a warning when compiling on x86_64
      V4L/DVB (6247): Fix bug #8689: Fixes IR stop/start during suspend/resume
      V4L/DVB (6251): Replace video-buf to a more generic approach
      V4L/DVB (6252): Adapt drivers to use the newer videobuf modules
      V4L/DVB (6253): Convert vivi to use the newer videobuf-dma-sg module
      V4L/DVB (6254): Add videobuf-vmalloc
      V4L/DVB (6255): Convert vivi to use videobuf-vmalloc
      V4L/DVB (6256): Remove the obsolete video-buf module
      V4L/DVB (6257): Rename video-buf-dvb to videobuf-dvb to be consistent with the other patches
      V4L/DVB (6259): Fix vivi poll() method
      V4L/DVB (6260): Fix Kconfig dependency
      V4L/DVB (6261): Cleans mem->vmalloc after vfree
      V4L/DVB (6262): An allocation error message were being printed as a debug msg
      V4L/DVB (6263): Fix buffer release code
      V4L/DVB (6264): Make the vertical lines to move
      V4L/DVB (6265): Prevent for calling mmap_free without an allocated buffer
      V4L/DVB (6266): videobuf cleanup: mmap check is common to all videobuf. Make it at core
      V4L/DVB (6277): vivi cleanup: remove the unused vars
      V4L/DVB (6286): Add support for MSI TV @nywhere A/D NB
      V4L/DVB (6287): Fix DMA Scatter/Gather constructor
      V4L/DVB (6290): remove videobuf_set_pci_ops
      V4L/DVB (6291): Fix: avoid oops on some SMP machines
      V4L/DVB (6292): videobuf_core init always require callback implementation

Maxim Levitsky (7):
      V4L/DVB (6268): V4L: Fix a lock inversion in generic videobuf code
      V4L/DVB (6269): V4L: Fix a "scheduling while atomic" bug in saa7134
      V4L/DVB (6270): V4L: Honor dev->ctl_invert when setting up the decoder in saa7134
      V4L/DVB (6271): V4L: Add basic support for suspend/resume for saa7134
      V4L/DVB (6272): V4L: properly fix support for capturing interlaced video in saa7134
      V4L/DVB (6278): Buf: fix typo that caused data loss when readng streams from device
      V4L/DVB (6306): Few clenups for saa7134 resume code

Michael Krufky (48):
      V4L/DVB (5949): s5h1409: use ARRAY_SIZE macro when appropriate
      V4L/DVB (5950): whitespace cleanup for mt2131 and s5h1409
      V4L/DVB (6006): tuner: move last_div to tuner-simple private data
      V4L/DVB (6074): tuner: fix ifdef tags to match actual file name
      V4L/DVB (6075): tuner: kernel headers go above subsystem headers
      V4L/DVB (6100): dvb_net: whitespace cleanup
      V4L/DVB (6125): whitespace cleanup: replace leading spaces with tabs
      V4L/DVB (6126): tuner: add warning for obsolete i2c address range 0x64 thru 0x6f
      V4L/DVB (6127): tuner: kill i2c_client interface to tuner sub-drivers
      V4L/DVB (6128): hybrid tuner refactoring core changes, phase 1
      V4L/DVB (6129): tda8290: convert from tuner sub-driver into dvb_frontend module
      V4L/DVB (6130): mt20xx: convert from tuner sub-driver into dvb_frontend module
      V4L/DVB (6131): tea5761: convert from tuner sub-driver into dvb_frontend module
      V4L/DVB (6132): tea5767: convert from tuner sub-driver into dvb_frontend module
      V4L/DVB (6133): tuner-simple: convert from tuner sub-driver into dvb_frontend module
      V4L/DVB (6134): tuner: alter build to produce separate modules
      V4L/DVB (6136): dvb_frontend: add get_rf_strength function pointer to dvb_tuner_ops
      V4L/DVB (6137): tuner-simple: add get_rf_strength and improve status reading efficiency
      V4L/DVB (6138): tea5761: add get_rf_strength and improve status reading efficiency
      V4L/DVB (6139): tea5767: add get_rf_strength and improve status reading efficiency
      V4L/DVB (6140): tda8290: add get_rf_strength and improve status reading efficiency
      V4L/DVB (6141): tuner: use get_rf_strength instead of get_status to determine signal strength
      V4L/DVB (6142): cx25840: fix build warning
      V4L/DVB (6151): include drivers/media/video/cx23885/Kconfig
      V4L/DVB (6152): cx23885: forward compatibility fixes for recent kernels
      V4L/DVB (6161): cx23885-dvb.c doesnt need to include dvb-pll.h
      V4L/DVB (6162): cx23885: whitespace cleanups
      V4L/DVB (6163): cx23885: remove old comments
      V4L/DVB (6164): cx23885: turn off i2c_debug by default
      V4L/DVB (6165): cx23885: fix Kconfig dependencies
      V4L/DVB (6179): Clean up FusionHDTV ir code
      V4L/DVB (6180): tuner: don't probe 0x6b or 0x6f on cx88 boards
      V4L/DVB (6181): cx88: auto-load rtc and ir receiver i2c modules for FusionHDTV5 RT Gold
      V4L/DVB (6193): cx23885: define Video B Interrupt Status register bit values
      V4L/DVB (6196): cx23885: add support for DViCO FusionHDTV 5 Express
      V4L/DVB (6198): add CARDLIST.cx23885 to Documentation/
      V4L/DVB (6200): cx23885: use a pointer to the required i2c bus in dvb_register function
      V4L/DVB (6222): select DVB_PLL if !DVB_FE_CUSTOMISE for FusionHDTV5 Express
      V4L/DVB (6224): VIDEO_CX23885 depends on DVB_CORE
      V4L/DVB (6226): dvb-pll: pass fe pointer into dvb_pll_configure() and set() functions
      V4L/DVB (6227): dvb-pll: store instance ID in dvb_pll_priv structure
      V4L/DVB (6228): dvb-pll: add module option to specify rf input
      V4L/DVB (6229): dvb-pll: increase DVB_PLL_MAX to 64
      V4L/DVB (6230): dvb-pll: add module option to force dvb-pll desc id (for debug use only)
      V4L/DVB (6231): dvb-pll: always show pll name if forced via insmod option
      V4L/DVB (6232): dvb-pll: report whether input rf will be autoselected or set via insmod option
      V4L/DVB (6241): fix typo in DVB_PLL Kconfig help text
      V4L/DVB (6297): cx23885: remove wrong Kconfig selection of VIDEOBUF

Michael Mauch (1):
      V4L/DVB (6038): Trivial: repair mixed parm descs in dvb-usb-init.c

Michal Piotrowski (3):
      V4L/DVB (6076): Coding style fix drivers/media/video/zr36060.c
      V4L/DVB (6077): Coding style fix drivers/media/video/zr36050.c
      V4L/DVB (6078): Coding style fix drivers/media/video/zr36016.c

Mike Isely (6):
      V4L/DVB (6205): pvrusb2: Fix oops in error leg cleanup
      V4L/DVB (6207): pvrusb2: Fix a potential oops in an error leg cleanup
      V4L/DVB (6208): pvrusb2: Implement programmatic means to extract prom contents
      V4L/DVB (6209): pvrusb2: Better discriminate among device types
      V4L/DVB (6210): pvrusb2: Do a far better job at setting the default initial video standard
      V4L/DVB (6211): pvrusb2: Allocate a debug mask bit for reporting video standard things

Oleg Nesterov (1):
      V4L/DVB (5990): cinergyt2_suspend: don't forget to unlock cinergyt2->wq_sem

Oliver Endriss (10):
      V4L/DVB (5934): dvb-ttpci/saa7146: Replace saa7146_i2c_transfer by generic i2c_transfer
      V4L/DVB (5935): dvb_frontend: Range check of frequency and symbol rate
      V4L/DVB (5936): tda10023: Remove range check of symbol rate
      V4L/DVB (5980): tda8083: fix frequency and symbolrate info
      V4L/DVB (5986): dvb_frontend: Fixed GET_INFO ioctl and check of frequency limits
      V4L/DVB (5987): saa7146: clean-up irq processing
      V4L/DVB (6105): dvb_frontend: ts_bus_ctrl() handling fixed
      V4L/DVB (6106): dvb_frontend: Default for dvb_shutdown_timeout set to 0
      V4L/DVB (6107): dvb_frontend: clean-up shutdown handling
      V4L/DVB (6221): budget-ci: select TT keymap for DVB-S TT 1500

Oliver Neukum (1):
      V4L/DVB (6237): Oops in pwc v4l driver

Olivier DANET (1):
      V4L/DVB (5914): Add initial support for Dual-DVB-T stick

Patrick Boettcher (6):
      V4L/DVB (5954): Sync with DiBcom Driver Release 2.1.3 + some improvements
      V4L/DVB (5955): Add support for DiB7070-based devices
      V4L/DVB (5958): Add support Compro VideoMate 500 with DiB7000PC
      V4L/DVB (5959): Fix for size of remote keys in DiB0700
      V4L/DVB (5961): Fix support for DiB7000M-devices
      V4L/DVB (5963): Module parameter description for SFN workaround

Pekka Seppanen (2):
      V4L/DVB (6243): [PATCH 2/2] GemTek Radio card
      V4L/DVB (6244): [PATCH 1/2] GemTek Radio card

Rasmus Rohde (1):
      V4L/DVB (5897): dtt200u: add support for the Miglia TVMini USB DVB-T adapter

Robert P. J. Day (1):
      V4L/DVB (6289): Remove reference to dead CONFIG_UST and ust.h header

Rolf Eike Beer (1):
      V4L/DVB (6005): Initialize filp->private_data only once in em28xx_v4l2_open

Sakari Ailus (8):
      V4L/DVB (5862): V4L: Add internal ioctl-like interface.
      V4L/DVB (5863): TCM825x: Add driver.
      V4L/DVB (5883): V4L: Fix a compile warning on non-32-bit machines.
      V4L/DVB (6216): V4L: Int if: add vidioc_int_g_ifparm, other updates
      V4L/DVB (6217): V4L: Int if: Add BT.656 interface support
      V4L/DVB (6218): V4L: Int if: Use -ENOIOCTLCMD for nonexistent ioctls
      V4L/DVB (6219): V4L: Int if: Remove [gs]_ext_clk
      V4L/DVB (6220): TCM825x: Add support for vidioc_int_g_ifparm call, small cleanups

Sascha Sommer (1):
      V4L/DVB (6249): Add Typhoon Tv-Tuner PCI to bttv-cards.c

Simon Arlott (1):
      V4L/DVB (5988): Fix OOP on videobuf-dvb when hibernating

Simon Farnsworth (1):
      V4L/DVB (6203): Fix SVideo input on KWorld DVB-T 220 boards

Stas Sergeev (1):
      V4L/DVB (6225): AverTV Studio 307 has only one composite input

Steven Toth (25):
      V4L/DVB (5947): Adding support for the MT2131 tuner.
      V4L/DVB (5948): Adding support for the S5H1409/CX24227 8VSB/QAM demodulator.
      V4L/DVB (6149): Add I2C_HW_B_CX23885 for Conexant 23885/23887 PCIe bridge
      V4L/DVB (6150): Add CX23885/CX23887 PCIe bridge driver
      V4L/DVB (6153): I2C bus 3 register was incorrect
      V4L/DVB (6154): NMI hang and corrupt transport packet fixes
      V4L/DVB (6155): Cleanup/remove code to access the sram memory maps
      V4L/DVB (6156): Added the I2C_FUNC_I2C support to the cx23885 i2c algo definition
      V4L/DVB (6157): Removed the need to manually define .bridge for each card
      V4L/DVB (6158): Fix MT2131 tuner lock status problem
      V4L/DVB (6159): General code cleanup
      V4L/DVB (6166): cx23885: Ensure pci_quirks is called after board identification
      V4L/DVB (6167): cx23885: Changed PCI quirks to after bridge detech
      V4L/DVB (6168): cx23885: Added HVR1250 ATSC support
      V4L/DVB (6169): Removed unused function mt2131_set_gpo()
      V4L/DVB (6170): cx23885: General cleanup of old code
      V4L/DVB (6171): cx23885: Cleaning up defines
      V4L/DVB (6172): cx23885: Removing duplicate tuner and demod definitions
      V4L/DVB (6173): cx23885: Minor cleanup and important NMI comment placed in code
      V4L/DVB (6190): cx23885: GPIO fix for non HVR1800lp boards
      V4L/DVB (6191): Removed a redundant switch()
      V4L/DVB (6192): Ensure start_dma() is capable of starting dma on port VIDB
      V4L/DVB (6194): Changes to support interrupts on VIDB
      V4L/DVB (6195): Changes to support MPEG TS on VIDB
      V4L/DVB (6199): cx23885: Changes to allow demodulators on each transport bus

Steven Walter (1):
      V4L/DVB (5989): V4L: Add additional ioctls to compat_ioctl32

Trent Piepho (36):
      V4L/DVB (5885): zr36067: Fix problems with module parameters
      V4L/DVB (5975): cx88: Wrong values used for HD-3000 radio mode
      V4L/DVB (5976): mt2131 s5h1409: correct frontend selection logic
      V4L/DVB (5977): cx8800: Add register debug functions to radio device too
      V4L/DVB (5978): tuner: Better tuner radio support
      V4L/DVB (6019): cx88: Make card database more memory efficient
      V4L/DVB (6020): cx88: Fix use of uninitialized variable
      V4L/DVB (6021): cx88: Copy board information into card state
      V4L/DVB (6022): cx88: Move card core creation from cx88-core.c to cx88-cards.c
      V4L/DVB (6023): cx88: Clean up some ugly and inconsistent printk()s
      V4L/DVB (6031): Fix for bug 7819: fixed hotplugging for dvbnet
      V4L/DVB (6034): cx88: Add parameter to control radio deemphasis time constant
      V4L/DVB (6064): cx88: Add symbolic names for the PCI interrupt bits
      V4L/DVB (6065): cx88-alsa: Call core irq handler when needed
      V4L/DVB (6066): cx88-alsa: Change order of interrupt enabling, fix spurious IRQs
      V4L/DVB (6067): cx88-alsa: Hardware doesn't support mono audio
      V4L/DVB (6068): cx88-alsa: Use pci_dev->revision
      V4L/DVB (6082): cx88: Improve risc instruction printing in sram channel dump
      V4L/DVB (6083): cx88-alsa: Rework buffer handling
      V4L/DVB (6084): cx88-alsa: Eliminate snd_cx88_cards
      V4L/DVB (6085): cx88-alsa: Fix mmap support
      V4L/DVB (6184): cx88-alsa: Make volume control stereo
      V4L/DVB (6186): cx88-alsa: Remove some unused fields in card state struct
      V4L/DVB (6245):  GemTek Radio card - frequency calculation
      V4L/DVB (6246):  GemTek Radio card - Control Word
      V4L/DVB (6283): videobuf: Remove references to old Kconfig option name
      V4L/DVB (6284): cx23885: Update to new videobuf code
      V4L/DVB (6299): dvb: Add dependencies for VIDEOBUF_DVB
      V4L/DVB (6300): CodingStyle cleanup
      V4L/DVB (6301): pvrusb: Update DEBUGIFC sysfs to kernel 2.6.13+
      V4L/DVB (6311): dvb: Replace list_for_each+list_entry with list_for_each_entry
      V4L/DVB (6312): cx88: Replace list_for_each+list_entry with list_for_each_entry
      V4L/DVB (6313): ivtv: Replace list_for_each+list_entry with list_for_each_entry
      V4L/DVB (6314): saa7134: Replace list_for_each+list_entry with list_for_each_entry
      V4L/DVB (6315): pvrusb2: Change list_for_each+list_entry to list_for_each_entry
      V4L/DVB (6316): Change list_for_each+list_entry to list_for_each_entry

Tyler Trafford (1):
      V4L/DVB (6124): cx25840: add a few 10 microsecond delays

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

