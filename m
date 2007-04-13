Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbXDMQOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbXDMQOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 12:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbXDMQOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 12:14:08 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:49276 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbXDMQN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 12:13:56 -0400
Date: Fri, 13 Apr 2007 18:14:41 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] do not print error on systems without apple motion sensor
Message-ID: <20070413161441.GA9816@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It is not an error if a system has no ams hardware.
Do not clutter dmesg in this case.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 drivers/hwmon/ams/ams-core.c |    3 ---
 1 file changed, 3 deletions(-)

Index: b/drivers/hwmon/ams/ams-core.c
===================================================================
--- a/drivers/hwmon/ams/ams-core.c
+++ b/drivers/hwmon/ams/ams-core.c
@@ -219,9 +219,6 @@ int __init ams_init(void)
 		/* Found PMU motion sensor */
 		return ams_pmu_init(np);
 #endif
-
-	printk(KERN_ERR "ams: No motion sensor found.\n");
-
 	return -ENODEV;
 }
 
