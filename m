Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbZHZQS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbZHZQS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZHZQSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:18:20 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:63740 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbZHZQRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:17:25 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, Zhang Rui <rui.zhang@intel.com>,
       Sujith Thomas <sujith.thomas@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH 2/6] thermal: sysfs-api.txt - document passive attribute for thermal zones
Date: Wed, 26 Aug 2009 18:17:21 +0200
Message-Id: <1251303445-25317-3-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1251303445-25317-1-git-send-email-elendil@planet.nl>
References: <1251303445-25317-1-git-send-email-elendil@planet.nl>
X-OriginalArrivalTime: 26 Aug 2009 16:17:25.0459 (UTC) FILETIME=[B2F8E230:01CA2668]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Sujith Thomas <sujith.thomas@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index 895337f..2a036eb 100644
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
 
