Return-Path: <linux-kernel-owner+w=401wt.eu-S1762682AbXGSUpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762682AbXGSUpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbXGSUpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:45:34 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:46651 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147AbXGSUpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:45:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=iLqtnjxJNmw8OwqLAtFGn9xObZwE5rozBYW4LAvUpUzhphXuDp84kVkQ5dYTKfEqKz1rAqzsf7BJQWR4tg+JXuMk6ooXHd/sEgTi6uxppk8JBA6Ei+Eih3LPdsXRFnGek3TQZcyOe/YylNpN3sZPrZqtvOvcrcYZdRdTvQJBeGU=
Message-ID: <469FCD5E.80808@gmail.com>
Date: Thu, 19 Jul 2007 16:45:18 -0400
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-mtd@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] MTD: potential leak in rfd_ftl_add_mtd
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a leak in the !mtd->erasesize error path (Coverity 1765).


Signed-off-by: Florin Malita <fmalita@gmail.com>
---

 drivers/mtd/rfd_ftl.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/rfd_ftl.c b/drivers/mtd/rfd_ftl.c
index d4b1ba8..006c03a 100644
--- a/drivers/mtd/rfd_ftl.c
+++ b/drivers/mtd/rfd_ftl.c
@@ -779,6 +779,7 @@ static void rfd_ftl_add_mtd(struct mtd_blktrans_ops *tr, struct mtd_info *mtd)
 	else {
 		if (!mtd->erasesize) {
 			printk(KERN_WARNING PREFIX "please provide block_size");
+			kfree(part);
 			return;
 		}
 		else

