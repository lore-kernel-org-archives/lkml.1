Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZHJMS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZHJMS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZHJMS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:18:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39426 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbZHJMSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:18:25 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hch@infradead.org, rlove@google.com,
       msb@google.com, viro@zeniv.linux.org.uk, hannes@cmpxchg.org
Subject: [PATCH 2/3] vfs: remove redundant position check in do_sendfile
Date: Mon, 10 Aug 2009 08:17:42 -0400
Message-Id: <1249906663-7572-3-git-send-email-jlayton@redhat.com>
In-Reply-To: <1249906663-7572-1-git-send-email-jlayton@redhat.com>
References: <1249906663-7572-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Johannes Weiner pointed out, one of the range checks in do_sendfile
is redundant and is already checked in rw_verify_area.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/read_write.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 6c8c55d..3ac2898 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -839,9 +839,6 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 		max = min(in_inode->i_sb->s_maxbytes, out_inode->i_sb->s_maxbytes);
 
 	pos = *ppos;
-	retval = -EINVAL;
-	if (unlikely(pos < 0))
-		goto fput_out;
 	if (unlikely(pos + count > max)) {
 		retval = -EOVERFLOW;
 		if (pos >= max)
-- 
1.6.0.6

