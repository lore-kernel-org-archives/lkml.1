Return-Path: <linux-kernel-owner+w=401wt.eu-S1763134AbYHFJYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763134AbYHFJYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758523AbYHFJX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:23:58 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49233 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377AbYHFJX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:23:56 -0400
Date: Wed, 6 Aug 2008 10:23:52 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: corentincj@iksaif.net
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH v2 1/2] eeepc-laptop: Fix user after free
Message-ID: <20080806092352.GA17801@srcf.ucam.org>
References: <20080804170833.GA9513@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804170833.GA9513@srcf.ucam.org>
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

commit 95f4bc41ef256b8e3dfa94cabe1faf0776ac988c
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Mon Aug 4 17:57:40 2008 +0100

    Fix use after free

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
