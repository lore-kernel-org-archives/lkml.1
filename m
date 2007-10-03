Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbXJCSUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbXJCSUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757874AbXJCSUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:20:40 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:25542 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbXJCSUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:20:39 -0400
Date: Wed, 3 Oct 2007 11:20:28 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: [git patch] small ocfs2 fix
Message-ID: <20071003182028.GA30360@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One more well tested Ocfs2 fix to get in before 2.6.24.

Thanks,
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/localalloc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

Sunil Mushran (1):
      ocfs2: Unlock mutex in local alloc failure case

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index de984d2..d272847 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -514,8 +514,10 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 	ac->ac_bh = osb->local_alloc_bh;
 	status = 0;
 bail:
-	if (status < 0 && local_alloc_inode)
+	if (status < 0 && local_alloc_inode) {
+		mutex_unlock(&local_alloc_inode->i_mutex);
 		iput(local_alloc_inode);
+	}
 
 	mlog_exit(status);
 	return status;
