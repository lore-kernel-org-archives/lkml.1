Return-Path: <linux-kernel-owner+w=401wt.eu-S1763224AbYCDDQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763224AbYCDDQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759315AbYCDDKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:10:36 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:38813 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758865AbYCDDKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:10:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=v+hE78aL5qL9qf9w7xg+zw0n19oA8XS2bRjuzOGG3UL+K/6wCMuOnpihbyzvqgrV68kdioIf+7HWUpJeGeZXDCvyuSWuFv3l8dVrXQ9QJVReM+Zr6a3QNsb+UC07DqAy3perDHvlg1jh97E43QifiX6Ux0xKtzKIWAO8Jq/tCcM=
Subject: [PATCH 14/14] fusion: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Eric Moore <Eric.Moore@lsi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 19:09:56 -0800
Message-Id: <1204600196.22933.94.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/message/fusion/mptbase.c  |   18 ++++++------
 drivers/message/fusion/mptctl.c   |    4 +-
 drivers/message/fusion/mptfc.c    |    8 +++---
 drivers/message/fusion/mptlan.c   |   26 +++++++++---------
 drivers/message/fusion/mptsas.c   |   54 ++++++++++++++++++------------------
 drivers/message/fusion/mptscsih.c |    4 +-
 6 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 6b6df86..89d0311 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -307,7 +307,7 @@ mpt_turbo_reply(MPT_ADAPTER *ioc, u32 pa)
 	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS ||
 		MptCallbacks[cb_idx] == NULL) {
 		printk(MYIOC_s_WARN_FMT "%s: Invalid cb_idx (%d)!\n",
-				__FUNCTION__, ioc->name, cb_idx);
+				__func__, ioc->name, cb_idx);
 		goto out;
 	}
 
@@ -371,7 +371,7 @@ mpt_reply(MPT_ADAPTER *ioc, u32 pa)
 	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS ||
 		MptCallbacks[cb_idx] == NULL) {
 		printk(MYIOC_s_WARN_FMT "%s: Invalid cb_idx (%d)!\n",
-				__FUNCTION__, ioc->name, cb_idx);
+				__func__, ioc->name, cb_idx);
 		freeme = 0;
 		goto out;
 	}
@@ -2299,7 +2299,7 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 
 	if (ioc->cached_fw != NULL) {
 		ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: Pushing FW onto "
-		    "adapter\n", __FUNCTION__, ioc->name));
+		    "adapter\n", __func__, ioc->name));
 		if ((ret = mpt_downloadboot(ioc, (MpiFwHeader_t *)
 		    ioc->cached_fw, CAN_SLEEP)) < 0) {
 			printk(MYIOC_s_WARN_FMT
@@ -3558,7 +3558,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 
 	if (ioc->pcidev->device == MPI_MANUFACTPAGE_DEVID_SAS1078) {
 		drsprintk(ioc, printk(MYIOC_s_WARN_FMT "%s: Doorbell=%p; 1078 reset "
-			"address=%p\n",  ioc->name, __FUNCTION__,
+			"address=%p\n",  ioc->name, __func__,
 			&ioc->chip->Doorbell, &ioc->chip->Reset_1078));
 		CHIPREG_WRITE32(&ioc->chip->Reset_1078, 0x07);
 		if (sleepFlag == CAN_SLEEP)
@@ -4607,12 +4607,12 @@ mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode)
 		break;
 	}
 
-	printk("%s: persist_opcode=%x\n",__FUNCTION__, persist_opcode);
+	printk("%s: persist_opcode=%x\n",__func__, persist_opcode);
 
 	/* Get a MF for this command.
 	 */
 	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
-		printk("%s: no msg frames!\n",__FUNCTION__);
+		printk("%s: no msg frames!\n",__func__);
 		return -1;
         }
 
@@ -4636,13 +4636,13 @@ mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode)
 	    (SasIoUnitControlReply_t *)ioc->persist_reply_frame;
 	if (le16_to_cpu(sasIoUnitCntrReply->IOCStatus) != MPI_IOCSTATUS_SUCCESS) {
 		printk("%s: IOCStatus=0x%X IOCLogInfo=0x%X\n",
-		    __FUNCTION__,
+		    __func__,
 		    sasIoUnitCntrReply->IOCStatus,
 		    sasIoUnitCntrReply->IOCLogInfo);
 		return -1;
 	}
 
-	printk("%s: success\n",__FUNCTION__);
+	printk("%s: success\n",__func__);
 	return 0;
 }
 
@@ -5649,7 +5649,7 @@ SendEventAck(MPT_ADAPTER *ioc, EventNotificationReply_t *evnp)
 
 	if ((pAck = (EventAck_t *) mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, no msg frames!!\n",
-		    ioc->name,__FUNCTION__));
+		    ioc->name,__func__));
 		return -1;
 	}
 
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index e630b50..adedac2 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -505,7 +505,7 @@ mptctl_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
 	event = le32_to_cpu(pEvReply->Event) & 0xFF;
 
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s() called\n",
-	    ioc->name, __FUNCTION__));
+	    ioc->name, __func__));
 	if(async_queue == NULL)
 		return 1;
 
@@ -2478,7 +2478,7 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 	 */
 	if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, no msg frames!!\n",
-		    ioc->name,__FUNCTION__));
+		    ioc->name,__func__));
 		goto out;
 	}
 
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 3cdd4e9..b3617a1 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -231,28 +231,28 @@ static int
 mptfc_abort(struct scsi_cmnd *SCpnt)
 {
 	return
-	    mptfc_block_error_handler(SCpnt, mptscsih_abort, __FUNCTION__);
+	    mptfc_block_error_handler(SCpnt, mptscsih_abort, __func__);
 }
 
 static int
 mptfc_dev_reset(struct scsi_cmnd *SCpnt)
 {
 	return
-	    mptfc_block_error_handler(SCpnt, mptscsih_dev_reset, __FUNCTION__);
+	    mptfc_block_error_handler(SCpnt, mptscsih_dev_reset, __func__);
 }
 
 static int
 mptfc_bus_reset(struct scsi_cmnd *SCpnt)
 {
 	return
-	    mptfc_block_error_handler(SCpnt, mptscsih_bus_reset, __FUNCTION__);
+	    mptfc_block_error_handler(SCpnt, mptscsih_bus_reset, __func__);
 }
 
 static int
 mptfc_host_reset(struct scsi_cmnd *SCpnt)
 {
 	return
-	    mptfc_block_error_handler(SCpnt, mptscsih_host_reset, __FUNCTION__);
+	    mptfc_block_error_handler(SCpnt, mptscsih_host_reset, __func__);
 }
 
 static void
diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index 7950fc6..df207c2 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -610,7 +610,7 @@ mpt_lan_send_turbo(struct net_device *dev, u32 tmsg)
 
 	dioprintk((KERN_INFO MYNAM ": %s/%s: @%s, skb %p sent.\n",
 			IOC_AND_NETDEV_NAMES_s_s(dev),
-			__FUNCTION__, sent));
+			__func__, sent));
 
 	priv->SendCtl[ctx].skb = NULL;
 	pci_unmap_single(mpt_dev->pcidev, priv->SendCtl[ctx].dma,
@@ -676,7 +676,7 @@ mpt_lan_send_reply(struct net_device *dev, LANSendReply_t *pSendRep)
 
 		dioprintk((KERN_INFO MYNAM ": %s/%s: @%s, skb %p sent.\n",
 				IOC_AND_NETDEV_NAMES_s_s(dev),
-				__FUNCTION__, sent));
+				__func__, sent));
 
 		priv->SendCtl[ctx].skb = NULL;
 		pci_unmap_single(mpt_dev->pcidev, priv->SendCtl[ctx].dma,
@@ -715,7 +715,7 @@ mpt_lan_sdu_send (struct sk_buff *skb, struct net_device *dev)
 	u16 cur_naa = 0x1000;
 
 	dioprintk((KERN_INFO MYNAM ": %s called, skb_addr = %p\n",
-			__FUNCTION__, skb));
+			__func__, skb));
 
 	spin_lock_irqsave(&priv->txfidx_lock, flags);
 	if (priv->mpt_txfidx_tail < 0) {
@@ -723,7 +723,7 @@ mpt_lan_sdu_send (struct sk_buff *skb, struct net_device *dev)
 		spin_unlock_irqrestore(&priv->txfidx_lock, flags);
 
 		printk (KERN_ERR "%s: no tx context available: %u\n",
-			__FUNCTION__, priv->mpt_txfidx_tail);
+			__func__, priv->mpt_txfidx_tail);
 		return 1;
 	}
 
@@ -733,7 +733,7 @@ mpt_lan_sdu_send (struct sk_buff *skb, struct net_device *dev)
 		spin_unlock_irqrestore(&priv->txfidx_lock, flags);
 
 		printk (KERN_ERR "%s: Unable to alloc request frame\n",
-			__FUNCTION__);
+			__func__);
 		return 1;
 	}
 
@@ -1208,7 +1208,7 @@ mpt_lan_post_receive_buckets(struct mpt_lan_priv *priv)
 
 	dioprintk((KERN_INFO MYNAM ": %s/%s: @%s, Start_buckets = %u, buckets_out = %u\n",
 			IOC_AND_NETDEV_NAMES_s_s(dev),
-			__FUNCTION__, buckets, curr));
+			__func__, buckets, curr));
 
 	max = (mpt_dev->req_sz - MPT_LAN_RECEIVE_POST_REQUEST_SIZE) /
 			(MPT_LAN_TRANSACTION32_SIZE + sizeof(SGESimple64_t));
@@ -1217,9 +1217,9 @@ mpt_lan_post_receive_buckets(struct mpt_lan_priv *priv)
 		mf = mpt_get_msg_frame(LanCtx, mpt_dev);
 		if (mf == NULL) {
 			printk (KERN_ERR "%s: Unable to alloc request frame\n",
-				__FUNCTION__);
+				__func__);
 			dioprintk((KERN_ERR "%s: %u buckets remaining\n",
-				 __FUNCTION__, buckets));
+				 __func__, buckets));
 			goto out;
 		}
 		pRecvReq = (LANReceivePostRequest_t *) mf;
@@ -1244,7 +1244,7 @@ mpt_lan_post_receive_buckets(struct mpt_lan_priv *priv)
 			spin_lock_irqsave(&priv->rxfidx_lock, flags);
 			if (priv->mpt_rxfidx_tail < 0) {
 				printk (KERN_ERR "%s: Can't alloc context\n",
-					__FUNCTION__);
+					__func__);
 				spin_unlock_irqrestore(&priv->rxfidx_lock,
 						       flags);
 				break;
@@ -1267,7 +1267,7 @@ mpt_lan_post_receive_buckets(struct mpt_lan_priv *priv)
 				if (skb == NULL) {
 					printk (KERN_WARNING
 						MYNAM "/%s: Can't alloc skb\n",
-						__FUNCTION__);
+						__func__);
 					priv->mpt_rxfidx[++priv->mpt_rxfidx_tail] = ctx;
 					spin_unlock_irqrestore(&priv->rxfidx_lock, flags);
 					break;
@@ -1305,7 +1305,7 @@ mpt_lan_post_receive_buckets(struct mpt_lan_priv *priv)
 
 		if (pSimple == NULL) {
 /**/			printk (KERN_WARNING MYNAM "/%s: No buckets posted\n",
-/**/				__FUNCTION__);
+/**/				__func__);
 			mpt_free_msg_frame(mpt_dev, mf);
 			goto out;
 		}
@@ -1329,9 +1329,9 @@ mpt_lan_post_receive_buckets(struct mpt_lan_priv *priv)
 
 out:
 	dioprintk((KERN_INFO MYNAM "/%s: End_buckets = %u, priv->buckets_out = %u\n",
-		  __FUNCTION__, buckets, atomic_read(&priv->buckets_out)));
+		  __func__, buckets, atomic_read(&priv->buckets_out)));
 	dioprintk((KERN_INFO MYNAM "/%s: Posted %u buckets and received %u back\n",
-	__FUNCTION__, priv->total_posted, priv->total_received));
+	__func__, priv->total_posted, priv->total_received));
 
 	clear_bit(0, &priv->post_buckets_active);
 }
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index f77b329..a03e83c 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -286,7 +286,7 @@ mptsas_port_delete(MPT_ADAPTER *ioc, struct mptsas_portinfo_details * port_detai
 	phy_info = port_info->phy_info;
 
 	dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: [%p]: num_phys=%02d "
-	    "bitmask=0x%016llX\n", ioc->name, __FUNCTION__, port_details,
+	    "bitmask=0x%016llX\n", ioc->name, __func__, port_details,
 	    port_details->num_phys, (unsigned long long)
 	    port_details->phy_bitmask));
 
@@ -397,7 +397,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 		 */
 		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "%s: [%p]: deleting phy = %d\n",
-		    ioc->name, __FUNCTION__, port_details, i));
+		    ioc->name, __func__, port_details, i));
 		port_details->num_phys--;
 		port_details->phy_bitmask &= ~ (1 << phy_info->phy_id);
 		memset(&phy_info->attached, 0, sizeof(struct mptsas_devinfo));
@@ -483,7 +483,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 			continue;
 		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "%s: [%p]: phy_id=%02d num_phys=%02d "
-		    "bitmask=0x%016llX\n", ioc->name, __FUNCTION__,
+		    "bitmask=0x%016llX\n", ioc->name, __func__,
 		    port_details, i, port_details->num_phys,
 		    (unsigned long long)port_details->phy_bitmask));
 		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\t\tport = %p rphy=%p\n",
@@ -539,7 +539,7 @@ mptsas_target_reset(MPT_ADAPTER *ioc, u8 channel, u8 id)
 
 	if ((mf = mpt_get_msg_frame(ioc->TaskCtx, ioc)) == NULL) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, no msg frames @%d!!\n",
-		    ioc->name,__FUNCTION__, __LINE__));
+		    ioc->name,__func__, __LINE__));
 		return 0;
 	}
 
@@ -592,7 +592,7 @@ mptsas_target_reset_queue(MPT_ADAPTER *ioc,
 	    GFP_ATOMIC);
 	if (!target_reset_list) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, failed to allocate mem @%d..!!\n",
-		    ioc->name,__FUNCTION__, __LINE__));
+		    ioc->name,__func__, __LINE__));
 		return;
 	}
 
@@ -659,7 +659,7 @@ mptsas_dev_reset_complete(MPT_ADAPTER *ioc)
 	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
 	if (!ev) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, failed to allocate mem @%d..!!\n",
-		    ioc->name,__FUNCTION__, __LINE__));
+		    ioc->name,__func__, __LINE__));
 		return;
 	}
 
@@ -1169,7 +1169,7 @@ static int mptsas_phy_reset(struct sas_phy *phy, int hard_reset)
 	reply = (SasIoUnitControlReply_t *)ioc->sas_mgmt.reply;
 	if (reply->IOCStatus != MPI_IOCSTATUS_SUCCESS) {
 		printk(MYIOC_s_INFO_FMT "%s: IOCStatus=0x%X IOCLogInfo=0x%X\n",
-		    ioc->name, __FUNCTION__, reply->IOCStatus, reply->IOCLogInfo);
+		    ioc->name, __func__, reply->IOCStatus, reply->IOCLogInfo);
 		error = -ENXIO;
 		goto out_unlock;
 	}
@@ -1256,14 +1256,14 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 	if (!rsp) {
 		printk(MYIOC_s_ERR_FMT "%s: the smp response space is missing\n",
-		    ioc->name, __FUNCTION__);
+		    ioc->name, __func__);
 		return -EINVAL;
 	}
 
 	/* do we need to support multiple segments? */
 	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
 		printk(MYIOC_s_ERR_FMT "%s: multiple segments req %u %u, rsp %u %u\n",
-		    ioc->name, __FUNCTION__, req->bio->bi_vcnt, req->data_len,
+		    ioc->name, __func__, req->bio->bi_vcnt, req->data_len,
 		    rsp->bio->bi_vcnt, rsp->data_len);
 		return -EINVAL;
 	}
@@ -1329,7 +1329,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 	timeleft = wait_for_completion_timeout(&ioc->sas_mgmt.done, 10 * HZ);
 	if (!timeleft) {
-		printk(MYIOC_s_ERR_FMT "%s: smp timeout!\n", ioc->name, __FUNCTION__);
+		printk(MYIOC_s_ERR_FMT "%s: smp timeout!\n", ioc->name, __func__);
 		/* On timeout reset the board */
 		mpt_HardResetHandler(ioc, CAN_SLEEP);
 		ret = -ETIMEDOUT;
@@ -1347,7 +1347,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		rsp->data_len -= smprep->ResponseDataLength;
 	} else {
 		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
-		    ioc->name, __FUNCTION__);
+		    ioc->name, __func__);
 		ret = -ENXIO;
 	}
 unmap:
@@ -1987,7 +1987,7 @@ static int mptsas_probe_one_phy(struct device *dev,
 			if (error) {
 				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 					"%s: exit at line=%d\n", ioc->name,
-					__FUNCTION__, __LINE__));
+					__func__, __LINE__));
 				goto out;
 			}
 			mptsas_set_port(ioc, phy_info, port);
@@ -2058,7 +2058,7 @@ static int mptsas_probe_one_phy(struct device *dev,
 		if (!rphy) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-				__FUNCTION__, __LINE__));
+				__func__, __LINE__));
 			goto out;
 		}
 
@@ -2067,7 +2067,7 @@ static int mptsas_probe_one_phy(struct device *dev,
 		if (error) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-				__FUNCTION__, __LINE__));
+				__func__, __LINE__));
 			sas_rphy_free(rphy);
 			goto out;
 		}
@@ -2596,7 +2596,7 @@ mptsas_hotplug_work(struct work_struct *work)
 				    (ev->channel << 8) + ev->id)) {
 					dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 					"%s: exit at line=%d\n", ioc->name,
-						__FUNCTION__, __LINE__));
+						__func__, __LINE__));
 					break;
 				}
 				phy_info = mptsas_find_phyinfo_by_sas_address(
@@ -2616,20 +2616,20 @@ mptsas_hotplug_work(struct work_struct *work)
 		if (!phy_info){
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-				__FUNCTION__, __LINE__));
+				__func__, __LINE__));
 			break;
 		}
 		if (!phy_info->port_details) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-			       	__FUNCTION__, __LINE__));
+			       	__func__, __LINE__));
 			break;
 		}
 		rphy = mptsas_get_rphy(phy_info);
 		if (!rphy) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-			       	__FUNCTION__, __LINE__));
+			       	__func__, __LINE__));
 			break;
 		}
 
@@ -2637,7 +2637,7 @@ mptsas_hotplug_work(struct work_struct *work)
 		if (!port) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-			       	__FUNCTION__, __LINE__));
+			       	__func__, __LINE__));
 			break;
 		}
 
@@ -2648,7 +2648,7 @@ mptsas_hotplug_work(struct work_struct *work)
 			if (!vtarget) {
 				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 					"%s: exit at line=%d\n", ioc->name,
-					__FUNCTION__, __LINE__));
+					__func__, __LINE__));
 				break;
 			}
 
@@ -2703,7 +2703,7 @@ mptsas_hotplug_work(struct work_struct *work)
 			(ev->channel << 8) + ev->id)) {
 				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 					"%s: exit at line=%d\n", ioc->name,
-					__FUNCTION__, __LINE__));
+					__func__, __LINE__));
 			break;
 		}
 
@@ -2715,7 +2715,7 @@ mptsas_hotplug_work(struct work_struct *work)
 		if (!phy_info || !phy_info->port_details) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-			       	__FUNCTION__, __LINE__));
+			       	__func__, __LINE__));
 			break;
 		}
 
@@ -2727,7 +2727,7 @@ mptsas_hotplug_work(struct work_struct *work)
 			if (!vtarget) {
 				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				    "%s: exit at line=%d\n", ioc->name,
-				    __FUNCTION__, __LINE__));
+				    __func__, __LINE__));
 				break;
 			}
 			/*
@@ -2750,7 +2750,7 @@ mptsas_hotplug_work(struct work_struct *work)
 		if (mptsas_get_rphy(phy_info)) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-			       	__FUNCTION__, __LINE__));
+			       	__func__, __LINE__));
 			if (ev->channel) printk("%d\n", __LINE__);
 			break;
 		}
@@ -2759,7 +2759,7 @@ mptsas_hotplug_work(struct work_struct *work)
 		if (!port) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-			       	__FUNCTION__, __LINE__));
+			       	__func__, __LINE__));
 			break;
 		}
 		memcpy(&phy_info->attached, &sas_device,
@@ -2784,7 +2784,7 @@ mptsas_hotplug_work(struct work_struct *work)
 		if (!rphy) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-			       	__FUNCTION__, __LINE__));
+			       	__func__, __LINE__));
 			break; /* non-fatal: an rphy can be added later */
 		}
 
@@ -2792,7 +2792,7 @@ mptsas_hotplug_work(struct work_struct *work)
 		if (sas_rphy_add(rphy)) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-			       	__FUNCTION__, __LINE__));
+			       	__func__, __LINE__));
 			sas_rphy_free(rphy);
 			break;
 		}
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 0c252f6..b5e2308 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -461,7 +461,7 @@ mptscsih_issue_sep_command(MPT_ADAPTER *ioc, VirtTarget *vtarget,
 
 	if ((mf = mpt_get_msg_frame(ioc->InternalCtx, ioc)) == NULL) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s: no msg frames!!\n",
-		    ioc->name,__FUNCTION__));
+		    ioc->name,__func__));
 		return;
 	}
 
@@ -2178,7 +2178,7 @@ mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *m
 				(ioc->debug_level & MPT_DEBUG_TM ))
 		printk("%s: ha=%d [%d:%d:0] task_type=0x%02X "
 			"iocstatus=0x%04X\n\tloginfo=0x%08X response_code=0x%02X "
-			"term_cmnds=%d\n", __FUNCTION__, ioc->id, pScsiTmReply->Bus,
+			"term_cmnds=%d\n", __func__, ioc->id, pScsiTmReply->Bus,
 			 pScsiTmReply->TargetID, pScsiTmReq->TaskType,
 			le16_to_cpu(pScsiTmReply->IOCStatus),
 			le32_to_cpu(pScsiTmReply->IOCLogInfo),pScsiTmReply->ResponseCode,
-- 
1.5.4.3.500.g83a2c

