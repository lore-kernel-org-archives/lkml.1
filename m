Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbYKEKsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbYKEKsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 05:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbYKEKsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 05:48:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:48469 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768AbYKEKsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 05:48:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,550,1220252400"; 
   d="scan'208";a="635742186"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] 3/3 intel_menlow: syncing with acpi function changes
Date: Wed, 5 Nov 2008 16:16:44 +0530
Message-ID: <7D0189F5BE1DF549A570B212D1D5612182AF07@bgsmsx412.gar.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] 3/3 intel_menlow: syncing with acpi function changes
Thread-Index: Ack/M8uUUA2VLNRLS0Wpci3B6Z1Zrg==
From: "Thomas, Sujith" <sujith.thomas@intel.com>
To: "Len Brown" <lenb@kernel.org>, "Zhang, Rui" <rui.zhang@intel.com>,
       "Thomas, Sujith" <sujith.thomas@intel.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <linux-acpi@vger.kernel.org>, "Brown, Len" <len.brown@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 05 Nov 2008 10:47:50.0850 (UTC) FILETIME=[F2F08220:01C93F33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

4th parameter of acpi_evaluate_integer changed to unsigned long long
acpi_driver_data() changed to inline function from macro

Signed-off-by: Sujith Thomas <sujith.thomas@intel.com>
---
 drivers/misc/intel_menlow.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6.27/drivers/misc/intel_menlow.c
===================================================================
--- linux-2.6.27.orig/drivers/misc/intel_menlow.c
+++ linux-2.6.27/drivers/misc/intel_menlow.c
@@ -62,7 +62,7 @@ static int memory_get_int_max_bandwidth(
 {
 	struct acpi_device *device = cdev->devdata;
 	acpi_handle handle = device->handle;
-	unsigned long value;
+	unsigned long long value;
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
 	acpi_status status = AE_OK;
@@ -98,7 +98,7 @@ static int memory_get_cur_bandwidth(stru
 {
 	struct acpi_device *device = cdev->devdata;
 	acpi_handle handle = device->handle;
-	unsigned long value;
+	unsigned long long value;
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
 	acpi_status status = AE_OK;
@@ -112,7 +112,7 @@ static int memory_get_cur_bandwidth(stru
 	if (ACPI_FAILURE(status))
 		return -EFAULT;
 
-	return sprintf(buf, "%ld\n", value);
+	return sprintf(buf, "%lld\n", value);
 }
 
 static int memory_set_cur_bandwidth(struct thermal_cooling_device
*cdev,
@@ -139,7 +139,7 @@ static int memory_set_cur_bandwidth(stru
 
 	status =
 	    acpi_evaluate_integer(handle, MEMORY_SET_BANDWIDTH,
&arg_list,
-				  (unsigned long *)&temp);
+				  (unsigned long long *)&temp);
 
 	printk(KERN_INFO
 	       "Bandwidth value was %d: status is %d\n", state, status);
@@ -183,7 +183,7 @@ static int intel_menlow_memory_add(struc
 		goto end;
 	}
 
-	acpi_driver_data(device) = cdev;
+	device->driver_data = cdev;
 	result = sysfs_create_link(&device->dev.kobj,
 				&cdev->device.kobj, "thermal_cooling");
 	if (result)
@@ -268,7 +268,7 @@ static int sensor_get_auxtrip(acpi_handl
 		return -EINVAL;
 
 	status = acpi_evaluate_integer(handle, index ? GET_AUX1 :
GET_AUX0,
-				       NULL, (unsigned long *)value);
+				       NULL, (unsigned long long
*)value);
 	if (ACPI_FAILURE(status))
 		return -EIO;
 
@@ -296,7 +296,7 @@ static int sensor_set_auxtrip(acpi_handl
 		return -EINVAL;
 
 	status = acpi_evaluate_integer(handle, index ? GET_AUX0 :
GET_AUX1,
-				       NULL, (unsigned long *)&temp);
+				       NULL, (unsigned long long
*)&temp);
 	if (ACPI_FAILURE(status))
 		return -EIO;
 	if ((index && value < temp) || (!index && value > temp))
@@ -304,7 +304,7 @@ static int sensor_set_auxtrip(acpi_handl
 
 	arg.integer.value = value;
 	status = acpi_evaluate_integer(handle, index ? SET_AUX1 :
SET_AUX0,
-				       &args, (unsigned long *)&temp);
+				       &args, (unsigned long long
*)&temp);
 	if (ACPI_FAILURE(status))
 		return -EIO;
 
@@ -384,7 +384,7 @@ static ssize_t bios_enabled_show(struct 
 				 struct device_attribute *attr, char
*buf)
 {
 	acpi_status status;
-	unsigned long bios_enabled;
+	unsigned long long bios_enabled;
 
 	status = acpi_evaluate_integer(NULL, BIOS_ENABLED, NULL,
&bios_enabled);
 	if (ACPI_FAILURE(status))
@@ -500,7 +500,7 @@ static int __init intel_menlow_module_in
 {
 	int result = -ENODEV;
 	acpi_status status;
-	unsigned long enable;
+	unsigned long long enable;
 
 	if (acpi_disabled)
 		return result;
