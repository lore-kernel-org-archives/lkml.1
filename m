Return-Path: <linux-kernel-owner+w=401wt.eu-S1763792AbXGQBeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763792AbXGQBeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 21:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbXGQBe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 21:34:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37538 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005AbXGQBe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 21:34:28 -0400
Date: Mon, 16 Jul 2007 18:34:13 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB updates
Message-Id: <1184622753.28584.2.camel@gaivota>
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

For the following:

   - Add experimental support for tea5761 tuner and AF9005 demodulator
   - Add instructions to retrieve opera firmware
   - Some improvements at dvb-pll and at tuner core
   - Usbvision conversion to use video_ioctl2
   - new board additions on existing drivers
   - Several cleanups, updates and fixes on existing drivers

Cheers,
Mauro.

---

 Documentation/dvb/bt8xx.txt                        |   32 +-
 Documentation/dvb/get_dvb_firmware                 |   63 +-
 Documentation/dvb/opera-firmware.txt               |   27 +
 Documentation/video4linux/CARDLIST.bttv            |    4 +-
 Documentation/video4linux/CARDLIST.cx88            |    1 +
 Documentation/video4linux/CARDLIST.saa7134         |    1 +
 Documentation/video4linux/CARDLIST.tuner           |    3 +-
 Documentation/video4linux/sn9c102.txt              |    3 +-
 Documentation/video4linux/zr364xx.txt              |    2 +-
 drivers/media/Kconfig                              |    4 +
 drivers/media/common/ir-functions.c                |   23 +-
 drivers/media/common/saa7146_core.c                |    8 +-
 drivers/media/common/saa7146_video.c               |    8 +-
 drivers/media/dvb/b2c2/Kconfig                     |    2 +-
 drivers/media/dvb/b2c2/Makefile                    |    2 +-
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c          |    4 +-
 drivers/media/dvb/bt8xx/Kconfig                    |    2 +-
 drivers/media/dvb/bt8xx/Makefile                   |    2 +-
 drivers/media/dvb/bt8xx/dst.c                      |    2 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c                |    5 +-
 drivers/media/dvb/cinergyT2/Makefile               |    2 +-
 drivers/media/dvb/cinergyT2/cinergyT2.c            |   19 +-
 drivers/media/dvb/dvb-core/dmxdev.c                |    2 +-
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c        |   12 +-
 drivers/media/dvb/dvb-core/dvb_demux.c             |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.h          |    2 +-
 drivers/media/dvb/dvb-core/dvb_net.c               |    5 +-
 drivers/media/dvb/dvb-core/dvbdev.c                |   10 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |   29 +-
 drivers/media/dvb/dvb-usb/Makefile                 |    8 +-
 drivers/media/dvb/dvb-usb/af9005-fe.c              | 1503 +++++++++
 drivers/media/dvb/dvb-usb/af9005-remote.c          |  157 +
 drivers/media/dvb/dvb-usb/af9005-script.h          |  203 ++
 drivers/media/dvb/dvb-usb/af9005.c                 | 1141 +++++++
 drivers/media/dvb/dvb-usb/af9005.h                 | 3496 ++++++++++++++++++++
 drivers/media/dvb/dvb-usb/cxusb.c                  |   18 +-
 drivers/media/dvb/dvb-usb/dibusb-common.c          |    2 +-
 drivers/media/dvb/dvb-usb/dibusb-mb.c              |   53 +-
 drivers/media/dvb/dvb-usb/dibusb.h                 |    1 +
 drivers/media/dvb/dvb-usb/digitv.c                 |   21 +-
 drivers/media/dvb/dvb-usb/digitv.h                 |    4 +
 drivers/media/dvb/dvb-usb/dvb-usb-i2c.c            |   79 -
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    6 +
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c         |    2 +-
 drivers/media/dvb/dvb-usb/dvb-usb.h                |   11 -
 drivers/media/dvb/dvb-usb/gl861.c                  |    7 +-
 drivers/media/dvb/dvb-usb/m920x.c                  |  127 +-
 drivers/media/dvb/dvb-usb/m920x.h                  |    5 +-
 drivers/media/dvb/dvb-usb/opera1.c                 |   25 +-
 drivers/media/dvb/dvb-usb/umt-010.c                |    8 +-
 drivers/media/dvb/frontends/Makefile               |    2 +-
 drivers/media/dvb/frontends/cx22702.c              |    1 -
 drivers/media/dvb/frontends/cx24123.c              |    2 +-
 drivers/media/dvb/frontends/dvb-pll.c              |  256 +-
 drivers/media/dvb/frontends/dvb-pll.h              |   73 +-
 drivers/media/dvb/frontends/nxt200x.c              |   23 +-
 drivers/media/dvb/frontends/nxt200x.h              |    3 -
 drivers/media/dvb/frontends/or51132.c              |    1 -
 drivers/media/dvb/frontends/or51211.c              |   31 +-
 drivers/media/dvb/frontends/stv0299.c              |    2 +-
 drivers/media/dvb/frontends/tda10023.c             |    2 +-
 drivers/media/dvb/pluto2/Makefile                  |    2 +-
 drivers/media/dvb/ttpci/Kconfig                    |    2 +-
 drivers/media/dvb/ttpci/Makefile                   |    2 +-
 drivers/media/dvb/ttpci/av7110.c                   |   13 +-
 drivers/media/dvb/ttpci/av7110.h                   |    1 +
 drivers/media/dvb/ttpci/av7110_av.c                |   20 +-
 drivers/media/dvb/ttpci/av7110_ca.c                |    4 +-
 drivers/media/dvb/ttpci/av7110_hw.c                |    8 +-
 drivers/media/dvb/ttpci/av7110_hw.h                |    2 +-
 drivers/media/dvb/ttpci/av7110_ir.c                |    2 +-
 drivers/media/dvb/ttpci/av7110_v4l.c               |    2 +-
 drivers/media/dvb/ttpci/budget-av.c                |   31 +-
 drivers/media/dvb/ttpci/budget-ci.c                |    2 +-
 drivers/media/dvb/ttusb-budget/Makefile            |    2 +-
 drivers/media/dvb/ttusb-dec/Makefile               |    2 +-
 drivers/media/radio/Kconfig                        |    4 +-
 drivers/media/radio/radio-aimslab.c                |    1 -
 drivers/media/radio/radio-aztech.c                 |    1 -
 drivers/media/radio/radio-gemtek-pci.c             |    1 -
 drivers/media/radio/radio-gemtek.c                 |    1 -
 drivers/media/radio/radio-rtrack2.c                |    1 -
 drivers/media/radio/radio-sf16fmi.c                |    1 -
 drivers/media/radio/radio-sf16fmr2.c               |    1 -
 drivers/media/radio/radio-terratec.c               |    1 -
 drivers/media/radio/radio-trust.c                  |    1 -
 drivers/media/radio/radio-typhoon.c                |    1 -
 drivers/media/video/Kconfig                        |    9 +
 drivers/media/video/Makefile                       |    6 +-
 drivers/media/video/adv7170.c                      |    8 +-
 drivers/media/video/adv7175.c                      |    8 +-
 drivers/media/video/bt819.c                        |    9 +-
 drivers/media/video/bt856.c                        |    8 +-
 drivers/media/video/bt8xx/bttv-cards.c             |  442 ++--
 drivers/media/video/bt8xx/bttv-driver.c            |   34 +-
 drivers/media/video/bt8xx/bttv-input.c             |    2 +-
 drivers/media/video/bt8xx/bttv.h                   |    2 +
 drivers/media/video/bt8xx/bttvp.h                  |    2 +-
 drivers/media/video/cpia2/cpia2_core.c             |    9 +-
 drivers/media/video/cpia2/cpia2_v4l.c              |    8 +-
 drivers/media/video/cx88/Kconfig                   |    2 +-
 drivers/media/video/cx88/cx88-blackbird.c          |   14 +-
 drivers/media/video/cx88/cx88-cards.c              |   24 +
 drivers/media/video/cx88/cx88-dvb.c                |  122 +-
 drivers/media/video/cx88/cx88-i2c.c                |   25 +-
 drivers/media/video/cx88/cx88-input.c              |   25 +-
 drivers/media/video/cx88/cx88-mpeg.c               |    2 +-
 drivers/media/video/cx88/cx88-vp3054-i2c.c         |   12 +-
 drivers/media/video/cx88/cx88-vp3054-i2c.h         |    7 +
 drivers/media/video/cx88/cx88.h                    |    6 +-
 drivers/media/video/et61x251/Kconfig               |    2 +-
 drivers/media/video/et61x251/et61x251.h            |   23 +-
 drivers/media/video/et61x251/et61x251_core.c       |  189 +-
 drivers/media/video/et61x251/et61x251_sensor.h     |    8 +-
 drivers/media/video/et61x251/et61x251_tas5130d1b.c |    2 +-
 drivers/media/video/ir-kbd-i2c.c                   |   53 +-
 drivers/media/video/ivtv/ivtv-driver.c             |   13 +-
 drivers/media/video/ivtv/ivtv-driver.h             |   19 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |    8 +-
 drivers/media/video/ivtv/ivtv-firmware.c           |    4 +-
 drivers/media/video/ivtv/ivtv-gpio.c               |    9 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |    4 +-
 drivers/media/video/ivtv/ivtv-irq.c                |   36 +-
 drivers/media/video/ivtv/ivtv-streams.c            |   35 +-
 drivers/media/video/ivtv/ivtv-vbi.c                |   31 +-
 drivers/media/video/msp3400-driver.c               |    6 +-
 drivers/media/video/mt20xx.c                       |   80 +-
 drivers/media/video/ov7670.c                       |    4 +-
 drivers/media/video/pwc/pwc-if.c                   |   12 +-
 drivers/media/video/pwc/pwc.h                      |    4 +-
 drivers/media/video/saa7111.c                      |    8 +-
 drivers/media/video/saa7114.c                      |   10 +-
 drivers/media/video/saa7134/Kconfig                |    2 +-
 drivers/media/video/saa7134/saa7134-alsa.c         |   16 +-
 drivers/media/video/saa7134/saa7134-cards.c        |   41 +-
 drivers/media/video/saa7134/saa7134-dvb.c          |  169 +-
 drivers/media/video/saa7134/saa7134-empress.c      |    8 +
 drivers/media/video/saa7134/saa7134-input.c        |   20 +-
 drivers/media/video/saa7134/saa7134-tvaudio.c      |   42 +-
 drivers/media/video/saa7134/saa7134.h              |    6 +-
 drivers/media/video/saa7185.c                      |    8 +-
 drivers/media/video/sn9c102/sn9c102.h              |    9 +-
 drivers/media/video/sn9c102/sn9c102_core.c         |  173 +-
 drivers/media/video/sn9c102/sn9c102_ov7630.c       |  214 ++-
 drivers/media/video/sn9c102/sn9c102_ov7660.c       |   88 +-
 drivers/media/video/stradis.c                      |    2 +-
 drivers/media/video/stv680.c                       |    7 +-
 drivers/media/video/tda8290.c                      |  129 +-
 drivers/media/video/tda9887.c                      |   57 +-
 drivers/media/video/tea5761.c                      |  243 ++
 drivers/media/video/tea5767.c                      |   16 +-
 drivers/media/video/tuner-core.c                   |   95 +-
 drivers/media/video/tuner-driver.h                 |  107 +
 drivers/media/video/tuner-simple.c                 |   27 +-
 drivers/media/video/tuner-types.c                  |   22 +-
 drivers/media/video/tveeprom.c                     |    8 +-
 drivers/media/video/tvp5150.c                      |    2 +-
 drivers/media/video/usbvideo/konicawc.c            |    2 +-
 drivers/media/video/usbvideo/quickcam_messenger.c  |    4 +-
 drivers/media/video/usbvideo/vicam.c               |  181 -
 drivers/media/video/usbvision/usbvision-cards.c    |    8 +-
 drivers/media/video/usbvision/usbvision-core.c     |   43 +-
 drivers/media/video/usbvision/usbvision-video.c    | 1561 +++++-----
 drivers/media/video/usbvision/usbvision.h          |   13 +-
 drivers/media/video/vino.c                         |    6 +-
 drivers/media/video/vivi.c                         |  178 +-
 drivers/media/video/zc0301/Kconfig                 |    2 +-
 drivers/media/video/zc0301/zc0301.h                |   21 +-
 drivers/media/video/zc0301/zc0301_core.c           |  147 +-
 drivers/media/video/zc0301/zc0301_pas202bcb.c      |    1 +
 drivers/media/video/zc0301/zc0301_pb0330.c         |    1 +
 drivers/media/video/zc0301/zc0301_sensor.h         |    2 +-
 drivers/media/video/zoran_driver.c                 |   63 -
 drivers/media/video/zr364xx.c                      |   18 +-
 include/media/saa7146.h                            |    6 +-
 include/media/tuner.h                              |   71 +-
 176 files changed, 9814 insertions(+), 3034 deletions(-)
 create mode 100644 Documentation/dvb/opera-firmware.txt
 create mode 100644 drivers/media/dvb/dvb-usb/af9005-fe.c
 create mode 100644 drivers/media/dvb/dvb-usb/af9005-remote.c
 create mode 100644 drivers/media/dvb/dvb-usb/af9005-script.h
 create mode 100644 drivers/media/dvb/dvb-usb/af9005.c
 create mode 100644 drivers/media/dvb/dvb-usb/af9005.h
 create mode 100644 drivers/media/video/tea5761.c
 create mode 100644 drivers/media/video/tuner-driver.h

Aapo Tahkola (6):
      V4L/DVB (5628): Add support for A-LINK DTU dvb-t adapter
      V4L/DVB (5692): M920x: attempt to fix hw pid filters on second endpoint
      V4L/DVB (5693): M920x: second endpoint also needs to be changed to alt setting
      V4L/DVB (5694): M920x: fix for Dposh devices
      V4L/DVB (5695): M920x: enable second adapter on LifeView TV Walker Twin
      V4L/DVB (5696): M920x: add missing error handling to prevent syslog spamming

Adrian Bunk (3):
      V4L/DVB (5740): Git-dvb: fix the tea5761 tuner support
      V4L/DVB (5813): TUNER_TEA5761 kconfig fixes
      V4L/DVB (5814): Unexport dvb_pll_configure

Akinobu Mita (1):
      V4L/DVB (5678): Zr364xx: fix return values

Antoine Jacquet (1):
      V4L/DVB (5792): Zr364xx: add support for Trust Powerc@m 970Z

Christoph Hellwig (1):
      V4L/DVB (5724): Saa7134-tvaudio: kthread conversion

Daniel Gimpelevich (1):
      V4L/DVB (5685): Cx88: add support for ADS Tech Instant Video PCI

David Warman (2):
      V4L/DVB (5641): change VideoNorm to NTSC for Belkin USB Videobus II
      V4L/DVB (5642): add comment that VO_MODE is also being set.

Dmitry Torokhov (4):
      V4L/DVB (5682): SAA7134 - switch to use msecs_to_jiffies()
      V4L/DVB (5683): V4L: cx88 - switch to using msecs_to_jiffies()
      V4L/DVB (5684): V4L: ir-kbd-i2c - switch to using msecs_to_jiffies()
      V4L/DVB (5698): Input: drivers/media - switch to using input_dev->dev.parent

Douglas Schilling Landgraf (2):
      V4L/DVB (5705): Removed unnecessary .hardware from video_device struct.
      V4L/DVB (5828): Kconfig: Added GemTek USB radio and removed experimental dependency.

Edgar Pisani (1):
      V4L/DVB (5787): Cx88: add remote control support for Leadtek Winfast DTV1000

Hans Verkuil (11):
      V4L/DVB (5671): Autodetect new PVR150 low profile cards.
      V4L/DVB (5674): Models 30012-30039 are for a low profile PVR250, not PVR150.
      V4L/DVB (5729): Remove support for 256 Kb firmware files.
      V4L/DVB (5733): Blackbird should accept only new cx2341x encoding firmwares
      V4L/DVB (5768): Ivtv: fix converity warning
      V4L/DVB (5769): Ivtv: fix broken VBI output support
      V4L/DVB (5770): Ivtv: fix return code of VIDIOC_G/S_FBUF when no FB is present
      V4L/DVB (5841): tveeprom: add support for Philips FQ1216LME MK3 tuner.
      V4L/DVB (5842): ivtv: Add locking to ensure stream setup is atomic.
      V4L/DVB (5843): ivtv: fix missing signal_pending check.
      V4L/DVB (5844): ivtv: add high volume debugging flag

James Le Cuirot (1):
      V4L/DVB (5821): Saa7134: add remote control support for LifeView FlyDVB-S LR300

Jan Frey (1):
      V4L/DVB (5786): Ir-kbd-i2c: add support for Hauppauge HVR1300 remote

Jean Delvare (1):
      V4L/DVB (5815): Cx88: i2c structure templates clean-up

Luca Olivetti (2):
      V4L/DVB (5625): Add support for the AF9005 demodulator from Afatech
      V4L/DVB (5626): Marked af9005 driver as experimental and fix dependencies

Luca Risolia (3):
      V4L/DVB (5765): SN9C1xx driver updates
      V4L/DVB (5766): ET61x251 driver updates
      V4L/DVB (5767): ZC0301 driver updates

Marco Gittler (2):
      V4L/DVB (5795): Fix: remove unused struct that could avoiding load the firmware
      V4L/DVB (5829): Firmware extract and loading for opera dvb-usb update

Matthew Garrett (1):
      V4L/DVB (5825): Alter the tuner type for the WinTV USB UK PAL model.

Matthias Kaehlcke (2):
      V4L/DVB (5809): Use mutex instead of semaphore in Philips webcam driver
      V4L/DVB (5811): Use mutex instead of semaphore in Virtual Video driver

Mauro Carvalho Chehab (13):
      V4L/DVB (5563a): Add experimental support for tea5761 tuner
      V4L/DVB (5681): Correct aliases for STD/L and STD/Lc
      V4L/DVB (5727): Remove VIVI_SCATTER
      V4L/DVB (5774a): Remove CONFIG_BIGPHYS_AREA from zoran_driver
      V4L/DVB (5750): Remove obsoleted support for PROC_FS on vicam.c
      V4L/DVB (5763): Fix tea5761 unselection
      V4L/DVB (5783): Fix excess of debug messages on cx88-mpeg
      V4L/DVB (5789): Fix 3dfx Voodoo entries on Cardlist
      V4L/DVB (5790): Fix error handling for stv680
      V4L/DVB (5791): Fix Kbuild for kbd-ir-i2c
      V4L/DVB (5819): Cleanup: reorder some includes
      V4L/DVB (5820): Cleanup on cinergyT2: Remove unneeded if(1)
      V4L/DVB (5840): fix dst and cx24123: tune() callback changed signess for delay

Michael Krufky (37):
      V4L/DVB (5632): Dvb-pll: pass dvb_frontend_parameters to generic set() function
      V4L/DVB (5633): Tuv1236d: move rf input switching code into dvb-pll
      V4L/DVB (5634): Saa7134-dvb: convert philips td1316 handling to use dvb-pll
      V4L/DVB (5635): Budget-av: convert philips sd1878 / tda8261 to use dvb-pll
      V4L/DVB (5648): Dvb/frontends: remove unnecessary #include's of "dvb-pll.h"
      V4L/DVB (5649): Umt-010: convert tua6034 handling to properly use dvb-pll
      V4L/DVB (5650): Umt-010: trivial whitespace cleanup
      V4L/DVB (5651): Dibusb-mb: convert pll handling to properly use dvb-pll
      V4L/DVB (5652): Dibusb-mb: use dvb_attach for dib3000mb_attach
      V4L/DVB (5637): Cx88: kill core->pll_desc and core->pll_addr
      V4L/DVB (5718): Mt20xx: whitespace cleanup
      V4L/DVB (5719): Tuner: Move device-specific private data out of tuner struct
      V4L/DVB (5734): Cx88: kill dev->fw_size
      V4L/DVB (5741): Tuner: add release callback
      V4L/DVB (5742): Tuner: define release callback for mt20xx, tda9887 and tda8290
      V4L/DVB (5743): Tuner: clean up kfree() after release
      V4L/DVB (5747): Tea5761: remove duplicated "#include <media/tuner.h>"
      V4L/DVB (5753): Tuner: create struct tuner_operations
      V4L/DVB (5754): Mt20xx: store tuning operations in tuner_operations structure
      V4L/DVB (5755): Tda8290: store tuning operations in tuner_operations structure
      V4L/DVB (5756): Tda9887: store tuning operations in tuner_operations structure
      V4L/DVB (5757): Tea5761: store tuning operations in tuner_operations structure
      V4L/DVB (5758): Tea5767: store tuning operations in tuner_operations structure
      V4L/DVB (5759): Tuner-simple: store tuning operations in tuner_operations struct
      V4L/DVB (5771): Get_dvb_firmware: update script for new location
      V4L/DVB (5772): Cx88: remove two unused pointers from struct cx8802_dev
      V4L/DVB (5778): Dvb-usb: kill unused tuner/i2c functions
      V4L/DVB (5779): Dibusb-mb: fix broken 'tuner_pass_ctrl' functionality
      V4L/DVB (5780): Dvb: Remove static dependencies on dvb-pll
      V4L/DVB (5784): Dibusb-mb: fix tuner autodetection regression
      V4L/DVB (5788): Cx88-input: convert nested if's to switch..case
      V4L/DVB (5793): Tuner: remove hardware-specific info from public header
      V4L/DVB (5798): Dvb-pll: add support for Philips fcv1236d
      V4L/DVB (5799): Or51211: remove hardcoded fcv1236d tuner programming
      V4L/DVB (5800): Tuner: correct description of Philips FCV1236D tuner
      V4L/DVB (5801): Tuner: update FCV1236D ranges to match the datasheet
      V4L/DVB (5803): Bttv: add support for DViCO FusionHDTV 2

Oliver Endriss (5):
      V4L/DVB (5669): Budget-av: Add support for EasyWatch DVB-S (0x1894:0x001b)
      V4L/DVB (5835): saa7146/dvb-ttpci: Fix signedness warnings (gcc 4.1.1, kernel 2.6.22)
      V4L/DVB (5836): dvb-ttpci: re-initialize aspect ratio and pan scan after arm crash
      V4L/DVB (5837): stv0299: Fix signedness warning (gcc 4.1.1, kernel 2.6.22)
      V4L/DVB (5838): dvb-core: Fix signedness warnings (gcc 4.1.1, kernel 2.6.22)

Rafael Bilski (1):
      V4L/DVB (5776): Hardware MPEG audio fix for SAA7134 based "KNC One TV-Station DVR" card

Rafał Bilski (1):
      V4L/DVB (5775): Alsa fix for SAA7134 based "KNC One TV-Station DVR" card

Robert P. J. Day (4):
      V4L/DVB (5704): Remove worthless references to obsolete MODULE_PARM macro.
      V4L/DVB (5739): Replace C code with calls to ARRAY_SIZE macro.
      V4L/DVB (5846): Clean up setting state and scheduling timeouts
      V4L/DVB (5847): Clean up schedule_timeout calls in cpia2 and ivtv code

Simon Arlott (1):
      V4L/DVB (5631): Dvb-core: Add level fixes to printk()s, plus spelling/grammer

Thierry MERLE (4):
      V4L/DVB (5643): Usbvision: make common video and radio ioctls
      V4L/DVB (5644): Usbvision: video_ioctl2 conversion
      V4L/DVB (5824): Usbvision: Hauppauge WinTV USB SECAM_L fix
      V4L/DVB (5826): Usbvision: video mux cleanup

Tony Wan (2):
      V4L/DVB (5646): V4l: saa7134: add support for 10moons TM300 card
      V4L/DVB (5647): Saa7134: enable ir-remote for 10moons TM300

Trent Piepho (10):
      V4L/DVB (5629): Cx88: VP3054 support can't be a module when cx88 is compiled in
      V4L/DVB (5636): Integrate all users of the fmd1216 tuner with dvb-pll
      V4L/DVB (5745): Dvb: use '+=' instead of '=' for EXTRA_CFLAGS
      V4L/DVB (5777): Dvb-pll digitv dvb-usb: Eliminate last user of dvb_pll_configure
      V4L/DVB (5805): Bttv: Fix problems with probing for non-existent tuners
      V4L/DVB (5806): Bttv: Be consistent in using symbolic names instead of constants
      V4L/DVB (5807): Bttv: Add support for DBG_[SG]_REGISTER ioctls
      V4L/DVB (5831): stradis: use ARRAY_SIZE
      V4L/DVB (5832): ir-common: optimize bit extract function
      V4L/DVB (5834): dvb-core: fix signedness warnings and const stripping

Uwe Bugla (1):
      V4L/DVB (5701): Documentation/dvb/bt8xx.txt update

Wade Berrier (1):
      V4L/DVB (5785): Revisited: 3dfx Voodoo TV 200 (US)

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

