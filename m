Return-Path: <linux-kernel-owner+w=401wt.eu-S1759886AbZBLSwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886AbZBLSwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 13:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757175AbZBLSwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 13:52:08 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:26992 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbZBLSwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 13:52:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=r0g0pzywkQ8GSenMl8qTyieZWnlm8ovq5qU+bNnD2D3tfhVbFnHM71aX2BzskWomUM
         mWANPNdDn0pM2TxKVYxJH5bSxVsDFWycFlO6DJJGQ34tyUW9WvvdQDymIHJhcAEWpX9j
         8IZCxpdDfM94zLOkgKLver8wVW3/h4M6upZfU=
Date: Fri, 13 Feb 2009 00:21:53 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: Kernel Janitors <kernel-janitors@lists.osdl.org>
Cc: FSDevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrw Morton <akpm@linux-foundation.org>
Subject: [PATCH] fs/proc/task_mmu.c: fix sparse warnings
Message-ID: <20090212185153.GA2221@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warnings in fs/proc/task_mmu.c :

linux.git/fs/proc/task_mmu.c:723:26: error: subtraction of different types can't work (different address spaces)
linux.git/fs/proc/task_mmu.c:725:24: error: subtraction of different types can't work (different address spaces)


Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
---

 task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 9406384..ea3e892 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -720,9 +720,9 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	if (ret == PM_END_OF_BUFFER)
 		ret = 0;
 	/* don't need mmap_sem for these, but this looks cleaner */
-	*ppos += (char *)pm.out - buf;
+	*ppos += (char __user *)pm.out - buf;
 	if (!ret)
-		ret = (char *)pm.out - buf;
+		ret = (char __user *)pm.out - buf;
 
 out_pages:
 	for (; pagecount; pagecount--) {
