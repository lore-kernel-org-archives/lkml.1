Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbYAYVo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbYAYVo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbYAYVoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:44:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58550 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760871AbYAYVoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:44:05 -0500
Date: Fri, 25 Jan 2008 19:43:12 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB updates for 2.6.25
Message-ID: <20080125194312.2cbccc3c@gaivota>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

People at v4l/dvb community were very busy since 2.6.24 window! This is the 
largest patch series I ever sent. It has 500+ patches. Thank you all for your 
development efforts.

There are several new things on this series. Just to point the ones I 
remember, follows a brief summary of the changes:

   - Hybrid tuner support complete;
   - Several internal API improvements;
   - Support for newer tea5767 radio boards with different xtals;
   - bttv removal of V4L1 API, using compat-v4l1 to support older API calls;
   - Remove v4l1 code from dvb-ttpci;
   - Audio driver conversions from V4L1 to V4L2 API;
   - Adds support for the bus-based I2C API;
   - Lots of em28xx improvements, including support for em28xx vendor-based 
     audio, FM receiver, xc3028 based board support, conversion to 
     video_ioctl2 and several fixes;
   - Adds support for mt9v111 sensors on sn8c102;
   - Since saa7134-alsa is stable, removes saa7134-oss;
   - Several improvements on pvrusb2 and ivtv drivers;
   - saa7134 and bttv converted to use video_ioctl2;
   - Adds support for analog TV on cx23885;

   - New drivers:
	Hybrid tuners: xc2028/3028, xc5000, tda18271/tda829x family
	A/V switch i2c driver for m52790;
	Radio support for si470x USB devices (radio-si470x);
	Web cam driver for Syntek 1125 USB;
	Cirrus Logic 24-bit, 192 kHz Stereo Audio ADC;

   - Several driver fixes and improvements;
   - Several new cards are supported;
   - Several cleanups and CodingStyle fixes.
   - more stuff I might have forgotten to mention ;)

Cheers,
Mauro.

---

 Documentation/DocBook/videobook.tmpl               |    9 -
 Documentation/dvb/bt8xx.txt                        |   12 +
 Documentation/video4linux/CARDLIST.cx23885         |    4 +-
 Documentation/video4linux/CARDLIST.cx88            |    1 +
 Documentation/video4linux/CARDLIST.em28xx          |   17 +-
 Documentation/video4linux/CARDLIST.ivtv            |    6 +
 Documentation/video4linux/CARDLIST.saa7134         |   17 +-
 Documentation/video4linux/CARDLIST.tuner           |    5 +-
 Documentation/video4linux/CARDLIST.usbvision       |    1 +
 Documentation/video4linux/extract_xc3028.pl        |  926 +++++++
 Documentation/video4linux/sn9c102.txt              |    1 +
 MAINTAINERS                                        |    9 +
 drivers/media/Kconfig                              |   22 +-
 drivers/media/common/Kconfig                       |    2 +-
 drivers/media/common/ir-functions.c                |    3 +-
 drivers/media/common/ir-keymaps.c                  |  146 ++-
 drivers/media/common/saa7146_fops.c                |    9 +-
 drivers/media/common/saa7146_vbi.c                 |   10 +-
 drivers/media/common/saa7146_video.c               |    8 +-
 drivers/media/dvb/b2c2/flexcop.c                   |    1 -
 drivers/media/dvb/bt8xx/bt878.c                    |   76 +-
 drivers/media/dvb/bt8xx/bt878.h                    |    6 -
 drivers/media/dvb/bt8xx/dst.c                      |   19 +-
 drivers/media/dvb/bt8xx/dst_common.h               |    5 -
 drivers/media/dvb/dvb-core/dvb_frontend.c          |    6 +
 drivers/media/dvb/dvb-core/dvb_frontend.h          |   43 +-
 drivers/media/dvb/dvb-core/dvb_ringbuffer.c        |    5 -
 drivers/media/dvb/dvb-usb/af9005.c                 |    7 +-
 drivers/media/dvb/dvb-usb/au6610.c                 |    6 +-
 drivers/media/dvb/dvb-usb/cxusb.c                  |  436 +++-
 drivers/media/dvb/dvb-usb/cxusb.h                  |    7 +-
 drivers/media/dvb/dvb-usb/dib0700_core.c           |    5 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  149 ++-
 drivers/media/dvb/dvb-usb/digitv.c                 |    3 +-
 drivers/media/dvb/dvb-usb/digitv.h                 |    3 -
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |   18 +-
 drivers/media/dvb/dvb-usb/gl861.c                  |    6 +-
 drivers/media/dvb/dvb-usb/gp8psk.c                 |   16 -
 drivers/media/dvb/dvb-usb/gp8psk.h                 |    1 -
 drivers/media/dvb/dvb-usb/opera1.c                 |    6 +-
 drivers/media/dvb/dvb-usb/opera1.h                 |    9 -
 drivers/media/dvb/dvb-usb/vp702x.c                 |   15 +-
 drivers/media/dvb/dvb-usb/vp702x.h                 |    2 -
 drivers/media/dvb/dvb-usb/vp7045.c                 |    5 +-
 drivers/media/dvb/dvb-usb/vp7045.h                 |    5 -
 drivers/media/dvb/frontends/Kconfig                |   16 +
 drivers/media/dvb/frontends/Makefile               |    5 +
 drivers/media/dvb/frontends/dib0070.c              |   13 +-
 drivers/media/dvb/frontends/dib3000mc.c            |   10 +-
 drivers/media/dvb/frontends/dib7000m.c             |    9 +-
 drivers/media/dvb/frontends/dib7000p.c             |   18 +-
 drivers/media/dvb/frontends/dibx000_common.h       |    5 +
 drivers/media/dvb/frontends/mt2266.c               |  204 +-
 drivers/media/dvb/frontends/mt312.c                |  257 ++-
 drivers/media/dvb/frontends/mt312.h                |   15 +-
 drivers/media/dvb/frontends/mt352.c                |    8 +-
 drivers/media/dvb/frontends/or51132.c              |    6 +-
 drivers/media/dvb/frontends/or51211.c              |    6 +-
 drivers/media/dvb/frontends/s5h1409.c              |   97 +-
 drivers/media/dvb/frontends/s5h1409.h              |   11 +-
 drivers/media/dvb/frontends/tda18271-common.c      |  653 +++++
 drivers/media/dvb/frontends/tda18271-fe.c          | 1225 +++++++++
 drivers/media/dvb/frontends/tda18271-priv.h        |  212 ++
 drivers/media/dvb/frontends/tda18271-tables.c      | 1285 ++++++++++
 drivers/media/dvb/frontends/tda18271.h             |   78 +
 drivers/media/dvb/frontends/tda827x.c              |  367 +++-
 drivers/media/dvb/frontends/tda827x.h              |    7 +
 drivers/media/dvb/frontends/ves1820.c              |    4 +-
 drivers/media/dvb/frontends/xc5000.c               |  964 +++++++
 drivers/media/dvb/frontends/xc5000.h               |   62 +
 drivers/media/dvb/frontends/xc5000_priv.h          |   36 +
 drivers/media/dvb/frontends/zl10353.c              |  327 +++-
 drivers/media/dvb/frontends/zl10353.h              |    9 +-
 drivers/media/dvb/frontends/zl10353_priv.h         |   23 +-
 drivers/media/dvb/ttpci/Kconfig                    |   37 +-
 drivers/media/dvb/ttpci/Makefile                   |   12 +-
 drivers/media/dvb/ttpci/av7110.c                   |    3 +-
 drivers/media/dvb/ttpci/av7110.h                   |    7 +-
 drivers/media/dvb/ttpci/av7110_av.c                |   16 +-
 drivers/media/dvb/ttpci/av7110_av.h                |    3 +-
 drivers/media/dvb/ttpci/av7110_v4l.c               |    4 +-
 drivers/media/radio/Kconfig                        |   10 +
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/dsbr100.c                      |   18 +-
 drivers/media/radio/radio-gemtek.c                 |    6 +-
 drivers/media/radio/radio-maestro.c                |    2 +-
 drivers/media/radio/radio-sf16fmi.c                |    2 +-
 drivers/media/radio/radio-sf16fmr2.c               |    3 +-
 drivers/media/radio/radio-si470x.c                 | 1432 +++++++++++
 drivers/media/video/Kconfig                        |   52 +-
 drivers/media/video/Makefile                       |   10 +-
 drivers/media/video/bt8xx/Kconfig                  |    2 +-
 drivers/media/video/bt8xx/Makefile                 |    2 +-
 drivers/media/video/bt8xx/bttv-audio-hook.c        |  382 +++
 drivers/media/video/bt8xx/bttv-audio-hook.h        |   23 +
 drivers/media/video/bt8xx/bttv-cards.c             |  444 +----
 drivers/media/video/bt8xx/bttv-driver.c            | 2374 ++++++++-----------
 drivers/media/video/bt8xx/bttv-input.c             |    5 +
 drivers/media/video/bt8xx/bttv-risc.c              |   14 +-
 drivers/media/video/bt8xx/bttv-vbi.c               |   58 +-
 drivers/media/video/bt8xx/bttv.h                   |    5 +-
 drivers/media/video/bt8xx/bttvp.h                  |   20 +-
 drivers/media/video/bw-qcam.c                      |   10 +-
 drivers/media/video/cs5345.c                       |  168 ++
 drivers/media/video/cs53l32a.c                     |   78 +-
 drivers/media/video/cx2341x.c                      |  313 ++--
 drivers/media/video/cx23885/Kconfig                |    4 +
 drivers/media/video/cx23885/Makefile               |    2 +-
 drivers/media/video/cx23885/cx23885-cards.c        |  135 +-
 drivers/media/video/cx23885/cx23885-core.c         |  296 ++-
 drivers/media/video/cx23885/cx23885-dvb.c          |  179 ++-
 drivers/media/video/cx23885/cx23885-i2c.c          |   98 +-
 drivers/media/video/cx23885/cx23885-reg.h          |   13 +
 drivers/media/video/cx23885/cx23885-vbi.c          |  258 ++
 drivers/media/video/cx23885/cx23885-video.c        | 1557 ++++++++++++
 drivers/media/video/cx23885/cx23885.h              |  168 ++-
 drivers/media/video/cx25840/cx25840-audio.c        |  123 +-
 drivers/media/video/cx25840/cx25840-core.c         |  695 +++---
 drivers/media/video/cx25840/cx25840-core.h         |    1 +
 drivers/media/video/cx25840/cx25840-firmware.c     |    5 +
 drivers/media/video/cx25840/cx25840-vbi.c          |    2 +-
 drivers/media/video/cx88/Kconfig                   |    1 +
 drivers/media/video/cx88/cx88-alsa.c               |    2 +-
 drivers/media/video/cx88/cx88-blackbird.c          |   92 +-
 drivers/media/video/cx88/cx88-cards.c              |  120 +-
 drivers/media/video/cx88/cx88-core.c               |    4 +-
 drivers/media/video/cx88/cx88-dvb.c                |   33 +
 drivers/media/video/cx88/cx88-i2c.c                |   27 +-
 drivers/media/video/cx88/cx88-input.c              |    6 +
 drivers/media/video/cx88/cx88-mpeg.c               |   39 +-
 drivers/media/video/cx88/cx88-vbi.c                |   10 +-
 drivers/media/video/cx88/cx88-video.c              |   58 +-
 drivers/media/video/cx88/cx88.h                    |   11 +-
 drivers/media/video/em28xx/Kconfig                 |   17 +-
 drivers/media/video/em28xx/Makefile                |    6 +
 drivers/media/video/em28xx/em28xx-audio.c          |  489 ++++
 drivers/media/video/em28xx/em28xx-cards.c          |  688 +++++-
 drivers/media/video/em28xx/em28xx-core.c           |   88 +-
 drivers/media/video/em28xx/em28xx-i2c.c            |   81 +-
 drivers/media/video/em28xx/em28xx-input.c          |   52 +-
 drivers/media/video/em28xx/em28xx-video.c          | 2622 +++++++++++---------
 drivers/media/video/em28xx/em28xx.h                |  166 +-
 drivers/media/video/et61x251/et61x251_core.c       |  157 +-
 drivers/media/video/et61x251/et61x251_sensor.h     |    8 -
 drivers/media/video/ir-kbd-i2c.c                   |    3 +-
 drivers/media/video/ivtv/Kconfig                   |    2 +
 drivers/media/video/ivtv/Makefile                  |    5 +
 drivers/media/video/ivtv/ivtv-cards.c              |  173 ++-
 drivers/media/video/ivtv/ivtv-cards.h              |   27 +-
 drivers/media/video/ivtv/ivtv-driver.c             |  117 +-
 drivers/media/video/ivtv/ivtv-driver.h             |   26 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |   52 +-
 drivers/media/video/ivtv/ivtv-gpio.c               |   24 +
 drivers/media/video/ivtv/ivtv-i2c.c                |  119 +-
 drivers/media/video/ivtv/ivtv-i2c.h                |    1 +
 drivers/media/video/ivtv/ivtv-ioctl.c              |  127 +-
 drivers/media/video/ivtv/ivtv-irq.c                |   95 +-
 drivers/media/video/ivtv/ivtv-mailbox.c            |    2 +-
 drivers/media/video/ivtv/ivtv-mailbox.h            |    2 +-
 drivers/media/video/ivtv/ivtv-routing.c            |   25 +-
 drivers/media/video/ivtv/ivtv-streams.c            |   25 +-
 drivers/media/video/ivtv/ivtv-version.h            |    2 +-
 drivers/media/video/ivtv/ivtv-yuv.c                | 1094 +++++----
 drivers/media/video/ivtv/ivtv-yuv.h                |   12 +-
 drivers/media/video/ivtv/ivtvfb.c                  |    6 +-
 drivers/media/video/m52790.c                       |  168 ++
 drivers/media/video/meye.c                         |    2 +-
 drivers/media/video/msp3400-driver.c               |  238 +-
 drivers/media/video/msp3400-kthreads.c             |  166 +-
 drivers/media/video/mt20xx.c                       |    2 +-
 drivers/media/video/pvrusb2/Kconfig                |   37 +-
 drivers/media/video/pvrusb2/Makefile               |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-audio.c        |   62 +-
 drivers/media/video/pvrusb2/pvrusb2-context.c      |   55 +-
 drivers/media/video/pvrusb2/pvrusb2-context.h      |    5 +-
 drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c  |   97 +-
 drivers/media/video/pvrusb2/pvrusb2-debug.h        |   39 +-
 drivers/media/video/pvrusb2/pvrusb2-debugifc.c     |  177 +--
 drivers/media/video/pvrusb2/pvrusb2-devattr.c      |  217 ++
 drivers/media/video/pvrusb2/pvrusb2-devattr.h      |  119 +
 drivers/media/video/pvrusb2/pvrusb2-eeprom.c       |    1 +
 drivers/media/video/pvrusb2/pvrusb2-encoder.c      |   75 +-
 drivers/media/video/pvrusb2/pvrusb2-encoder.h      |    1 +
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |   80 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          | 1301 ++++++----
 drivers/media/video/pvrusb2/pvrusb2-hdw.h          |  144 +-
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c     |   10 +-
 drivers/media/video/pvrusb2/pvrusb2-main.c         |    6 +-
 drivers/media/video/pvrusb2/pvrusb2-std.c          |    7 +
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c        |   60 +
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    7 +-
 drivers/media/video/pvrusb2/pvrusb2-video-v4l.c    |   55 +-
 drivers/media/video/saa7115.c                      |   80 +-
 drivers/media/video/saa7127.c                      |  148 +-
 drivers/media/video/saa7134/Kconfig                |   13 +-
 drivers/media/video/saa7134/Makefile               |    1 -
 drivers/media/video/saa7134/saa7134-alsa.c         |   16 +-
 drivers/media/video/saa7134/saa7134-cards.c        |  614 +++++-
 drivers/media/video/saa7134/saa7134-core.c         |   35 +-
 drivers/media/video/saa7134/saa7134-dvb.c          |   19 +-
 drivers/media/video/saa7134/saa7134-empress.c      |  293 ++-
 drivers/media/video/saa7134/saa7134-i2c.c          |   15 +-
 drivers/media/video/saa7134/saa7134-input.c        |   63 +-
 drivers/media/video/saa7134/saa7134-oss.c          | 1046 --------
 drivers/media/video/saa7134/saa7134-ts.c           |    8 +-
 drivers/media/video/saa7134/saa7134-tvaudio.c      |   79 +-
 drivers/media/video/saa7134/saa7134-vbi.c          |    8 +-
 drivers/media/video/saa7134/saa7134-video.c        | 1536 ++++++------
 drivers/media/video/saa7134/saa7134.h              |   34 +-
 drivers/media/video/sn9c102/Makefile               |    1 +
 drivers/media/video/sn9c102/sn9c102_core.c         |    4 +-
 drivers/media/video/sn9c102/sn9c102_devtable.h     |    2 +
 drivers/media/video/sn9c102/sn9c102_mt9v111.c      |  259 ++
 drivers/media/video/stk-sensor.c                   |  578 +++++
 drivers/media/video/stk-webcam.c                   | 1465 +++++++++++
 drivers/media/video/stk-webcam.h                   |  138 +
 drivers/media/video/tda7432.c                      |  232 +-
 drivers/media/video/tda8290.c                      |  901 ++++----
 drivers/media/video/tda8290.h                      |   31 +-
 drivers/media/video/tda9875.c                      |  167 +-
 drivers/media/video/tda9887.c                      |  305 ++-
 drivers/media/video/tda9887.h                      |   38 +
 drivers/media/video/tea5761.c                      |    2 +-
 drivers/media/video/tea5767.c                      |   92 +-
 drivers/media/video/tea5767.h                      |   19 +
 drivers/media/video/tlv320aic23b.c                 |  134 +-
 drivers/media/video/tuner-core.c                   |  748 ++++---
 drivers/media/video/tuner-driver.h                 |   99 -
 drivers/media/video/tuner-i2c.h                    |   57 +-
 drivers/media/video/tuner-simple.c                 |   17 +-
 drivers/media/video/tuner-types.c                  |   12 +-
 drivers/media/video/tuner-xc2028-types.h           |  128 +
 drivers/media/video/tuner-xc2028.c                 | 1213 +++++++++
 drivers/media/video/tuner-xc2028.h                 |   63 +
 drivers/media/video/tvaudio.c                      |  504 ++--
 drivers/media/video/tveeprom.c                     |  504 ++--
 drivers/media/video/upd64031a.c                    |  111 +-
 drivers/media/video/upd64083.c                     |  103 +-
 drivers/media/video/usbvision/usbvision-cards.c    |   18 +-
 drivers/media/video/usbvision/usbvision-cards.h    |    1 +
 drivers/media/video/usbvision/usbvision-core.c     |  330 ++--
 drivers/media/video/usbvision/usbvision-video.c    |   60 +-
 drivers/media/video/usbvision/usbvision.h          |    8 +-
 drivers/media/video/v4l2-common.c                  |   32 +-
 drivers/media/video/v4l2-int-device.c              |    6 +-
 drivers/media/video/videobuf-core.c                |  357 ++--
 drivers/media/video/videobuf-dma-sg.c              |   23 +-
 drivers/media/video/videobuf-dvb.c                 |    2 +-
 drivers/media/video/videobuf-vmalloc.c             |    2 +-
 drivers/media/video/videodev.c                     |    8 +-
 drivers/media/video/vivi.c                         |  706 +++---
 drivers/media/video/vp27smpx.c                     |  113 +-
 drivers/media/video/wm8739.c                       |  137 +-
 drivers/media/video/wm8775.c                       |  140 +-
 drivers/media/video/zr364xx.c                      |    2 +-
 include/linux/i2c-id.h                             |    2 +
 include/media/cs5345.h                             |   39 +
 include/media/cx2341x.h                            |    2 +-
 include/media/cx25840.h                            |   19 +
 include/media/ir-common.h                          |    3 +-
 include/media/m52790.h                             |   93 +
 include/media/saa7146_vv.h                         |    1 -
 include/media/tuner.h                              |    5 +-
 include/media/v4l2-chip-ident.h                    |    6 +
 include/media/v4l2-common.h                        |   18 +-
 include/media/v4l2-i2c-drv-legacy.h                |  140 ++
 include/media/v4l2-i2c-drv.h                       |   68 +
 include/media/v4l2-int-device.h                    |    5 +-
 include/media/videobuf-core.h                      |   20 +-
 269 files changed, 29548 insertions(+), 11654 deletions(-)
 create mode 100644 Documentation/video4linux/extract_xc3028.pl
 delete mode 100644 drivers/media/dvb/dvb-usb/opera1.h
 create mode 100644 drivers/media/dvb/frontends/tda18271-common.c
 create mode 100644 drivers/media/dvb/frontends/tda18271-fe.c
 create mode 100644 drivers/media/dvb/frontends/tda18271-priv.h
 create mode 100644 drivers/media/dvb/frontends/tda18271-tables.c
 create mode 100644 drivers/media/dvb/frontends/tda18271.h
 create mode 100644 drivers/media/dvb/frontends/xc5000.c
 create mode 100644 drivers/media/dvb/frontends/xc5000.h
 create mode 100644 drivers/media/dvb/frontends/xc5000_priv.h
 create mode 100644 drivers/media/radio/radio-si470x.c
 create mode 100644 drivers/media/video/bt8xx/bttv-audio-hook.c
 create mode 100644 drivers/media/video/bt8xx/bttv-audio-hook.h
 create mode 100644 drivers/media/video/cs5345.c
 create mode 100644 drivers/media/video/cx23885/cx23885-vbi.c
 create mode 100644 drivers/media/video/cx23885/cx23885-video.c
 create mode 100644 drivers/media/video/em28xx/em28xx-audio.c
 create mode 100644 drivers/media/video/m52790.c
 create mode 100644 drivers/media/video/pvrusb2/pvrusb2-devattr.c
 create mode 100644 drivers/media/video/pvrusb2/pvrusb2-devattr.h
 delete mode 100644 drivers/media/video/saa7134/saa7134-oss.c
 create mode 100644 drivers/media/video/sn9c102/sn9c102_mt9v111.c
 create mode 100644 drivers/media/video/stk-sensor.c
 create mode 100644 drivers/media/video/stk-webcam.c
 create mode 100644 drivers/media/video/stk-webcam.h
 create mode 100644 drivers/media/video/tda9887.h
 delete mode 100644 drivers/media/video/tuner-driver.h
 create mode 100644 drivers/media/video/tuner-xc2028-types.h
 create mode 100644 drivers/media/video/tuner-xc2028.c
 create mode 100644 drivers/media/video/tuner-xc2028.h
 create mode 100644 include/media/cs5345.h
 create mode 100644 include/media/m52790.h
 create mode 100644 include/media/v4l2-i2c-drv-legacy.h
 create mode 100644 include/media/v4l2-i2c-drv.h

Adrian Bunk (13):
      V4L/DVB (6399): saa7134/: make 2 functions static
      V4L/DVB (6569): bt8xx/dst.c: make code static
      V4L/DVB (6570): core/dvb_ringbuffer.c: remove unused exports
      V4L/DVB (6571): dvb-usb/gp8psk.c: #if 0 gp8psk_bcm4500_reload()
      V4L/DVB (6572): dvb-usb/vp702x.c: cleanups
      V4L/DVB (6573): unexport flexcop_reset_block_300
      V4L/DVB (6574): common/ir-functions.c: make a function static
      V4L/DVB (6575): cx23885/: cleanups
      V4L/DVB (6576): cx88-mpeg.c: make 4 functions static
      V4L/DVB (6577): et61x251/: make 5 functions static
      V4L/DVB (6578): dvb-usb: make some debug vars static
      V4L/DVB (6623): remove saa7134-oss
      V4L/DVB (6665a): finish the VID_HARDWARE_* removal

Aidan Thornton (1):
      V4L/DVB (6619): Use MTS firmware for the HVR-900

Akinobu Mita (2):
      V4L/DVB (6848): bttv: check pci_register_driver() error
      V4L/DVB (7077): bt878: remove handcrafted PCI subsystem ID check

Albert Graham (1):
      V4L/DVB (6752): saa7134: Enable remote control support for Avermedia M102

Andrew Morton (6):
      V4L/DVB (6749): v4l-nopage-fix
      V4L/DVB (6808): git-dvb: fix build in drivers/media/dvb/frontends/tda18271.h
      V4L/DVB (6809): git-dvb: drivers/media/video/et61x251/et61x251_core.c: fix warnings
      V4L/DVB (6811): media-video-usbvision-add-mutex_unlock-to-error-paths-fix
      V4L/DVB (6818): git-dvb: drivers/media/dvb/frontends/zl10353.c: avoid 64-bit divide
      V4L/DVB (6976): drivers/media/radio/radio-sf16fmr2.c: fix error handling

Andrey J. Melnikoff (TEMHOTA) (1):
      V4L/DVB (6973): Add Beholder TV 401/405/407/409/505/507/609/M6 support

Aurelien Jarno (1):
      V4L/DVB (em28xx): Add support for Pinnacle Dazzle DVC 100

Brandon Philips (3):
      V4L/DVB (6600): V4L: videobuf: don't chew up namespace STATE_.*, convert to VIDEOBUF_
      V4L/DVB (6603): V4L: videobuf: convert streaming and reading to bitfields
      V4L/DVB (6688): V4L: fix copy and paste error in dprintk for videobuf-vmalloc.c

Brett T. Warden (1):
      V4L/DVB (7013): bw-qcam: add module parameter 'force_init' to skip polite auto-detection prior to direct initialization

Chris Pascoe (40):
      V4L/DVB (6624): CXUSB: return control message transfer result to caller
      V4L/DVB (6625): CXUSB: i2c transfer failure notification
      V4L/DVB (6626): CXUSB: support only-read i2c requests
      V4L/DVB (6627): CXUSB: handle write then read from different address
      V4L/DVB (6628): zl10353: Improve support for boards without a tuner on secondary i2c
      V4L/DVB (6630): zl10353: calculate input frequency register instead of using hardcoded value
      V4L/DVB (6631): xc2028: eliminate i2c macro side-effects
      V4L/DVB (6632): xc2028: fix inverted logic in audio standard check
      V4L/DVB (6633): xc2028: make register reads atomic
      V4L/DVB (6634): xc2028: error messages missing whitespace
      V4L/DVB (6635): xc2028: v4l2_std_id needs to be long long to display completely
      V4L/DVB (6636): xc2028: protect device list
      V4L/DVB (6637): xc2028: add missing break
      V4L/DVB (6638): xc2028: firmware loading cleanup
      V4L/DVB (6639): xc2028: correct divisor length
      V4L/DVB (6640): xc2028: correctly select 8MHz firmware
      V4L/DVB (6641): xc2028: correct tuner offset for 7MHz DTV
      V4L/DVB (6642): xc2028: don't duplicate max_len in priv
      V4L/DVB (6643): xc2028: use best match instead of first partial match during firmware selection
      V4L/DVB (6644): xc2028: use correct offset into scode firmware
      V4L/DVB (6645): xc2028: allow selection of D2633 firmware
      V4L/DVB (6646): xc2028: rework firmware (re)loading process
      V4L/DVB (6647): xc2028: retry firmware load if tuner does not respond
      V4L/DVB (6648): xc2028: add sleep hook
      V4L/DVB (6649): Add support for the DViCO FusionHDTV Dual Digital 4
      V4L/DVB (6650): xc2028: base firmwares should have std0
      V4L/DVB (6651): xc2028: mask off type correctly when searching for standard-specific types
      V4L/DVB (6652): xc2028: try non-8MHZ init1 firmware
      V4L/DVB (6653): Add support for the DViCO FusionHDTV NANO2 w/ZL10353 and firmware
      V4L/DVB (6654): mt352: support oversampled IF input
      V4L/DVB (6655): Add support for MT352-based DViCO FusionHDTV DVB-T NANO devices
      V4L/DVB (6656): zl10353: store frequencies in 0.1kHz to eliminate rounding errors
      V4L/DVB (6851): xc2028: include int_freq in firmware version display
      V4L/DVB (6852): xc2028: s-code offset should not modify internal control structure
      V4L/DVB (6853): xc2028: check HAS_IF flag against table
      V4L/DVB (6854): xc2028: be more specific about when applying offset for 7MHz channels
      V4L/DVB (6855): xc2028: select DTV78 firmware if tuning 7MHz VHF / 8MHz UHF
      V4L/DVB (6856): zl10353: improve tuning parameters and update register map
      V4L/DVB (6857): cx23885: correctly join I2C writes and reads from same address
      V4L/DVB (6897): xc2028: ignore HAS_IF during specific S-Code type searches

Daniel Gimpelevich (1):
      V4L/DVB (7066):  ASUS My Cinema U3000 Mini DVBT Tuner

Daniel Walker (2):
      V4L/DVB (6810): media: video: usbvision: add mutex_unlock() to error paths
      V4L/DVB (6812): media: video: usbvision: remove ctrlUrbLock

Darren Salt (1):
      V4L/DVB (7069):  Support for myTV.t

Douglas Schilling Landgraf (5):
      V4L/DVB (6481): radio-gemtek: make file_operations const
      V4L/DVB (6482): zr364: make file_operations const
      V4L/DVB (6483): ivtv-streams: make file_operations const
      V4L/DVB (6734): Converted saa7134-video to use video_ioctl2
      V4L/DVB (6911): Converted bttv to use video_ioctl2

Frej Drejhammar (1):
      V4L/DVB (6834): cx88-video: Enable selection of the WM8775 for cx88 cards

Hans Verkuil (53):
      V4L/DVB (6451): v4l2: add support for bus-based I2C drivers
      V4L/DVB (6452): wm8775: convert to bus-based I2C API
      V4L/DVB (6453): wm8739: convert to bus-based I2C API
      V4L/DVB (6454): vp27smpx: convert to bus-based I2C API
      V4L/DVB (6455): saa7115: convert to bus-based I2C API
      V4L/DVB (6456): saa7127: convert to bus-based I2C API
      V4L/DVB (6457): msp3400: convert to bus-based I2C API
      V4L/DVB (6458): cs53l23a: convert to bus-based I2C API
      V4L/DVB (6459): cx25840: convert to bus-based I2C API
      V4L/DVB (6460): v4l2-i2c-drv: add legacy_probe function pointer
      V4L/DVB (6461): tvaudio: convert to bus-based I2C API
      V4L/DVB (6462): upd64083: convert to bus-based I2C API
      V4L/DVB (6463): upd64031a: convert to bus-based I2C API
      V4L/DVB (6464): tlv320aic23b: convert to bus-based I2C API
      V4L/DVB (6465): Use correct error codes when chip is not recognized
      V4L/DVB (6466): v4l2-i2c-drv: first call remove, then detach client
      V4L/DVB (6467): v4l2-common: minor cleanups
      V4L/DVB (6471): tuner: i2c_client cannot be part of the tuner struct
      V4L/DVB (6486): m52790: add new Mitsubishi A/V switch i2c driver
      V4L/DVB (6487): i2c-id: add M52790 driver ID
      V4L/DVB (6488): ivtv: add ASUS Falcon2 support
      V4L/DVB (6489): ivtv: add support for AVerMedia PVR-150 Plus
      V4L/DVB (6490): Remove EXPERIMENTAL from several i2c drivers
      V4L/DVB (6553): tuner: replace default_mode_mask
      V4L/DVB (6555): tuner: reorder functions to prepare for i2c conversion
      V4L/DVB (6556): tuner: convert to bus-based I2C API
      V4L/DVB (6557): tea5767: remove unnecessary warning
      V4L/DVB (6665b): add ivtv to MAINTAINERS
      V4L/DVB (6737): wm8775: codingstyle cleanup
      V4L/DVB (6738): wm8739: codingstyle cleanups
      V4L/DVB (6739): cs53l32a: codingstyle cleanups
      V4L/DVB (6740): tlv320aic23b: codingstyle cleanups
      V4L/DVB (6741): cx2341x: codingstyle cleanups
      V4L/DVB (6742): ivtv: fix incorrect debug message
      V4L/DVB (6743): cx25840: fix endianness inconsistency
      V4L/DVB (6762): ivtv: update version number to 1.2
      V4L/DVB (6763): ivtv: add AVerMedia EZMaker PCI Deluxe support
      V4L/DVB (6764): ivtv: select VIDEO_IR in Kconfig
      V4L/DVB (6765): ivtv: convert to bus-based i2c API
      V4L/DVB (6766): ivtv: remove i2c legacy support from drivers that no longer need it
      V4L/DVB (6859): tveeprom: add support for Hauppauge models 74xxx
      V4L/DVB (6860): tveeprom: CodingStyle cleanup
      V4L/DVB (6861): cx2341x: command argument should be u32 instead of int
      V4L/DVB (6862): ivtv: really remove i2c legacy support from drivers that no longer need it
      V4L/DVB (6863): upd64083: CodingStyle cleanups
      V4L/DVB (6864): upd64031a: CodingStyle cleanup
      V4L/DVB (6865): vp27smpx: CodingStyle cleanup
      V4L/DVB (6866): msp3400: CodingStyle cleanups
      V4L/DVB (6867): saa7127: CodingStyle cleanups
      V4L/DVB (6868): i2c-id.h: add I2C_DRIVERID_CS5345
      V4L/DVB (6869): cs5345: new i2c driver
      V4L/DVB (6896): ivtv: add XC2028 support for Club3D cards
      V4L/DVB (6917): ivtv: small textual update

Hermann Pitton (3):
      V4L/DVB (6687): saa7134: add mute support for radio/analog-in on MD9717 and MD7134
      V4L/DVB (7016): saa7134: remove the Avermedia Super 007 from eeprom detection
      V4L/DVB (7017): saa7134: add MSI TV@nywhere Plus with the older tda8275 tuner

Ian Armstrong (8):
      V4L/DVB (6712): ivtv: ivtv yuv stream handling change
      V4L/DVB (6713): ivtv: ivtv_yuv_prep_frame breakup and yuv hardware buffer changes
      V4L/DVB (6714): ivtv: yuv frame parameter fix
      V4L/DVB (6715): ivtv: Remove unnecessary register update
      V4L/DVB (6716): ivtv: yuv interlace mode change
      V4L/DVB (6717): ivtv: Initial merge of video48 yuv handling into the IVTV_IOC_DMA_FRAME framework
      V4L/DVB (6718): ivtv: ivtv yuv format description correction
      V4L/DVB (6719): ivtv: ivtv-yuv clean-up + source cropping bug-fix

Jaime Velasco Juan (1):
      V4L/DVB (7019): V4L: add support for Syntek DC1125 webcams

Jaroslav Barton (1):
      V4L/DVB (6588):  Leadtek Winfast DTV Dongle remote control

Jean Delvare (1):
      V4L/DVB (6915): ivtv: drop an incorrect comment

Jelle Foks (3):
      V4L/DVB (6828): cx88-blackbird: audio improvements
      V4L/DVB (6829): cx88-blackbird: remove unnecessary msleep()'s
      V4L/DVB (6830): cx88-blackbird: remove unnecessary encoder unmute

Joe Perches (3):
      V4L/DVB (6616): drivers/media/radio: Add missing "space"
      V4L/DVB (6617): drivers/media/video: Add missing "space"
      V4L/DVB (6618): drivers/media/dvb: Add missing "space"

Jose Alberto Reguero (1):
      V4L/DVB (7067): fix autoserach in the Hauppauge NOVA-T 500

Julia Lawall (2):
      V4L/DVB (7035): drivers/media/common: Add missing video_device_release
      V4L/DVB (7036): radio: Use video_device_release rather than kfree

Luca Olivetti (1):
      V4L/DVB (7054): ansonic branded dvb-t usb stick support in the af9005 driver

Luca Risolia (1):
      V4L/DVB (6591): Adds support for MT9V111 on sn9c102

Marco Schluessler (2):
      V4L/DVB (6496): saa7146_vv.h: remove wrong include <linux/videodev.h>
      V4L/DVB (6497): saa7146/budget*/dvb-ttpci: Remove V4L1 code

Markus Rechberger (1):
      V4L/DVB (6949): Adds em28xx-audio module

Matthias Kaehlcke (1):
      V4L/DVB (6400): usbvision: Convert the usbvision->lock semaphore to the mutex API

Matthias Schwarzott (3):
      V4L/DVB (6873): Fixes issues listed by checkpatch
      V4L/DVB (6874): removes duplicated KERN_DEBUG flags from dprintk calls in mt312.c
      V4L/DVB (6903): mt312: CodingStyle fix

Mauro Carvalho Chehab (115):
      V4L/DVB (6384): Replace TDA9887_SET_CONFIG by TUNER_SET_CONFIG
      V4L/DVB (6385): Adds the capability of configuring tea5767 support
      V4L/DVB (6386): Add support for radio on CX88_BOARD_MSI_TVANYWHERE_MASTER
      V4L/DVB (6411): remove V4L1 from being compiled when V4L2 only is selected
      V4L/DVB (6412): Audio hooks moved to another file
      V4L/DVB (6418): Converted tvaudio from V4L1 to V4L2
      V4L/DVB (6419): V4L2 port of tda7432 from V4L1 api
      V4L/DVB (6420): V4L2 conversion for tda9875 from V4L1 API
      V4L/DVB (6421): Make Kconfig reflect the changes at audio helper modules
      V4L/DVB (6422): Add the pending entries for xc2028/3028 based boards
      V4L/DVB (6423): Add tuner-xc2028 driver
      V4L/DVB (6426): Some fixes on tuner-xc2028
      V4L/DVB (6427): Some cleanups at tuner-xc2028 driver
      V4L/DVB (6429): Avoid having two tuner commands happening at the same time
      V4L/DVB (6430): Convert tuner-xc2028 driver to the newer hybrid approach
      V4L/DVB (6431): Improve firmware format
      V4L/DVB (6470): Avoid breaking compilation
      V4L/DVB (6472): Re-inserts xc2028 attach code, fixing its parameters
      V4L/DVB (6473): Prevents double tuner registering
      V4L/DVB (6474): Add support for tuner-xc2028
      V4L/DVB (6475): Fix some troubles at list handling
      V4L/DVB (6476): Add support for analog tv on HVR-950
      V4L/DVB (6477): Properly fill MODULE_AUTHOR
      V4L/DVB (6516): Allow faster loading by using 64 bytes block by em28xx i2c write
      V4L/DVB (6517): CodingStyle fixup
      V4L/DVB (6519): Fix HVR900/HVR950 entry
      V4L/DVB (6535): Fix: Adds the generic PCI IDs for em28xx
      V4L/DVB (6536): Add a hint for boards without unique USB ID
      V4L/DVB (6537): Add entry for Pixelview Prolink PlayTV USB 2.0
      V4L/DVB (6541): Add V-Gear PocketTV to Cardlist.em28xx
      V4L/DVB (6546): Add comments for the hint methods
      V4L/DVB(6548a) Fix compilation for TDA8290
      V4L/DVB(6548b) Fix compilation for em28xx
      V4L/DVB (6559): Fix a buffer overflow at xc2028_get_reg
      V4L/DVB (6560): Fix a bug when setting tuner type
      V4L/DVB (6561): Fix xc2028 get register functions and calls
      V4L/DVB (6562): Make HVR900 to use also tveeprom
      V4L/DVB (6582): Fix em28xx to allow multiple open
      V4L/DVB (6583): Fix em28xx read stream locking
      V4L/DVB (6584): Fix read() method
      V4L/DVB (6585): Convert em28xx to video_ioctl2
      V4L/DVB (6586): Remove some dead code and make drive fully V4L2 compatible
      V4L/DVB (6587): Cleanup at tv norm selection
      V4L/DVB (6592): Add the capability to work with more complete firmwares
      V4L/DVB (6593): Fix scode table loading
      V4L/DVB (6594): Add tuner_err macro
      V4L/DVB (6595): Corrects printk lines
      V4L/DVB (6598): Fix standard name
      V4L/DVB (6605): Add a modprobe option to manually select audio standard
      V4L/DVB (6613): Fix: add a missing continue statement
      V4L/DVB (6614): Fix driver for i386 architectures
      V4L/DVB (6657): Fix standard selection for PAL/M, PAL/N, PAL/Nc and NTSC
      V4L/DVB (6658): Sets a default std, if not specified
      V4L/DVB (6659): Convert MTS to bitfield
      V4L/DVB (6660): Allow fully configuring xc3028 during xc2028_attach
      V4L/DVB (6661): Remove firmware reload hack for analog
      V4L/DVB (6662): Fix standard selection for PAL
      V4L/DVB (6664): Add missing USB ID's at CARDLIST.em28xx
      V4L/DVB (6665): Fix CodingStyle
      V4L/DVB (6671): Avoids checking digital/analog at check_firmware
      V4L/DVB (6672): Add support for radio
      V4L/DVB (6674): Add support for other DTV types
      V4L/DVB (6675): Allow selecting the proper SCode table for DTV
      V4L/DVB (6676): Improve s-code support
      V4L/DVB (6677): Fix xc2028 driver for non OFDM
      V4L/DVB (6683): Fix DVB compatibility
      V4L/DVB (6735): Reorder functions to make easier to compare with the previous code
      V4L/DVB (6736): Fix some errors at the video_ioctl2 conversion
      V4L/DVB (6753): Fix vivi to support non-zero minor node
      V4L/DVB (6754): Allow vivi to open multiple video devices
      V4L/DVB (6755): Avoid troubles when using multiple devices
      V4L/DVB (6758): Miscelaneous cleanups
      V4L/DVB (6759): CodingStyle fixes
      V4L/DVB (6791): Rename all vidioc_ to saa7134_
      V4L/DVB (6792): Fix VBI support
      V4L/DVB (6793): Convert saa7134-empress to video_ioctl2
      V4L/DVB (6795): Add EXPORT_SYMBOL_GPL to the saa7134 video control routines
      V4L/DVB (6804): __videobuf_read_start is static
      V4L/DVB (6805): video std is a bitmask. Better to print in hexa
      V4L/DVB (6806): Allow emulating changes of video std by vivi
      V4L/DVB (6807): fix debug enable
      V4L/DVB (6815): Fix vivi internal debug messages
      V4L/DVB (6816): Add proper locking for buffer filling
      V4L/DVB (6817): Cleanup kernel thread and provide overrun detection
      V4L/DVB (6827): Auto-selects D2633 for ATSC
      V4L/DVB (6836): Fix CodingStyle troubles caused by the previous cx88 commits
      V4L/DVB (6858): Fix offset for ATSC
      V4L/DVB (6912): Replace vidioc_ to bttv_
      V4L/DVB (6913): Preserve the previous order to make easier to check the conversion
      V4L/DVB (6914): Fix a few issues at the bttv conversion
      V4L/DVB (6938): Add a tool for extracting xc3028 version 2.7 firmware
      V4L/DVB (6944): Fix in-kernel ivtv compilation
      V4L/DVB (6947): Improve audio setup handling
      V4L/DVB (6948): HVR950 requires additional settings for audio to properly work
      V4L/DVB (6950): Lindent em28xx-audio.c
      V4L/DVB (6951): Integrates em28xx-audio.c into em28xx kernel module
      V4L/DVB (6952): Add code for autoloading em28xx-alsa, if needed
      V4L/DVB (6953): Fix radio set frequency logic
      V4L/DVB (6954): There isn't a MTS radio firmware
      V4L/DVB (6955): Properly implement 12MHz I2S support
      V4L/DVB (6956): Add Radio support for em28xx
      V4L/DVB (6969): Avoid causing regressions for non-HVR950 boards
      V4L/DVB (6970): Request snd-usb-audio for devices with Audio Class support
      V4L/DVB (6974): Fix codingStyle
      V4L/DVB (6975): Add missing entry for Beholder BeholdTV 407
      V4L/DVB (6981): Fix bugzillas 9686 and 9691
      V4L/DVB (6993): Fix CARDLIST.saa7134
      V4L/DVB (6997): Replace a very dirty hack on videobuf for a clean wait_event
      V4L/DVB (7020): Add USB ID for a newer variant of Hauppauge WinTV USB2
      V4L/DVB (7021): Move all board specific configuration to em28xx-cards.c
      V4L/DVB (7022): Fix timestamp presentation on vivi driver
      V4L/DVB (7023): Fix a regresion left by changeset 7e65d6e8f6df
      V4L/DVB (7039): Reorder headers
      V4L/DVB (7051): Cleans up error handling on or51xxx_attach
      V4L/DVB (7060): em28xx: remove has_tuner

Maxim Levitsky (4):
      V4L/DVB (6667): Fix access to configuration space while in D3
      V4L/DVB (6668): Fix theoretical races between IRQ handler and .suspend/resume
      V4L/DVB (6669): Add few missing bits of code to saa7134_resume
      V4L/DVB (6670): V4L: saa7134: tvaudio cleanups

Michael Krufky (127):
      V4L/DVB (6433): Move all tda8275/8275a tuning code from tda8290 module into tda827x module
      V4L/DVB (6434): tda827x: fix GPL export on attach function
      V4L/DVB (6435): tda8290: add support for NXP TDA18271 tuner and TDA8295 analog demod
      V4L/DVB (6436): tuner: move analog_tuner_ops into dvb_frontend_ops
      V4L/DVB (6437): tuner: clear analog_demod_ops on release
      V4L/DVB (6438): tuner: move analog_demod_priv into struct dvb_frontend
      V4L/DVB (6439): dvb_frontend: codingstyle cleanups
      V4L/DVB (6440): tuner: convert analog tuner demod sub-modules to dvb_frontend interface
      V4L/DVB (6441): tuner: clean up ops checking in tuner_status function
      V4L/DVB (6442): move std if setting from tda8290 to tda827x
      V4L/DVB (6443): make tda9887 build selectable via Kconfig
      V4L/DVB (6444): tuner-core: remove excessive parenthesis
      V4L/DVB (6445): tuner-core: improve comments inside function fe_release()
      V4L/DVB (6446): tda18271: clean up debug macros
      V4L/DVB (6447): tuner: add i2c_gate_ctrl function to struct analog_tuner_ops
      V4L/DVB (6448): tda8290: fill i2c_gate_ctrl callback
      V4L/DVB (6449): tda18271: clean up i2c_gate handling
      V4L/DVB (6450): tda9887: add missing module license
      V4L/DVB (6468): tda8290: auto-detect tda8290 or tda8295
      V4L/DVB (6469): tuner: remove TUNER_PHILIPS_TDA8295
      V4L/DVB (6491): tuner: prevent repeated "type set" message unless debug is enabled
      V4L/DVB (6492): tuner: improve tuner_foo printk macros consistency
      V4L/DVB (6543): tda8290: enable probing of tda8295
      V4L/DVB (6550): tda8290: return -ENODEV on probe failures
      V4L/DVB (6551): tda8290: rule out tda988x before detecting tda8290/tda8295
      V4L/DVB (6563): tda8290: optimize for loop in tda829x_probe function
      V4L/DVB (6606): saa7134: add autodetection support for alternate subids of Hauppauge HVR1110
      V4L/DVB (6607): saa7134: add support for reading Hauppauge eeprom
      V4L/DVB (6620): kconfig: VIDEO_SAA7134 must select VIDEO_TVEEPROM
      V4L/DVB (6621): tda827x: fix NULL pointer dereference during tda827x_probe_version
      V4L/DVB (6622): tda827x: prevent possible NULL pointer dereference in tda827xa_lna_gain
      V4L/DVB (6678): tda18271: define init callback
      V4L/DVB (6679): tda8290: force tuner init after attach
      V4L/DVB (6680): tda18271: move tda18271_map tables to a separate source file
      V4L/DVB (6681): tda18271: rename 'debug' to 'tda18271_debug'
      V4L/DVB (6702): pvrusb2: fix typo in comments
      V4L/DVB (6723): tda18271: only force init once during attach
      V4L/DVB (6724): tda18271: remove duplicated code
      V4L/DVB (6725): tda18271: improve debug flexibility
      V4L/DVB (6726): tda18271: set image rejection validity
      V4L/DVB (6727): tda18271: convert table lookup loops to functions
      V4L/DVB (6728): tda18271: fix register dump format
      V4L/DVB (6745): tda18271: remove tuning offset for atsc/qam
      V4L/DVB (6782): tda8290: access frontend structure directly, where possible
      V4L/DVB (6783): tuner: combine set_tv_freq and set_radio_freq into a single set_params method
      V4L/DVB (6784): tda8290: prevent possible memory leak
      V4L/DVB (6785): tda8290: remove dependency on struct tuner
      V4L/DVB (6786): tuner: add struct analog_demod_info to struct analog_tuner_ops
      V4L/DVB (6787): tuner: bug-fix: default mode was set to bogus value
      V4L/DVB (6788): tda8290: fix codingstyle, open brace following struct on the same line
      V4L/DVB (6789): tuner: use char *name instead of 128 byte fixed array for demod info
      V4L/DVB (6800): tda18271: use an enum rather than an integer to store analog / digital state
      V4L/DVB (6801): tda18271: pass i2c gate configuration into tda18271_attach()
      V4L/DVB (6821): s5h1409: fix IF frequency configuration
      V4L/DVB (6822): s5h1409: use VSB IF frequency ( 44 / 5.38 MHz ) unless otherwise specified
      V4L/DVB (6832): cx88-blackbird: don't mute audio when stopping the codec
      V4L/DVB (6837): Convert cx88_input.audioroute to a bitfield
      V4L/DVB (6838): tda9887: remove references to struct tuner from printk macros
      V4L/DVB (6839): tuner: add set_config to struct analog_tuner_ops
      V4L/DVB (6840): tuner: convert tda9887 to use TUNER_SET_CONFIG
      V4L/DVB (6841): tda9887: maintain private state independent of struct tuner
      V4L/DVB (6842): tda9887: remove dependency on struct tuner
      V4L/DVB (6843): tda9887: use printk macros from tuner-i2c.h
      V4L/DVB (6844): tuner: remove struct tuner from tuner-driver.h
      V4L/DVB (6845): tuner: remove unneeded #includes from tuner-driver.h
      V4L/DVB (6846): tda9887: initialize mode to T_STANDBY at startup
      V4L/DVB (6875): tuner-xc2028: ATSC requires 1.75 MHz tuning offset
      V4L/DVB (6878): tuner: remove extraneous variable declaration
      V4L/DVB (6879): move struct analog_tuner_ops into dvb_frontend.h
      V4L/DVB (6880): kill tuner-driver.h
      V4L/DVB (6881): include struct analog_demod_ops directly inside struct dvb_frontend
      V4L/DVB (6882): dvb_frontend: release analog demod in dvb_frontend_detach
      V4L/DVB (6890): tda18271: fix typo in RF tracking filter calibration
      V4L/DVB (6892): xc5000: fix build when DVB_TUNER_XC5000 is disabled
      V4L/DVB (6893): tuner-xc2028: fix xc2028_attach function
      V4L/DVB (6894): xc5000: fix build warning
      V4L/DVB (6898): cx23885: add support for Hauppauge WinTV HVR-1500
      V4L/DVB (6899): Kconfig: VIDEO_CX23885 must select TUNER_XC2028 if !DVB_FE_CUSTOMIZE
      V4L/DVB (6900): cx23885: enable EZ-QAM mode for Hauppauge WinTV HVR-1800
      V4L/DVB (6901): Kconfig: VIDEO_CX23885 selects TUNER_TDA8290 and DVB_TDA18271
      V4L/DVB (6904): tda18271: divider byte 1, bit 7 is always 0
      V4L/DVB (6905): tda18271: check ID register during attach
      V4L/DVB (6906): tda18271: rename tda18271_calc_* functions to tda18271_lookup_*
      V4L/DVB (6907): tda18271: create separate calc_pll functions
      V4L/DVB (6908): tda8290: add the option not to probe for tuners passed into tda829x_config
      V4L/DVB (6909): cx23885: fix bad use count caused by tda18271 being probed by tda8290
      V4L/DVB (6919): Kconfig: VIDEO_CX23885 must select DVB_TUNER_XC5000 if !DVB_FE_CUSTOMIZE
      V4L/DVB (6920): tuner: fix backwards logic in check for set_config
      V4L/DVB (6921): include/media/v4l2-i2c-drv.h must #include <media/v4l2-common.h>
      V4L/DVB (6923): tda18271: remove extraneous debug
      V4L/DVB (6924): tda18271: fix whitespace in tda18271_ir_measure
      V4L/DVB (6925): tda18271: move state structures to tda18271-priv.h
      V4L/DVB (6926): tda18271: consolidate table lookup functions
      V4L/DVB (6927): tda18271: improve printk macros
      V4L/DVB (6928): tda18271: break calculation functions out of tda18271_tune
      V4L/DVB (6932): cx23885: add missing subsystem ID for Hauppauge HVR1800 Retail
      V4L/DVB (6933): cx23885: update model matrix for Hauppauge HVR1800
      V4L/DVB (6934): cx23885: update model matrix for Hauppauge HVR1250
      V4L/DVB (6935): cx23885: add missing subsystem IDs for Hauppauge HVR1500 Retail
      V4L/DVB (6936): cx23885: update model matrix for Hauppauge HVR1500
      V4L/DVB (6957): tda18271: fail table lookups if frequency is out of range
      V4L/DVB (6958): tda18271: clean up function tda18271_set_analog_params
      V4L/DVB (6959): tda18271: add MODULE_VERSION
      V4L/DVB (6960): tda18271: add support for NXP TDA18271HD/C2
      V4L/DVB (6961): tda18271: move common code to tda18271-common.c
      V4L/DVB (6962): tda18271: allow device-specific configuration of IF frequency and std bits
      V4L/DVB (6963): tda18271: store IF frequency in a u16 instead of u32
      V4L/DVB (6964): tda18271: document debug level and configuration parameters
      V4L/DVB (6965): tda18271: fix analog tuning regression caused by earlier changeset
      V4L/DVB (6967): pvrusb2: add support for Hauppauge WinTV PVR-USB2 Model 75xxx
      V4L/DVB (6977): tda18271: clean up calibration initialization procedures
      V4L/DVB (6978): tda18271: store frequency and bandwidth after successful tune
      V4L/DVB (6979): tda18271: use a mutex to protect state in critical sections
      V4L/DVB (6986): tda18271: share state between analog and digital tuner instances
      V4L/DVB (6987): tda18271: add support for fm radio
      V4L/DVB (6988): tda18271: give calibration debug a separate debug mask
      V4L/DVB (6989): tda18271: clean up chip id logic in tda829x_release
      V4L/DVB (7026): tda18271: report when the RF tracking filter calibration has completed
      V4L/DVB (7027): tda18271: put the device in standby mode during sleep()
      V4L/DVB (7028): tda18271: test RF_CAL_OK to see if we need additional RF calibration
      V4L/DVB (7029): tda18271: provide a choice whether to perform rf cal on init or on first tune
      V4L/DVB (7030): Kconfig: add missing selections for VIDEO_PVRUSB2
      V4L/DVB (7032): tda18271: tda18271_cal_on_startup should be declared static
      V4L/DVB (7047): fix broken build when CONFIG_USB_SI470X is set
      V4L/DVB (7052): tda18271: when tuning digital, the analog demod must be tri-stated
      V4L/DVB (7055): make tuner names consistent with standard cases
      V4L/DVB (7056): tuner: suppress obsolete tuner i2c address warning for XC5000 tuners

Michel Lespinasse (1):
      V4L/DVB (6685): ir-keymaps.c: extra keys on winfast Y04G0033 remote

Michel Ludwig (6):
      V4L/DVB (6424): Improve tuner-xc2028 script
      V4L/DVB (6425): Add experimental DVB frontend tuner interface to xc2028/3028
      V4L/DVB (6428): Make the naming of the DTV firmware files more consistent
      V4L/DVB (6610): Fix a wrong typecast
      V4L/DVB (6611): Change xc2028_attach method to make easier for DVB
      V4L/DVB (6612): Allow RESET_CLK callback and avoids unneeded loading

Mike Isely (23):
      V4L/DVB (6691): pvrusb2: Rework pipeline state control
      V4L/DVB (6692): pvrusb2: Centralize device specific attributes into a single place
      V4L/DVB (6693): pvrusb2: Add pvrusb2-devattr.o to driver build
      V4L/DVB (6694): pvrusb2: Remove obsolete global hardware type enumeration
      V4L/DVB (6695): pvrusb2: Implement functions to pass descriptive hardware info
      V4L/DVB (6696): pvrusb2: Miscellaneous tweaks for controlling tuner type and video standard
      V4L/DVB (6697): pvrusb2: Existence of Hauppauge ROM is a device-specific attribute
      V4L/DVB (6698): pvrusb2: Implement signal routing schemes
      V4L/DVB (6699): pvrusb2: Use of virtual IR chip is a device-specific attribute
      V4L/DVB (6700): pvrusb2: Soften the crashed encoder warning message
      V4L/DVB (6701): pvrusb2: Enable support for "GOTVIEW USB2.0 DVD2" hardware
      V4L/DVB (6705): pvrusb2: Implement default standard selection based on device type
      V4L/DVB (6706): pvrusb2: Remove use of volatile in command sequencer
      V4L/DVB (6707): pvrusb2: Remove use of volatile in pipeline control state machine
      V4L/DVB (6708): pvrusb2: Expand comment in device attributes description
      V4L/DVB (6709): pvrusb2: minor rework for default video standard handling
      V4L/DVB (6710): pvrusb2: Recognize ATSC video standard bit values
      V4L/DVB (6768): pvrusb2: Mark Gotview hardware as having a cx2584x part
      V4L/DVB (6769): pvrusb2: Implement experimental support for OnAir Creator and USB2 devices
      V4L/DVB (6770): pvrusb2: Device CONFIG flags for OnAir device support
      V4L/DVB (6771): pvrusb2: Remove old obsolete CONFIG flags for pvrusb2 driver
      V4L/DVB (6772): pvrusb2: Remove obsolete (and misleading) comment
      V4L/DVB (6773): pvrusb2: rework device descriptor layout

Nick Piggin (1):
      V4L/DVB (6748): Subject: v4l: nopage

Nickolay V. Shmyrev (8):
      V4L/DVB (6408): Cleanup: Removed obsoleted code from bttv-cards
      V4L/DVB (6409): Cleanup: removed i2c_vidiocschan
      V4L/DVB (6410): Partial conversion from V4L1 to V4L2
      V4L/DVB (6413): Forward VIDIOCGAUDIO and VIDIOCSAUDIO through v4l1-compat
      V4L/DVB (6414): Remove bass, treble and balance from audio hook since they are unused
      V4L/DVB (6415): Restructurize volume hook and drop unused mute hook
      V4L/DVB (6416): Split hooks on volume and audio mode and rework their handling
      V4L/DVB (6417): Report detected sound carrier into rxsubchans

Oliver Neukum (1):
      V4L/DVB (6732): dsbr100 violates DMA coherency rules

Olivier DANET (2):
      V4L/DVB (6590): Adding support for VHF with MT2266-devices
      V4L/DVB (7072): sets the MT2060 IF1 frequency according to EEPROM

Patrick Boettcher (4):
      V4L/DVB (7071): DiB0700: Start streaming the right way
      V4L/DVB (7073): DiB7070: Reception quality improved
      V4L/DVB (7074): DiB7000P: correct tuning problem for 7MHz channel
      V4L/DVB (7075): Make a local function static

Randy Dunlap (2):
      V4L/DVB (6480): bttv: uses input functions, should depend on INPUT
      V4L/DVB (7078): radio: fix sf16fmi section mismatch

Ricardo Cerqueira (2):
      V4L/DVB (6831): Audio routes fix for blackbird boards with the wm8775 ADC
      V4L/DVB (6833): Don't limit cx88 audio routing to blackbird boards

Richard Knutsson (2):
      V4L/DVB (6731): ivtv: Remove a invalid shadow-variable
      V4L/DVB (6776): ivtv: Some general fixes

Roel Kluin (2):
      V4L/DVB (6564): Move check before lock
      V4L/DVB (6703): pvrusb2: Change division to bit-or for tveeprom standards

Sakari Ailus (1):
      V4L/DVB (6580): Set slave's master before master's attach call.

Sascha Sommer (3):
      V4L/DVB (6538): em28xx: fix locking to allow accesses from 2 different threads at the same time
      V4L/DVB (6539): em28xx: add support for vgear pockettv
      V4L/DVB (6545): em28xx: autodetect Cinergy 200 USB and VGear PocketTV

Soeren Moch (1):
      V4L/DVB (7070): Fix some tuning problems

Steven Toth (27):
      V4L/DVB (6404): cx23885: i2c 16bit reg/val read/write fix
      V4L/DVB (6884): Add support for the Xceive xc5000 silicon tuner
      V4L/DVB (6885): Add support for the Hauppauge HVR1500Q
      V4L/DVB (6886): xc5000: Cleanups of types, result codes etc
      V4L/DVB (6887): Avoid 'unknown model' message for the HVR1500-Q
      V4L/DVB (6888): Add Hauppauge tuner type 150 defintion
      V4L/DVB (6930): xc5000: Removed erroneous defines
      V4L/DVB (7002): cx25840: Add basic CX23885 AVCore support
      V4L/DVB (7003): cx23885: Add support for device revision detection
      V4L/DVB (7004): cx23885: Ensure HVR1800 TDA8295A is reset fully on module load
      V4L/DVB (7005): cx23885: SRAM reallocation prior to analog video implementation
      V4L/DVB (7006): cx23885: Track the board clock frequency and allow overrides
      V4L/DVB (7007): cx23885: Add basic video support for the HVR1800
      V4L/DVB (7008): s5h1409: Ensure the silicon is initialized during attach
      V4L/DVB (7009): cx23885: Video and VBI related files
      V4L/DVB (7010): cx23885: Small cleanup
      V4L/DVB (7011): cx23885: Cleanup of compiler defines and warnings
      V4L/DVB (7014): cx23885: dprintk macro cleanup
      V4L/DVB (7041): s5h1409: Bug fix for parallel support
      V4L/DVB (7042): xc5000: Tuner analog support
      V4L/DVB (7043): New card supported(partially): Pinnacle 800i
      V4L/DVB (7044): XC5000: Fix support for HVR1500Q broken by patch 1
      V4L/DVB (7045): xc5000: Small amount of cleanup and commenting
      V4L/DVB (7046): Finalise support for the Pinnacle HD 8000i
      V4L/DVB (7058): IR corrections for the Pinnacle 800i
      V4L/DVB (7059): cx88: Ensure the tuner is reset correctly
      V4L/DVB (7063): xc5000: Fix OOPS caused by missing firmware

Thierry MERLE (3):
      V4L/DVB (6994): usbvision: add Pinnacle Studio PCTV USB (NTSC) FM V3
      V4L/DVB (6995): ubvision: add adjust_X_Offset/adjust_Y_Offset parms
      V4L/DVB (7024): usbvision: YUV to RGB conversion fixes

Tim Taubert (1):
      V4L/DVB (7068): Add support for WinTV Nova-T-CE driver

Tobias Lorenz (3):
      V4L/DVB (7038): USB radio driver for Silicon Labs Si470x FM Radio Receivers
      V4L/DVB (7061): radio-si470x: Some cleanups
      V4L/DVB (7062): radio-si570x: Some fixes and new USB ID addition

Trent Piepho (2):
      V4L/DVB (6507): bttv: whitespace cleanup
      V4L/DVB (6508): ttpci: Rework Kconfig menus and Makefile

Yousef Lamlum (1):
      V4L/DVB (7065): Artec T14BR patches

Zoltan Devai (1):
      V4L/DVB (7037): Fix build breakage of the bttv driver, when advanced debugging is not enabled

dominik (1):
      V4L/DVB (6589): Gigabyte u7000 usb dvb-t support

hermann pitton (1):
      V4L/DVB (6992): saa7134: remove Beholder devices without eeprom from auto detection

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
