Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbXF3DT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbXF3DT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXF3DTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:19:22 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:58092 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbXF3DTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:19:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=VL/RrMAW2aTtFVQwngvPr+0cQTd8P/CfnsEIQfjW46JTL+s4ayF4HdV9YNFD4rk8KtSluG5e8B27NIVZx2e6QNiAShnipqcwBq7+hPbRmGkkFPvL7igF9O1JqZHulWdtYVs/OaH+osMxAn81Of+9+GbK5FDel2mT6W9lp60/h9Q=
Date: Sat, 30 Jun 2007 12:10:13 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/4] void unregister_blkdev - do WARN_ON failure
Message-ID: <20070630031013.GC4045@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When unregister_blkdev() has failed, something wrong happened.
This patch adds WARN_ON to notify such badness.

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 block/genhd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: 2.6-mm/block/genhd.c
===================================================================
--- 2.6-mm.orig/block/genhd.c
+++ 2.6-mm/block/genhd.c
@@ -120,9 +120,10 @@ int unregister_blkdev(unsigned int major
 	for (n = &major_names[index]; *n; n = &(*n)->next)
 		if ((*n)->major == major)
 			break;
-	if (!*n || strcmp((*n)->name, name))
+	if (!*n || strcmp((*n)->name, name)) {
+		WARN_ON(1);
 		ret = -EINVAL;
-	else {
+	} else {
 		p = *n;
 		*n = p->next;
 	}
