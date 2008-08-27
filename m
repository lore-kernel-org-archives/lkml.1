Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbYH0NvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbYH0NvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbYH0NsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:48:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691AbYH0NsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:48:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 27/59] CRED: Wrap task credential accesses in the FUSE
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Miklos Szeredi <miklos@szeredi.hu>,
       fuse-devel@lists.sourceforge.net
Date: Wed, 27 Aug 2008 14:48:01 +0100
Message-ID: <20080827134801.19980.78008.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net
---

 fs/fuse/dev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 87250b6..2d3ccbd 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -87,8 +87,8 @@ static void __fuse_put_request(struct fuse_req *req)
 
 static void fuse_req_init_context(struct fuse_req *req)
 {
-	req->in.h.uid = current->fsuid;
-	req->in.h.gid = current->fsgid;
+	req->in.h.uid = current_fsuid();
+	req->in.h.gid = current_fsgid();
 	req->in.h.pid = current->pid;
 }
 

