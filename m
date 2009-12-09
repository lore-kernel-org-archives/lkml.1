Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZLIERC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZLIERC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 23:17:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbZLIEQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 23:16:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691AbZLIEQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 23:16:53 -0500
Date: Wed, 9 Dec 2009 02:16:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: [GIT PULL for 2.6.33] V4L/DVB updates
Message-ID: <20091209021639.14f08856@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For a series of345 patches that contain:
	- new tuner driver for max2165;
	- new dvb-usb driver for ec168;
	- new frontend drivers for atbm8830, ds3000, ec100, stb6100,
	- new radio driver for tef6862;
	- new gspca drivers for pac7302, stv0680 and w996Xcf;
	- new sensor drivers for ov9640 and rj54n1cb0c;
	- IR core improvements to dynamically work with scancode/keycode tables;
	- DVB docbook improvements to document ISDB-T and S2API;
	- lots of drivers fixes, improvements and cleanups.


Cheers,
Mauro.

---

 Documentation/DocBook/dvb/dvbapi.xml               |   13 +
 .../DocBook/dvb/{isdbt.xml => dvbproperty.xml}     |    4 +
 Documentation/DocBook/dvb/frontend.h.xml           |  415 ++
 Documentation/DocBook/dvb/frontend.xml             |  185 +-
 Documentation/DocBook/media-entities.tmpl          |    3 +-
 Documentation/DocBook/v4l/controls.xml             |   20 +-
 Documentation/DocBook/v4l/pixfmt.xml               |    5 +
 Documentation/DocBook/v4l/videodev2.h.xml          |    7 +-
 Documentation/DocBook/v4l/vidioc-g-fbuf.xml        |   17 +
 Documentation/video4linux/CARDLIST.cx23885         |    2 +
 Documentation/video4linux/CARDLIST.cx88            |    1 +
 Documentation/video4linux/CARDLIST.em28xx          |    3 +-
 Documentation/video4linux/CARDLIST.saa7134         |    2 +
 Documentation/video4linux/gspca.txt                |   19 +-
 Documentation/video4linux/si4713.txt               |    2 +-
 Documentation/video4linux/zr364xx.txt              |    1 +
 drivers/media/common/Makefile                      |    2 +-
 drivers/media/common/ir-functions.c                |   71 +-
 drivers/media/common/ir-keymaps.c                  |  167 +
 drivers/media/common/ir-keytable.c                 |  429 ++
 drivers/media/common/saa7146_video.c               |   16 +-
 drivers/media/common/tuners/Kconfig                |    7 +
 drivers/media/common/tuners/Makefile               |    1 +
 drivers/media/common/tuners/max2165.c              |  442 ++
 drivers/media/common/tuners/max2165.h              |   48 +
 drivers/media/common/tuners/max2165_priv.h         |   60 +
 drivers/media/common/tuners/mxl5005s.c             |    5 +-
 drivers/media/common/tuners/mxl5005s.h             |    4 +
 drivers/media/common/tuners/mxl5007t.c             |    2 +-
 drivers/media/common/tuners/tda18271-common.c      |   16 +-
 drivers/media/common/tuners/tda18271-fe.c          |  114 +-
 drivers/media/common/tuners/tda18271-maps.c        |    1 +
 drivers/media/common/tuners/tda18271-priv.h        |   47 +-
 drivers/media/common/tuners/tda18271.h             |   12 +-
 drivers/media/common/tuners/tda8290.c              |    1 +
 drivers/media/common/tuners/tda9887.c              |    2 +-
 drivers/media/common/tuners/xc5000.c               |   97 +-
 drivers/media/common/tuners/xc5000.h               |    6 +
 drivers/media/dvb/bt8xx/dvb-bt8xx.c                |    2 +-
 drivers/media/dvb/dm1105/dm1105.c                  |   12 +-
 drivers/media/dvb/dvb-core/dvb_demux.c             |   39 +
 drivers/media/dvb/dvb-core/dvb_demux.h             |    5 +
 drivers/media/dvb/dvb-core/dvb_frontend.c          |  179 +-
 drivers/media/dvb/dvb-core/dvbdev.h                |   28 +
 drivers/media/dvb/dvb-usb/Kconfig                  |    8 +
 drivers/media/dvb/dvb-usb/Makefile                 |    3 +
 drivers/media/dvb/dvb-usb/af9015.c                 |   33 +-
 drivers/media/dvb/dvb-usb/af9015.h                 |  215 +-
 drivers/media/dvb/dvb-usb/cxusb.c                  |  117 +
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  182 +-
 drivers/media/dvb/dvb-usb/dvb-usb-dvb.c            |    1 +
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |   11 +
 drivers/media/dvb/dvb-usb/dvb-usb.h                |    3 +
 drivers/media/dvb/dvb-usb/ec168.c                  |  440 ++
 drivers/media/dvb/dvb-usb/ec168.h                  |   73 +
 drivers/media/dvb/dvb-usb/friio-fe.c               |   59 +-
 drivers/media/dvb/firewire/Kconfig                 |    7 +-
 drivers/media/dvb/firewire/Makefile                |    1 +
 drivers/media/dvb/firewire/firedtv-1394.c          |   41 +-
 drivers/media/dvb/firewire/firedtv-avc.c           |   54 +-
 drivers/media/dvb/firewire/firedtv-dvb.c           |   15 +-
 drivers/media/dvb/firewire/firedtv-fw.c            |  376 ++
 drivers/media/dvb/firewire/firedtv-rc.c            |    2 +
 drivers/media/dvb/firewire/firedtv.h               |   19 +-
 drivers/media/dvb/frontends/Kconfig                |   21 +
 drivers/media/dvb/frontends/Makefile               |    3 +
 drivers/media/dvb/frontends/atbm8830.c             |  495 ++
 drivers/media/dvb/frontends/atbm8830.h             |   76 +
 drivers/media/dvb/frontends/atbm8830_priv.h        |   75 +
 drivers/media/dvb/frontends/au8522_decoder.c       |   22 +-
 drivers/media/dvb/frontends/au8522_priv.h          |    2 +
 drivers/media/dvb/frontends/dib7000p.c             |   33 +-
 drivers/media/dvb/frontends/dib7000p.h             |   13 +
 drivers/media/dvb/frontends/dib8000.c              |   23 +-
 drivers/media/dvb/frontends/dib8000.h              |   14 +
 drivers/media/dvb/frontends/ds3000.c               | 1367 ++++++
 drivers/media/dvb/frontends/ds3000.h               |   45 +
 drivers/media/dvb/frontends/ec100.c                |  335 ++
 drivers/media/dvb/frontends/ec100.h                |   46 +
 drivers/media/dvb/frontends/ec100_priv.h           |   39 +
 drivers/media/dvb/frontends/s5h1409.c              |  149 +-
 drivers/media/dvb/frontends/s5h1409.h              |    7 +
 drivers/media/dvb/frontends/stb6100_proc.h         |  138 +
 drivers/media/dvb/frontends/stv0900.h              |    3 +
 drivers/media/dvb/frontends/stv0900_core.c         | 1560 +++----
 drivers/media/dvb/frontends/stv0900_init.h         |  257 +-
 drivers/media/dvb/frontends/stv0900_priv.h         |   81 +-
 drivers/media/dvb/frontends/stv0900_reg.h          | 5000 ++++++++++----------
 drivers/media/dvb/frontends/stv0900_sw.c           | 3171 +++++--------
 drivers/media/dvb/frontends/stv090x.c              |  242 +-
 drivers/media/dvb/frontends/stv090x_priv.h         |    3 +-
 drivers/media/dvb/frontends/stv090x_reg.h          |   70 +-
 drivers/media/dvb/frontends/stv6110.c              |   13 +-
 drivers/media/dvb/frontends/stv6110.h              |    1 +
 drivers/media/dvb/frontends/stv6110x.c             |    6 +-
 drivers/media/dvb/pt1/pt1.c                        |    1 -
 drivers/media/dvb/pt1/va1j5jf8007s.c               |   57 +-
 drivers/media/dvb/pt1/va1j5jf8007t.c               |   49 +-
 drivers/media/dvb/siano/sms-cards.c                |    4 +-
 drivers/media/dvb/siano/sms-cards.h                |    2 +-
 drivers/media/dvb/siano/smscoreapi.c               |    2 +-
 drivers/media/dvb/siano/smssdio.c                  |    2 +-
 drivers/media/dvb/ttpci/budget-av.c                |    2 +-
 drivers/media/dvb/ttpci/budget-ci.c                |   18 +-
 drivers/media/dvb/ttusb-dec/ttusb_dec.c            |    2 +-
 drivers/media/radio/Kconfig                        |   12 +
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/radio-mr800.c                  |  358 +-
 drivers/media/radio/tef6862.c                      |  232 +
 drivers/media/video/Kconfig                        |   33 +-
 drivers/media/video/Makefile                       |    2 +
 drivers/media/video/adv7180.c                      |  323 ++-
 drivers/media/video/au0828/au0828-video.c          |    2 +-
 drivers/media/video/bt819.c                        |    2 +-
 drivers/media/video/bt8xx/bttv-input.c             |   15 +-
 drivers/media/video/cx18/cx18-av-core.c            |   14 +-
 drivers/media/video/cx18/cx18-cards.h              |    3 +
 drivers/media/video/cx18/cx18-driver.c             |   64 +-
 drivers/media/video/cx18/cx18-driver.h             |   62 +-
 drivers/media/video/cx18/cx18-dvb.c                |    9 +-
 drivers/media/video/cx18/cx18-fileops.c            |  132 +-
 drivers/media/video/cx18/cx18-i2c.c                |   25 +-
 drivers/media/video/cx18/cx18-ioctl.c              |    3 +-
 drivers/media/video/cx18/cx18-mailbox.c            |   62 +-
 drivers/media/video/cx18/cx18-mailbox.h            |    6 +-
 drivers/media/video/cx18/cx18-queue.c              |  346 ++-
 drivers/media/video/cx18/cx18-queue.h              |   41 +-
 drivers/media/video/cx18/cx18-scb.h                |    4 +-
 drivers/media/video/cx18/cx18-streams.c            |   92 +-
 drivers/media/video/cx18/cx18-streams.h            |   10 +-
 drivers/media/video/cx18/cx18-vbi.c                |   35 +-
 drivers/media/video/cx18/cx18-vbi.h                |    2 +-
 drivers/media/video/cx18/cx18-version.h            |    2 +-
 drivers/media/video/cx18/cx23418.h                 |    2 +-
 drivers/media/video/cx231xx/cx231xx-input.c        |   11 +-
 drivers/media/video/cx231xx/cx231xx-video.c        |    2 +-
 drivers/media/video/cx23885/Kconfig                |    2 +
 drivers/media/video/cx23885/Makefile               |    3 +-
 drivers/media/video/cx23885/cx23885-417.c          |   10 +-
 drivers/media/video/cx23885/cx23885-cards.c        |  155 +-
 drivers/media/video/cx23885/cx23885-core.c         |  119 +-
 drivers/media/video/cx23885/cx23885-dvb.c          |  158 +-
 drivers/media/video/cx23885/cx23885-f300.c         |  177 +
 drivers/media/video/cx23885/cx23885-f300.h         |    2 +
 drivers/media/video/cx23885/cx23885-input.c        |  427 ++
 drivers/media/video/cx23885/cx23885-input.h        |   30 +
 drivers/media/video/cx23885/cx23885-ioctl.c        |  208 +
 drivers/media/video/cx23885/cx23885-ioctl.h        |   39 +
 drivers/media/video/cx23885/cx23885-ir.c           |  101 +
 drivers/media/video/cx23885/cx23885-ir.h           |   31 +
 drivers/media/video/cx23885/cx23885-reg.h          |    5 +-
 drivers/media/video/cx23885/cx23885-video.c        |   44 +-
 drivers/media/video/cx23885/cx23885.h              |   31 +-
 drivers/media/video/cx23885/cx23888-ir.c           | 1239 +++++
 drivers/media/video/cx23885/cx23888-ir.h           |   28 +
 drivers/media/video/cx25840/cx25840-audio.c        |  463 ++-
 drivers/media/video/cx25840/cx25840-core.c         |  324 +-
 drivers/media/video/cx25840/cx25840-core.h         |   22 +-
 drivers/media/video/cx25840/cx25840-firmware.c     |   10 +-
 drivers/media/video/cx88/Kconfig                   |    2 +
 drivers/media/video/cx88/cx88-cards.c              |   19 +-
 drivers/media/video/cx88/cx88-dvb.c                |   58 +-
 drivers/media/video/cx88/cx88-input.c              |   47 +-
 drivers/media/video/cx88/cx88-video.c              |    2 +-
 drivers/media/video/cx88/cx88.h                    |    1 +
 drivers/media/video/davinci/dm355_ccdc.c           |    4 +-
 drivers/media/video/davinci/dm644x_ccdc.c          |    4 +-
 drivers/media/video/davinci/vpfe_capture.c         |   47 +-
 drivers/media/video/em28xx/em28xx-audio.c          |    4 +-
 drivers/media/video/em28xx/em28xx-cards.c          |   50 +-
 drivers/media/video/em28xx/em28xx-core.c           |   22 +-
 drivers/media/video/em28xx/em28xx-dvb.c            |   24 +-
 drivers/media/video/em28xx/em28xx-input.c          |   27 +-
 drivers/media/video/em28xx/em28xx-reg.h            |    1 +
 drivers/media/video/em28xx/em28xx-video.c          |    8 +-
 drivers/media/video/em28xx/em28xx.h                |    7 +-
 drivers/media/video/gspca/Kconfig                  |   23 +-
 drivers/media/video/gspca/Makefile                 |    4 +
 drivers/media/video/gspca/conex.c                  |   12 +-
 drivers/media/video/gspca/etoms.c                  |   10 +-
 drivers/media/video/gspca/finepix.c                |   23 +-
 drivers/media/video/gspca/gl860/gl860-mi1320.c     |   55 +-
 drivers/media/video/gspca/gl860/gl860-mi2020.c     |   69 +-
 drivers/media/video/gspca/gl860/gl860-ov2640.c     |  140 +-
 drivers/media/video/gspca/gl860/gl860-ov9655.c     |   43 +-
 drivers/media/video/gspca/gl860/gl860.c            |   61 +-
 drivers/media/video/gspca/gl860/gl860.h            |    7 +-
 drivers/media/video/gspca/gspca.c                  |  137 +-
 drivers/media/video/gspca/gspca.h                  |   15 +-
 drivers/media/video/gspca/jeilinj.c                |   34 +-
 drivers/media/video/gspca/m5602/m5602_core.c       |   25 +-
 drivers/media/video/gspca/mars.c                   |   11 +-
 drivers/media/video/gspca/mr97310a.c               |  602 ++-
 drivers/media/video/gspca/ov519.c                  | 1495 +++++-
 drivers/media/video/gspca/ov534.c                  | 1537 ++++++-
 drivers/media/video/gspca/pac207.c                 |   13 +-
 drivers/media/video/gspca/pac7302.c                | 1272 +++++
 drivers/media/video/gspca/pac7311.c                |  716 +--
 drivers/media/video/gspca/pac_common.h             |   91 +-
 drivers/media/video/gspca/sn9c20x.c                |   11 +-
 drivers/media/video/gspca/sonixb.c                 |   21 +-
 drivers/media/video/gspca/sonixj.c                 |  660 ++--
 drivers/media/video/gspca/spca500.c                |   11 +-
 drivers/media/video/gspca/spca501.c                |   14 +-
 drivers/media/video/gspca/spca505.c                |   10 +-
 drivers/media/video/gspca/spca506.c                |   12 +-
 drivers/media/video/gspca/spca508.c                |   10 +-
 drivers/media/video/gspca/spca561.c                |   14 +-
 drivers/media/video/gspca/sq905.c                  |   75 +-
 drivers/media/video/gspca/sq905c.c                 |   31 +-
 drivers/media/video/gspca/stk014.c                 |   11 +-
 drivers/media/video/gspca/stv0680.c                |  364 ++
 drivers/media/video/gspca/stv06xx/stv06xx.c        |   11 +-
 drivers/media/video/gspca/sunplus.c                |   11 +-
 drivers/media/video/gspca/t613.c                   |    7 +-
 drivers/media/video/gspca/tv8532.c                 |    7 +-
 drivers/media/video/gspca/vc032x.c                 |   23 +-
 drivers/media/video/gspca/w996Xcf.c                |  609 +++
 drivers/media/video/gspca/zc3xx.c                  | 1470 ++----
 drivers/media/video/hdpvr/hdpvr-video.c            |    8 +-
 drivers/media/video/hexium_gemini.c                |    2 +-
 drivers/media/video/hexium_orion.c                 |    2 +-
 drivers/media/video/ir-kbd-i2c.c                   |   19 +-
 drivers/media/video/ivtv/ivtv-cards.c              |   16 +-
 drivers/media/video/ivtv/ivtv-cards.h              |   51 +-
 drivers/media/video/ivtv/ivtv-driver.c             |   27 +-
 drivers/media/video/ivtv/ivtv-driver.h             |    6 +
 drivers/media/video/ivtv/ivtv-i2c.c                |  153 +-
 drivers/media/video/ivtv/ivtv-i2c.h                |    1 +
 drivers/media/video/mxb.c                          |    2 +-
 drivers/media/video/ov9640.c                       |  801 ++++
 drivers/media/video/ov9640.h                       |  209 +
 drivers/media/video/pms.c                          | 1425 +++---
 drivers/media/video/pvrusb2/pvrusb2-debugifc.c     |   17 +-
 drivers/media/video/pvrusb2/pvrusb2-devattr.c      |   13 +-
 drivers/media/video/pvrusb2/pvrusb2-devattr.h      |    1 +
 drivers/media/video/pvrusb2/pvrusb2-encoder.c      |    5 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    1 +
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |   63 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.h          |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c     |    1 +
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |   15 +-
 drivers/media/video/pwc/pwc-if.c                   |   23 +-
 drivers/media/video/rj54n1cb0c.c                   | 1219 +++++
 drivers/media/video/s2255drv.c                     |    2 +-
 drivers/media/video/saa7110.c                      |    2 +-
 drivers/media/video/saa7134/saa7134-cards.c        |   55 +
 drivers/media/video/saa7134/saa7134-core.c         |    6 +-
 drivers/media/video/saa7134/saa7134-dvb.c          |   66 +-
 drivers/media/video/saa7134/saa7134-input.c        |   55 +-
 drivers/media/video/saa7134/saa7134-video.c        |    2 +-
 drivers/media/video/saa7134/saa7134.h              |    3 +-
 drivers/media/video/saa7164/saa7164-core.c         |    4 +-
 drivers/media/video/saa7164/saa7164-dvb.c          |    1 +
 drivers/media/video/saa717x.c                      |    4 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |   83 +-
 drivers/media/video/tuner-core.c                   |   20 +-
 drivers/media/video/tvaudio.c                      |    2 +-
 drivers/media/video/tvp514x.c                      |    2 +-
 drivers/media/video/usbvideo/konicawc.c            |    2 +-
 drivers/media/video/usbvideo/quickcam_messenger.c  |    2 +-
 drivers/media/video/usbvision/usbvision-video.c    |    2 +-
 drivers/media/video/uvc/uvc_ctrl.c                 |   36 +-
 drivers/media/video/uvc/uvc_driver.c               |  428 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |   60 +-
 drivers/media/video/uvc/uvc_video.c                |   26 +-
 drivers/media/video/uvc/uvcvideo.h                 |   23 +-
 drivers/media/video/v4l2-common.c                  |    9 +
 drivers/media/video/videobuf-core.c                |   12 +-
 drivers/media/video/videobuf-dma-contig.c          |    2 +-
 drivers/media/video/videobuf-dma-sg.c              |    6 +-
 drivers/media/video/videobuf-dvb.c                 |   11 +-
 drivers/media/video/videobuf-vmalloc.c             |    4 +-
 drivers/media/video/vpx3220.c                      |    2 +-
 drivers/media/video/zoran/zoran_driver.c           |    2 +-
 drivers/media/video/zr364xx.c                      |    1 +
 drivers/staging/go7007/Makefile                    |    4 +-
 drivers/staging/go7007/go7007-driver.c             |   30 +-
 drivers/staging/go7007/go7007-priv.h               |    8 +
 drivers/staging/go7007/go7007-usb.c                |    6 +-
 drivers/staging/go7007/go7007-v4l2.c               |  109 +-
 drivers/staging/go7007/s2250-board.c               |  558 ++--
 drivers/staging/go7007/s2250-loader.c              |   12 +-
 include/linux/videodev2.h                          |    7 +-
 include/media/cx25840.h                            |    1 +
 include/media/davinci/vpfe_capture.h               |    2 +
 include/media/ir-common.h                          |   43 +-
 include/media/v4l2-chip-ident.h                    |   23 +
 include/media/v4l2-subdev.h                        |  103 +-
 include/media/videobuf-core.h                      |    4 +-
 include/media/videobuf-dma-contig.h                |    2 +-
 include/media/videobuf-dma-sg.h                    |    2 +-
 include/media/videobuf-dvb.h                       |    4 +-
 include/media/videobuf-vmalloc.h                   |    4 +-
 294 files changed, 28000 insertions(+), 11201 deletions(-)
 rename Documentation/DocBook/dvb/{isdbt.xml => dvbproperty.xml} (99%)
 create mode 100644 Documentation/DocBook/dvb/frontend.h.xml
 create mode 100644 drivers/media/common/ir-keytable.c
 create mode 100644 drivers/media/common/tuners/max2165.c
 create mode 100644 drivers/media/common/tuners/max2165.h
 create mode 100644 drivers/media/common/tuners/max2165_priv.h
 create mode 100644 drivers/media/dvb/dvb-usb/ec168.c
 create mode 100644 drivers/media/dvb/dvb-usb/ec168.h
 create mode 100644 drivers/media/dvb/firewire/firedtv-fw.c
 create mode 100644 drivers/media/dvb/frontends/atbm8830.c
 create mode 100644 drivers/media/dvb/frontends/atbm8830.h
 create mode 100644 drivers/media/dvb/frontends/atbm8830_priv.h
 create mode 100644 drivers/media/dvb/frontends/ds3000.c
 create mode 100644 drivers/media/dvb/frontends/ds3000.h
 create mode 100644 drivers/media/dvb/frontends/ec100.c
 create mode 100644 drivers/media/dvb/frontends/ec100.h
 create mode 100644 drivers/media/dvb/frontends/ec100_priv.h
 create mode 100644 drivers/media/dvb/frontends/stb6100_proc.h
 create mode 100644 drivers/media/radio/tef6862.c
 create mode 100644 drivers/media/video/cx23885/cx23885-f300.c
 create mode 100644 drivers/media/video/cx23885/cx23885-f300.h
 create mode 100644 drivers/media/video/cx23885/cx23885-input.c
 create mode 100644 drivers/media/video/cx23885/cx23885-input.h
 create mode 100644 drivers/media/video/cx23885/cx23885-ioctl.c
 create mode 100644 drivers/media/video/cx23885/cx23885-ioctl.h
 create mode 100644 drivers/media/video/cx23885/cx23885-ir.c
 create mode 100644 drivers/media/video/cx23885/cx23885-ir.h
 create mode 100644 drivers/media/video/cx23885/cx23888-ir.c
 create mode 100644 drivers/media/video/cx23885/cx23888-ir.h
 create mode 100644 drivers/media/video/gspca/pac7302.c
 create mode 100644 drivers/media/video/gspca/stv0680.c
 create mode 100644 drivers/media/video/gspca/w996Xcf.c
 create mode 100644 drivers/media/video/ov9640.c
 create mode 100644 drivers/media/video/ov9640.h
 create mode 100644 drivers/media/video/rj54n1cb0c.c

Abylay Ospan (3):
      V4L/DVB (13271): TS speed check. Logging transport stream speed in Kbits per second
      V4L/DVB (13334): stv6110: add configurable gain
      V4L/DVB (13335): stv0900: fix diseqc support for NetUP card

Akihiro Tsukada (2):
      V4L/DVB (13293): dvb-usb-friio: return the correct DTV_DELIVERY_SYSTEM
      V4L/DVB (13294): dvb-usb-friio: cleaning up unnecessary functions

Aleksandr V. Piskunov (2):
      V4L/DVB (13232): cx25840 6.5MHz carrier detection fixes
      V4L/DVB (13441): ivtv: Added FM radio support to Avermedia AVerTV MCE 116 Plus card

Alexander Strakh (2):
      V4L/DVB (13378): konicawc.c: possible buffer overflow while use strncat
      V4L/DVB (13379): quickcam_messenger: possible buffer overflow while use strncat

Amauri Magagna (1):
      V4L/DVB (13197): gspca - sonixj: Adjust colors and autogain for sensor om6802.

Andreas Regel (10):
      V4L/DVB (13351): stv090x: increases search range based on symbol rate
      V4L/DVB (13352): stv090x: fixes errors and typos in register definitions
      V4L/DVB (13353): stv090x: fixes STR and SNR calculation and normalizes the value into the 0..0xFFFF range
      V4L/DVB (13354): stv090x: fixes some typos like wrong register or variable names
      V4L/DVB (13355): stv090x: fixes calculation of AGC2 and uses a different AGC2 threshold for cut 3 chips
      V4L/DVB (13356): stv090x: fixes signal lock logic
      V4L/DVB (13357): stv090x: adds an additional check for signal presence based on AGC1
      V4L/DVB (13358): stv090x: add an additional check for packet delineator lock in stv090x_read_status in case of a tuned DVB-S2 signal
      V4L/DVB (13359): stv090x: adds corrections of some register values
      V4L/DVB (13360): stv090x: fix the calculation of the r divider in stv6110x_set_frequency

Andy Shevchenko (1):
      V4L/DVB (13231): pwc: Use kernel's simple_strtol()

Andy Walls (29):
      V4L/DVB (13084): v4l2-chip-ident: Add ID's needed for the cx23885 and cx25840 modules
      V4L/DVB (13085): cx23885: Fix support for v4l2-dbg access to CX2388[578] and CX23417 regs
      V4L/DVB (13086): cx23885: Add skeleton v4l2_subdev for the CX23888 integrated IR controller
      V4L/DVB (13087): cx25840: Improve detection of CX2388[578] A/V cores
      V4L/DVB (13088): cx25840: Convert chip/core family checks to static inline functions
      V4L/DVB (13089): cx25840: Separate set_audclk_freq functionality for the different chips
      V4L/DVB (13090): cx25840: Init PLLs properly for CX2388[578] A/V cores
      V4L/DVB (13091): cx23885: Enable HVR-1850 CX23888 A/V core to get VID_CLK running for IR
      V4L/DVB (13096): v4l2-subdev: Add v4l2_subdev_ir_ops and IR notify defines for v4l2_device
      V4L/DVB (13097): cx23885: Complete CX23888 IR subdev implementation for Rx & almost for Tx
      V4L/DVB (13098): cx23885: Add integrated IR subdevice interrupt and notification handling
      V4L/DVB (13099): ir-functions: Export ir_rc5_decode() for use by the cx23885 module
      V4L/DVB (13100): cx23885: Add IR input keypress handling and enable for the HVR-1850
      V4L/DVB (13253): cx23885: CodingStyle fix
      V4L/DVB (13426): cx18: Rename struct cx18_mdl to struct cx18_mdl_ent
      V4L/DVB (13427): cx18: Rename struct cx18_queue.buffers to struct cx18_queue.depth
      V4L/DVB (13428): cx18: Rename mdl_offset to mdl_base_idx or free_mdl_idx as appropriate
      V4L/DVB (13429): cx18: Add Memory Descriptor List (MDL) layer to buffer handling
      V4L/DVB (13430): cx18: Fix YUV capture so that encoder passes a single frame per transfer
      V4L/DVB (13431): cx18: Adjust an MDL's final buffer size to force encoder transfer size
      V4L/DVB (13432): cx18: Adjust encoder VBI MDL size to be exactly frame's worth of VBI data
      V4L/DVB (13433): cx18: Remove duplicate list traversal when processing incoming MDLs
      V4L/DVB (13434): cx18: Bump version number due to significant buffer handling changes.
      V4L/DVB (13440): ivtv: Update the cards definitions to add another AVerMedia M113 variant
      V4L/DVB (13442): ivtv: Add module parameter to adjust I2C SCL clock period per board
      V4L/DVB (13443): ivtv: Defer legacy I2C IR probing until after setup of known I2C devices
      V4L/DVB (13444): ivtv: Add explicit IR controller initialization for the AVerTV M116
      V4L/DVB (13445): cx18: Use per cx18 instance init data for ir-kbd-i2c instead of const data
      V4L/DVB (13446): ivtv: Add more explicit detection of known IR devices for Hauppauge cards

Antoine Jacquet (1):
      V4L/DVB (13438): zr364xx: add support for Trust Powerc@m 910Z

Antti Palosaari (7):
      V4L/DVB (13054): af9015: add USB ID for KWorld PlusTV DVB-T PCI Pro Card (DVB-T PC160-T)
      V4L/DVB (13055): af9015: fix few typos
      V4L/DVB (13056): af9015: add LeadTek Y04G0051 remote buttons
      V4L/DVB (13057): af9015: add MSI DIGIVOX mini III remote
      V4L/DVB (13058): af9015: enable remote polling when eeprom contains 0x04
      V4L/DVB (13363): ec100: add new driver for E3C EC100 DVB-T demodulator
      V4L/DVB (13364): ec168: add new driver for E3C EC168 DVB USB

Aurelien Jacobs (1):
      V4L/DVB (13243): gscpa_mr97310a: Add Trust Spyc@m 100 USB ID

Beholder Intl. Ltd. Dmitry Belimov (2):
      V4L/DVB (13075): xc5000: add FM radio support
      V4L/DVB (13080): saa7134: add support for the digital side of the Behold X7

Danny Wood (1):
      V4L/DVB (13168): Add support for Asus Europa Hybrid DVB-T card (SAA7134 SubVendor ID: 0x1043 Device ID: 0x4847)

David Ellingsworth (14):
      V4L/DVB (13060): radio-mr800: implement proper locking
      V4L/DVB (13061): radio-mr800: simplify video_device allocation
      V4L/DVB (13062): radio-mr800: simplify error paths in usb probe callback
      V4L/DVB (13063): radio-mr800: remove unnecessary local variable
      V4L/DVB (13064): radio-mr800: simplify access to amradio_device
      V4L/DVB (13065): radio-mr800: simplify locking in ioctl callbacks
      V4L/DVB (13066): radio-mr800: remove device removed indicator
      V4L/DVB (13067): radio-mr800: fix potential use after free
      V4L/DVB (13068): radio-mr800: remove device initialization from open/close
      V4L/DVB (13069): radio-mr800: ensure the radio is initialized to a consistent state
      V4L/DVB (13070): radio-mr800: fix behavior of set_stereo function
      V4L/DVB (13071): radio-mr800: preserve radio state during suspend/resume
      V4L/DVB (13072): radio-mr800: simplify device warnings
      V4L/DVB (13073): radio-mr800: set radio frequency only upon success

David T. L. Wong (1):
      V4L/DVB (13375): cx23885: Add support for Mygica X8558Pro DMB-TH

David T.L. Wong (9):
      V4L/DVB (13206): cx25840: add component support
      V4L/DVB (13207): cx23885: add component input type
      V4L/DVB (13208): cx23885: fix uninitialized member bug
      V4L/DVB (13209): cx23885: card mygica x8506 add analog video input support
      V4L/DVB (13210): cx23885: card Mygica X8506 better GPIO setup
      V4L/DVB (13211): cx23885: card Mygica X8506 analog TV support
      V4L/DVB (13212): fix gcc-4.3.3 compilation error at dib7000p_pid_filter(): missing parameter name
      V4L/DVB (13373): Maxium MAX2165 silicon tuner
      V4L/DVB (13374): AltoBeam ATBM8830 GB20600-2006(DMB-TH) demodulator

David Wong (2):
      V4L/DVB (13376): cx-usb: add Mygica D689 DMB-TH USB support
      V4L/DVB (13541): atbm8830: replace 64-bit division and floating point usage

Devin Heitmueller (10):
      V4L/DVB (13076): xc5000: make the definition of the FM input part of the xc5000 config struct
      V4L/DVB (13077): em28xx: Add support for new variant of KWorld 2800d
      V4L/DVB (13081): saa7134: use the #define for the xc5000 radio_input field
      V4L/DVB (13082): em28xx: remove "not validated" status from Terratec Cinergy T XS (005e)
      V4L/DVB (13187): au8522: add support for saturation and hue controls
      V4L/DVB (13188): xc5000: return an error on tuning attempts if firmware not loaded
      V4L/DVB (13329): s5h1409: provide HVR-1600 specific optimizations
      V4L/DVB (13330): s5h1409: properly handle QAM optimization after lock achieved
      V4L/DVB (13331): mxl5005s: provide ability to override QAM gain for HVR-1600
      V4L/DVB (13332): s5h1409: remove a set register that would cause lock to be lost.

Filipe Rosset (2):
      V4L/DVB (13289): em28xx-audio: Convert printks to em28xx_err
      V4L/DVB (13290): em28xx-dvb: Convert printks to em28xx_err and em28xx_info

Gary Francis (1):
      V4L/DVB (13500): pvrusb2: Fix lingering 16KB FX2 Firmware issues

Guennadi Liakhovetski (1):
      V4L/DVB (13130): soc-camera: add a new driver for the RJ54N1CB0C camera sensor from Sharp

Hans Verkuil (12):
      V4L/DVB (13460): v4l2-spec: add missing V4L2-PIX-FMT-STV0680 description.
      V4L/DVB (13476): spec: remove old dvb-spec and v4l2-spec directories
      V4L/DVB (13477): v4l2-subdev: remove unnecessary check
      V4L/DVB (13478): cx18: remove bogus init call.
      V4L/DVB (13479): cxusb: fix compile warning
      V4L/DVB (13480): atbm8830: fix compile warning
      V4L/DVB (13508): pms: source code cleanup, use struct v4l2_device.
      V4L/DVB (13509): pms: convert from V4L1 to V4L2.
      V4L/DVB (13518): spec: regenerate videodev2.h.xml
      V4L/DVB (13521): dib8000: fix compile warning
      V4L/DVB (13522): valj5jf8007s/t: fix compile warnings
      V4L/DVB (13523): dvb-bt8xx: fix compile warning

Hans de Goede (17):
      V4L/DVB (13138): gspca_sq905: cleanup sq905_dostream
      V4L/DVB (13140): gspca_jeilinj: once one frame is discarded it keeps discarding all frames
      V4L/DVB (13141): gspca_sq905c: once one frame is discarded it keeps discarding all frames
      V4L/DVB (13142): gspca_mr97310a: small tweak to CIF sensor type 1 exposure setting
      V4L/DVB (13143): gspca_ov519 cleanup sensor detection
      V4L/DVB (13144): gspca_ov519: Add support for OV2610 and OV3610 sensors
      V4L/DVB (13145): gscpa_ov519: add support for the ovfx2 bridge
      V4L/DVB (13146): gspca_ov519: cleanup sensor handling
      V4L/DVB (13178): gspca: Add support for Winbond W9967CF and W9968CF camera's
      V4L/DVB (13179): gspca_ov519: cache sensor regs to avoid unnecessary slow i2c reads / writes
      V4L/DVB (13180): gspca-w9968cf: Don't add an extra packet to the buffer after the EOF
      V4L/DVB (13181): gspca w9968cf: Add support for JPEG compression
      V4L/DVB (13182): gspca w9968cf: slight tweak to vstart and hstart
      V4L/DVB (13183): gspca: add stv0680 subdriver
      V4L/DVB (13184): gspca: Don't forget to resubmit URB's in case of an error
      V4L/DVB (13185): gspca: Don't resubmit error status URB's when suspending
      V4L/DVB (13242): gspca_mr97310a: Add minimum clock divider control

Henk Vergonet (1):
      V4L/DVB (13108): tda8290: enable deemphasis_50 module parameter

Huang Weiyi (1):
      V4L/DVB: pt1: remove duplicated #include

Ignacio de Miguel Diaz (1):
      V4L/DVB (13368): af9015: support for Sveon STV20 Tuner USB DVB-T HDTV

Igor M. Liplianin (11):
      V4L/DVB (13045): Fix debug messaging for stv0900 demod.
      V4L/DVB (13134): Add support for TBS-likes remotes
      V4L/DVB (13135): Add support for TeVii remotes
      V4L/DVB (13336): stv0900: config definition for single/dual mode
      V4L/DVB (13337): Change str snr scale for stv0900/903 and Netup Dual DVB-S2 card.
      V4L/DVB (13338): stv0900: big rework to support cut 3.0.
      V4L/DVB (13339): stv0900: big rework to support cut 3.0.
      V4L/DVB (13340): stv0900: big rework to support cut 3.0.
      V4L/DVB (13341): stv0900: big rework to support cut 3.0.
      V4L/DVB (13407): Add Prof 7301 PCI DVB-S2 card
      V4L/DVB (13493): TeVii S470 and TBS 6920 fixes

Jean Delvare (4):
      V4L/DVB (13233): i2c_board_info can be local
      V4L/DVB (13234): IR device at I2C address 0x7a
      V4L/DVB (13235): saa7134: Complete the IR address list
      V4L/DVB (13236): ir-kbd-i2c: Don't reject unknown I2C addresses

Jean-Francois Moine (34):
      V4L/DVB (13114): gspca - zc3xx.c: Bad init sequences of sensor cs2102.
      V4L/DVB (13115): gspca - main: More information messages.
      V4L/DVB (13193): gspca - zc3xx.c: Change init sequences of sensor tas5130c.
      V4L/DVB (13198): gspca - ov519: Bad frame pointer in ovfx2 packet scan.
      V4L/DVB (13249): gspca - pac7311: Webcam 093a:2628 added.
      V4L/DVB (13250): gspca - zc3xx: Add some delays and warn on i2c errors.
      V4L/DVB (13251): gspca - sonixj: Cleanup code and change some comments.
      V4L/DVB (13301): gspca - sonixj: Simplify the sensor init exchanges.
      V4L/DVB (13302): gspca - sonixj: Fix some bad values of sensor om6802.
      V4L/DVB (13303): gspca - sonixj: Change sensor and om6802 exchanges.
      V4L/DVB (13304): gspca - sonixj: Don't access the sensor when setting the bridge.
      V4L/DVB (13305): gspca - sonixj: The V flip control does not exist for all sensors.
      V4L/DVB (13306): gspca - sonixj: Change the copyright.
      V4L/DVB (13323): gspca - zc3xx: Adjust the exchanges of sensors mi0360soc and pb0330.
      V4L/DVB (13384): gspca - sonixj: Optimize code and add some comments.
      V4L/DVB (13386): gspca - main: Change version to 2.8.0.
      V4L/DVB (13387): gspca - main: Fix a compilation warning.
      V4L/DVB (13420): gspca - doc: Change the name of some webcams.
      V4L/DVB (13421): gspca - main: Clearer message when bandwidth too small.
      V4L/DVB (13422): gspca - ov534: ov772x changes from Richard Kaswy.
      V4L/DVB (13423): gspca - ov534: More ov772x changes from Max Thrun.
      V4L/DVB (13424): gspca - ov534: Fix ov772x brightness and ov965x frame rate.
      V4L/DVB (13425): gspca - ov534: Bad name of the ov965x 320x240 resolution.
      V4L/DVB (13448): gspca - main: Add a gspca flag for inactive controls.
      V4L/DVB (13449): gspca - ov534: The AWB control works only when autogain is set.
      V4L/DVB (13450): gspca - main: Clear the urb status before resubmit.
      V4L/DVB (13451): gspca - main: Memorize the current frame buffer.
      V4L/DVB (13452): gspca - main: Let the driver scan URB packets when no frame buffer.
      V4L/DVB (13453): gspca - all subdrivers: Remove the unused frame ptr from pkt_scan().
      V4L/DVB (13487): gspca - ov534: Add svga, xga and sxga modes for ov965x.
      V4L/DVB (13488): gspca - ov534: Remove extra values at end of ov965x sequences.
      V4L/DVB (13489): gspca - sonixj: Add the sensor po1030.
      V4L/DVB (13490): gspca - ov534: Add controls for sensor ov965x.
      V4L/DVB (13491): gspca - vc032x: Avoid crash on querymenu.

Johann Friedrichs (1):
      V4L/DVB (13239): saa7146: fix memory leakage in pagetable-handling

Jonathan Corbet (2):
      V4L/DVB (13377): make struct videobuf_queue_ops constant
      V4L/DVB (13417): Fix videobuf_queue_vmalloc_init() prototype

Julia Lawall (3):
      V4L/DVB (13166): remove duplicate structure field initialization
      V4L/DVB (13396): correct initialization of audio_mode
      V4L/DVB (13413): introduce missing kfree

Kuninori Morimoto (2):
      V4L/DVB (13127): sh_mobile_ceu: add soft reset function
      V4L/DVB (13128): sh_mobile_ceu_camera: add VBP error support

Laurent Pinchart (15):
      V4L/DVB (13148): uvcvideo: Handle V4L2_CTRL_TYPE_BUTTON control type in VIDIOC_QUERYCTRL
      V4L/DVB (13149): uvcvideo: Add a new UVC_TRACE_VIDEO trace level
      V4L/DVB (13150): uvcvideo: Don't acquire privileges in VIDIOC_TRY_FMT
      V4L/DVB (13151): uvcvideo: Dismiss privileges when freeing video buffers
      V4L/DVB (13152): uvcvideo: Rely on videodev to reference-count the device
      V4L/DVB (13154): uvcvideo: Handle garbage at the end of streaming interface descriptors
      V4L/DVB (13155): uvcvideo: Add a module parameter to set the streaming control timeout
      V4L/DVB (13238): v4l2_subdev: rename tuner s_standby operation to core s_power
      V4L/DVB (13308): uvcvideo: Add support for MSI StarCam 370i webcams
      V4L/DVB (13310): uvcvideo: Return -EINVAL instead of -ENODEV in read()
      V4L/DVB (13502): uvcvideo: Add support for Genius eFace 2025 webcams
      V4L/DVB (13503): uvcvideo: Merge iterms, oterms and units linked lists
      V4L/DVB (13504): uvcvideo: Fix extension units parsing
      V4L/DVB (13505): uvcvideo: Refactor chain scan
      V4L/DVB (13506): uvcvideo: Factorize common field in uvc_entity structure

Manu Abraham (1):
      V4L/DVB (13361): stv090x: fix TS corruption with High Symbol Rate streams

Marek Vasut (1):
      V4L/DVB (13040): V4L2: Add a v4l2-subdev (soc-camera) driver for OmniVision OV9640 sensor

Marton Nemeth (13):
      V4L/DVB (13117): gspca - pac7311: remove magic value for SKIP.
      V4L/DVB (13118): gspca - pac7311: remove magic values for END_OF_SEQUENCE and LOAD_PAGE.
      V4L/DVB (13119): gspca - pac7311: remove magic value for USB_BUF_SZ
      V4L/DVB (13120): gspca - pac7311: remove redundant register page switching
      V4L/DVB (13121): gspca - pac7311: add comment about JPEG header
      V4L/DVB (13192): gspca - pac_common: redesign function for finding Start Of Frame
      V4L/DVB (13298): gspca - pac207/pac7311/mr97310a: Simplify pac_find_sof.
      V4L/DVB (13299): gspca - pac7311: Extract pac_start_frame.
      V4L/DVB (13300): gspca - pac7302/pac7311: Separate the two subdrivers.
      V4L/DVB (13324): gspca - pac7302/pac7311: Handle return value of usb_control_msg().
      V4L/DVB (13325): gspca - pac7302/pac7311: Fix buffer overrun.
      V4L/DVB (13388): gspca - pac7302: Add white balance control.
      V4L/DVB (13389): gspca - pac7302: Handle return values in sd_start().

Mauro Carvalho Chehab (28):
      V4L/DVB (13042): Add NEC protocol to firmware v1.2 handler
      V4L/DVB (13043): Add support for Pixelview SBTVD IR
      V4L/DVB (13044): dib0700: Be less verbose when an IR key is pressed
      V4L/DVB (13157): dvb_frontend: represent all DVBS2API commands via macro
      V4L/DVB (13159): DocBook/frontend: use cross references for ioctls
      V4L/DVB (13160): DocBook/Makefile: add linux/dvb/frontend.h header file
      V4L/DVB (13161): Add missing specs for FE_SET_FRONTEND_TUNE_MODE ioctl.
      V4L/DVB (13162): Docbook/dvb: add missing specs for FE_DISHNETWORK_SEND_LEGACY_CMD ioctl
      V4L/DVB (13163): Docbook/dvb: Rename isdbt.xml to dvbproperty.xml
      V4L/DVB (13164): DocBook/dvb: Starts documenting DVBS2API ioctls
      V4L/DVB (13271a): Fix a badly solved merge conflict
      V4L/DVB (13327): em28xx: fix alt modprobe parameter
      V4L/DVB (13328): em28xx: Add chip ID for em2800
      em28xx: em2800 chips support max width of 640
      em28xx: don't load audio modules when AC97 is mis-detected
      em28xx: don't reduce scale to half size for em2800
      V4L/DVB (13528): em28xx: add support for em2800 VC211A card
      V4L/DVB (13531): ir-common: rename the debug routine to allow exporting it
      V4L/DVB (13532): ir-common: Add infrastructure to use a dynamic keycode table
      V4L/DVB (13533): ir: use dynamic tables, instead of static ones
      V4L/DVB (13534): ir-common: Remove some unused fields/structs
      V4L/DVB (13535): ir-common: Add a hauppauge new table with the complete RC5 code
      V4L/DVB (13536): em28xx: Use the full RC5 code on HVR-950 Remote Controller
      V4L/DVB (13537): ir: Prepare the code for dynamic keycode table allocation
      V4L/DVB (13538): ir-common: Use a dynamic keycode table
      V4L/DVB (13539): ir-common: add __func__ for debug messages
      V4L/DVB (13540): ir-common: Cleanup get key evdev code
      V4L/DVB (13542): ir-keytable: Allow dynamic table change

Michael Krufky (22):
      V4L/DVB (13103): create a standard method for dvb adapter drivers to override frontend ioctls
      V4L/DVB (13104): cx23885: define a dvb frontend ioctl override function
      V4L/DVB (13105): dvb-usb: add fe_ioctl_override callback to dvb_usb_adapter_properties
      V4L/DVB (13110): tda18271: use temporary variables in tda18271_rf_tracking_filters_init
      V4L/DVB (13111): tda18271: more signedness fixes
      V4L/DVB (13112): tda18271: display some state information in debug output
      V4L/DVB (13201): saa7164: disable tda18271 slave tuner output on slave in standby mode
      V4L/DVB (13204): saa7134: add support for the Leadtek DTV1000S
      V4L/DVB (13214): tda18271: allow for i2c buses that cant send 16 bytes at once
      V4L/DVB (13215): tda18271: add support for the set_config method
      V4L/DVB (13216): tda18271: initialize tuner during set_config if rf_cal_on_startup is set
      V4L/DVB (13217): tda18271: handle rf_cal_on_startup properly during attach
      V4L/DVB (13218): tda18271: consolidate common code for calibration on startup determination
      V4L/DVB (13219): tda18271: remove unneeded braces in switch..case block
      V4L/DVB (13220): tda18271: increment module version minor
      V4L/DVB (13247): tuner-core: dont force every tuner to set frequency at startup
      V4L/DVB (13259): saa7134: fix badly merged DTV1000S patch
      V4L/DVB (13262): tda18271: fix regression preventing std map override from taking effect
      V4L/DVB (13269): saa7134: codingstyle: use /* style comments */ instead of //
      V4L/DVB (13347): cx23885: add digital television support for Hauppauge WinTV-HVR1290
      V4L/DVB (13348): cx23885: update model matrix for models 85021 and 85721
      V4L/DVB (13349): cx23885: Enable IR input keypress handling for the Hauppauge WinTV HVR-1290

Michael Obst (1):
      V4L/DVB (13260): saa7134: add support for Leadtek Winfast DTV-1000S remote control

Mike Isely (12):
      V4L/DVB (13222): pvrusb2: Make more info available to udev
      V4L/DVB (13223): pvrusb2: Soften encoder warning message
      V4L/DVB (13224): pvrusb2: Improve diagnostic info on driver initialization failure
      V4L/DVB (13225): pvrusb2: Report hardware description to kernel log upon initialization
      V4L/DVB (13226): pvrusb2: Add hardware description to debuginfo output
      V4L/DVB (13227): pvrusb2: Fix redundant message on driver initialization failure (missing break)
      V4L/DVB (13228): pvrusb2: Cosmetic kernel log tweak
      V4L/DVB (13495): pvrusb2: Support 16KB FX2 firmware
      V4L/DVB (13496): pvrusb2: Support manual extraction of 16KB FX2 firmware
      V4L/DVB (13497): pvrusb2: Shorten device hardware description text to work around V4L shortcoming
      V4L/DVB (13498): pvrusb2: Bind I2C address 0x71 for Zilog IR devices
      V4L/DVB (13499): pvrusb2: Cosmetic tweak to minimize size_t exposure

Ming Lei (1):
      V4L/DVB (13153): uvcvideo: Fix uvc_alloc_urb_buffers()

MÃ¡rton NÃ©meth (5):
      V4L/DVB (13382): gspca - pac7302: Remove redundant stream off command.
      V4L/DVB (13383): gspca - pac7311/pac7302: Propagate error to higher level software.
      V4L/DVB (13385): gspca - pac7302: Add red and blue balance control.
      V4L/DVB (13418): gspca - pac7311: Stop sending URBs on first error.
      V4L/DVB (13419): gspca - pac7302: Add debug register write interface.

Márton Németh (3):
      V4L/DVB (13414): ttusb-dec: do not overwrite the first part of phys string
      V4L/DVB (13415): videobuf-core: explicitly cast page count
      V4L/DVB (13416): smssdio: initialize return value

Oliver Neukum (1):
      V4L/DVB (13402): radio-mr800 - autosuspend for radio-mr800 driver

Olivier Grenie (2):
      V4L/DVB (13049): dib8000: SNR in 10th of dB
      V4L/DVB (13051): DiB7000P: improve rebostness of HAS_LOCK indicator

Olivier Lorin (3):
      V4L/DVB (13194): gspca - gl860: improvement of the main driver part
      V4L/DVB (13195): gspca - gl860: comment changes and naming scheme egalization
      V4L/DVB (13196): gspca - gl860: add flip/mirror for OV2640

Pete Eberlein (4):
      V4L/DVB (13455): go7007: Add struct v4l2_device.
      V4L/DVB (13456): s2250: Change module structure
      V4L/DVB (13457): s2250: subdev conversion
      V4L/DVB (13458): go7007: subdev conversion

Peter Huewe (1):
      V4L/DVB (13288): adding __init/__exit macros to various drivers

Rafal Milecki (1):
      V4L/DVB (13116): gspca - ov519: Webcam 041e:4067 added.

Richard Röjfors (5):
      V4L/DVB (13173): adv7180: Support for getting input status
      V4L/DVB (13174): adv7180: Support for setting input status
      V4L/DVB (13175): adv7180: Use __devinit and __devexit macros
      V4L/DVB (13176): adv7180: Support checking standard via interrupts
      V4L/DVB (13177): radio: Add support for TEF6862 tuner

Roel Kluin (4):
      V4L/DVB (13241): Cleanup redundant tests on unsigned
      V4L/DVB (13285): vpfe_capture: keep index within bound in vpfe_cropcap()
      V4L/DVB (13380): sms-cards: make id unsigned in sms_get_board()
      V4L/DVB: Fix test in copy_reg_bits()

S?rgio Fortier (1):
      V4L/DVB (13052): DiB0700: EvolutePC TvWay+ USB ISDB-Tb fullseg device support

Sebastian Andrzej Siewior (1):
      V4L/DVB (13292): tvp514x: recognize the error case in tvp514x_read_reg()

Sergio C Fortier (1):
      V4L/DVB (13297): dib0700_devices: EvolutePC TvWay+ USB ISDB-Tb remote control support

Stefan Richter (7):
      V4L/DVB (13397): firedtv: move remote control workqueue handling into rc source file
      V4L/DVB (13398): firedtv: reform lock transaction backend call
      V4L/DVB (13399): firedtv: add missing include, rename a constant
      V4L/DVB (13400): firedtv: port to new firewire core
      V4L/DVB (13408): firedtv: shrink buffer pointer table
      V4L/DVB (13409): firedtv: packet requeuing is likely to succeed
      V4L/DVB (13410): firedtv: remove an unnecessary function argument

Steven Toth (1):
      V4L/DVB (13092): cx25840: Improvements to the cx23885/7/8 chip detection mechanism.

Theodore Kilgore (7):
      V4L/DVB (13137): gspca_mr97310a: Add controls for vga cams with sensor type 0
      V4L/DVB (13139): gspca_mr97310a: Improve VGA sensor type detection
      V4L/DVB (13244): gspca_mr97310a: Fix / update some comments
      V4L/DVB (13245): gspca_mr97310a: Change blue gain setting for Sakar Digital VGA camera
      V4L/DVB (13265): gspca_mr97310a: Partly back off red gain change for Sakar Digital VGA camera
      V4L/DVB (13266): gspca_mr97310a: Fix / update some comments
      V4L/DVB (13267): gspca_mr97310a: Change brightness for VGA type 1 cameras downward

Tuukka Toivonen (1):
      V4L/DVB (13165): videobuf do not force buffer size to be multiple of PAGE_SIZE

Uroš Vampl (1):
      V4L/DVB (13078): em28xx: fix support for Terratec Cinergy T XS (005e)

Vaibhav Hiremath (9):
      V4L/DVB (13463): Davinci VPFE Capture: Specify device pointer in videobuf_queue_dma_contig_init
      V4L/DVB (13464): Davinci VPFE Capture: add i2c adapter id in platform data
      V4L/DVB (13465): Davinci VPFE Capture: Take i2c adapter id through platform data
      V4L/DVB (13466): Davinci VPFE Capture:Replaced IRQ_VDINT1 with vpfe_dev->ccdc_irq1
      V4L/DVB (13467): V4L2: Added CID's V4L2_CID_ROTATE/BG_COLOR
      V4L/DVB (13468): v4l2 doc: Added ROTATE and BG_COLOR control documentation
      V4L/DVB (13469): Davinci VPFE Capture: Add support for Control ioctls
      V4L/DVB (13470): V4L2: Add Capability and Flag field for Chroma Key
      V4L/DVB (13471): v4l2 doc: Added FBUF_CAP_SRC_CHROMAKEY/FLAG_SRC_CHROMAKEY

hiranotaka@zng.jp (1):
      V4L/DVB (13394): pt1: Support FE_READ_SNR

Éric Piel (1):
      V4L/DVB (13295): sms1xxx: load smsdvb also for the hauppauge tiger cards

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
