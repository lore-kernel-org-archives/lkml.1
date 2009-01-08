Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbZAHOxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbZAHOxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759087AbZAHOxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:53:31 -0500
Received: from relay1.sgi.com ([192.48.179.29]:39192 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757469AbZAHOxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:53:30 -0500
Date: Thu, 8 Jan 2009 08:53:29 -0600
From: Dean Nelson <dcn@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] sgi-xp: eliminate false detection of no heartbeat
Message-ID: <20090108145329.GA22609@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After XPC has been up and running on multiple partitions for any length of
time, if XPC on one of the partitions is stopped and restarted (either by a
rmmod/insmod or a system restart), it is possible for the XPCs running on
the other partitions to falsely detect a lack of heartbeat from the XPC that
was just restarted. This false detection will occur if the restarted XPC comes
up within the five-seconds preceding one of the other XPC's heartbeat check
(which occurs once every twenty seconds).

The detection of no heartbeat results in the detecting XPC deactivating from
the just restarted XPC. The only remedy is to restart one of the XPCs and
hope that one doesn't hit this five-second window on any of the other
partitions.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: stable <stable@kernel.org>

---

 drivers/misc/sgi-xp/xpc_sn2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-xp/xpc_sn2.c
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xpc_sn2.c	2008-12-30 12:01:18.000000000 -0600
+++ linux/drivers/misc/sgi-xp/xpc_sn2.c	2009-01-08 08:12:01.000000000 -0600
@@ -899,7 +899,7 @@ xpc_update_partition_info_sn2(struct xpc
 	dev_dbg(xpc_part, "  remote_vars_pa = 0x%016lx\n",
 		part_sn2->remote_vars_pa);
 
-	part->last_heartbeat = remote_vars->heartbeat;
+	part->last_heartbeat = remote_vars->heartbeat - 1;
 	dev_dbg(xpc_part, "  last_heartbeat = 0x%016lx\n",
 		part->last_heartbeat);
 
