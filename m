Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbZKSJ24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbZKSJ24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 04:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757720AbZKSJ2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 04:28:54 -0500
Received: from smtp.nokia.com ([192.100.105.134]:16965 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbZKSJ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 04:28:48 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH v3 0/5] lis3: Feature updates
Date: Thu, 19 Nov 2009 11:27:17 +0200
Message-Id: <1258622842-23129-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 19 Nov 2009 09:27:27.0442 (UTC) FILETIME=[82861B20:01CA68FA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is made to top of 7 previously accepted lis3 related patches in
mm-tree:
- I2C bus support for lis3lv02d and variant accelerometer chips...
- Add the possibility to remap axes via platform data...
- Send input_sync after each measurement round...
- polled input device itself was not free'd....
- riginally the driver was only targeted to 12bits sensors...
- Most of the documentation and comments were written when the driver ..
- Lis3 accelerometer sensors have quite long power on delay ..

Tested with 2.6.32-RC7 which was patched with above 7 lis3 related patches.
Tested only with 8 bit lis3 device since I don't have possibility to test
other chips.

0001:
Implement selftest feature for HW diagnostic purposes. This feature can be used
to detect if the sensor is electrically or mechanically damaged.

0002:
Calibration functionality is removed from the driver. Chip is allready
calibrated by the manufacturer. SW calibration doesn't improve the situation.

0003:
Added possibility to set chip sampling rate. Position entry in sysfs
allows reading at sampling rate.

0004:
Scale output values to mg (1/1000 of earth gravity).
Behaviour of the joystick interface is not changed. All other interfaces
will have different scale after this patch. See further information from
patch itself.

0005:
Update documentation to cover changes which were made by these patches.


Samu Onkalo (5):
  lis3: Selftest support
  LIS3LV02D: Remove calibaration functionality
  lis3: Sysfs entry for setting chip measurement rate
  lis3: Scale output values to mg
  LIS3: Update documentation to match latest changes

 Documentation/hwmon/lis3lv02d |   31 ++++++--
 drivers/hwmon/lis3lv02d.c     |  180 ++++++++++++++++++++++++++++++++---------
 drivers/hwmon/lis3lv02d.h     |   25 +++++-
 include/linux/lis3lv02d.h     |    3 +
 4 files changed, 190 insertions(+), 49 deletions(-)

