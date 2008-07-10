Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbYGJP3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbYGJP3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759242AbYGJP11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:27:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45162 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759234AbYGJP10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:27:26 -0400
Subject: [PATCH 13/15] regulator: documentation - ABI
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 16:27:23 +0100
Message-Id: <1215703643.13431.69.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds documentation describing the sysfs ABI used by the regulator
framework.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 Documentation/ABI/testing/sysfs-class-regulator |  187 +++++++++++++++++++++++
 1 files changed, 187 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-regulator

diff --git a/Documentation/ABI/testing/sysfs-class-regulator b/Documentation/ABI/testing/sysfs-class-regulator
new file mode 100644
index 0000000..4655927
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-regulator
@@ -0,0 +1,187 @@
+What:		/sys/class/regulator/.../state
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		state. This holds the regulator output state.
+
+		This will be one of the following strings:
+
+		'enabled'
+		'disabled'
+		'unknown'
+
+		'enabled' means the regulator output is ON and is supplying
+		power to the system.
+
+		'disabled' means the regulator output is OFF and is not
+		supplying power to the system..
+
+		'unknown' means software cannot determine the state.
+
+		NOTE: this field can be used in conjunction with microvolts
+		and microamps to determine regulator output levels.
+
+
+What:		/sys/class/regulator/.../type
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		type. This holds the regulator type.
+
+		This will be one of the following strings:
+
+		'voltage'
+		'current'
+		'unknown'
+
+		'voltage' means the regulator output voltage can be controlled
+		by software.
+
+		'current' means the regulator output current limit can be
+		controlled by software.
+
+		'unknown' means software cannot control either voltage or
+		current limit.
+
+
+What:		/sys/class/regulator/.../microvolts
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		microvolts. This holds the regulator output voltage setting
+		measured in microvolts (i.e. E-6 Volts).
+
+		NOTE: This value should not be used to determine the regulator
+		output voltage level as this value is the same regardless of
+		whether the regulator is enabled or disabled.
+
+
+What:		/sys/class/regulator/.../microamps
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		microamps. This holds the regulator output current limit
+		setting measured in microamps (i.e. E-6 Amps).
+
+		NOTE: This value should not be used to determine the regulator
+		output current level as this value is the same regardless of
+		whether the regulator is enabled or disabled.
+
+
+What:		/sys/class/regulator/.../opmode
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		opmode. This holds the regulator operating mode setting.
+
+		The opmode value can be one of the following strings:
+
+		'fast'
+		'normal'
+		'idle'
+		'standby'
+		'unknown'
+
+		The modes are described in include/linux/regulator/regulator.h
+
+		NOTE: This value should not be used to determine the regulator
+		output operating mode as this value is the same regardless of
+		whether the regulator is enabled or disabled.
+
+
+What:		/sys/class/regulator/.../min_microvolts
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		min_microvolts. This holds the minimum safe working regulator
+		output voltage setting for this domain measured in microvolts.
+
+		NOTE: this will return the string 'constraint not defined' if
+		the power domain has no min microvolts constraint defined by
+		platform code.
+
+
+What:		/sys/class/regulator/.../max_microvolts
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		max_microvolts. This holds the maximum safe working regulator
+		output voltage setting for this domain measured in microvolts.
+
+		NOTE: this will return the string 'constraint not defined' if
+		the power domain has no max microvolts constraint defined by
+		platform code.
+
+
+What:		/sys/class/regulator/.../min_microamps
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		min_microamps. This holds the minimum safe working regulator
+		output current limit setting for this domain measured in
+		microamps.
+
+		NOTE: this will return the string 'constraint not defined' if
+		the power domain has no min microamps constraint defined by
+		platform code.
+
+
+What:		/sys/class/regulator/.../max_microamps
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		max_microamps. This holds the maximum safe working regulator
+		output current limit setting for this domain measured in
+		microamps.
+
+		NOTE: this will return the string 'constraint not defined' if
+		the power domain has no max microamps constraint defined by
+		platform code.
+
+
+What:		/sys/class/regulator/.../num_users
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		num_users. This holds the number of consumer devices that
+		have called regulator_enable() on this regulator.
+
+
+What:		/sys/class/regulator/.../requested_microamps
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		requested_microamps. This holds the total requested load
+		current in microamps for this regulator from all its consumer
+		devices.
+
+
+What:		/sys/class/regulator/.../parent
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Some regulator directories will contain a link called parent.
+		This points to the parent or supply regulator if one exists.
-- 
1.5.4.3



