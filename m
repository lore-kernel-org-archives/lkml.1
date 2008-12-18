Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752509AbYLRPq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbYLRPq7 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 10:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYLRPqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 10:46:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:55369 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbYLRPql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 10:46:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UTZtRadUNPsDZunU2RULOke3Z+6sHi7JpN4kLkxxMUgBqvv51zjdY3SbZyPh9lr7tS
         rs4DhE0T1+x82LLJhcJP5bA2tNYQ4uAA2HLSTOOTBk1+o6El0YbMO0YylTzeKNAX+5LB
         XpQvftxBcK80xZt7LLUtV86W2gn7P1/YPxNOI=
Date: Thu, 18 Dec 2008 18:46:36 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, NKML <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH] net: ppp_generic - use DEFINE_IDR for static initialization
Message-ID: <20081218154636.GB12874@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please review.

---
>From 17bbdd601fc1be761876165488879def4649c968 Mon Sep 17 00:00:00 2001
From: Cyrill Gorcunov <gorcunov@openvz.org>
Date: Thu, 18 Dec 2008 18:41:42 +0300
Subject: [PATCH] net: ppp_generic - use DEFINE_IDR for static initialization

We could use DEFINE_IDR for statically allocated idr
that allow us to save a few lines of code.

And spell fix.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: David Miller <davem@davemloft.net>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 drivers/net/ppp_generic.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
index 293e1c4..b13e600 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -178,7 +178,7 @@ struct channel {
  */
 static DEFINE_MUTEX(all_ppp_mutex);
 static atomic_t ppp_unit_count = ATOMIC_INIT(0);
-static struct idr ppp_units_idr;
+static DEFINE_IDR(ppp_units_idr);
 
 /*
  * all_channels_lock protects all_channels and last_channel_index,
@@ -841,8 +841,6 @@ static int __init ppp_init(void)
 		device_create(ppp_class, NULL, MKDEV(PPP_MAJOR, 0), "ppp");
 	}
 
-	idr_init(&ppp_units_idr);
-
 out:
 	if (err)
 		printk(KERN_ERR "failed to register PPP device (%d)\n", err);
@@ -2426,7 +2424,7 @@ ppp_create_interface(int unit, int *retp)
 		if (unit_find(&ppp_units_idr, unit))
 			goto out2; /* unit already exists */
 		else {
-			/* darn, someone is cheatting us? */
+			/* darn, someone is cheating us? */
 			*retp = -EINVAL;
 			goto out2;
 		}
-- 
1.6.0.4.603.gbc9c0

