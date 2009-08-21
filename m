Return-Path: <linux-kernel-owner+w=401wt.eu-S932380AbZHUPbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbZHUPbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 11:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbZHUPbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 11:31:17 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:54887 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932182AbZHUPbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 11:31:16 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org
Subject: Re: [PATCH,v2] acpi: thermal: display forced passive trip points in proc
Date: Fri, 21 Aug 2009 17:31:15 +0200
User-Agent: KMail/1.9.9
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org
References: <200908211617.03574.elendil@planet.nl>
In-Reply-To: <200908211617.03574.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908211731.16812.elendil@planet.nl>
X-OriginalArrivalTime: 21 Aug 2009 15:31:17.0225 (UTC) FILETIME=[6CE92590:01CA2274]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users can force a passive trip point for a thermal zone that does not
have _PSV defined in ACPI by setting the passive attribute in sysfs.
It's useful to display such trip points in /proc/acpi/thermal_zone.

.../TZ1/cooling_mode:<setting not supported>
.../TZ1/polling_frequency:polling frequency:       10 seconds
.../TZ1/state:state:                   ok
.../TZ1/temperature:temperature:             53 C
.../TZ1/trip_points:critical (S5):           110 C
.../TZ1/trip_points:passive (forced):        95 C

And if not set (passive is 0):
.../TZ1/trip_points:passive (forced):<not set>

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Zhang Rui <rui.zhang@intel.com>
---

I noticed I forgot the linefeed and thought of a further improvement.

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 564ea14..7ff5789 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -1050,6 +1050,13 @@ static int acpi_thermal_trip_seq_show(struct 
seq_file *seq, void *offset)
 				   acpi_device_bid(device));
 		}
 		seq_puts(seq, "\n");
+	} else {
+		seq_printf(seq, "passive (forced):");
+		if (tz->thermal_zone->forced_passive)
+			seq_printf(seq, "        %i C\n",
+				   tz->thermal_zone->forced_passive / 1000);
+		else
+			seq_printf(seq, "<not set>\n");
 	}
 
 	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE; i++) {
