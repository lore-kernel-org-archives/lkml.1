Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZG0UGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZG0UGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZG0UGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:06:38 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:50593 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbZG0UGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:06:37 -0400
Date: Mon, 27 Jul 2009 21:59:48 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/staging: Correct use of ! and &
Message-ID: <Pine.LNX.4.64.0907272159040.8135@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Correct priority problem in the use of ! and &.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E; constant C; @@
- !E & C
+ !(E & C)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/rt3090/sta_ioctl.c |    6 ++----
 drivers/staging/vt6656/iwctl.c     |    3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rt3090/sta_ioctl.c b/drivers/staging/rt3090/sta_ioctl.c
index 93efd7f..3ddc0f6 100644
--- a/drivers/staging/rt3090/sta_ioctl.c
+++ b/drivers/staging/rt3090/sta_ioctl.c
@@ -1840,10 +1840,8 @@ int rt_ioctl_siwencode(struct net_device *dev,
             }
         else
 			/* Don't complain if only change the mode */
-		if(!erq->flags & IW_ENCODE_MODE)
-		{
-				return -EINVAL;
-		}
+		if (!(erq->flags & IW_ENCODE_MODE))
+			return -EINVAL;
 	}
 
 done:
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index e4fdb6f..96f2a78 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1409,8 +1409,7 @@ int iwctl_siwencode(struct net_device *dev,
 		// Do we want to just set the transmit key index ?
 		if ( index < 4 ) {
 		    pDevice->byKeyIndex = index;
-		}
-		else if(!wrq->flags & IW_ENCODE_MODE) {
+		} else if (!(wrq->flags & IW_ENCODE_MODE)) {
 				rc = -EINVAL;
 				return rc;
 	    }
