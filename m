Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbZKJMmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbZKJMmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbZKJMmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:42:22 -0500
Received: from smtp.nokia.com ([192.100.122.233]:52687 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbZKJMmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:42:21 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, daniel@caiaq.de, pavel@ucw.cz
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH v2 02/10] LIS3LV02D: Correct memory leak in module unload
Date: Tue, 10 Nov 2009 14:41:04 +0200
Message-Id: <1257856872-11612-3-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com>
References: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 10 Nov 2009 12:41:23.0172 (UTC) FILETIME=[1C3DDA40:01CA6203]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

polled input device itself was not free'd.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/lis3lv02d.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 7f43a3b..dbd0b05 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -333,6 +333,7 @@ void lis3lv02d_joystick_disable(void)
 	if (lis3_dev.irq)
 		misc_deregister(&lis3lv02d_misc_device);
 	input_unregister_polled_device(lis3_dev.idev);
+	input_free_polled_device(lis3_dev.idev);
 	lis3_dev.idev = NULL;
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
-- 
1.5.6.3

