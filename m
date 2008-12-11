Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbYLKXC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbYLKXC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 18:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbYLKXCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 18:02:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:55042 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699AbYLKXCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 18:02:42 -0500
Message-ID: <49419a3f.0710660a.4800.7087@mx.google.com>
To: netdev@vger.kernel.org
Cc: Karsten Keil <kkeil@suse.de>
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Thu, 11 Dec 2008 22:36:00 +0100
Subject: [PATCH 8/9][v2] mISDN: timerdev: use __user for mISDN_read's buffer argument
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this warning:

  drivers/isdn/mISDN/timerdev.c:264:11: warning: incorrect type in initializer (incompatible argument 2 (different address spaces))
  drivers/isdn/mISDN/timerdev.c:264:11:    expected int ( *read )( ... )
  drivers/isdn/mISDN/timerdev.c:264:11:    got int ( static [toplevel] *<noident> )( ... )

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Acked-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/mISDN/timerdev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/mISDN/timerdev.c b/drivers/isdn/mISDN/timerdev.c
index 62b5e49..f2b3218 100644
--- a/drivers/isdn/mISDN/timerdev.c
+++ b/drivers/isdn/mISDN/timerdev.c
@@ -86,7 +86,7 @@ mISDN_close(struct inode *ino, struct file *filep)
 }
 
 static ssize_t
-mISDN_read(struct file *filep, char *buf, size_t count, loff_t *off)
+mISDN_read(struct file *filep, char __user *buf, size_t count, loff_t *off)
 {
 	struct mISDNtimerdev	*dev = filep->private_data;
 	struct mISDNtimer	*timer;
@@ -116,7 +116,7 @@ mISDN_read(struct file *filep, char *buf, size_t count, loff_t *off)
 		timer = (struct mISDNtimer *)dev->expired.next;
 		list_del(&timer->list);
 		spin_unlock_irqrestore(&dev->lock, flags);
-		if (put_user(timer->id, (int *)buf))
+		if (put_user(timer->id, (int __user *)buf))
 			ret = -EFAULT;
 		else
 			ret = sizeof(int);
-- 
1.5.6.3

