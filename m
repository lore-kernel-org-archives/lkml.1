Return-Path: <linux-kernel-owner+w=401wt.eu-S934128AbXEEXDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128AbXEEXDG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 19:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934124AbXEEXCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 19:02:07 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:54803 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934102AbXEEXB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 19:01:57 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 2/2] fs: Use path_walk in do_path_lookup
Date: Sat,  5 May 2007 18:59:40 -0400
Message-Id: <11784059801600-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.1043.g4342
In-Reply-To: <1178405980972-git-send-email-jsipek@cs.sunysb.edu>
References: <1178405980972-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since, path_walk sets the total_link_count to 0, and calls link_path_walk,
we can just call path_walk directly.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 600a4e7..86f0def 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1153,8 +1153,8 @@ static int fastcall do_path_lookup(int dfd, const char *name,
 
 		fput_light(file, fput_needed);
 	}
-	current->total_link_count = 0;
-	retval = link_path_walk(name, nd);
+
+	retval = path_walk(name, nd);
 out:
 	if (likely(retval == 0)) {
 		if (unlikely(!audit_dummy_context() && nd && nd->dentry &&
-- 
1.5.0.3.1043.g4342

