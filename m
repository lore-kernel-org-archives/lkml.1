Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbYL1X2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbYL1X2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 18:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbYL1X1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 18:27:51 -0500
Received: from mx2-2.mail.ru ([194.67.23.122]:30371 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755427AbYL1X1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 18:27:50 -0500
Date: Mon, 29 Dec 2008 02:25:50 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] minix: fix add link - wrong position calculation
Message-ID: <20081228232550.GA11504@rain>
Mail-Followup-To: Nick Piggin <npiggin@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes add link method.
Position in directory was calculated in wrong way.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
---
 fs/minix/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index f704338..4b603b7 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -280,7 +280,7 @@ int minix_add_link(struct dentry *dentry, struct inode *inode)
 	return -EINVAL;
 
 got_it:
-	pos = (page->index >> PAGE_CACHE_SHIFT) + p - (char*)page_address(page);
+	pos = page_offset(page) + p - (char*)page_address(page);
 	err = __minix_write_begin(NULL, page->mapping, pos, sbi->s_dirsize,
 					AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err)
-- 
1.6.0.6

-- 
/Evgeniy

