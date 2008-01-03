Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbYACSaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbYACSaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 13:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbYACSaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 13:30:04 -0500
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:27169 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbYACSaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 13:30:01 -0500
X-IronPort-AV: E=Sophos;i="4.24,240,1196668800"; 
   d="scan'208";a="5659496"
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git for-linus
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 03 Jan 2008 10:29:51 -0800
Message-ID: <adak5mqu5i8.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Jan 2008 18:29:51.0956 (UTC) FILETIME=[A1305940:01C84E36]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will pull one fix for an oops caused by reloading the ib_srp module:

David Dillow (1):
      IB/srp: Fix list corruption/oops on module reload

 drivers/infiniband/ulp/srp/ib_srp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 950228f..77e8b90 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2054,6 +2054,7 @@ static void srp_remove_one(struct ib_device *device)
 		list_for_each_entry_safe(target, tmp_target,
 					 &host->target_list, list) {
 			scsi_remove_host(target->scsi_host);
+			srp_remove_host(target->scsi_host);
 			srp_disconnect_target(target);
 			ib_destroy_cm_id(target->cm_id);
 			srp_free_target_ib(target);
