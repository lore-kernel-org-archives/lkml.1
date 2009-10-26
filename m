Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbZJZHjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbZJZHjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbZJZHjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:39:07 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:60969 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754864AbZJZHjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:39:02 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Frans Pop <elendil@planet.nl>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH 3/6] acpi: thermal: display forced passive trip points in proc
Date: Mon, 26 Oct 2009 08:39:01 +0100
Message-Id: <1256542744-26569-4-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1256542744-26569-1-git-send-email-elendil@planet.nl>
References: <1256542744-26569-1-git-send-email-elendil@planet.nl>
X-OriginalArrivalTime: 26 Oct 2009 07:39:05.0661 (UTC) FILETIME=[653F0ED0:01CA560F]
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
Acked-by: Zhang Rui <rui.zhang@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
---
 drivers/acpi/thermal.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 65f6781..9073ada 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -1052,6 +1052,13 @@ static int acpi_thermal_trip_seq_show(struct seq_file *seq, void *offset)
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
-- 
1.5.6.5

