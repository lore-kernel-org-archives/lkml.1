Return-Path: <linux-kernel-owner+w=401wt.eu-S1763311AbZAORul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763311AbZAORul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760742AbZAORuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:50:03 -0500
Received: from relay3.sgi.com ([192.48.171.31]:46687 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759027AbZAORuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:50:00 -0500
Message-Id: <20090115174959.345025723@attica.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 15 Jan 2009 11:49:49 -0600
From: holt@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dcn@sgi.com, <stable@kernel.org>
Subject: [patch 1/3] sgi-xpc: ensure flags are updated before bte_copy
References: <20090115174948.731212661@attica.americas.sgi.com>
Content-Disposition: inline; filename=xpc-write-barrier
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Holt <holt@sgi.com>

The clearing of the msg->flags needs a barrier between it and the notify
of the channel threads that the messages are cleaned and ready for use.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: <stable@kernel.org>

---

 drivers/misc/sgi-xp/xpc_sn2.c |    1 +
 1 file changed, 1 insertion(+)
Index: xpc-fixes-20090115/drivers/misc/sgi-xp/xpc_sn2.c
===================================================================
--- xpc-fixes-20090115.orig/drivers/misc/sgi-xp/xpc_sn2.c	2009-01-15 10:21:53.700266968 -0600
+++ xpc-fixes-20090115/drivers/misc/sgi-xp/xpc_sn2.c	2009-01-15 10:51:10.165613058 -0600
@@ -1836,6 +1836,7 @@ xpc_process_msg_chctl_flags_sn2(struct x
 		 */
 		xpc_clear_remote_msgqueue_flags_sn2(ch);
 
+		wmb();	/* ensure flags have been cleared before bte_copy */
 		ch_sn2->w_remote_GP.put = ch_sn2->remote_GP.put;
 
 		dev_dbg(xpc_chan, "w_remote_GP.put changed to %ld, partid=%d, "

