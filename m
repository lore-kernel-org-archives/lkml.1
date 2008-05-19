Return-Path: <linux-kernel-owner+w=401wt.eu-S1763333AbYESNhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763333AbYESNhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760438AbYESNV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:21:57 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:39065 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761595AbYESNV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:21:56 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: khali@linux-fr.org
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] i2c: align i2c_device_id
Date: Mon, 19 May 2008 15:18:44 +0200
Message-Id: <1211203124-3096-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align i2c_device_id.driver_data to 8 bytes to not fail on crossbuilds.

(Added in d2653e92732bd3911feff6bee5e23dbf959381db.)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
---
 include/linux/mod_devicetable.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index a37db57..1fd03e7 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -384,7 +384,8 @@ struct virtio_device_id {
 
 struct i2c_device_id {
 	char name[I2C_NAME_SIZE];
-	kernel_ulong_t driver_data;	/* Data private to the driver */
+	kernel_ulong_t driver_data	/* Data private to the driver */
+			__attribute__((aligned(sizeof(kernel_ulong_t))));
 };
 
 
-- 
1.5.4.5

