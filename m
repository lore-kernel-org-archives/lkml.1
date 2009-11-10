Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbZKJMoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbZKJMoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756278AbZKJMmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:42:23 -0500
Received: from smtp.nokia.com ([192.100.122.233]:52685 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbZKJMmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:42:21 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, daniel@caiaq.de, pavel@ucw.cz
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH v2 01/10] LIS3LV02D: Send sync event
Date: Tue, 10 Nov 2009 14:41:03 +0200
Message-Id: <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 10 Nov 2009 12:41:21.0000 (UTC) FILETIME=[1AF26E80:01CA6203]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Send input_sync after each measurement round. This helps userspace to
detect which reported values belongs to the same measurement.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/lis3lv02d.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index cf5afb9..7f43a3b 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -276,6 +276,7 @@ static void lis3lv02d_joystick_poll(struct input_polled_dev *pidev)
 	input_report_abs(pidev->input, ABS_X, x - lis3_dev.xcalib);
 	input_report_abs(pidev->input, ABS_Y, y - lis3_dev.ycalib);
 	input_report_abs(pidev->input, ABS_Z, z - lis3_dev.zcalib);
+	input_sync(pidev->input);
 }
 
 
-- 
1.5.6.3

