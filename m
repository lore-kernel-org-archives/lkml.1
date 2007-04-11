Return-Path: <linux-kernel-owner+w=401wt.eu-S1030360AbXDKDj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030360AbXDKDj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030761AbXDKDjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:39:23 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:15870 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030760AbXDKDi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=kez58Jlfnj1Gkg+hjiLO/ycv0DRHlO6bVB/LyqWL879L7mSlBExIRrbVOoedzROXit+awN1OKzakLalFuwncAANi14XNJGtZBuorZRssj4Zo9Gpw3c2ahB15gvTXwVg6j4jyj5IH6wBtLCIYn71Jhf4X+jacaJjYjM2zo7C6P78=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 10 Apr 2007 20:36:00 -0700
Message-Id: <20070411033600.11000.47234.patchbomb.py@localhost>
In-Reply-To: <20070411033600.11000.38285.patchbomb.py@localhost>
Subject: [PATCH 9/13] ocfs2: use zero_user_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use zero_user_page() instead of open-coding it. 

Signed-off-by: Nate Diller <nate.diller@gmail.com>

--- 

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/ocfs2/aops.c linux-2.6.21-rc6-mm1-test/fs/ocfs2/aops.c
--- linux-2.6.21-rc6-mm1/fs/ocfs2/aops.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/ocfs2/aops.c	2007-04-09 18:18:23.000000000 -0700
@@ -234,10 +234,7 @@ static int ocfs2_readpage(struct file *f
 	 * XXX sys_readahead() seems to get that wrong?
 	 */
 	if (start >= i_size_read(inode)) {
-		char *addr = kmap(page);
-		memset(addr, 0, PAGE_SIZE);
-		flush_dcache_page(page);
-		kunmap(page);
+		zero_user_page(page, 0, PAGE_SIZE);
 		SetPageUptodate(page);
 		ret = 0;
 		goto out_alloc;
