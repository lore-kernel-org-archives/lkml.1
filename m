Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbZJZHjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbZJZHjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbZJZHjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:39:11 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:60983 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754895AbZJZHjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:39:04 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Frans Pop <elendil@planet.nl>,
       Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 6/6] thermal: disable polling if passive_delay and polling_delay are both unset
Date: Mon, 26 Oct 2009 08:39:04 +0100
Message-Id: <1256542744-26569-7-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1256542744-26569-1-git-send-email-elendil@planet.nl>
References: <1256542744-26569-1-git-send-email-elendil@planet.nl>
X-OriginalArrivalTime: 26 Oct 2009 07:39:05.0880 (UTC) FILETIME=[65607980:01CA560F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise polling will continue for the thermal zone even when
it is no longer needed, for example because forced passive cooling
was disabled.

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Matthew Garrett <mjg@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/thermal_sys.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index fc5e92e..d69e6fd 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1019,6 +1019,8 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 		thermal_zone_device_set_polling(tz, tz->passive_delay);
 	else if (tz->polling_delay)
 		thermal_zone_device_set_polling(tz, tz->polling_delay);
+	else
+		thermal_zone_device_set_polling(tz, 0);
 	mutex_unlock(&tz->lock);
 }
 EXPORT_SYMBOL(thermal_zone_device_update);
-- 
1.5.6.5

