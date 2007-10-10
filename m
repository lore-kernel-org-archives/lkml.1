Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbXJJVpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbXJJVpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757077AbXJJVnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:43:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757023AbXJJVnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:43:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/31] IGET: Use iget_failed() in AFS [try #3]
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Wed, 10 Oct 2007 22:43:29 +0100
Message-ID: <20071010214328.17535.99884.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk>
References: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk>
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

