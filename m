Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbYLYOfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbYLYOfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYLYOer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:34:47 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:51805 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbYLYOeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:34:46 -0500
Date: Thu, 25 Dec 2008 15:34:44 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: ds@schleef.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/7] drivers/staging/comedi: Use DEFINE_SPINLOCK
Message-ID: <Pine.LNX.4.64.0812251534260.22039@ask.diku.dk>
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
diff -u -p a/drivers/staging/comedi/rt_pend_tq.c b/drivers/staging/comedi/rt_pend_tq.c
--- a/drivers/staging/comedi/rt_pend_tq.c
+++ b/drivers/staging/comedi/rt_pend_tq.c
@@ -25,7 +25,7 @@ volatile static struct rt_pend_tq rt_pen
 volatile static struct rt_pend_tq *volatile rt_pend_head = rt_pend_tq,
 	*volatile rt_pend_tail = rt_pend_tq;
 int rt_pend_tq_irq = 0;
-spinlock_t rt_pend_tq_lock = SPIN_LOCK_UNLOCKED;
+DEFINE_SPINLOCK(rt_pend_tq_lock);
 
 // WARNING: following code not checked against race conditions yet.
 #define INC_CIRCULAR_PTR(ptr,begin,size) do {if(++(ptr)>=(begin)+(size)) (ptr)=(begin); } while(0)
