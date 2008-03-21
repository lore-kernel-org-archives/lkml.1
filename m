Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbYCUVCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbYCUVCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbYCUVC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:02:26 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:5780 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbYCUVCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:02:25 -0400
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 21 Mar 2008 14:02:21 -0700
Message-ID: <adabq57x02q.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Mar 2008 21:02:24.0057 (UTC) FILETIME=[DC7CA290:01C88B96]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

Chien Tung (1):
      RDMA/nes: Fix MSS calculation on RDMA path

 drivers/infiniband/hw/nes/nes_cm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 39adb26..0bef878 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -40,6 +40,7 @@
 #include <linux/tcp.h>
 #include <linux/init.h>
 #include <linux/if_arp.h>
+#include <linux/if_vlan.h>
 #include <linux/notifier.h>
 #include <linux/net.h>
 #include <linux/types.h>
@@ -1072,7 +1073,7 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 	ts = current_kernel_time();
 	cm_node->tcp_cntxt.loc_seq_num = htonl(ts.tv_nsec);
 	cm_node->tcp_cntxt.mss = nesvnic->max_frame_size - sizeof(struct iphdr) -
-			sizeof(struct tcphdr) - ETH_HLEN;
+			sizeof(struct tcphdr) - ETH_HLEN - VLAN_HLEN;
 	cm_node->tcp_cntxt.rcv_nxt = 0;
 	/* get a unique session ID , add thread_id to an upcounter to handle race */
 	atomic_inc(&cm_core->node_cnt);
