Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbYGPSE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbYGPSE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 14:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYGPSEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 14:04:20 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:6792 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbYGPSET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 14:04:19 -0400
Date: Wed, 16 Jul 2008 20:04:11 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [GIT PULL] i2c updates for 2.6.27, round 2
Message-ID: <20080716200411.3aeb716c@hyperion.delvare>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the second round of i2c subsystem updates for Linux 2.6.27
from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

This contains almost exclusively driver conversion from the legacy
binding model to the new (standard) one.


 Documentation/i2c/chips/max6875        |    2 +-
 Documentation/i2c/chips/pca9539        |   10 ++-
 Documentation/i2c/chips/pcf8574        |   12 +-
 Documentation/i2c/chips/pcf8575        |    9 +-
 drivers/hwmon/ad7418.c                 |  109 ++++------------
 drivers/hwmon/adm1021.c                |  105 ++++++++-------
 drivers/hwmon/adm1025.c                |  101 +++++++-------
 drivers/hwmon/adm1026.c                |  109 ++++++---------
 drivers/hwmon/adm1029.c                |   97 ++++++--------
 drivers/hwmon/adm1031.c                |   96 +++++++-------
 drivers/hwmon/adm9240.c                |   93 +++++++-------
 drivers/hwmon/ads7828.c                |   89 ++++++-------
 drivers/hwmon/adt7470.c                |  100 +++++++-------
 drivers/hwmon/adt7473.c                |  102 +++++++--------
 drivers/hwmon/asb100.c                 |  207 ++++++++++++-----------------
 drivers/hwmon/atxp1.c                  |  109 +++++++--------
 drivers/hwmon/ds1621.c                 |   99 +++++++-------
 drivers/hwmon/f75375s.c                |   89 ++-----------
 drivers/hwmon/fscher.c                 |   93 ++++++-------
 drivers/hwmon/fschmd.c                 |  112 ++++++++--------
 drivers/hwmon/fscpos.c                 |   94 ++++++--------
 drivers/hwmon/gl518sm.c                |   99 +++++++-------
 drivers/hwmon/gl520sm.c                |   91 ++++++-------
 drivers/hwmon/lm63.c                   |   99 ++++++--------
 drivers/hwmon/lm77.c                   |  102 +++++++--------
 drivers/hwmon/lm80.c                   |   94 ++++++-------
 drivers/hwmon/lm83.c                   |  104 +++++++--------
 drivers/hwmon/lm87.c                   |   99 +++++++--------
 drivers/hwmon/lm90.c                   |  119 +++++++++--------
 drivers/hwmon/lm92.c                   |   98 ++++++--------
 drivers/hwmon/lm93.c                   |  126 +++++++++---------
 drivers/hwmon/max1619.c                |  101 ++++++--------
 drivers/hwmon/max6650.c                |  102 +++++++--------
 drivers/hwmon/smsc47m192.c             |  102 +++++++--------
 drivers/hwmon/thmc50.c                 |  107 ++++++++--------
 drivers/hwmon/w83791d.c                |  205 ++++++++++-------------------
 drivers/hwmon/w83792d.c                |  214 ++++++++++--------------------
 drivers/hwmon/w83793.c                 |  227 +++++++++++++-------------------
 drivers/hwmon/w83l785ts.c              |  117 +++++++++--------
 drivers/hwmon/w83l786ng.c              |   98 +++++++--------
 drivers/i2c/busses/i2c-amd756-s4882.c  |   27 ++--
 drivers/i2c/busses/i2c-nforce2-s4985.c |   31 ++---
 drivers/i2c/chips/eeprom.c             |   92 ++++++-------
 drivers/i2c/chips/max6875.c            |  120 +++++++----------
 drivers/i2c/chips/pca9539.c            |  109 +++++-----------
 drivers/i2c/chips/pcf8574.c            |  108 +++++++---------
 drivers/i2c/chips/pcf8575.c            |   96 ++++++--------
 drivers/i2c/chips/pcf8591.c            |   94 ++++++--------
 drivers/i2c/i2c-core.c                 |    4 +
 drivers/w1/masters/ds2482.c            |  104 ++++++---------
 50 files changed, 2129 insertions(+), 2797 deletions(-)

---------------

Jean Delvare (44):
      i2c: Clear i2c_adapter.dev on adapter removal
      i2c: Convert the eeprom driver to a new-style i2c driver
      i2c: Convert the pcf8591 driver to a new-style i2c driver
      i2c: Convert the pcf8574 driver to a new-style i2c driver
      i2c: Convert the pcf8575 driver to a new-style i2c driver
      i2c: Convert the pca9539 driver to a new-style i2c driver
      i2c: Convert the max6875 driver to a new-style i2c driver
      w1/ds2482: Convert to a new-style driver
      hwmon: (ad7418) Convert to a new-style i2c driver
      hwmon: (adm1021) Convert to a new-style i2c driver
      hwmon: (adm1025) Convert to a new-style i2c driver
      hwmon: (adm1026) Convert to a new-style i2c driver
      hwmon: (adm1029) Convert to a new-style i2c driver
      hwmon: (adm1031) Convert to a new-style i2c driver
      hwmon: (adm9240) Convert to a new-style i2c driver
      hwmon: (ads7828) Convert to a new-style i2c driver
      hwmon: (adt7470) Convert to a new-style i2c driver
      hwmon: (adt7473) Convert to a new-style i2c driver
      hwmon: (asb100) Convert to a new-style i2c driver
      hwmon: (atxp1) Convert to a new-style i2c driver
      hwmon: (ds1621) Convert to a new-style i2c driver
      hwmon: (f75375s) Drop legacy i2c driver
      hwmon: (fscher) Convert to a new-style i2c driver
      hwmon: (fschmd) Convert to a new-style i2c driver
      hwmon: (fscpos) Convert to a new-style i2c driver
      hwmon: (gl518sm) Convert to a new-style i2c driver
      hwmon: (gl520sm) Convert to a new-style i2c driver
      hwmon: (lm63) Convert to a new-style i2c driver
      hwmon: (lm77) Convert to a new-style i2c driver
      hwmon: (lm80) Convert to a new-style i2c driver
      hwmon: (lm83) Convert to a new-style i2c driver
      hwmon: (lm87) Convert to a new-style i2c driver
      hwmon: (lm90) Convert to a new-style i2c driver
      hwmon: (lm92) Convert to a new-style i2c driver
      hwmon: (lm93) Convert to a new-style i2c driver
      hwmon: (max1619) Convert to a new-style i2c driver
      hwmon: (max6650) Convert to a new-style i2c driver
      hwmon: (smsc47m192) Convert to a new-style i2c driver
      hwmon: (thmc50) Convert to a new-style i2c driver
      hwmon: (w83791d) Convert to a new-style i2c driver
      hwmon: (w83792d) Convert to a new-style i2c driver
      hwmon: (w83793) Convert to a new-style i2c driver
      hwmon: (w83l785ts) Convert to a new-style i2c driver
      hwmon: (w83l786ng) Convert to a new-style i2c driver



-- 
Jean Delvare
