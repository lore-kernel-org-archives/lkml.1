Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZKCE2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZKCE2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbZKCE2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:28:03 -0500
Received: from ozlabs.org ([203.10.76.45]:39478 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853AbZKCE2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:28:02 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911031458.05663.rusty@rustcorp.com.au>
Date: Tue, 3 Nov 2009 14:58:05 +1030
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Robert Love <robert.w.love@intel.com>,
       Chris Leech <christopher.leech@intel.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 9/14] cpumask: use modern cpumask style in drivers/scsi/fcoe/fcoe.c
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Chris Leech <christopher.leech@intel.com>
Cc: linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Chris Leech <christopher.leech@intel.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/fcoe/fcoe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1047,7 +1047,7 @@ int fcoe_rcv(struct sk_buff *skb, struct
 				"CPU.\n");
 
 		spin_unlock_bh(&fps->fcoe_rx_list.lock);
-		cpu = first_cpu(cpu_online_map);
+		cpu = cpumask_first(cpu_online_mask);
 		fps = &per_cpu(fcoe_percpu, cpu);
 		spin_lock_bh(&fps->fcoe_rx_list.lock);
 		if (!fps->thread) {

