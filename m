Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbZHRXhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbZHRXhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZHRXhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:37:39 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47546 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbZHRXhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:37:36 -0400
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 1/2] hwmon: Enhance the sysfs API for power meters.
To: "Darrick J. Wong" <djwong@us.ibm.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Pavel Machek <pavel@ucw.cz>
Date: Tue, 18 Aug 2009 16:48:04 -0700
Message-ID: <20090818234803.2004.28814.stgit@elm3a70.beaverton.ibm.com>
In-Reply-To: <20090818234757.2004.88017.stgit@elm3a70.beaverton.ibm.com>
References: <20090818234757.2004.88017.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Augment the documentation of the hwmon sysfs API to accomodate ACPI power
meters.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 Documentation/hwmon/sysfs-interface |   60 ++++++++++++++++++++++++++++++++++-
 1 files changed, 59 insertions(+), 1 deletions(-)


diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
index dcbd502..8b5a654 100644
--- a/Documentation/hwmon/sysfs-interface
+++ b/Documentation/hwmon/sysfs-interface
@@ -353,10 +353,20 @@ power[1-*]_average		Average power use
 				Unit: microWatt
 				RO
 
-power[1-*]_average_interval	Power use averaging interval
+power[1-*]_average_interval	Power use averaging interval.  A poll
+				notification is sent to this file if the
+				hardware changes the averaging interval.
 				Unit: milliseconds
 				RW
 
+power[1-*]_average_interval_max	Maximum power use averaging interval
+				Unit: milliseconds
+				RO
+
+power[1-*]_average_interval_min	Minimum power use averaging interval
+				Unit: milliseconds
+				RO
+
 power[1-*]_average_highest	Historical average maximum power use
 				Unit: microWatt
 				RO
@@ -365,6 +375,18 @@ power[1-*]_average_lowest	Historical average minimum power use
 				Unit: microWatt
 				RO
 
+power[1-*]_average_max		A poll notification is sent to
+				power[1-*]_average when power use
+				rises above this value.
+				Unit: microWatt
+				RW
+
+power[1-*]_average_min		A poll notification is sent to
+				power[1-*]_average when power use
+				sinks below this value.
+				Unit: microWatt
+				RW
+
 power[1-*]_input		Instantaneous power use
 				Unit: microWatt
 				RO
@@ -381,6 +403,42 @@ power[1-*]_reset_history	Reset input_highest, input_lowest,
 				average_highest and average_lowest.
 				WO
 
+power[1-*]_accuracy		Accuracy of the power meter.
+				Unit: Percent
+				RO
+
+power[1-*]_alarm		1 if the system is drawing more power than the
+				cap allows; 0 otherwise.  A poll notification is
+				sent to this file if the power use exceeds the
+				cap.  The action that is taken when this event
+				happens is undefined--it is possible that the
+				hardware will reduce performance to cut the
+				power use, but it is also possible that the
+				system designer expects the OS to try to
+				reduce power consumption.  Contact your
+				machine's vendor to find out which.
+				RO
+
+power[1-*]_cap			If power use rises above this limit, the
+				system should take action to reduce power use.
+				A poll notification is sent to this file if the
+				cap is changed by the hardware.
+				Unit: microWatt
+				RW
+
+power[1-*]_cap_hyst		Margin of hysteresis built around capping and
+				notification.
+				Unit: microWatt
+				RW
+
+power[1-*]_cap_max		Maximum cap that can be set.
+				Unit: microWatt
+				RO
+
+power[1-*]_cap_min		Minimum cap that can be set.
+				Unit: microWatt
+				RO
+
 **********
 * Energy *
 **********

