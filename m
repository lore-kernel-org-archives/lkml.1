Return-Path: <linux-kernel-owner+w=401wt.eu-S1751850AbZHZQRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbZHZQRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZHZQR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:17:29 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:50203 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730AbZHZQRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:17:25 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, Matthew Garrett <mjg@redhat.com>,
       Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 6/6] thermal: disable polling if passive_delay and polling_delay are both unset
Date: Wed, 26 Aug 2009 18:17:25 +0200
Message-Id: <1251303445-25317-7-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1251303445-25317-1-git-send-email-elendil@planet.nl>
References: <1251303445-25317-1-git-send-email-elendil@planet.nl>
X-OriginalArrivalTime: 26 Aug 2009 16:17:26.0379 (UTC) FILETIME=[B38543B0:01CA2668]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise polling will continue for the thermal zone even when
it is no longer needed, for example because forced passive cooling
was disabled.

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index ceda0f1..a59685b 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1012,6 +1012,8 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 		thermal_zone_device_set_polling(tz, tz->passive_delay);
 	else if (tz->polling_delay)
 		thermal_zone_device_set_polling(tz, tz->polling_delay);
+	else
+		thermal_zone_device_set_polling(tz, 0);
 	mutex_unlock(&tz->lock);
 }
 EXPORT_SYMBOL(thermal_zone_device_update);
