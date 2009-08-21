Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZHUI7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZHUI7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 04:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbZHUI7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 04:59:36 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:60146 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754366AbZHUI7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 04:59:35 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org
Subject: [PATCH 2/3] acpi: thermal/sysfs-api.txt: document passive attribute for thermal zones
Date: Fri, 21 Aug 2009 10:59:35 +0200
User-Agent: KMail/1.9.9
Cc: Sujith Thomas <sujith.thomas@intel.com>, Zhang Rui <rui.zhang@intel.com>,
       linux-kernel@vger.kernel.org
References: <200908211055.20569.elendil@planet.nl>
In-Reply-To: <200908211055.20569.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908211059.36774.elendil@planet.nl>
X-OriginalArrivalTime: 21 Aug 2009 08:59:37.0018 (UTC) FILETIME=[B5B221A0:01CA223D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Sujith Thomas <sujith.thomas@intel.com>

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index 48e9c5c..52b63c4 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -3,7 +3,7 @@ Generic Thermal Sysfs driver How To
 
 Written by Sujith Thomas <sujith.thomas@intel.com>, Zhang Rui <rui.zhang@intel.com>
 
-Updated: 2 January 2008
+Updated: 21 August 2009
 
 Copyright (c)  2008 Intel Corporation
 
@@ -199,6 +199,16 @@ cdev[0-*]_trip_point
 	point.
 	RO, Optional
 
+passive
+	Attribute is only present for zones which do not have a passive
+	cooling policy (_PSV) defined in ACPI. Default is zero and can be
+	set to a temperature (in millidegrees) to enable a passive trip
+	point for the zone. Activation is done by polling (default interval:
+	10 seconds); the polling interval can be set in
+	/proc/acpi/thermal/TZN/polling_frequency.
+	Unit: millidegree Celsius
+	RW, Optional
+
 *****************************
 * Cooling device attributes *
 *****************************
@@ -230,8 +240,9 @@ thermal_zone_device (thermal_zone1) with 4 trip points in all.
 It has one processor and one fan, which are both registered as
 thermal_cooling_device.
 
-If the processor is listed in _PSL method, and the fan is listed in _AL0
-method, the sys I/F structure will be built like this:
+If the processor is listed in _PSL method, the fan is listed in _AL0
+method, and the zone has a _PSV method, the sys I/F structure will be
+built like this:
 
 /sys/class/thermal:
 
