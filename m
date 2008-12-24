Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbYLXPYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbYLXPYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 10:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbYLXPYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 10:24:10 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:50506 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbYLXPYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 10:24:08 -0500
Date: Wed, 24 Dec 2008 16:24:05 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/3] drivers/staging/rt2860,rt2870: Correct use of ! and &
Message-ID: <Pine.LNX.4.64.0812241623380.5475@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

IW_ENCODE_MODE is 0xF000 and thus !erq->flags & IW_ENCODE_MODE is always 0.
I assume that !(erq->flags & IW_ENCODE_MODE) was intended.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E; constant C; @@
(
  !E & !C
|
- !E & C
+ !(E & C)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/rt2860/sta_ioctl.c |    2 +-
 drivers/staging/rt2870/sta_ioctl.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/staging/rt2860/sta_ioctl.c b/drivers/staging/rt2860/sta_ioctl.c
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -1756,7 +1756,7 @@ int rt_ioctl_siwencode(struct net_device
             }
         else
 			/* Don't complain if only change the mode */
-			if(!erq->flags & IW_ENCODE_MODE) {
+			if (!(erq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 		}
 	}
diff -u -p a/drivers/staging/rt2870/sta_ioctl.c b/drivers/staging/rt2870/sta_ioctl.c
--- a/drivers/staging/rt2870/sta_ioctl.c
+++ b/drivers/staging/rt2870/sta_ioctl.c
@@ -1776,7 +1776,7 @@ int rt_ioctl_siwencode(struct net_device
             }
         else
 			/* Don't complain if only change the mode */
-			if(!erq->flags & IW_ENCODE_MODE) {
+			if (!(erq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 		}
 	}
