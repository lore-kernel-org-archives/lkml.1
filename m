Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832Ab0AEAne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab0AEAne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444Ab0AEAnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:43:00 -0500
Received: from kroah.org ([198.145.64.141]:34504 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416Ab0AEAfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jonathan Cameron <jic23@cam.ac.uk>,
       Christoph Walser <walser@tik.ee.ethz.ch>,
       Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 68/97] hwmon: (sht15) Off-by-one error in array index + incorrect constants
Date: Mon,  4 Jan 2010 16:33:21 -0800
Message-Id: <1262651630-7354-68-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

commit 4235f684b66d6f00d2cd8849c884cf8f8b57ecad upstream.

Fix an off-by-one error in array index + incorrect constants.

Signed-off-by: Christoph Walser <walser@tik.ee.ethz.ch>
Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/hwmon/sht15.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index ebe38b6..864a371 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -305,7 +305,7 @@ static inline int sht15_calc_temp(struct sht15_data *data)
 	int d1 = 0;
 	int i;
 
-	for (i = 1; i < ARRAY_SIZE(temppoints) - 1; i++)
+	for (i = 1; i < ARRAY_SIZE(temppoints); i++)
 		/* Find pointer to interpolate */
 		if (data->supply_uV > temppoints[i - 1].vdd) {
 			d1 = (data->supply_uV/1000 - temppoints[i - 1].vdd)
@@ -332,12 +332,12 @@ static inline int sht15_calc_humid(struct sht15_data *data)
 
 	const int c1 = -4;
 	const int c2 = 40500; /* x 10 ^ -6 */
-	const int c3 = 2800; /* x10 ^ -9 */
+	const int c3 = -2800; /* x10 ^ -9 */
 
 	RHlinear = c1*1000
 		+ c2 * data->val_humid/1000
 		+ (data->val_humid * data->val_humid * c3)/1000000;
-	return (temp - 25000) * (10000 + 800 * data->val_humid)
+	return (temp - 25000) * (10000 + 80 * data->val_humid)
 		/ 1000000 + RHlinear;
 }
 
-- 
1.6.6

