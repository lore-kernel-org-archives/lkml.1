Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZLAIej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZLAIej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbZLAIeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:34:36 -0500
Received: from smtp.nokia.com ([192.100.122.230]:59116 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbZLAIef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:34:35 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH v4 5/5] LIS3: Update documentation to match latest changes
Date: Tue,  1 Dec 2009 10:33:42 +0200
Message-Id: <1259656422-7697-6-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1259656422-7697-5-git-send-email-samu.p.onkalo@nokia.com>
References: <1259656422-7697-1-git-send-email-samu.p.onkalo@nokia.com>
 <1259656422-7697-2-git-send-email-samu.p.onkalo@nokia.com>
 <1259656422-7697-3-git-send-email-samu.p.onkalo@nokia.com>
 <1259656422-7697-4-git-send-email-samu.p.onkalo@nokia.com>
 <1259656422-7697-5-git-send-email-samu.p.onkalo@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Dec 2009 08:33:52.0064 (UTC) FILETIME=[02F75C00:01CA7261]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 Documentation/hwmon/lis3lv02d |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/Documentation/hwmon/lis3lv02d b/Documentation/hwmon/lis3lv02d
index 21f0902..cd354e3 100644
--- a/Documentation/hwmon/lis3lv02d
+++ b/Documentation/hwmon/lis3lv02d
@@ -20,18 +20,35 @@ sporting the feature officially called "HP Mobile Data Protection System 3D" or
 models (full list can be found in drivers/hwmon/hp_accel.c) will have their
 axis automatically oriented on standard way (eg: you can directly play
 neverball). The accelerometer data is readable via
-/sys/devices/platform/lis3lv02d.
+/sys/devices/platform/lis3lv02d. Reported values are scaled
+to mg values (1/1000th of earth gravity).
 
 Sysfs attributes under /sys/devices/platform/lis3lv02d/:
 position - 3D position that the accelerometer reports. Format: "(x,y,z)"
-calibrate - read: values (x, y, z) that are used as the base for input
-		  class device operation.
-            write: forces the base to be recalibrated with the current
-		   position.
-rate - reports the sampling rate of the accelerometer device in HZ
+rate - read reports the sampling rate of the accelerometer device in HZ.
+	write changes sampling rate of the accelerometer device.
+	Only values which are supported by HW are accepted.
+selftest - performs selftest for the chip as specified by chip manufacturer.
 
 This driver also provides an absolute input class device, allowing
-the laptop to act as a pinball machine-esque joystick.
+the laptop to act as a pinball machine-esque joystick. Joystick device can be
+calibrated. Joystick device can be in two different modes.
+By default output values are scaled between -32768 .. 32767. In joystick raw
+mode, joystick and sysfs position entry have the same scale. There can be
+small difference due to input system fuzziness feature.
+Events are also available as input event device.
+
+Selftest is meant only for hardware diagnostic purposes. It is not meant to be
+used during normal operations. Position data is not corrupted during selftest
+but interrupt behaviour is not quaranteed to work reliably. In test mode, the
+sensing element is internally moved little bit. Selftest measures difference
+between normal mode and test mode. Chip specifications tell the acceptance
+limit for each type of the chip. Limits are provided via platform data
+to allow adjustment of the limits without a change to the actual driver.
+Seltest returns either "OK x y z" or "FAIL x y z" where x, y and z are
+measured difference between modes. Axes are not remapped in selftest mode.
+Measurement values are provided to help HW diagnostic applications to make
+final decision.
 
 On HP laptops, if the led infrastructure is activated, support for a led
 indicating disk protection will be provided as /sys/class/leds/hp::hddprotect.
-- 
1.6.0.4

