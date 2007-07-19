Return-Path: <linux-kernel-owner+w=401wt.eu-S1764595AbXGSJGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764595AbXGSJGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937429AbXGSJG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:06:29 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:53068 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764146AbXGSJG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:06:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent:from:sender;
        b=pP2TgBv3FWQzgaPUWoyZtl1yOndRogzqgfGPv6qiMn6VCHBxec/GDl44uVP6DIO81WnrleDxqLzHLGF+CiVZZDylpgp/4ZKeY9riWYAOu4M8aJQcHSlFAc60OgoW20Dse/KCB8SIIci2vNBNT9rIO+Gt6iY9PyzAYwA6/NPVifU=
Date: Thu, 19 Jul 2007 17:06:20 +0800
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Subject: [PATCH] fs/afs/flock.c: posix_test_lock() returns void
Message-ID: <20070719090620.GA14799@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
From: Eugene Teo <eugeneteo@kernel.sg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

posix_test_lock() returns void, so there is no need to test the return value.
Checking fl->fl_type for F_UNLCK instead.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 fs/afs/flock.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/afs/flock.c b/fs/afs/flock.c
index 8f07f8d..4f77f3c 100644
--- a/fs/afs/flock.c
+++ b/fs/afs/flock.c
@@ -456,7 +456,8 @@ static int afs_do_getlk(struct file *file, struct file_lock *fl)
 
 	/* check local lock records first */
 	ret = 0;
-	if (posix_test_lock(file, fl) == 0) {
+	posix_test_lock(file, fl);
+	if (fl->fl_type == F_UNLCK) {
 		/* no local locks; consult the server */
 		ret = afs_vnode_fetch_status(vnode, NULL, key);
 		if (ret < 0)
-- 
1.5.2.2

