Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbYKKLLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbYKKLLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 06:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbYKKLLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 06:11:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34645 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbYKKLLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 06:11:31 -0500
Date: Tue, 11 Nov 2008 09:11:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES for 2.6.28] V4L/DVB fixes
Message-ID: <20081111091141.04643597@pedra.chehab.org>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For the following driver fixes:
   - radio-si470x: add support for kworld usb radio;
   - ibmcam: Fix a regression caused by a482f327ff56bc3cf53176a7eb736cea47291a1d;
   - cafe_ccic.c: remove BKL;
   - saa7134: fix resource map sanity check conflict;
   - saa7110: Minor fixes;
   - ivtv: remove incorrect V4L1 & tvaudio dependency;
   - ivtv/ivtvfb: no longer experimental;
   - anysee: initialize anysee_usb_mutex statically;
   - cx88: VBI fix for cx88 cards;
   - cx88-dvb: Fix Oops in case i2c bus failed to register;
   - cx88-blackbird: a few bug fixes;
   - ivtv/cx18: fix test whether modules should be loaded or not;
   - cx18: Mark CX18_CPU_DE_RELEASE_MDL as a slow API call;
   - cx18: Use correct Mailbox IRQ Ack values and misc IRQ handling cleanup;
   - cx18: Move DVB buffer transfer handling from irq handler to work_queue;
   - cx18: Disable write retries for registers that always change;
   - af9013: fix bug in status reading;
   - af9015: fix compile warnings;
   - gspca: Fix a typo in one of gspca chips name.
   - gspca: Bad init sequence for sensor HV7131B in zc3xx.
   - gspca: Small changes for the sensor HV7131B in zc3xx.
   - dvb-usb: unplug oops from dvb_frontend_init;

   - Some driver Documentation updates;
   - avoid usb hid driver to handle a fm device (fm700);

A few Build and core documentation updates:
   - CinergyT2: fix Kconfig typo;
   - dtv5100: add dependency on zl10353;
   - gspca: proper indent help;
   - Add gspca driver and subdrivers to MAINTAINERS;
   - update feature-removal-schedule.txt after the removal of tuner-3036 
     and dpc7146;

And two trivial core fixes:
   - dvb core: i2c gate enable/disable fix;
   - v4l core: Add some missing compat32 ioctls;

Cheers,
Mauro.

---

 Documentation/feature-removal-schedule.txt |   24 -----
 Documentation/video4linux/README.cx88      |    4 +-
 Documentation/video4linux/si470x.txt       |  118 +++++++++++++++++++++++
 MAINTAINERS                                |   31 ++++++
 drivers/hid/hid-core.c                     |    1 +
 drivers/hid/hid-ids.h                      |    3 +
 drivers/media/dvb/dvb-core/dvb_frontend.c  |    2 +
 drivers/media/dvb/dvb-usb/Kconfig          |    3 +-
 drivers/media/dvb/dvb-usb/af9015.c         |   14 ++--
 drivers/media/dvb/dvb-usb/af9015.h         |    1 -
 drivers/media/dvb/dvb-usb/anysee.c         |    4 +-
 drivers/media/dvb/dvb-usb/dvb-usb-urb.c    |    6 +-
 drivers/media/dvb/frontends/af9013.c       |    6 +-
 drivers/media/radio/Kconfig                |   14 +++
 drivers/media/radio/radio-si470x.c         |   19 +---
 drivers/media/video/cafe_ccic.c            |    6 +-
 drivers/media/video/compat_ioctl32.c       |    3 +
 drivers/media/video/cx18/cx18-driver.c     |   17 +++-
 drivers/media/video/cx18/cx18-driver.h     |   20 +++--
 drivers/media/video/cx18/cx18-dvb.c        |   23 +++++
 drivers/media/video/cx18/cx18-dvb.h        |    1 +
 drivers/media/video/cx18/cx18-io.c         |   17 +++-
 drivers/media/video/cx18/cx18-io.h         |   17 ++++
 drivers/media/video/cx18/cx18-irq.c        |   96 +++++++++++--------
 drivers/media/video/cx18/cx18-irq.h        |    4 +-
 drivers/media/video/cx18/cx18-mailbox.c    |    6 +-
 drivers/media/video/cx18/cx18-queue.c      |   14 +--
 drivers/media/video/cx18/cx18-scb.h        |   40 ++++----
 drivers/media/video/cx88/cx88-blackbird.c  |   12 ++-
 drivers/media/video/cx88/cx88-dvb.c        |    5 +
 drivers/media/video/cx88/cx88-mpeg.c       |   28 +++---
 drivers/media/video/cx88/cx88-video.c      |   10 ++-
 drivers/media/video/cx88/cx88.h            |    1 +
 drivers/media/video/gspca/Kconfig          |  144 ++++++++++++++--------------
 drivers/media/video/gspca/zc3xx.c          |   12 ++-
 drivers/media/video/ivtv/Kconfig           |    5 +-
 drivers/media/video/ivtv/ivtv-driver.c     |   26 +++---
 drivers/media/video/saa7110.c              |    4 +-
 drivers/media/video/saa7134/saa7134-core.c |    3 +-
 drivers/media/video/usbvideo/ibmcam.c      |   12 +-
 40 files changed, 509 insertions(+), 267 deletions(-)
 create mode 100644 Documentation/video4linux/si470x.txt

Akinobu Mita (1):
      V4L/DVB (9494): anysee: initialize anysee_usb_mutex statically

Alexey Klimov (2):
      V4L/DVB (9337a): HID: Don't allow KWorld radio fm700 be handled by usb hid drivers
      V4L/DVB (9350): radio-si470x: add support for kworld usb radio

Andy Walls (5):
      V4L/DVB (9475): cx18: Disable write retries for registers that always change - part 1.
      V4L/DVB (9510): cx18: Fix write retries for registers that always change - part 2.
      V4L/DVB (9511): cx18: Mark CX18_CPU_DE_RELEASE_MDL as a slow API call
      V4L/DVB (9515): cx18: Use correct Mailbox IRQ Ack values and misc IRQ handling cleanup
      V4L/DVB (9516): cx18: Move DVB buffer transfer handling from irq handler to work_queue

Antoine Jacquet (1):
      V4L/DVB (9348): dtv5100: add dependency on zl10353

Antti Palosaari (1):
      V4L/DVB (9527): af9015: fix compile warnings

Daniel J Blueman (1):
      V4L/DVB (9492): unplug oops from dvb_frontend_init...

Darron Broad (1):
      V4L/DVB (9499): cx88-mpeg: final fix for analogue only compilation + de-alloc fix

Frederic CAND (3):
      V4L/DVB (9495): cx88-blackbird: bugfix: cx88-blackbird-poll-fix
      V4L/DVB (9496): cx88-blackbird: bugfix: cx88-blackbird-mpeg-users
      V4L/DVB (9493): kconfig patch

Gregor Jasny (1):
      V4L/DVB (9352): Add some missing compat32 ioctls

Hans Verkuil (3):
      V4L/DVB (9485): ivtv: remove incorrect V4L1 & tvaudio dependency
      V4L/DVB (9486): ivtv/ivtvfb: no longer experimental
      V4L/DVB (9506): ivtv/cx18: fix test whether modules should be loaded or not.

Jean Delvare (2):
      V4L/DVB (9337b): remove tuner-3036 and dpc7146 drivers from feature-removal-schedule.txt
      V4L/DVB (9372): Minor fixes to the saa7110 driver

Jean-Francois Moine (3):
      V4L/DVB (9367a): Add gspca driver and subdrivers to MAINTAINERS
      V4L/DVB (9556): gspca: Bad init sequence for sensor HV7131B in zc3xx.
      V4L/DVB (9557): gspca: Small changes for the sensor HV7131B in zc3xx.

Jonathan Corbet (1):
      V4L/DVB (9355): de-BKL cafe_ccic.c

Krzysztof Helt (1):
      V4L/DVB (9549): gspca: Fix a typo in one of gspca chips name.

Manu Abraham (1):
      V4L/DVB (9346): Optimization: Enable gate in a symmetric/disciplined way,

Matthias Schwarzott (1):
      V4L/DVB (9357): cx88-dvb: Fix Oops in case i2c bus failed to register

Mauro Carvalho Chehab (1):
      V4L/DVB (9351): ibmcam: Fix a regression caused by a482f327ff56bc3cf53176a7eb736cea47291a1d

Rafael Diniz (2):
      V4L/DVB (9368): VBI fix for cx88 cards
      V4L/DVB (9369): Documentation update for cx88

Suresh Siddha (1):
      V4L/DVB (9356): [PATCH] saa7134: fix resource map sanity check conflict

Thierry MERLE (1):
      V4L/DVB (9358): CinergyT2: fix Kconfig typo

Tobias Lorenz (1):
      V4L/DVB (9482): Documentation, especially regarding audio and informational links

roel kluin (1):
      V4L/DVB (9524): af9013: fix bug in status reading

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
