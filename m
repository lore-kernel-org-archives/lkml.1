Return-Path: <linux-kernel-owner+w=401wt.eu-S933331AbYCFC2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbYCFC2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762285AbYCFCZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:25:03 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:61432 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761520AbYCFCZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:25:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HVEm4iuAx+aHaLQ2KPtt7aDh+QzKfufZRPUCThuUADXMhXBCdWi4kxPUt9bPdYtiB1mTEvQ5/07Bdf3WWO2YCVqGZdHRSrjEzL+EjSNZzd13aQ0Oq3lfzVxBxXjvxX55eB978Voj5a4ABrB4ZL1IenmXxQoWRt7s9F6NjODpQl0=
Subject: [PATCH 06/16] firmware: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Doug Warzecha <Douglas_Warzecha@dell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 18:24:54 -0800
Message-Id: <1204770294.14154.42.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/firmware/dcdbas.c   |   16 ++++++++--------
 drivers/firmware/dell_rbu.c |   12 ++++++------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 1636806..ce4f286 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -64,7 +64,7 @@ static void smi_data_buf_free(void)
 		return;
 
 	dev_dbg(&dcdbas_pdev->dev, "%s: phys: %x size: %lu\n",
-		__FUNCTION__, smi_data_buf_phys_addr, smi_data_buf_size);
+		__func__, smi_data_buf_phys_addr, smi_data_buf_size);
 
 	dma_free_coherent(&dcdbas_pdev->dev, smi_data_buf_size, smi_data_buf,
 			  smi_data_buf_handle);
@@ -93,7 +93,7 @@ static int smi_data_buf_realloc(unsigned long size)
 	if (!buf) {
 		dev_dbg(&dcdbas_pdev->dev,
 			"%s: failed to allocate memory size %lu\n",
-			__FUNCTION__, size);
+			__func__, size);
 		return -ENOMEM;
 	}
 	/* memory zeroed by dma_alloc_coherent */
@@ -111,7 +111,7 @@ static int smi_data_buf_realloc(unsigned long size)
 	smi_data_buf_size = size;
 
 	dev_dbg(&dcdbas_pdev->dev, "%s: phys: %x size: %lu\n",
-		__FUNCTION__, smi_data_buf_phys_addr, smi_data_buf_size);
+		__func__, smi_data_buf_phys_addr, smi_data_buf_size);
 
 	return 0;
 }
@@ -259,7 +259,7 @@ static int smi_request(struct smi_cmd *smi_cmd)
 
 	if (smi_cmd->magic != SMI_CMD_MAGIC) {
 		dev_info(&dcdbas_pdev->dev, "%s: invalid magic value\n",
-			 __FUNCTION__);
+			 __func__);
 		return -EBADR;
 	}
 
@@ -268,7 +268,7 @@ static int smi_request(struct smi_cmd *smi_cmd)
 	set_cpus_allowed(current, cpumask_of_cpu(0));
 	if (smp_processor_id() != 0) {
 		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
-			__FUNCTION__);
+			__func__);
 		ret = -EBUSY;
 		goto out;
 	}
@@ -429,7 +429,7 @@ static int host_control_smi(void)
 
 	default:
 		dev_dbg(&dcdbas_pdev->dev, "%s: invalid SMI type %u\n",
-			__FUNCTION__, host_control_smi_type);
+			__func__, host_control_smi_type);
 		return -ENOSYS;
 	}
 
@@ -457,13 +457,13 @@ static void dcdbas_host_control(void)
 	host_control_action = HC_ACTION_NONE;
 
 	if (!smi_data_buf) {
-		dev_dbg(&dcdbas_pdev->dev, "%s: no SMI buffer\n", __FUNCTION__);
+		dev_dbg(&dcdbas_pdev->dev, "%s: no SMI buffer\n", __func__);
 		return;
 	}
 
 	if (smi_data_buf_size < sizeof(struct apm_cmd)) {
 		dev_dbg(&dcdbas_pdev->dev, "%s: SMI buffer too small\n",
-			__FUNCTION__);
+			__func__);
 		return;
 	}
 
diff --git a/drivers/firmware/dell_rbu.c b/drivers/firmware/dell_rbu.c
index 477a3d0..6a8b1e0 100644
--- a/drivers/firmware/dell_rbu.c
+++ b/drivers/firmware/dell_rbu.c
@@ -123,7 +123,7 @@ static int create_packet(void *data, size_t length)
 	if (!newpacket) {
 		printk(KERN_WARNING
 			"dell_rbu:%s: failed to allocate new "
-			"packet\n", __FUNCTION__);
+			"packet\n", __func__);
 		retval = -ENOMEM;
 		spin_lock(&rbu_data.lock);
 		goto out_noalloc;
@@ -152,7 +152,7 @@ static int create_packet(void *data, size_t length)
 		printk(KERN_WARNING
 			"dell_rbu:%s: failed to allocate "
 			"invalid_addr_packet_array \n",
-			__FUNCTION__);
+			__func__);
 		retval = -ENOMEM;
 		spin_lock(&rbu_data.lock);
 		goto out_alloc_packet;
@@ -164,7 +164,7 @@ static int create_packet(void *data, size_t length)
 		if (!packet_data_temp_buf) {
 			printk(KERN_WARNING
 				"dell_rbu:%s: failed to allocate new "
-				"packet\n", __FUNCTION__);
+				"packet\n", __func__);
 			retval = -ENOMEM;
 			spin_lock(&rbu_data.lock);
 			goto out_alloc_packet_array;
@@ -416,7 +416,7 @@ static int img_update_realloc(unsigned long size)
 		 */
 		if ((size != 0) && (rbu_data.image_update_buffer == NULL)) {
 			printk(KERN_ERR "dell_rbu:%s: corruption "
-				"check failed\n", __FUNCTION__);
+				"check failed\n", __func__);
 			return -EINVAL;
 		}
 		/*
@@ -642,7 +642,7 @@ static ssize_t write_rbu_image_type(struct kobject *kobj,
 			if (req_firm_rc) {
 				printk(KERN_ERR
 					"dell_rbu:%s request_firmware_nowait"
-					" failed %d\n", __FUNCTION__, rc);
+					" failed %d\n", __func__, rc);
 				rc = -EIO;
 			} else
 				rbu_data.entry_created = 1;
@@ -718,7 +718,7 @@ static int __init dcdrbu_init(void)
 	if (IS_ERR(rbu_device)) {
 		printk(KERN_ERR
 			"dell_rbu:%s:platform_device_register_simple "
-			"failed\n", __FUNCTION__);
+			"failed\n", __func__);
 		return PTR_ERR(rbu_device);
 	}
 
-- 
1.5.4.GIT


