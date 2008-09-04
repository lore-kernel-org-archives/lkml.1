Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYIDOzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYIDOzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYIDOzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:55:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYIDOzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:55:31 -0400
Date: Thu, 4 Sep 2008 16:55:18 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de
Subject: [PATCH] nfsd/nfs4acl: Number of used used array elements needs to
 be zeroed.
Message-ID: <20080904165518.15a02908@psychotron.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Number of used used array elements needs to be zeroed. It may cause
problems otherwise, because it's used uninitialized in find_uid().

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
---
 fs/nfsd/nfs4acl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/nfsd/nfs4acl.c b/fs/nfsd/nfs4acl.c
index 54b8b41..7dcd90f 100644
--- a/fs/nfsd/nfs4acl.c
+++ b/fs/nfsd/nfs4acl.c
@@ -447,11 +447,13 @@ init_state(struct posix_acl_state *state, int cnt)
 	state->users = kzalloc(alloc, GFP_KERNEL);
 	if (!state->users)
 		return -ENOMEM;
+	state->users->n = 0;
 	state->groups = kzalloc(alloc, GFP_KERNEL);
 	if (!state->groups) {
 		kfree(state->users);
 		return -ENOMEM;
 	}
+	state->groups->n = 0;
 	return 0;
 }
 
-- 
1.5.5.1

