Return-Path: <linux-kernel-owner+w=401wt.eu-S1757929AbZEFReg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbZEFReg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 13:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbZEFRe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 13:34:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:42415 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbZEFReZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 13:34:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:content-disposition:from:cc:date:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=N3U/apQK1vXj72xufgHLOa+FVic5LBWFSqdiO1GwVDNqjnlks0GAdOODpCeP9mehUm
         sXhrtAYSah/EWJq4bdTLJ03XDXEmW7frYO5KbbXqybIvo0z+W1NUIHuGhbRTWQyHw+p3
         ahlPlgd2MA3SKuFLkOKTJD9B8Xoi+jLn595n8=
To: rui.zhang@intel.com
Subject: [PATCH 2.6.30-rc4] thermal: fix off-by-1 error in trip point trigger condition
Content-Disposition: inline
From: Vladimir Zajac <eightgraph@gmail.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 6 May 2009 19:34:21 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200905061934.21821.eightgraph@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a regression caused by commit
b1569e99c795bf83b4ddf41c4f1c42761ab7f75e
"ACPI: move thermal trip handling to generic thermal layer"
which accidentally changed trip point trigger condition to
  temp > trip_temp

This patch changes the trigger condition back to
  temp >= trip_temp

Signed-off-by: Vladimir Zajac <eightgraph@gmail.com>
---

 thermal_sys.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.30-rc4/drivers/thermal/thermal_sys.c	2009-04-30 23:52:59.000000000 +0200
+++ linux-2.6.30-rc4-p1/drivers/thermal/thermal_sys.c	2009-05-04 19:58:30.000000000 +0200
@@ -961,7 +961,7 @@ void thermal_zone_device_update(struct t
 
 		switch (trip_type) {
 		case THERMAL_TRIP_CRITICAL:
-			if (temp > trip_temp) {
+			if (temp >= trip_temp) {
 				if (tz->ops->notify)
 					ret = tz->ops->notify(tz, count,
 							      trip_type);
@@ -974,7 +974,7 @@ void thermal_zone_device_update(struct t
 			}
 			break;
 		case THERMAL_TRIP_HOT:
-			if (temp > trip_temp)
+			if (temp >= trip_temp)
 				if (tz->ops->notify)
 					tz->ops->notify(tz, count, trip_type);
 			break;
@@ -986,14 +986,14 @@ void thermal_zone_device_update(struct t
 
 				cdev = instance->cdev;
 
-				if (temp > trip_temp)
+				if (temp >= trip_temp)
 					cdev->ops->set_cur_state(cdev, 1);
 				else
 					cdev->ops->set_cur_state(cdev, 0);
 			}
 			break;
 		case THERMAL_TRIP_PASSIVE:
-			if (temp > trip_temp || tz->passive)
+			if (temp >= trip_temp || tz->passive)
 				thermal_zone_device_passive(tz, temp,
 							    trip_temp, count);
 			break;
