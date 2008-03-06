Return-Path: <linux-kernel-owner+w=401wt.eu-S1761219AbYCFRYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbYCFRYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYCFRYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:24:14 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:34226 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbYCFRYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:24:12 -0500
Date: Thu, 6 Mar 2008 18:24:05 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: starvik@axis.com, jesper.nilsson@axis.com, dev-etrax@axis.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] arch/cris: Use mutex_unlock rather than spin_unlock
Message-ID: <Pine.LNX.4.58.0803061823370.1669@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

It looks at least odd to apply spin_unlock to a mutex.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@def@
declarer DEFINE_MUTEX;
identifier m;
@@

DEFINE_MUTEX(m);

@@
identifier def.m;
@@

(
- spin_lock(&m)
+ mutex_lock(&m)
|
- spin_unlock(&m)
+ mutex_unlock(&m)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/cris/arch-v10/drivers/pcf8563.c |    2 +-
 arch/cris/arch-v32/drivers/pcf8563.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/arch/cris/arch-v10/drivers/pcf8563.c b/arch/cris/arch-v10/drivers/pcf8563.c
--- a/arch/cris/arch-v10/drivers/pcf8563.c 2008-02-10 22:34:04.000000000 +0100
+++ b/arch/cris/arch-v10/drivers/pcf8563.c 2008-03-05 22:06:18.000000000 +0100
@@ -233,7 +233,7 @@ int pcf8563_ioctl(struct inode *inode, s

 		if (copy_to_user((struct rtc_time *) arg, &tm,
 				 sizeof tm)) {
-			spin_unlock(&rtc_lock);
+			mutex_unlock(&rtc_lock);
 			return -EFAULT;
 		}

diff -u -p a/arch/cris/arch-v32/drivers/pcf8563.c b/arch/cris/arch-v32/drivers/pcf8563.c
--- a/arch/cris/arch-v32/drivers/pcf8563.c 2008-02-10 22:34:04.000000000 +0100
+++ b/arch/cris/arch-v32/drivers/pcf8563.c 2008-03-05 22:06:18.000000000 +0100
@@ -229,7 +229,7 @@ int pcf8563_ioctl(struct inode *inode, s

 		if (copy_to_user((struct rtc_time *) arg, &tm,
 				 sizeof tm)) {
-			spin_unlock(&rtc_lock);
+			mutex_unlock(&rtc_lock);
 			return -EFAULT;
 		}

