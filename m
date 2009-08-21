Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbZHUORF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbZHUORF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZHUORE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:17:04 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:56827 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754644AbZHUORE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:17:04 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org
Subject: [PATCH] acpi: thermal: display forced passive trip points in proc
Date: Fri, 21 Aug 2009 16:17:02 +0200
User-Agent: KMail/1.9.9
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908211617.03574.elendil@planet.nl>
X-OriginalArrivalTime: 21 Aug 2009 14:17:04.0209 (UTC) FILETIME=[0EB4D410:01CA226A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users can force a passive trip point for a thermal zone that does not
have _PSV defined in ACPI by setting the passive attribute in sysfs.
It's useful to display such trip points in /proc/acpi/thermal_zone.

.../TZ1/cooling_mode:<setting not supported>
.../TZ1/polling_frequency:polling frequency:       10 seconds
.../TZ1/state:state:                   ok
.../TZ1/temperature:temperature:             56 C
.../TZ1/trip_points:critical (S5):           110 C
.../TZ1/trip_points:passive:                 95 C: forced

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Zhang Rui <rui.zhang@intel.com>
---

Now that I've got this set on my notebook, I also want to see that
it's set :-)

Cheers,
FJP

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 564ea14..c64cfa9 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -1050,6 +1050,10 @@ static int acpi_thermal_trip_seq_show(struct seq_file *seq, void *offset)
 				   acpi_device_bid(device));
 		}
 		seq_puts(seq, "\n");
+	} else if (tz->thermal_zone->forced_passive) {
+		seq_printf(seq,
+			   "passive:                 %i C: forced",
+			   tz->thermal_zone->forced_passive / 1000);
 	}
 
 	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE; i++) {
