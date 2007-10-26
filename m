Return-Path: <linux-kernel-owner+w=401wt.eu-S1763510AbXJZXGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763510AbXJZXGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbXJZXGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:06:16 -0400
Received: from 70-56-216-30.albq.qwest.net ([70.56.216.30]:43035 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751516AbXJZXGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:06:15 -0400
Date: Fri, 26 Oct 2007 17:06:14 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 9p: return NULL when trans not found
Message-ID: <20071026230614.GB23570@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

v9fs_match_trans function returns arbitrary transport module instead of NULL
when the requested transport is not registered. This patch modifies the
function to return NULL in that case.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
commit 25ed88ed319e40fb6426e2aaefcc5f136aadd4ee
tree 281feda9127a85178d44faca59a13645d08e314d
parent 0c0b7fa3d4e80ab3e4e69b8a55661f649d1b41ff
author Latchesar Ionkov <lucho@ionkov.net> 1193438318 -0600
committer Latchesar Ionkov <lucho@ionkov.net> 1193438318 -0600

 net/9p/mod.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/9p/mod.c b/net/9p/mod.c
index 41d70f4..8f9763a 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -76,9 +76,9 @@ struct p9_trans_module *v9fs_match_trans(const substring_t *name)
 	list_for_each(p, &v9fs_trans_list) {
 		t = list_entry(p, struct p9_trans_module, list);
 		if (strncmp(t->name, name->from, name->to-name->from) == 0)
-			break;
+			return t;
 	}
-	return t;
+	return NULL;
 }
 EXPORT_SYMBOL(v9fs_match_trans);
 
