Return-Path: <linux-kernel-owner+w=401wt.eu-S1760134AbYEHGb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134AbYEHGb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 02:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbYEHGbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 02:31:05 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:11243 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbYEHGbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 02:31:03 -0400
From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 3/5] SCSI sd driver calls revalidate_disk wrapper.
To: linux-scsi@vger.kernel.org
Cc: andrew.patterson@hp.com, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com
Date: Thu, 08 May 2008 00:31:01 -0600
Message-ID: <20080508063100.3818.73689.stgit@bluto.andrew>
In-Reply-To: <20080508062930.3818.31401.stgit@bluto.andrew>
References: <20080508062930.3818.31401.stgit@bluto.andrew>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCSI sd driver calls revalidate_disk wrapper.

Modify the SCSI disk driver to call the revalidate_disk()
wrapper. This allows us to do some housekeeping such as accounting for
a disk being resized online. The wrapper will call
sd_revalidate_disk() at the appropriate time.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

 drivers/scsi/sd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 01cefbb..7aedeb3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -160,7 +160,7 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 			sd_print_sense_hdr(sdkp, &sshdr);
 		return -EINVAL;
 	}
-	sd_revalidate_disk(sdkp->disk);
+	revalidate_disk(sdkp->disk);
 	return count;
 }
 
@@ -871,7 +871,7 @@ static void sd_rescan(struct device *dev)
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 
 	if (sdkp) {
-		sd_revalidate_disk(sdkp->disk);
+		revalidate_disk(sdkp->disk);
 		scsi_disk_put(sdkp);
 	}
 }

