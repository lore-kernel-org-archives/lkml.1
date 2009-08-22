Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbZHVL5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbZHVL5X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 07:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbZHVL5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 07:57:23 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:62461 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755799AbZHVL5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 07:57:22 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3,v2] acpi: thermal/sysfs-api.txt: document passive attribute for thermal zones
Date: Sat, 22 Aug 2009 13:57:20 +0200
User-Agent: KMail/1.9.9
Cc: Sujith Thomas <sujith.thomas@intel.com>, Zhang Rui <rui.zhang@intel.com>,
       linux-kernel@vger.kernel.org
References: <200908211055.20569.elendil@planet.nl> <200908211059.36774.elendil@planet.nl>
In-Reply-To: <200908211059.36774.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908221357.21567.elendil@planet.nl>
X-OriginalArrivalTime: 22 Aug 2009 11:57:22.0081 (UTC) FILETIME=[B4FB5910:01CA231F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Sujith Thomas <sujith.thomas@intel.com>
---

While working on some further patches I discovered that polling_delay does
not actually determine the polling interval for a forced passive trip
point. Instead a hardcoded interval of 1 second is used (passive_delay).

I also saw that the thermal_sys driver is somewhat independent of ACPI,
so the third patch in the series may not be appropriate.

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index 48e9c5c..f6b3743 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -3,7 +3,7 @@ Generic Thermal Sysfs driver How To
 
 Written by Sujith Thomas <sujith.thomas@intel.com>, Zhang Rui <rui.zhang@intel.com>
 
-Updated: 2 January 2008
+Updated: 21 August 2009
 
 Copyright (c)  2008 Intel Corporation
 
@@ -199,6 +199,15 @@ cdev[0-*]_trip_point
 	point.
 	RO, Optional
 
+passive
+	Attribute is only present for zones which do not have a passive
+	cooling policy (_PSV) defined in ACPI. Default is zero and can be
+	set to a temperature (in millidegrees) to enable a passive trip
+	point for the zone. Activation is done by polling with an interval
+	of 1 second.
+	Unit: millidegrees Celsius
+	RW, Optional
+
 *****************************
 * Cooling device attributes *
 *****************************
@@ -230,8 +239,9 @@ thermal_zone_device (thermal_zone1) with 4 trip points in all.
 It has one processor and one fan, which are both registered as
 thermal_cooling_device.
 
-If the processor is listed in _PSL method, and the fan is listed in _AL0
-method, the sys I/F structure will be built like this:
+If the processor is listed in _PSL method, the fan is listed in _AL0
+method, and the zone has a _PSV method, the sys I/F structure will be
+built like this:
 
 /sys/class/thermal:
 
