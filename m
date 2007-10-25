Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbXJYQhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbXJYQhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXJYQe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:34:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbXJYQez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:34:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/31] IGET: Use iget_failed() in GFS2 [try #5]
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 25 Oct 2007 17:34:17 +0100
Message-ID: <20071025163417.5057.24708.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
References: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
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
index 5f6dc32..c5285e2 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -235,7 +235,7 @@ fail_put:
 	ip->i_gl->gl_object = NULL;
 	gfs2_glock_put(ip->i_gl);
 fail:
-	iput(inode);
+	iget_failed(inode);
 	return ERR_PTR(error);
 }
 

