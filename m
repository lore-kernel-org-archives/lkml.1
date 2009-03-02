Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbZCBVFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbZCBVFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbZCBVFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:05:24 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:36216 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922AbZCBVFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:05:23 -0500
Date: Mon, 2 Mar 2009 13:05:05 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH] lm85: Add VRM10 support for adt7468 chip
Message-ID: <20090302210505.GF6550@plum>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The adt7468 chip supports VRM10 sensors just like the adt7463; add a missing
check for it.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/lm85.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/lm85.c b/drivers/hwmon/lm85.c
index cf1422e..b251d86 100644
--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -410,7 +410,8 @@ static ssize_t show_vid_reg(struct device *dev, struct device_attribute *attr,
 	struct lm85_data *data = lm85_update_device(dev);
 	int vid;
 
-	if (data->type == adt7463 && (data->vid & 0x80)) {
+	if ((data->type == adt7463 || data->type == adt7468) &&
+	    (data->vid & 0x80)) {
 		/* 6-pin VID (VRM 10) */
 		vid = vid_from_reg(data->vid & 0x3f, data->vrm);
 	} else {
