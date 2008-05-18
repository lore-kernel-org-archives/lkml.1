Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbYERUwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbYERUwc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 16:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbYERUwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 16:52:22 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:14048 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbYERUwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 16:52:21 -0400
Date: Sun, 18 May 2008 22:51:54 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [GIT PULL] i2c updates and fixes for 2.6.26
Message-ID: <20080518225154.1fa0681c@hyperion.delvare>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the i2c subsystem updates and fixes for Linux 2.6.26 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

(Note to other readers: please do NOT pull the whole kernel tree from
this location, my line wouldn't like it.)

You'll get the last pieces of the conversion of the device/driver
matching model of the i2c subsystem, blacklisting of 1 motherboard in
the i2c-nforce2 SMBus controller driver for safety reasons, and a few
random fixes.

Sorry for pushing this a bit late in the game, but I feel that if I
don't remove the old i2c device/driver matching mechanism now, more
drivers will start using it and it will be even mode work for me to
convert them all later.

 MAINTAINERS                                |    4 ++-
 arch/blackfin/mach-bf527/boards/ezkit.c    |    2 -
 arch/powerpc/platforms/pasemi/misc.c       |    7 +---
 drivers/i2c/busses/i2c-amd756.c            |    2 +-
 drivers/i2c/busses/i2c-nforce2.c           |   28 ++++++++++++++++---
 drivers/i2c/chips/max6875.c                |    3 --
 drivers/i2c/i2c-core.c                     |   22 +++------------
 drivers/media/video/cs5345.c               |    7 +++++
 drivers/media/video/cs53l32a.c             |   10 ++++++-
 drivers/media/video/cx18/cx18-i2c.c        |    9 +++---
 drivers/media/video/cx25840/cx25840-core.c |    7 +++++
 drivers/media/video/ivtv/ivtv-i2c.c        |   13 ++++-----
 drivers/media/video/m52790.c               |    9 +++++-
 drivers/media/video/msp3400-driver.c       |   17 ++++++++---
 drivers/media/video/saa7115.c              |   40 +++++++++++++++++++--------
 drivers/media/video/saa7127.c              |    9 +++++-
 drivers/media/video/saa717x.c              |    9 +++++-
 drivers/media/video/tuner-core.c           |   17 +++++++++++-
 drivers/media/video/upd64031a.c            |    6 ++++
 drivers/media/video/upd64083.c             |    6 ++++
 drivers/media/video/vp27smpx.c             |    9 +++++-
 drivers/media/video/wm8739.c               |    7 +++++
 drivers/media/video/wm8775.c               |    7 +++++
 include/linux/i2c.h                        |    7 +----
 include/linux/i2c/pcf857x.h                |    3 +-
 25 files changed, 180 insertions(+), 80 deletions(-)

---------------

Jean Delvare (8):
      i2c: New co-maintainer
      i2c-nforce2: Disable the second SMBus channel on the DFI Lanparty NF4 Expert
      i2c: Clean up Blackfin BF527 I2C device declarations
      i2c: Switch pasemi to the new device/driver matching scheme
      i2c: Convert remaining new-style drivers to use module aliasing
      i2c: Kill the old driver matching scheme
      i2c-amd756: Fix functionality flags
      i2c/max6875: Really prevent 24RF08 corruption

Thanks,
-- 
Jean Delvare
