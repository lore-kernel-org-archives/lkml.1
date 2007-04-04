Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103AbXDDRgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbXDDRgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbXDDRgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:36:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:52357 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbXDDRgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:36:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=jkUmsP/IvVqGr8gcA1iWFBR/CtdYqw2l9SjjljC6him86MIvjauVZbfsmgcNjdAt7hrfoVvhaioKblAr40A++6duS9JVcWXxuVZ9thQUGKjokplCBFwV3o9m8zM3A/6zV5M4pp6dee/5v4xscy3MLBQGfPUZB4kEQAgo9hajJnc=
Date: Wed, 4 Apr 2007 23:07:40 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [KJ][PATCH]ROUND_UP macro cleanup in drivers/char/lp.c
Message-ID: <20070404173739.GB9830@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ROUND_UP macro cleanup use DIV_ROUND_UP

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---
 lp.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)


diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index b51d08b..c086910 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -139,9 +139,6 @@
 /* if you have more than 8 printers, remember to increase LP_NO */
 #define LP_NO 8
 
-/* ROUND_UP macro from fs/select.c */
-#define ROUND_UP(x,y) (((x)+(y)-1)/(y))
-
 static struct lp_struct lp_table[LP_NO];
 
 static unsigned int lp_count = 0;
@@ -652,7 +649,7 @@ static int lp_ioctl(struct inode *inode, struct file *file,
 			    (par_timeout.tv_usec < 0)) {
 				return -EINVAL;
 			}
-			to_jiffies = ROUND_UP(par_timeout.tv_usec, 1000000/HZ);
+			to_jiffies = DIV_ROUND_UP(par_timeout.tv_usec, 1000000/HZ);
 			to_jiffies += par_timeout.tv_sec * (long) HZ;
 			if (to_jiffies <= 0) {
 				return -EINVAL;

-- 
Milind Arun Choudhary
