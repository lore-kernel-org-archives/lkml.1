Return-Path: <linux-kernel-owner+w=401wt.eu-S1751965AbXJANL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbXJANL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 09:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbXJANJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 09:09:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbXJANJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:09:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/30] IGET: Use iget_failed() in GFS2
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Mon, 01 Oct 2007 14:09:37 +0100
Message-ID: <20071001130937.29339.82052.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
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
 

