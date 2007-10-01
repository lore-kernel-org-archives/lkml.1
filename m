Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbXJANKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbXJANKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 09:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbXJANJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 09:09:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbXJANJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:09:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/30] IGET: Use iget_failed() in AFS
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Mon, 01 Oct 2007 14:09:32 +0100
Message-ID: <20071001130932.29339.49381.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
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

