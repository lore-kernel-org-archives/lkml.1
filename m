Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab0BJJ1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:27:23 -0500
Received: from palm.sejo.be ([86.39.155.213]:60682 "EHLO palm.sejo.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab0BJJ0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:26:16 -0500
From: Jochen Maes <jochen.maes@sejo.be>
To: gregkh@suse.de
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
       Jochen Maes <jochen.maes@sejo.be>
Subject: [PATCH 3/3] drivers: dream: Codestyle patch
Date: Wed, 10 Feb 2010 10:27:14 +0100
Message-Id: <1265794034-17022-1-git-send-email-jochen.maes@sejo.be>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed code style issues.

Signed-off-by: Jochen Maes <jochen.maes@sejo.be>
---
 drivers/staging/dream/camera/msm_camera.c |   63 ++++++++++++++---------------
 1 files changed, 30 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/dream/camera/msm_camera.c b/drivers/staging/dream/camera/msm_camera.c
index 7d93877..3298ed4 100644
--- a/drivers/staging/dream/camera/msm_camera.c
+++ b/drivers/staging/dream/camera/msm_camera.c
@@ -2,7 +2,7 @@
  * Copyright (C) 2008-2009 QUALCOMM Incorporated.
  */
 
-//FIXME: most allocations need not be GFP_ATOMIC
+/* FIXME: most allocations need not be GFP_ATOMIC
 /* FIXME: management of mutexes */
 /* FIXME: msm_pmem_region_lookup return values */
 /* FIXME: way too many copy to/from user */
@@ -76,14 +76,14 @@ static LIST_HEAD(msm_sensors);
 		list_del_init(&qcmd->list);			\
 		kfree(qcmd);					\
 	};							\
-} while(0)
+} while (0)
 
 #define MSM_DRAIN_QUEUE(sync, name) do {			\
 	unsigned long flags;					\
 	spin_lock_irqsave(&(sync)->name##_lock, flags);		\
 	MSM_DRAIN_QUEUE_NOSYNC(sync, name);			\
 	spin_unlock_irqrestore(&(sync)->name##_lock, flags);	\
-} while(0)
+} while (0)
 
 static int check_overlap(struct hlist_head *ptype,
 			unsigned long paddr,
@@ -361,7 +361,7 @@ static int __msm_get_frame(struct msm_sync *sync,
 	if (!frame->buffer) {
 		pr_err("%s: cannot get frame, invalid lookup address "
 			"y=%x cbcr=%x offset=%d\n",
-			__FUNCTION__,
+			__func__,
 			pphy->y_phy,
 			pphy->cbcr_phy,
 			frame->y_off);
@@ -455,7 +455,7 @@ static int msm_disable_vfe(struct msm_sync *sync, void __user *arg)
 	return rc;
 }
 
-static struct msm_queue_cmd* __msm_control(struct msm_sync *sync,
+static struct msm_queue_cmd *__msm_control(struct msm_sync *sync,
 		struct msm_control_device_queue *queue,
 		struct msm_queue_cmd *qcmd,
 		int timeout)
@@ -592,8 +592,7 @@ end:
 	 * a result of a successful completion, we are freeing the qcmd that
 	 * we dequeued from queue->ctrl_status_q.
 	 */
-	if (qcmd)
-		kfree(qcmd);
+	kfree(qcmd);
 
 	CDBG("msm_control: end rc = %d\n", rc);
 	return rc;
@@ -670,7 +669,7 @@ static int msm_get_stats(struct msm_sync *sync, void __user *arg)
 					&(stats.fd));
 			if (!stats.buffer) {
 				pr_err("%s: msm_pmem_stats_ptov_lookup error\n",
-					__FUNCTION__);
+					__func__);
 				rc = -EINVAL;
 				goto failure;
 			}
@@ -718,8 +717,7 @@ static int msm_get_stats(struct msm_sync *sync, void __user *arg)
 					buf.fmain.buffer =
 						(unsigned long)region.vaddr;
 					buf.fmain.fd = region.fd;
-				}
-				else {
+				} else {
 					pr_err("%s: pmem lookup failed\n",
 						__func__);
 					rc = -EINVAL;
@@ -796,8 +794,7 @@ static int msm_get_stats(struct msm_sync *sync, void __user *arg)
 	}
 
 failure:
-	if (qcmd)
-		kfree(qcmd);
+	kfree(qcmd);
 
 	CDBG("msm_get_stats: %d\n", rc);
 	return rc;
@@ -838,8 +835,8 @@ static int msm_ctrl_cmd_done(struct msm_control_device *ctrl_pmsm,
 			kfree(qcmd);
 			goto end;
 		}
-	}
-	else ctrlcmd->value = NULL;
+	} else
+		ctrlcmd->value = NULL;
 
 end:
 	CDBG("msm_ctrl_cmd_done: end rc = %d\n", rc);
@@ -869,14 +866,14 @@ static int msm_config_vfe(struct msm_sync *sync, void __user *arg)
 		return -EFAULT;
 	}
 
-	switch(cfgcmd.cmd_type) {
+	switch (cfgcmd.cmd_type) {
 	case CMD_STATS_ENABLE:
 		axi_data.bufnum1 =
 			msm_pmem_region_lookup(&sync->stats,
 					MSM_PMEM_AEC_AWB, &region[0],
 					NUM_WB_EXP_STAT_OUTPUT_BUFFERS);
 		if (!axi_data.bufnum1) {
-			pr_err("%s: pmem region lookup error\n", __FUNCTION__);
+			pr_err("%s: pmem region lookup error\n", __func__);
 			return -EINVAL;
 		}
 		axi_data.region = &region[0];
@@ -888,7 +885,7 @@ static int msm_config_vfe(struct msm_sync *sync, void __user *arg)
 					MSM_PMEM_AF, &region[0],
 					NUM_AF_STAT_OUTPUT_BUFFERS);
 		if (!axi_data.bufnum1) {
-			pr_err("%s: pmem region lookup error\n", __FUNCTION__);
+			pr_err("%s: pmem region lookup error\n", __func__);
 			return -EINVAL;
 		}
 		axi_data.region = &region[0];
@@ -899,7 +896,7 @@ static int msm_config_vfe(struct msm_sync *sync, void __user *arg)
 		break;
 	default:
 		pr_err("%s: unknown command type %d\n",
-			__FUNCTION__, cfgcmd.cmd_type);
+			__func__, cfgcmd.cmd_type);
 		return -EINVAL;
 	}
 
@@ -928,7 +925,7 @@ static int msm_frame_axi_cfg(struct msm_sync *sync,
 			msm_pmem_region_lookup(&sync->frame, pmem_type,
 				&region[0], 8);
 		if (!axi_data.bufnum1) {
-			pr_err("%s: pmem region lookup error\n", __FUNCTION__);
+			pr_err("%s: pmem region lookup error\n", __func__);
 			return -EINVAL;
 		}
 		break;
@@ -939,7 +936,7 @@ static int msm_frame_axi_cfg(struct msm_sync *sync,
 			msm_pmem_region_lookup(&sync->frame, pmem_type,
 				&region[0], 8);
 		if (!axi_data.bufnum2) {
-			pr_err("%s: pmem region lookup error\n", __FUNCTION__);
+			pr_err("%s: pmem region lookup error\n", __func__);
 			return -EINVAL;
 		}
 		break;
@@ -950,7 +947,7 @@ static int msm_frame_axi_cfg(struct msm_sync *sync,
 			msm_pmem_region_lookup(&sync->frame, pmem_type,
 				&region[0], 8);
 		if (!axi_data.bufnum1) {
-			pr_err("%s: pmem region lookup error\n", __FUNCTION__);
+			pr_err("%s: pmem region lookup error\n", __func__);
 			return -EINVAL;
 		}
 
@@ -959,7 +956,7 @@ static int msm_frame_axi_cfg(struct msm_sync *sync,
 			msm_pmem_region_lookup(&sync->frame, pmem_type,
 				&region[axi_data.bufnum1], 8);
 		if (!axi_data.bufnum2) {
-			pr_err("%s: pmem region lookup error\n", __FUNCTION__);
+			pr_err("%s: pmem region lookup error\n", __func__);
 			return -EINVAL;
 		}
 		break;
@@ -970,7 +967,7 @@ static int msm_frame_axi_cfg(struct msm_sync *sync,
 			msm_pmem_region_lookup(&sync->frame, pmem_type,
 				&region[0], 8);
 		if (!axi_data.bufnum2) {
-			pr_err("%s: pmem region lookup error\n", __FUNCTION__);
+			pr_err("%s: pmem region lookup error\n", __func__);
 			return -EINVAL;
 		}
 		break;
@@ -981,7 +978,7 @@ static int msm_frame_axi_cfg(struct msm_sync *sync,
 
 	default:
 		pr_err("%s: unknown command type %d\n",
-			__FUNCTION__, cfgcmd->cmd_type);
+			__func__, cfgcmd->cmd_type);
 		return -EINVAL;
 	}
 
@@ -1047,7 +1044,7 @@ static int __msm_put_frame_buf(struct msm_sync *sync,
 			rc = sync->vfefn.vfe_config(&cfgcmd, &pphy);
 	} else {
 		pr_err("%s: msm_pmem_frame_vtop_lookup failed\n",
-			__FUNCTION__);
+			__func__);
 		rc = -EINVAL;
 	}
 
@@ -1131,7 +1128,7 @@ static int msm_stats_axi_cfg(struct msm_sync *sync,
 		break;
 	default:
 		pr_err("%s: unknown command type %d\n",
-			__FUNCTION__, cfgcmd->cmd_type);
+			__func__, cfgcmd->cmd_type);
 		return -EINVAL;
 	}
 
@@ -1140,7 +1137,7 @@ static int msm_stats_axi_cfg(struct msm_sync *sync,
 			msm_pmem_region_lookup(&sync->stats, pmem_type,
 				&region[0], NUM_WB_EXP_STAT_OUTPUT_BUFFERS);
 		if (!axi_data.bufnum1) {
-			pr_err("%s: pmem region lookup error\n", __FUNCTION__);
+			pr_err("%s: pmem region lookup error\n", __func__);
 			return -EINVAL;
 		}
 		axi_data.region = &region[0];
@@ -1177,7 +1174,7 @@ static int msm_put_stats_buffer(struct msm_sync *sync, void __user *arg)
 			cfgcmd.cmd_type = CMD_STATS_AF_BUF_RELEASE;
 		else {
 			pr_err("%s: invalid buf type %d\n",
-				__FUNCTION__,
+				__func__,
 				buf.type);
 			rc = -EINVAL;
 			goto put_done;
@@ -1223,7 +1220,7 @@ static int msm_axi_config(struct msm_sync *sync, void __user *arg)
 
 	default:
 		pr_err("%s: unknown command type %d\n",
-			__FUNCTION__,
+			__func__,
 			cfgcmd.cmd_type);
 		return -EINVAL;
 	}
@@ -1622,7 +1619,7 @@ static int msm_release_control(struct inode *node, struct file *filep)
 	int rc;
 	struct msm_control_device *ctrl_pmsm = filep->private_data;
 	struct msm_device *pmsm = ctrl_pmsm->pmsm;
-	printk("msm_camera: RELEASE %s\n", filep->f_path.dentry->d_name.name);
+	printk(KERN_INFO "msm_camera: RELEASE %s\n", filep->f_path.dentry->d_name.name);
 	rc = __msm_release(pmsm->sync);
 	if (!rc) {
 		MSM_DRAIN_QUEUE(&ctrl_pmsm->ctrl_q, ctrl_status_q);
@@ -1636,7 +1633,7 @@ static int msm_release_frame(struct inode *node, struct file *filep)
 {
 	int rc;
 	struct msm_device *pmsm = filep->private_data;
-	printk("msm_camera: RELEASE %s\n", filep->f_path.dentry->d_name.name);
+	printk(KERN_INFO "msm_camera: RELEASE %s\n", filep->f_path.dentry->d_name.name);
 	rc = __msm_release(pmsm->sync);
 	if (!rc) {
 		MSM_DRAIN_QUEUE(pmsm->sync, prev_frame_q);
@@ -1720,7 +1717,7 @@ static void msm_vfe_sync(struct msm_vfe_resp *vdata,
 	qcmd->type = qtype;
 
 	if (qtype == MSM_CAM_Q_VFE_MSG) {
-		switch(vdata->type) {
+		switch (vdata->type) {
 		case VFE_MSG_OUTPUT1:
 		case VFE_MSG_OUTPUT2:
 			qcmd_frame =
@@ -1929,7 +1926,7 @@ static int __msm_v4l2_control(struct msm_sync *sync,
 	memcpy(out->value, ctrl->value, ctrl->length);
 
 end:
-	if (rcmd) kfree(rcmd);
+	kfree(rcmd);
 	CDBG("__msm_v4l2_control: end rc = %d\n", rc);
 	return rc;
 }
-- 
1.6.6

