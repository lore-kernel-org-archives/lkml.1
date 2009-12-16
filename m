Return-Path: <linux-kernel-owner+w=401wt.eu-S1761716AbZLPPEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716AbZLPPEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758608AbZLPPEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:04:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758383AbZLPPEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:04:07 -0500
Date: Wed, 16 Dec 2009 13:03:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: [GIT PULL for 2.6.33] V4L/DVB fixes
Message-ID: <20091216130325.041e70fc@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For the following 116 patches:
   - ir: improvements for selecting IR protocols based on the IR table, and start
	 preparing the existing IR code to be generic;
   - v4l2 core: cleanups at video device name reports;
   - v4l2 API: add ioctl's to properly work with HDTV formats;
   - v4l2-spec: Adds EBUSY error code for S_STD and QUERYSTD ioctls;
   - v4l2 API: Add a 10-bit monochrome and missing 8- and 10-bit Bayer fourcc codes;
   - v4l KABI: add a media-bus API for configuring v4l2 subdev pixel and frame formats;
   - videobuf_dma_contig: fixes for working with non-aligned offsets;
   - driver improvements/fixes/cleanups at radio drivers, gspca, smsusb,
     em28xx, dib0700, dib8000, dvb-usb-friio, genpix, cpia, pwc, cpia2,
     ov511, bttv, vpss, sh_mobile_ceu, vpfe, vpif, uvc, stv0900,
     tw9910, soc_camera, rj54n1cb0c, mt9t031, lnbp21, stv090x, lgs9gxx,
     sanio-ms, cx231xx, au8522, pms.
   - Add mediabus KABI to be used by drivers that support several different ways
     to configure their internal streaming buses;
   - New drivers:
	- dib0090 frontend driver for ISDB-T devices;
	- mt9t112 sensor.

Cheers,
Mauro.

---

 Documentation/DocBook/Makefile                     |   21 +-
 Documentation/DocBook/media-entities.tmpl          |   18 +
 Documentation/DocBook/media-indices.tmpl           |    4 +
 Documentation/DocBook/v4l/common.xml               |   35 +
 Documentation/DocBook/v4l/compat.xml               |   16 +-
 Documentation/DocBook/v4l/v4l2.xml                 |   26 +-
 Documentation/DocBook/v4l/videodev2.h.xml          |  116 ++-
 .../DocBook/v4l/vidioc-enum-dv-presets.xml         |  238 +++
 Documentation/DocBook/v4l/vidioc-enuminput.xml     |   36 +-
 Documentation/DocBook/v4l/vidioc-enumoutput.xml    |   36 +-
 Documentation/DocBook/v4l/vidioc-g-dv-preset.xml   |  111 ++
 Documentation/DocBook/v4l/vidioc-g-dv-timings.xml  |  224 +++
 Documentation/DocBook/v4l/vidioc-g-std.xml         |    6 +
 .../DocBook/v4l/vidioc-query-dv-preset.xml         |   85 ++
 Documentation/DocBook/v4l/vidioc-querystd.xml      |    6 +
 Documentation/video4linux/gspca.txt                |   34 +-
 Documentation/video4linux/sh_mobile_ceu_camera.txt |  157 ++
 Documentation/video4linux/v4l2-framework.txt       |   16 +-
 arch/sh/boards/mach-ap325rxa/setup.c               |   41 +-
 arch/sh/boards/mach-kfr2r09/setup.c                |   13 +-
 arch/sh/boards/mach-migor/setup.c                  |   32 +-
 drivers/media/IR/Kconfig                           |    9 +
 drivers/media/IR/Makefile                          |    5 +
 drivers/media/{common => IR}/ir-functions.c        |   20 +-
 drivers/media/{common => IR}/ir-keymaps.c          |  219 ++-
 drivers/media/{common => IR}/ir-keytable.c         |   90 +-
 drivers/media/Kconfig                              |    1 +
 drivers/media/Makefile                             |    2 +-
 drivers/media/common/Makefile                      |    2 -
 drivers/media/common/saa7146_fops.c                |   60 +-
 drivers/media/dvb/dm1105/dm1105.c                  |   14 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |    8 +-
 drivers/media/dvb/dvb-usb/dib0700.h                |   26 +-
 drivers/media/dvb/dvb-usb/dib0700_core.c           |  101 ++-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  725 +++++++---
 drivers/media/dvb/dvb-usb/dibusb-common.c          |   15 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    3 +
 drivers/media/dvb/dvb-usb/dw2102.c                 |  456 ++++--
 drivers/media/dvb/dvb-usb/friio-fe.c               |   10 +-
 drivers/media/dvb/dvb-usb/gp8psk-fe.c              |    4 +-
 drivers/media/dvb/frontends/Kconfig                |    9 +
 drivers/media/dvb/frontends/Makefile               |    1 +
 drivers/media/dvb/frontends/au8522_decoder.c       |    4 +-
 drivers/media/dvb/frontends/dib0070.c              |  674 +++++-----
 drivers/media/dvb/frontends/dib0070.h              |    4 +-
 drivers/media/dvb/frontends/dib0090.c              | 1522 ++++++++++++++++++++
 drivers/media/dvb/frontends/dib0090.h              |  108 ++
 drivers/media/dvb/frontends/dib8000.c              |  137 ++-
 drivers/media/dvb/frontends/dib8000.h              |   32 +-
 drivers/media/dvb/frontends/dibx000_common.c       |   15 +-
 drivers/media/dvb/frontends/dibx000_common.h       |   71 +-
 drivers/media/dvb/frontends/lgs8gxx.c              |    4 +-
 drivers/media/dvb/frontends/lnbp21.c               |   28 +-
 drivers/media/dvb/frontends/stv0900_core.c         |   13 +
 drivers/media/dvb/frontends/stv090x.c              |    7 +-
 drivers/media/dvb/frontends/stv090x.h              |    2 +
 drivers/media/dvb/siano/smsdvb.c                   |    4 +-
 drivers/media/dvb/siano/smssdio.c                  |    8 +-
 drivers/media/dvb/siano/smsusb.c                   |   18 +-
 drivers/media/dvb/ttpci/budget-ci.c                |   52 +-
 drivers/media/radio/Kconfig                        |    7 +-
 drivers/media/radio/radio-aimslab.c                |    4 +
 drivers/media/radio/radio-aztech.c                 |    4 +
 drivers/media/radio/radio-gemtek-pci.c             |    4 +
 drivers/media/radio/radio-maestro.c                |    4 +
 drivers/media/radio/radio-maxiradio.c              |    4 +
 drivers/media/radio/radio-mr800.c                  |    4 +
 drivers/media/radio/radio-rtrack2.c                |    4 +
 drivers/media/radio/radio-sf16fmi.c                |   82 +-
 drivers/media/radio/radio-sf16fmr2.c               |    4 +
 drivers/media/radio/radio-tea5764.c                |   12 +-
 drivers/media/radio/radio-terratec.c               |    4 +
 drivers/media/radio/radio-trust.c                  |    4 +
 drivers/media/radio/radio-typhoon.c                |    4 +
 drivers/media/radio/radio-zoltrix.c                |    4 +
 drivers/media/radio/si470x/radio-si470x-common.c   |   98 ++
 drivers/media/radio/si470x/radio-si470x-i2c.c      |  219 +++-
 drivers/media/radio/si470x/radio-si470x-usb.c      |   97 +--
 drivers/media/radio/si470x/radio-si470x.h          |    5 +-
 drivers/media/video/Kconfig                        |   10 +-
 drivers/media/video/Makefile                       |    3 +-
 drivers/media/video/arv.c                          |    5 +-
 drivers/media/video/au0828/au0828-video.c          |   36 +-
 drivers/media/video/au0828/au0828.h                |    1 -
 drivers/media/video/bt8xx/bttv-driver.c            |   41 +-
 drivers/media/video/bt8xx/bttv-i2c.c               |    4 +-
 drivers/media/video/bt8xx/bttv-input.c             |    9 +-
 drivers/media/video/c-qcam.c                       |    4 +-
 drivers/media/video/cafe_ccic.c                    |    1 -
 drivers/media/video/cpia.c                         |  221 ++--
 drivers/media/video/cpia2/cpia2_v4l.c              |   34 +-
 drivers/media/video/cx18/cx18-fileops.c            |    4 +-
 drivers/media/video/cx18/cx18-streams.c            |   20 +-
 drivers/media/video/cx231xx/cx231xx-cards.c        |   23 +-
 drivers/media/video/cx231xx/cx231xx-core.c         |   26 -
 drivers/media/video/cx231xx/cx231xx-input.c        |   10 +-
 drivers/media/video/cx231xx/cx231xx-video.c        |   58 +-
 drivers/media/video/cx231xx/cx231xx.h              |    2 -
 drivers/media/video/cx23885/cimax2.c               |  107 +-
 drivers/media/video/cx23885/cx23885-417.c          |   29 +-
 drivers/media/video/cx23885/cx23885-core.c         |   11 -
 drivers/media/video/cx23885/cx23885-input.c        |    9 +-
 drivers/media/video/cx23885/cx23885-video.c        |   57 +-
 drivers/media/video/cx23885/cx23885.h              |    3 -
 drivers/media/video/cx88/cx88-blackbird.c          |   26 +-
 drivers/media/video/cx88/cx88-input.c              |    9 +-
 drivers/media/video/cx88/cx88-mpeg.c               |   15 -
 drivers/media/video/cx88/cx88-video.c              |   68 +-
 drivers/media/video/cx88/cx88.h                    |    2 -
 drivers/media/video/davinci/vpfe_capture.c         |    6 +-
 drivers/media/video/davinci/vpif.c                 |    2 +-
 drivers/media/video/davinci/vpif_display.c         |    1 -
 drivers/media/video/davinci/vpss.c                 |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c          |    7 +-
 drivers/media/video/em28xx/em28xx-core.c           |   30 +-
 drivers/media/video/em28xx/em28xx-input.c          |   68 +-
 drivers/media/video/em28xx/em28xx-video.c          |   59 +-
 drivers/media/video/em28xx/em28xx.h                |    5 +-
 drivers/media/video/et61x251/et61x251_core.c       |   45 +-
 drivers/media/video/gspca/conex.c                  |    4 +-
 drivers/media/video/gspca/etoms.c                  |    4 +-
 drivers/media/video/gspca/gl860/gl860-mi1320.c     |    2 +-
 drivers/media/video/gspca/gl860/gl860-mi2020.c     |    2 +-
 drivers/media/video/gspca/gl860/gl860.c            |   14 +-
 drivers/media/video/gspca/gspca.c                  |   67 +-
 drivers/media/video/gspca/gspca.h                  |   10 +
 drivers/media/video/gspca/m5602/m5602_core.c       |    4 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.c     |    2 +-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c     |   10 +-
 drivers/media/video/gspca/mr97310a.c               |    2 +-
 drivers/media/video/gspca/ov519.c                  |   14 +-
 drivers/media/video/gspca/pac7302.c                |   25 +-
 drivers/media/video/gspca/pac7311.c                |    4 +-
 drivers/media/video/gspca/sn9c20x.c                |   12 +-
 drivers/media/video/gspca/sonixb.c                 |    4 +-
 drivers/media/video/gspca/spca506.c                |    4 +-
 drivers/media/video/gspca/stk014.c                 |  106 +-
 drivers/media/video/gspca/sunplus.c                |  237 ++--
 drivers/media/video/gspca/zc3xx.c                  |   36 +-
 drivers/media/video/hdpvr/hdpvr-core.c             |   16 +-
 drivers/media/video/hdpvr/hdpvr-video.c            |    2 +-
 drivers/media/video/ir-kbd-i2c.c                   |   12 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |    4 +-
 drivers/media/video/ivtv/ivtv-streams.c            |   19 +-
 drivers/media/video/meye.c                         |    1 -
 drivers/media/video/mt9m001.c                      |  205 ++-
 drivers/media/video/mt9m111.c                      |  189 ++-
 drivers/media/video/mt9t031.c                      |  281 ++--
 drivers/media/video/mt9t112.c                      | 1177 +++++++++++++++
 drivers/media/video/mt9v022.c                      |  228 ++--
 drivers/media/video/mx1_camera.c                   |  126 ++-
 drivers/media/video/mx3_camera.c                   |  296 +++--
 drivers/media/video/omap24xxcam.c                  |   10 +-
 drivers/media/video/ov511.c                        |    9 +-
 drivers/media/video/ov772x.c                       |  233 ++--
 drivers/media/video/ov9640.c                       |  107 +-
 drivers/media/video/pms.c                          |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |   21 +-
 drivers/media/video/pwc/pwc-if.c                   |    5 +-
 drivers/media/video/pxa_camera.c                   |  335 +++--
 drivers/media/video/rj54n1cb0c.c                   |  474 +++++--
 drivers/media/video/s2255drv.c                     |   55 +-
 drivers/media/video/saa5246a.c                     |    1 -
 drivers/media/video/saa7134/saa7134-cards.c        |   22 +
 drivers/media/video/saa7134/saa7134-core.c         |   19 +-
 drivers/media/video/saa7134/saa7134-empress.c      |   20 +-
 drivers/media/video/saa7134/saa7134-input.c        |   71 +-
 drivers/media/video/saa7134/saa7134-video.c        |   39 +-
 drivers/media/video/se401.c                        |    4 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |  520 ++++---
 drivers/media/video/sn9c102/sn9c102_core.c         |   47 +-
 drivers/media/video/soc_camera.c                   |  106 +-
 drivers/media/video/soc_camera_platform.c          |   40 +-
 drivers/media/video/soc_mediabus.c                 |  157 ++
 drivers/media/video/stk-webcam.c                   |    9 +-
 drivers/media/video/stradis.c                      |    4 +-
 drivers/media/video/stv680.c                       |    5 +-
 drivers/media/video/tw9910.c                       |  337 +++---
 drivers/media/video/usbvideo/usbvideo.c            |    4 +-
 drivers/media/video/usbvideo/vicam.c               |    5 +-
 drivers/media/video/usbvision/usbvision-i2c.c      |    4 +-
 drivers/media/video/usbvision/usbvision-video.c    |   34 +-
 drivers/media/video/uvc/uvc_driver.c               |    1 -
 drivers/media/video/uvc/uvc_video.c                |    2 +-
 drivers/media/video/v4l2-common.c                  |   47 +
 drivers/media/video/v4l2-compat-ioctl32.c          |    6 +
 drivers/media/video/v4l2-dev.c                     |   22 +-
 drivers/media/video/v4l2-ioctl.c                   |  147 ++
 drivers/media/video/videobuf-dma-contig.c          |    6 +-
 drivers/media/video/vino.c                         |    1 -
 drivers/media/video/vivi.c                         |   22 +-
 drivers/media/video/w9968cf.c                      |   34 +-
 drivers/media/video/zc0301/zc0301_core.c           |   44 +-
 drivers/media/video/zoran/zoran_driver.c           |    1 -
 drivers/media/video/zr364xx.c                      |    5 +-
 drivers/staging/cx25821/cx25821-audups11.c         |   33 +-
 drivers/staging/cx25821/cx25821-video.c            |    6 +-
 drivers/staging/cx25821/cx25821-video0.c           |   33 +-
 drivers/staging/cx25821/cx25821-video1.c           |   33 +-
 drivers/staging/cx25821/cx25821-video2.c           |   34 +-
 drivers/staging/cx25821/cx25821-video3.c           |   34 +-
 drivers/staging/cx25821/cx25821-video4.c           |   34 +-
 drivers/staging/cx25821/cx25821-video5.c           |   34 +-
 drivers/staging/cx25821/cx25821-video6.c           |   34 +-
 drivers/staging/cx25821/cx25821-video7.c           |   34 +-
 drivers/staging/cx25821/cx25821-videoioctl.c       |   32 +-
 drivers/staging/cx25821/cx25821-vidups10.c         |   33 +-
 drivers/staging/cx25821/cx25821-vidups9.c          |   33 +-
 drivers/staging/go7007/go7007-v4l2.c               |    5 +-
 include/linux/videodev2.h                          |  123 ++-
 include/media/ir-common.h                          |   39 +-
 include/media/ir-core.h                            |   62 +
 include/media/mt9t112.h                            |   30 +
 include/media/ov772x.h                             |    4 +-
 include/media/rj54n1cb0c.h                         |   19 +
 include/media/saa7146_vv.h                         |    4 -
 include/media/sh_mobile_ceu.h                      |    2 +
 include/media/soc_camera.h                         |   30 +-
 include/media/soc_camera_platform.h                |    3 +-
 include/media/soc_mediabus.h                       |   65 +
 include/media/tw9910.h                             |    1 -
 include/media/v4l2-chip-ident.h                    |    2 +
 include/media/v4l2-common.h                        |    2 +-
 include/media/v4l2-dev.h                           |   23 +-
 include/media/v4l2-ioctl.h                         |   15 +
 include/media/v4l2-mediabus.h                      |   61 +
 include/media/v4l2-subdev.h                        |   61 +-
 227 files changed, 10431 insertions(+), 4078 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/vidioc-enum-dv-presets.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-dv-preset.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-dv-timings.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-query-dv-preset.xml
 create mode 100644 Documentation/video4linux/sh_mobile_ceu_camera.txt
 create mode 100644 drivers/media/IR/Kconfig
 create mode 100644 drivers/media/IR/Makefile
 rename drivers/media/{common => IR}/ir-functions.c (92%)
 rename drivers/media/{common => IR}/ir-keymaps.c (97%)
 rename drivers/media/{common => IR}/ir-keytable.c (81%)
 create mode 100644 drivers/media/dvb/frontends/dib0090.c
 create mode 100644 drivers/media/dvb/frontends/dib0090.h
 create mode 100644 drivers/media/video/mt9t112.c
 create mode 100644 drivers/media/video/soc_mediabus.c
 create mode 100644 include/media/ir-core.h
 create mode 100644 include/media/mt9t112.h
 create mode 100644 include/media/rj54n1cb0c.h
 create mode 100644 include/media/soc_mediabus.h
 create mode 100644 include/media/v4l2-mediabus.h

Abylay Ospan (2):
      V4L/DVB (13630): Print bitrate measured by stv0900 demod in stv0900_read_status
      V4L/DVB (13676): configurable IRQ mode on NetUP Dual DVB-S2 CI; IRQ from CAM processing (CI interface works faster)

Akihiro Tsukada (1):
      V4L/DVB (13577): [PATCH] dvb-usb-friio: accept center-shifted frequency

Alexey Dobriyan (1):
      V4L/DVB (13590): cpia: convert it to use proc_fops

Andrea Odetti (1):
      V4L/DVB (13593): PWC: parameter trace is only available in debug

Antonio Ospite (1):
      V4L/DVB (13564): gspca - main: Implement vidioc_enum_frameintervals.

Ben Hutchings (2):
      V4L/DVB (13680a): DocBook/media: copy images after building HTML
      V4L/DVB (13680b): DocBook/media: create links for included sources

Dan Carpenter (1):
      V4L/DVB (13596): ov511.c typo: lock => unlock

David Howells (1):
      V4L/DVB: lgs8gxx: Use shifts rather than multiply/divide when possible

Derek (1):
      V4L/DVB (13578): [PATCH] fix genpix driver (no 8psk lock).

Duncan Gibb (1):
      V4L/DVB (13684): Fix some cut-and-paste noise in dib0090.h

Guennadi Liakhovetski (12):
      V4L/DVB (13643): soc-camera: remove no longer needed struct members
      V4L/DVB (13644): v4l: add new v4l2-subdev sensor operations, use g_skip_top_lines in soc-camera
      V4L/DVB (13645): soc-camera: fix multi-line comment coding style
      V4L/DVB (13646): sh_mobile_ceu_camera: do not mark host occupied, when adding a client fails
      V4L/DVB (13647): v4l: Add a 10-bit monochrome and missing 8- and 10-bit Bayer fourcc codes
      V4L/DVB (13648): soc-camera: add a private field to struct soc_camera_link
      V4L/DVB (13650): soc-camera: switch drivers and platforms to use .priv in struct soc_camera_link
      V4L/DVB (13651): sh_mobile_ceu_camera: document the scaling and cropping algorithm
      V4L/DVB (13658): v4l: add a media-bus API for configuring v4l2 subdev pixel and frame formats
      V4L/DVB (13659): soc-camera: convert to the new mediabus API
      V4L/DVB (13661): rj54n1cb0c: Add cropping, auto white balance, restrict sizes, add platform data
      V4L/DVB (13662): mt9t031: make the use of the soc-camera client API optional

Hans Verkuil (2):
      V4L/DVB (13547): radio: add trivial checks on the tuner and type args.
      V4L/DVB (13573): v4l2-spec: updated revision history, updated version to 2.6.33.

Huang Weiyi (1):
      V4L/DVB: Davinci VPFE Capture: remove unused #include <linux/version.h>

Igor M. Liplianin (1):
      V4L/DVB (13678): Add support for yet another DvbWorld, TeVii and Prof USB devices

Jarod Wilson (2):
      V4L/DVB (13597): bttv: add i2c addr for old WinTV card to IR probe list
      V4L/DVB (13602): bttv: fix MODULE_PARM_DESC for i2c_debug and i2c_hw

Jean-Francois Moine (9):
      V4L/DVB (13559): gspca - pac7302: Some webcams are upside-down by default.
      V4L/DVB (13560): gspca - main: Cleanup source.
      V4L/DVB (13562): gspca - doc: Update webcam list.
      V4L/DVB (13563): gspca - zc3xx: Bad sensor probe of the webcam 0ac8:305b.
      V4L/DVB (13565): gspca - pac7302: One more webcam is upside-down by default.
      V4L/DVB (13566): gspca - main: New variable usb_err for USB exchanges.
      V4L/DVB (13567): gspca - sunplus/stk014: Propagate errors to higher level.
      V4L/DVB (13626): gspca - many subdrivers: Fix some warnings.
      V4L/DVB (13627): gspca - zc3xx: Set the quality for sensor tas5130c.

Joonyoung Shim (3):
      V4L/DVB (13599): radio-si470x: move some file operations to common file
      V4L/DVB (13600): radio-si470x: support RDS on si470x i2c driver
      V4L/DVB (13601): radio-si470x: support PM functions

Julia Lawall (3):
      V4L/DVB (13610): uvc: Correct size given to memset
      V4L/DVB (13611): radio-tea5764: Correct size given to memset
      V4L/DVB (13685): Correct code taking the size of a pointer

Kuninori Morimoto (15):
      V4L/DVB (13642): tw9910: The driver can also handle revision 1 of the chip
      V4L/DVB (13652): tw9910: Add revision control
      V4L/DVB (13653): tw9910: simplify chip ID calculation
      V4L/DVB (13654): tw9910: Tri-state pins when idle
      V4L/DVB (13655): tw9910: Add power control
      V4L/DVB (13656): tw9910: tw9910_set_hsync clean up
      V4L/DVB (13657): tw9910: Add revision control to tw9910_set_hsync
      V4L/DVB (13663): sh_mobile_ceu: Add V4L2_FIELD_INTERLACED_BT/TB support
      V4L/DVB (13664): tw9910: use V4L2_FIELD_INTERLACED_BT
      V4L/DVB (13665): sh_mobile_ceu_camera: Add support for sync polarity selection
      V4L/DVB (13666): tw9910: modify V/H outpit pin setting to use VALID
      V4L/DVB (13667): tw9910: modify output format
      V4L/DVB (13668): tw9910: remove cropping
      V4L/DVB (13669): tw9910: Add sync polarity support
      V4L/DVB (13670): soc-camera: Add mt9t112 camera driver

Laurent Pinchart (9):
      V4L/DVB (13549): v4l: Add video_device_node_name function
      V4L/DVB (13550): v4l: Use the new video_device_node_name function
      V4L/DVB (13551): v4l: Remove video_device::num usage from device drivers
      V4L/DVB (13552): v4l: Replace video_is_unregistered with video_is_registered
      V4L/DVB (13553): v4l: Use the video_is_registered function in device drivers
      V4L/DVB (13554a): v4l: Use the video_drvdata function in drivers
      V4L/DVB (13555): v4l: Use video_device_node_name() instead of the minor number
      V4L/DVB (13556): v4l: Remove unneeded video_device::minor assignments
      V4L/DVB (13557): v4l: Remove unneeded video_device::minor usage in drivers

Lukas Karas (1):
      V4L/DVB (13591): add support for IR on FlyDVB Trio (saa7134)

Magnus Damm (1):
      V4L/DVB (13671): sh_mobile_ceu_camera: Remove frame size page alignment

Mauro Carvalho Chehab (13):
      V4L/DVB (13543): ir-common: Associate a table with a given protocol type
      V4L/DVB (13544): ir-keymaps: mark the new rc5 hauppauge with IR_TYPE_RC5
      V4L/DVB (13545): em28xx: properly select IR protocol based on the IR table
      V4L/DVB (13546): ir-keymaps: Add table for Terratec Cinergy XS FM
      V4L/DVB (13575): em28xx: Use the complete address/command RC5 code for WinTV USB2
      V4L/DVB (13576): ir-common: fix an oops caused by the usage of an initialized drvdata
      V4L/DVB (13612): IR: Move common IR code to drivers/media/IR
      V4L/DVB (13613): IR: create ir-core module
      V4L/DVB (13614): dib0090: Fix compilation when module is not selected
      V4L/DVB (13615): ir-core: create ir_input_register
      V4L/DVB (13616): IR: rename ir_input_free as ir_input_unregister
      V4L/DVB (13617): ir: move input_register_device() to happen inside ir_input_register()
      V4L/DVB (13698): pms: replace asm/uaccess.h to linux/uaccess.h

Michael Krufky (1):
      V4L/DVB (13569): smsusb: add autodetection support for five additional Hauppauge USB IDs

Muralidharan Karicheri (5):
      V4L/DVB (13571): v4l: Adding Digital Video Timings APIs
      V4L/DVB (13572): v4l2-spec: Digital Video Timings API documentation
      V4L/DVB (13598): videobuf_dma_contig_user_get() for non-aligned offsets
      V4L/DVB (13618): v4l2: Adding helper function to get dv preset description
      V4L/DVB (13619): v4l2-spec: Adds EBUSY error code for S_STD and QUERYSTD ioctls

MÃ¡rton NÃ©meth (2):
      V4L/DVB (13561): gspca - main: Remove unnecessary set to alternate 0.
      V4L/DVB (13621): gspca - some subdrivers: Make device_table[]s constant.

Márton Németh (5):
      V4L/DVB (13589): dib8000: merge two conditionals
      V4L/DVB (13682): dib8000: make some constant static
      V4L/DVB (13683): sanio-ms: clean up init, exit and id_table
      V4L/DVB (13687): cx231xx: use NULL when pointer is needed
      V4L/DVB (13688): au8522: modify the attributes of local filter coefficients

Oliver Endriss (2):
      V4L/DVB (13673): lnbp21: Implement 22 kHz tone control
      V4L/DVB (13674): stv090x: Add DiSEqC envelope mode

Olivier Grenie (5):
      V4L/DVB (13583): DiB8090: Add the DiB0090 tuner driver and STK8096GP-board
      V4L/DVB (13584): DiBXXX0: fix most of the Codingstyle violations from the previous patch
      V4L/DVB (13585): STK807xPVR: correct the enumeration
      V4L/DVB (13586): DiB0700: Add parameter to change the buffer size
      V4L/DVB (13587): DiB8000: enhance status lock

Ondrej Zary (2):
      V4L/DVB (13608): radio-sf16fmi: fix mute, add SF16-FMP to texts
      V4L/DVB (13609): radio-sf16fmi: add autoprobing

Patrick Boettcher (3):
      V4L/DVB (13580): Add support for PCTV 74e (Pinnacle) + fix USB vendor IDs
      V4L/DVB (13582): DiB0700: remove USB IDs of PCTV 74e from the driver
      V4L/DVB (13581): DiBUSB: fix I2c access when there is a read-access w/o write sequence

Pedro Andres Aranda Gutierrez (1):
      V4L/DVB (13579): PATCH: better support for INTUIX DVB stick boot

Randy Dunlap (1):
      V4L/DVB (13690): radio/si470x: #include <sched.h>

Thiago Farina (1):
      V4L/DVB (13594): cpia2: use __stringify macro.

Uwe Kleine-König (4):
      V4L/DVB (13604): vpss: move vpss_remove to .devexit
      V4L/DVB (13605): sh_mobile_ceu_camera: don't use __exit_p to wrap sh_mobile_ceu_remove
      V4L/DVB (13606): vpfe_capture: move vpfe_remove to .devexit
      V4L/DVB (13607): vpif: move vpif_remove to .devexit

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
