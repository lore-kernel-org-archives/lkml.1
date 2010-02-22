Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab0BVSmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:42:16 -0500
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:33443 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754018Ab0BVSmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:42:12 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-15.arcor-online.net 42EE3356AA6
From: Stefan Achatz <erazor_de@users.sourceforge.net>
To: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3/3] Adding documentation to sysfs attributes of roccat kone driver
Date: Mon, 22 Feb 2010 19:42:04 +0100
User-Agent: KMail/1.9.9
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Pavel Machek <pavel@suse.cz>,
       Alessandro Guido <ag@alessandroguido.name>,
       Tomas Hanak <tomas.hanak@gmail.com>, Jason Noble <nobleja@polezero.com>,
       simon.windows@gmail.com, Sean Hildebrand <silverwraithii@gmail.com>,
       Sid Boyce <sboyce@blueyonder.co.uk>, Henning Glawe <glaweh@debian.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201002200911.53900.stefan_achatz@web.de> <20100222062916.GA2095@core.coreip.homeip.net> <alpine.LNX.2.00.1002221100130.30967@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1002221100130.30967@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002221942.04624.erazor_de@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch adds documentation to sysfs attributes introduced by
 roccat kone mouse driver. The attributes are used by userland
 software already released by me under
 http://sourceforge.net/projects/roccat/

Didn't know if sysfs-driver-hid-roccat-kone or sysfs-driver-usb-roccat-kone
is the right filename, since the sysfs files are in bus/usb path.

I refused to split the What-lines to keep lines under 80 chars.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-kone       |  108 ++++++++++++++++++++
 1 files changed, 108 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-kone

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone 
b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
new file mode 100644
index 0000000..0bf1589
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
@@ -0,0 +1,108 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/actual_dpi
+Date:		February 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	It is possible to switch the dpi setting of the mouse with the
+		press of a button.
+		When read, this file returns the raw number of the actual dpi
+		setting of the mouse. This number has to be further processed
+		to receive the real dpi value.
+
+		VALUE DPI
+		1     800
+		2     1200
+		3     1600
+		4     2000
+		5     2400
+		6     3200
+
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/actual_profile
+Date:		February 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the number of the actual profile.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface 
num>/firmware_version
+Date:		February 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the raw version number of the
+		firmware stored in the mouse. Using the integer value eases
+		further usage in other programs. To receive the real version
+		number the decimal point has to be shifted 2 positions to the
+		left. E.g. a returned value of 138 means 1.38
+		This file is readonly.
+	
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface 
num>/kone_driver_version
+Date:		February 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the driver version.
+		The format of the string is "v<major>.<minor>.<patchlevel>".
+		This filename is used by the userland tools to find the
+		sys-paths of installed kone-mice. Versions of this driver for
+		old kernels replace usbhid instead of generic-usb. The way to
+		scan for this file has been chosen to provide a consistent way
+		for all supported kernel versions.
+		The version number is used to determine the drivers abilities.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile[1-5]
+Date:		February 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile holds informations like button
+		mappings, sensitivity, the colors of the 5 leds and light
+		effects.
+		When read, these files return the respective profile. The
+		returned data is 975 bytes in size.
+		When written, this file lets one write the respective profile
+		data back to the mouse. The data has to be 975 bytes long. The
+		checksum and correct profile number will be set by the driver.
+		The mouse will reject invalid data.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/settings
+Date:		February 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the settings stored in the mouse.
+		The size of the data is 36 bytes and holds information like the
+		startup_profile, tcu state and calibration_data.
+		When written, this file lets write settings back to the mouse.
+		The data has to be 36 bytes long, the checksum will be
+		calculated by the driver. The mouse will reject invalid data.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/startup_profile
+Date:		February 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the number of the profile thats
+		active when the mouse is powered on.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/tcu
+Date:		February 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse has a "Tracking Control Unit" which lets the user
+		calibrate the laser power to the mousepad surface.
+		When read, this file returns the current state of the TCU,
+		where 0 means off and 1 means on.
+		Writing 0 in this file will switch the TCU off.
+		Writing 1 in this file will start the calibration which takes
+		around 6 seconds to complete and activates the TCU.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/weight
+Date:		February 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can be equipped with one of four supplied weights
+		ranging from 5 to 20 grams which are recognized by the mouse
+		and its value can be read out. When read, this file returns the
+		raw value returned by the mouse which eases further processing
+		in other software.
+		The values map to the weights as follows:
+
+		VALUE WEIGHT
+		0     none
+		1     5g
+		2     10g
+		3     15g
+		4     20g
+
+		This file is readonly.
-- 
1.6.6

