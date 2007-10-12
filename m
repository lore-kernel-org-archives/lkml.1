Return-Path: <linux-kernel-owner+w=401wt.eu-S1760406AbXJLJJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760406AbXJLJJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759996AbXJLJHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:07:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759566AbXJLJHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:07:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/31] IGET: Use iget_failed() in AFS [try #4]
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Fri, 12 Oct 2007 10:07:29 +0100
Message-ID: <20071012090729.3442.69693.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
References: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use iget_failed() in AFS to kill a failed inode.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/inode.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index d196840..ca9b02f 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -196,10 +196,7 @@ struct inode *afs_iget(struct super_block *sb, struct key *key,
 
 	/* failure */
 bad_inode:
-	make_bad_inode(inode);
-	unlock_new_inode(inode);
-	iput(inode);
-
+	iget_failed(inode);
 	_leave(" = %d [bad]", ret);
 	return ERR_PTR(ret);
 }

