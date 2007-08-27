Return-Path: <linux-kernel-owner+w=401wt.eu-S964966AbXH0Rum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964966AbXH0Rum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758001AbXH0Ru1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:50:27 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:61340 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964866AbXH0RuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:50:24 -0400
Date: Mon, 27 Aug 2007 10:58:01 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] mptsas: scan the logical volume at first
To: Andrew Morton <akpm@linux-foundation.org>,
       Sathya Prakash <sathya.prakash@lsi.com>,
       James Bottomley <James.Bottomley@steeleye.com>, Eric.Moore@lsi.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200708271058.01919.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] mptsas: scan the logical volume at first

user like to see the raid show as /dev/sda before left raw disks.
So scan the volume at first to make their life easier.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index b9c69bf..4c452be 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2403,9 +2403,6 @@ mptsas_scan_sas_topology(MPT_ADAPTER *ioc)
 	int i;
 
 	mutex_lock(&ioc->sas_discovery_mutex);
-	mptsas_probe_hba_phys(ioc);
-	while (!mptsas_probe_expander_phys(ioc, &handle))
-		;
 	/*
 	  Reporting RAID volumes.
 	*/
@@ -2420,6 +2417,9 @@ mptsas_scan_sas_topology(MPT_ADAPTER *ioc)
 		    ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID, 0);
 	}
  out:
+	mptsas_probe_hba_phys(ioc);
+	while (!mptsas_probe_expander_phys(ioc, &handle))
+		;
 	mutex_unlock(&ioc->sas_discovery_mutex);
 }
 
