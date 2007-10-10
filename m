Return-Path: <linux-kernel-owner+w=401wt.eu-S1757676AbXJJVqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbXJJVqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757335AbXJJVns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:43:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757210AbXJJVno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:43:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/31] IGET: Use iget_failed() in GFS2 [try #3]
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Wed, 10 Oct 2007 22:43:34 +0100
Message-ID: <20071010214334.17535.643.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk>
References: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use iget_failed() in GFS2 to kill a failed inode.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/gfs2/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 34f7bcd..498844f 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -185,7 +185,7 @@ fail_put:
 	ip->i_gl->gl_object = NULL;
 	gfs2_glock_put(ip->i_gl);
 fail:
-	iput(inode);
+	iget_failed(inode);
 	return ERR_PTR(error);
 }
 

