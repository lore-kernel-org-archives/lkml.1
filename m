Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbYHDRIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbYHDRIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbYHDRIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:08:37 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45923 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbYHDRIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:08:36 -0400
Date: Mon, 4 Aug 2008 18:08:33 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: corentincj@iksaif.net
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH 1/2] eeepc-laptop: Fix user after free
Message-ID: <20080804170833.GA9513@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eeepc-laptop uses the hwmon struct after unregistering the device, 
causing an oops on module unload. Flip the ordering to fix.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

diff --git a/drivers/misc/eeepc-laptop.c b/drivers/misc/eeepc-laptop.c
index 9e8d79e..facdb98 100644
--- a/drivers/misc/eeepc-laptop.c
+++ b/drivers/misc/eeepc-laptop.c
@@ -553,9 +553,9 @@ static void eeepc_hwmon_exit(void)
 	hwmon = eeepc_hwmon_device;
 	if (!hwmon)
 		return ;
-	hwmon_device_unregister(hwmon);
 	sysfs_remove_group(&hwmon->kobj,
 			   &hwmon_attribute_group);
+	hwmon_device_unregister(hwmon);
 	eeepc_hwmon_device = NULL;
 }

-- 
Matthew Garrett | mjg59@srcf.ucam.org
