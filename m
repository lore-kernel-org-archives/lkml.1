Return-Path: <linux-kernel-owner+w=401wt.eu-S972137AbXHMPXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972137AbXHMPXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761598AbXHMNM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:12:26 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:23678 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S972569AbXHMNMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:12:21 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Message-ID: <46C05896.4050509@amd.com>
Date: Mon, 13 Aug 2007 15:11:50 +0200
From: "Markus Rechberger" <markus.rechberger@amd.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, "Jean Delvare" <khali@linux-fr.org>,
       "Greg KH" <greg@kroah.com>
Subject: [PATCH] Firmware class name collision
X-OriginalArrivalTime: 13 Aug 2007 13:12:03.0086 (UTC)
 FILETIME=[8A2F72E0:01C7DDAB]
X-WSS-ID: 6ADE872F0X84480270-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

following patch fixes the i2c name collision with i2c-dev.

http://mcentral.de/wiki/index.php/Bugtracker#i2c_core_problem

This issue has been experienced with em28xx and saa7133 based devices.
I discussed that problem with Jean Delvare a while ago and he proposed 
to add a prefix to the class name.

http://mcentral.de/~mrec/patches/firmware_class_name_collision.diff

Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>

index b24efd4..bfc54a1 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -297,8 +297,7 @@ firmware_class_timeout(u_long data)
 
 static inline void fw_setup_device_id(struct device *f_dev, struct 
device *dev)
 {
-       /* XXX warning we should watch out for name collisions */
-       strlcpy(f_dev->bus_id, dev->bus_id, BUS_ID_SIZE);
+       snprintf(f_dev->bus_id, BUS_ID_SIZE, "fw-%s", dev->bus_id);
 }
 
 static int fw_register_device(struct device **dev_p, const char *fw_name,

Markus


