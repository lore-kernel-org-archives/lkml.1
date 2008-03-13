Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbYCMWNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbYCMWNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYCMWMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:12:54 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41195 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbYCMWMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:12:53 -0400
Date: Thu, 13 Mar 2008 15:12:46 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: lm-sensors <lm-sensors@lm-sensors.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ibmpex: Report temperatures in mC, not C.
Message-ID: <20080313221245.GI5529@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ibmpex's temperature sensors report incorrect units.  Apply
a conversion factor so that tempertures report correctly.
Until now, no systems seemed to report temperatures this
way, but evidently QS2x blades do.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/ibmpex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index db551d8..4e9b19c 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -410,7 +410,7 @@ static int ibmpex_find_sensors(struct ibmpex_bmc_data *data)
 			sensor_type = TEMP_SENSOR;
 			num_temp++;
 			sensor_counter = num_temp;
-			data->sensors[i].multiplier = 1;
+			data->sensors[i].multiplier = 1000;
 		} else
 			continue;
 
