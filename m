Return-Path: <linux-kernel-owner+w=401wt.eu-S2993231AbXDSLmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993231AbXDSLmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 07:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993234AbXDSLmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 07:42:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:29376 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993231AbXDSLmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 07:42:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ptDa83s6iefB0OvrcOAPGxzpo+qyLjH2iIcdjEwYxbm3/P8i1DY0mHhpAZhjk3Qb4jsf3ycAhWlrAeu05NH6KJwSgiDO5KMmAKsyjmWOzW5avDsMtIdloAh7wJ6f6xUOnIeQBwHitzAzS0mDdgpSQfc31S5P8fz6C9zQ6dRwQnM=
Date: Thu, 19 Apr 2007 17:14:44 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: Kernel Janitors <kernel-janitors@lists.osdl.org>,
       ALSA <alsa-devel@alsa-project.org>
Cc: Andrw Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, liam.girdwood@wolfsonmicro.com
Subject: [KJ][PATCH] sound: SPIN_LOCK_UNLOCKED cleanup
Message-ID: <20070419114444.GA12114@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED cleanup,use __SPIN_LOCK_UNLOCKED instead 

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---

 soc/at91/at91-i2s.c          |    6 +++---
 1 file changed, 3  insertions(+), 3 deletions(-)

diff --git a/sound/soc/at91/at91-i2s.c b/sound/soc/at91/at91-i2s.c
index 9fc0c03..d65a47d 100644
--- a/sound/soc/at91/at91-i2s.c
+++ b/sound/soc/at91/at91-i2s.c
@@ -151,20 +151,20 @@ static struct at91_ssc_info {
 } ssc_info[NUM_SSC_DEVICES] = {
 	{
 	.name		= "ssc0",
-	.lock		= SPIN_LOCK_UNLOCKED,
+	.lock		= __SPIN_LOCK_UNLOCKED(ssc_info[0].lock),
 	.dir_mask	= 0,
 	.initialized	= 0,
 	},
 #if NUM_SSC_DEVICES == 3
 	{
 	.name		= "ssc1",
-	.lock		= SPIN_LOCK_UNLOCKED,
+	.lock		= __SPIN_LOCK_UNLOCKED(ssc_info[1].lock),
 	.dir_mask	= 0,
 	.initialized	= 0,
 	},
 	{
 	.name		= "ssc2",
-	.lock		= SPIN_LOCK_UNLOCKED,
+	.lock		= __SPIN_LOCK_UNLOCKED(ssc_info[2].lock),
 	.dir_mask	= 0,
 	.initialized	= 0,
 	},
-- 
Milind Arun Choudhary
