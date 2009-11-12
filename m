Return-Path: <linux-kernel-owner+w=401wt.eu-S1759813AbZKLAXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759813AbZKLAXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 19:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759801AbZKLAXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 19:23:42 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37283 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759794AbZKLAXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 19:23:42 -0500
Date: Thu, 12 Nov 2009 11:23:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: linux-next: origin tree build failure
Message-Id: <20091112112348.e351451f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Today's linux-next build (x86_64 allmodconfig) failed like this:

ERROR: "log_start_commit" [fs/ext3/ext3.ko] undefined!

I applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 12 Nov 2009 11:19:26 +1100
Subject: [PATCH] jbd: export log_start_commit for ext3

Today's linux-next build (x86_64 allmodconfig) failed like this:

ERROR: "log_start_commit" [fs/ext3/ext3.ko] undefined!

Caused by commit fe8bc91c4c30122b357d197117705cfd4fabaf28 ("ext3: Wait
for proper transaction commit on fsync").

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/jbd/journal.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 49d5cd6..34973f6 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -461,6 +461,7 @@ int log_start_commit(journal_t *journal, tid_t tid)
 	spin_unlock(&journal->j_state_lock);
 	return ret;
 }
+EXPORT_SYMBOL(log_start_commit);
 
 /*
  * Force and wait upon a commit if the calling process is not within
-- 
1.6.5.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
