Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbYLYOem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbYLYOem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYLYOe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:34:29 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:51795 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbYLYOe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:34:28 -0500
Date: Thu, 25 Dec 2008 15:34:25 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: v4l-dvb-maintainer@linuxtv.org, stefanr@s5r6.in-berlin.de,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/7] drivers/media/dvb/firesat: Use DEFINE_SPINLOCK
Message-ID: <Pine.LNX.4.64.0812251534060.22039@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

SPIN_LOCK_UNLOCKED is deprecated.  The following makes the change suggested
in Documentation/spinlocks.txt

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
declarer name DEFINE_SPINLOCK;
identifier xxx_lock;
@@

- spinlock_t xxx_lock = SPIN_LOCK_UNLOCKED;
+ DEFINE_SPINLOCK(xxx_lock);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
diff -u -p a/drivers/media/dvb/firesat/firesat_1394.c b/drivers/media/dvb/firesat/firesat_1394.c
--- a/drivers/media/dvb/firesat/firesat_1394.c
+++ b/drivers/media/dvb/firesat/firesat_1394.c
@@ -94,7 +94,7 @@ MODULE_DEVICE_TABLE(ieee1394, firesat_id
 
 /* list of all firesat devices */
 LIST_HEAD(firesat_list);
-spinlock_t firesat_list_lock = SPIN_LOCK_UNLOCKED;
+DEFINE_SPINLOCK(firesat_list_lock);
 
 static void fcp_request(struct hpsb_host *host,
 			int nodeid,
