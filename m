Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab0BXLFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 06:05:54 -0500
Received: from ist.d-labs.de ([213.239.218.44]:49540 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637Ab0BXLFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 06:05:52 -0500
From: florian@mickler.org
To: "Marcel Holtmann" <marcel@holtmann.org>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Florian Mickler <florian@mickler.org>
Subject: [PATCH v2 1/2] Document the rfkill sysfs ABI
Date: Wed, 24 Feb 2010 12:05:16 +0100
Message-Id: <1267009517-5017-2-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1266704345.32739.0.camel@jlt3.sipsolutions.net>
References: <1266704345.32739.0.camel@jlt3.sipsolutions.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves sysfs ABI info from Documentation/rfkill.txt to the
ABI subfolder and reformats it.

This also schedules the deprecated sysfs parts to be removed in
2012 (claim file) and 2014 (state file).

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 Documentation/ABI/obsolete/sysfs-class-rfkill |   29 ++++++++++++++++
 Documentation/ABI/stable/sysfs-class-rfkill   |   42 +++++++++++++++++++++++
 Documentation/feature-removal-schedule.txt    |   18 ++++++++++
 Documentation/rfkill.txt                      |   44 +++++++-----------------
 4 files changed, 102 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/sysfs-class-rfkill
 create mode 100644 Documentation/ABI/stable/sysfs-class-rfkill

diff --git a/Documentation/ABI/obsolete/sysfs-class-rfkill b/Documentation/ABI/obsolete/sysfs-class-rfkill
new file mode 100644
index 0000000..ed7174e
--- /dev/null
+++ b/Documentation/ABI/obsolete/sysfs-class-rfkill
@@ -0,0 +1,29 @@
+rfkill - radio frequency (RF) connector kill switch support
+
+For details to this subsystem look at Documentation/rfkill.txt.
+
+What:		/sys/class/rfkill/rfkill[0-9]+/state
+Date:		09-Jul-2007
+KernelVersion	v2.6.22
+Contact:	linux-wireless@vger.kernel.org
+Description: 	Current state of the transmitter.
+		This file is deprecated and sheduled to be removed in 2014,
+		because its not possible to express the 'soft and hard block'
+		state of the rfkill driver.
+Values: 	A numeric value.
+		0: RFKILL_STATE_SOFT_BLOCKED
+			transmitter is turned off by software
+		1: RFKILL_STATE_UNBLOCKED
+			transmitter is (potentially) active
+		2: RFKILL_STATE_HARD_BLOCKED
+			transmitter is forced off by something outside of
+			the driver's control.
+
+What:		/sys/class/rfkill/rfkill[0-9]+/claim
+Date:		09-Jul-2007
+KernelVersion	v2.6.22
+Contact:	linux-wireless@vger.kernel.org
+Description:	This file is deprecated because there no longer is a way to
+		claim just control over a single rfkill instance. 
+		This file is scheduled to be removed in 2012. 
+Values: 	0: Kernel handles events
diff --git a/Documentation/ABI/stable/sysfs-class-rfkill b/Documentation/ABI/stable/sysfs-class-rfkill
new file mode 100644
index 0000000..97d5064
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-class-rfkill
@@ -0,0 +1,42 @@
+rfkill - radio frequency (RF) connector kill switch support
+
+For details to this subsystem look at Documentation/rfkill.txt.
+
+For the deprecated /sys/class/rfkill/*/state and
+/sys/class/rfkill/*/claim knobs of this interface look in
+Documentation/ABI/obsolte/sysfs-class-rfkill.
+
+What: 		/sys/class/rfkill
+Date:		09-Jul-2007
+KernelVersion:	v2.6.22
+Contact:	linux-wireless@vger.kernel.org,
+Description: 	The rfkill class subsystem folder.
+		Each registered rfkill driver is represented by an rfkillX
+		subfolder (X being an integer > 0).
+
+
+What:		/sys/class/rfkill/rfkill[0-9]+/name
+Date:		09-Jul-2007
+KernelVersion	v2.6.22
+Contact:	linux-wireless@vger.kernel.org
+Description: 	Name assigned by driver to this key (interface or driver name).
+Values: 	arbitrary string.
+
+
+What: 		/sys/class/rfkill/rfkill[0-9]+/type
+Date:		09-Jul-2007
+KernelVersion	v2.6.22
+Contact:	linux-wireless@vger.kernel.org
+Description: 	Driver type string ("wlan", "bluetooth", etc).
+Values: 	See include/linux/rfkill.h.
+
+
+What:		/sys/class/rfkill/rfkill[0-9]+/persistent
+Date:		09-Jul-2007
+KernelVersion	v2.6.22
+Contact:	linux-wireless@vger.kernel.org
+Description: 	Whether the soft blocked state is initialised from non-volatile
+		storage at startup.
+Values: 	A numeric value.
+		0: false
+		1: true
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0a46833..b90c337 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -542,3 +542,21 @@ Why:	Duplicate functionality with the gspca_zc3xx driver, zc0301 only
 	sensors) wich are also supported by the gspca_zc3xx driver
 	(which supports 53 USB-ID's in total)
 Who:	Hans de Goede <hdegoede@redhat.com>
+
+----------------------------
+
+What:	sysfs-class-rfkill state file
+When:	Feb 2014
+Files:	net/rfkill/core.c
+Why: 	Documented as obsolete since Feb 2010. This file is limited to 3
+	states while the rfkill drivers can have 4 states.
+Who: 	anybody or Florian Mickler <florian@mickler.org>
+
+----------------------------
+
+What: 	sysfs-class-rfkill claim file
+When:	Feb 2012
+Files:	net/rfkill/core.c
+Why:	It is not possible to claim an rfkill driver since 2007. This is
+	Documented as obsolete since Feb 2010.
+Who: 	anybody or Florian Mickler <florian@mickler.org>
diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
index b486050..83668e5 100644
--- a/Documentation/rfkill.txt
+++ b/Documentation/rfkill.txt
@@ -99,37 +99,15 @@ system. Also, it is possible to switch all rfkill drivers (or all drivers of
 a specified type) into a state which also updates the default state for
 hotplugged devices.
 
-After an application opens /dev/rfkill, it can read the current state of
-all devices, and afterwards can poll the descriptor for hotplug or state
-change events.
-
-Applications must ignore operations (the "op" field) they do not handle,
-this allows the API to be extended in the future.
-
-Additionally, each rfkill device is registered in sysfs and there has the
-following attributes:
-
-	name: Name assigned by driver to this key (interface or driver name).
-	type: Driver type string ("wlan", "bluetooth", etc).
-	persistent: Whether the soft blocked state is initialised from
-	            non-volatile storage at startup.
-	state: Current state of the transmitter
-		0: RFKILL_STATE_SOFT_BLOCKED
-			transmitter is turned off by software
-		1: RFKILL_STATE_UNBLOCKED
-			transmitter is (potentially) active
-		2: RFKILL_STATE_HARD_BLOCKED
-			transmitter is forced off by something outside of
-			the driver's control.
-	       This file is deprecated because it can only properly show
-	       three of the four possible states, soft-and-hard-blocked is
-	       missing.
-	claim: 0: Kernel handles events
-	       This file is deprecated because there no longer is a way to
-	       claim just control over a single rfkill instance.
-
-rfkill devices also issue uevents (with an action of "change"), with the
-following environment variables set:
+After an application opens /dev/rfkill, it can read the current state of all
+devices. Changes can be either obtained by either polling the descriptor for
+hotplug or state change events or by listening for uevents emitted by the
+rfkill core framework.
+
+Additionally, each rfkill device is registered in sysfs and emits uevents.
+
+rfkill devices issue uevents (with an action of "change"), with the following
+environment variables set:
 
 RFKILL_NAME
 RFKILL_STATE
@@ -137,3 +115,7 @@ RFKILL_TYPE
 
 The contents of these variables corresponds to the "name", "state" and
 "type" sysfs files explained above.
+
+
+For further details consult Documentation/ABI/stable/dev-rfkill and
+Documentation/ABI/stable/sysfs-class-rfkill.
-- 
1.6.6.1

