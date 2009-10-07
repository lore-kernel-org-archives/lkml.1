Return-Path: <linux-kernel-owner+w=401wt.eu-S934170AbZJGIls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934170AbZJGIls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934098AbZJGIlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:41:47 -0400
Received: from mxout-08.mxes.net ([216.86.168.183]:50063 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933981AbZJGIlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:41:46 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 2/7] kmsg: no need to limit the return value of printk
Date: Wed,  7 Oct 2009 09:39:42 +0100
Message-Id: <1254904787-11323-3-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prefixes added by printk() are no longer included in the count of
characters which it returns.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 drivers/char/mem.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index a074fce..8599f65 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -852,9 +852,6 @@ static ssize_t kmsg_write(struct file * file, const char __user * buf,
 	if (!copy_from_user(tmp, buf, count)) {
 		tmp[count] = 0;
 		ret = printk("%s", tmp);
-		if (ret > count)
-			/* printk can add a prefix */
-			ret = count;
 	}
 	kfree(tmp);
 	return ret;
-- 
1.6.3.2

