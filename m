Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYGHVln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYGHVln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 17:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYGHVlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 17:41:36 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:51160 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYGHVlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 17:41:35 -0400
X-IronPort-AV: E=Sophos;i="4.30,326,1212364800"; 
   d="scan'208";a="17497289"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       steve@opengridcomputing.com
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Tue, 08 Jul 2008 14:41:29 -0700
Message-ID: <adaprporr3q.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Jul 2008 21:41:29.0755 (UTC) FILETIME=[61A87EB0:01C8E143]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a fix for one regression introduced earlier in the
2.6.26 cycle:

Steve Wise (1):
      RDMA/cxgb3: Fix regression caused by class_device -> device conversion

 drivers/infiniband/hw/cxgb3/iwch_provider.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 8934178..95f82cf 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1096,7 +1096,9 @@ static ssize_t show_fw_ver(struct device *dev, struct device_attribute *attr, ch
 	struct net_device *lldev = iwch_dev->rdev.t3cdev_p->lldev;
 
 	PDBG("%s dev 0x%p\n", __func__, dev);
+	rtnl_lock();
 	lldev->ethtool_ops->get_drvinfo(lldev, &info);
+	rtnl_unlock();
 	return sprintf(buf, "%s\n", info.fw_version);
 }
 
@@ -1109,7 +1111,9 @@ static ssize_t show_hca(struct device *dev, struct device_attribute *attr,
 	struct net_device *lldev = iwch_dev->rdev.t3cdev_p->lldev;
 
 	PDBG("%s dev 0x%p\n", __func__, dev);
+	rtnl_lock();
 	lldev->ethtool_ops->get_drvinfo(lldev, &info);
+	rtnl_unlock();
 	return sprintf(buf, "%s\n", info.driver);
 }
 
