Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYKEEsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYKEEsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 23:48:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbYKEEry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 23:47:54 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:29210 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYKEErx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 23:47:53 -0500
Date: Tue, 4 Nov 2008 20:46:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Eric Van Hensbergen <ericvh@gmail.com>,
       davem@davemloft.net
Subject: [PATCH] net/9p: fix printk format warnings
Message-Id: <20081104204646.977cecad.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in net/9p.
Built cleanly on 7 arches.

net/9p/client.c:820: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
net/9p/client.c:820: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
net/9p/client.c:867: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
net/9p/client.c:867: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
net/9p/client.c:932: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
net/9p/client.c:932: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'u64'
net/9p/client.c:982: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
net/9p/client.c:982: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
net/9p/client.c:1025: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
net/9p/client.c:1025: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
net/9p/client.c:1227: warning: format '%llx' expects type 'long long unsigned int', but argument 7 has type 'u64'
net/9p/client.c:1227: warning: format '%llx' expects type 'long long unsigned int', but argument 12 has type 'u64'
net/9p/client.c:1227: warning: format '%llx' expects type 'long long unsigned int', but argument 8 has type 'u64'
net/9p/client.c:1227: warning: format '%llx' expects type 'long long unsigned int', but argument 13 has type 'u64'
net/9p/client.c:1252: warning: format '%llx' expects type 'long long unsigned int', but argument 7 has type 'u64'
net/9p/client.c:1252: warning: format '%llx' expects type 'long long unsigned int', but argument 12 has type 'u64'
net/9p/client.c:1252: warning: format '%llx' expects type 'long long unsigned int', but argument 8 has type 'u64'
net/9p/client.c:1252: warning: format '%llx' expects type 'long long unsigned int', but argument 13 has type 'u64'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Eric Van Hensbergen <ericvh@gmail.com>
---
 net/9p/client.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- lin2628-rc3.orig/net/9p/client.c
+++ lin2628-rc3/net/9p/client.c
@@ -818,7 +818,9 @@ struct p9_fid *p9_client_attach(struct p
 	}
 
 	P9_DPRINTK(P9_DEBUG_9P, "<<< RATTACH qid %x.%llx.%x\n",
-					qid.type, qid.path, qid.version);
+					qid.type,
+					(unsigned long long)qid.path,
+					qid.version);
 
 	memmove(&fid->qid, &qid, sizeof(struct p9_qid));
 
@@ -865,7 +867,9 @@ p9_client_auth(struct p9_client *clnt, c
 	}
 
 	P9_DPRINTK(P9_DEBUG_9P, "<<< RAUTH qid %x.%llx.%x\n",
-					qid.type, qid.path, qid.version);
+					qid.type,
+					(unsigned long long)qid.path,
+					qid.version);
 
 	memmove(&afid->qid, &qid, sizeof(struct p9_qid));
 	p9_free_req(clnt, req);
@@ -930,7 +934,8 @@ struct p9_fid *p9_client_walk(struct p9_
 
 	for (count = 0; count < nwqids; count++)
 		P9_DPRINTK(P9_DEBUG_9P, "<<<     [%d] %x.%llx.%x\n",
-			count, wqids[count].type, wqids[count].path,
+			count, wqids[count].type,
+			(unsigned long long)wqids[count].path,
 			wqids[count].version);
 
 	if (nwname)
@@ -980,7 +985,9 @@ int p9_client_open(struct p9_fid *fid, i
 	}
 
 	P9_DPRINTK(P9_DEBUG_9P, "<<< ROPEN qid %x.%llx.%x iounit %x\n",
-				qid.type, qid.path, qid.version, iounit);
+				qid.type,
+				(unsigned long long)qid.path,
+				qid.version, iounit);
 
 	fid->mode = mode;
 	fid->iounit = iounit;
@@ -1023,7 +1030,9 @@ int p9_client_fcreate(struct p9_fid *fid
 	}
 
 	P9_DPRINTK(P9_DEBUG_9P, "<<< RCREATE qid %x.%llx.%x iounit %x\n",
-				qid.type, qid.path, qid.version, iounit);
+				qid.type,
+				(unsigned long long)qid.path,
+				qid.version, iounit);
 
 	fid->mode = mode;
 	fid->iounit = iounit;
@@ -1230,9 +1239,9 @@ struct p9_wstat *p9_client_stat(struct p
 		"<<<    name=%s uid=%s gid=%s muid=%s extension=(%s)\n"
 		"<<<    uid=%d gid=%d n_muid=%d\n",
 		ret->size, ret->type, ret->dev, ret->qid.type,
-		ret->qid.path, ret->qid.version, ret->mode,
-		ret->atime, ret->mtime, ret->length, ret->name,
-		ret->uid, ret->gid, ret->muid, ret->extension,
+		(unsigned long long)ret->qid.path, ret->qid.version, ret->mode,
+		ret->atime, ret->mtime, (unsigned long long)ret->length,
+		ret->name, ret->uid, ret->gid, ret->muid, ret->extension,
 		ret->n_uid, ret->n_gid, ret->n_muid);
 
 free_and_error:
@@ -1255,9 +1264,9 @@ int p9_client_wstat(struct p9_fid *fid, 
 		"     name=%s uid=%s gid=%s muid=%s extension=(%s)\n"
 		"     uid=%d gid=%d n_muid=%d\n",
 		wst->size, wst->type, wst->dev, wst->qid.type,
-		wst->qid.path, wst->qid.version, wst->mode,
-		wst->atime, wst->mtime, wst->length, wst->name,
-		wst->uid, wst->gid, wst->muid, wst->extension,
+		(unsigned long long)wst->qid.path, wst->qid.version, wst->mode,
+		wst->atime, wst->mtime, (unsigned long long)wst->length,
+		wst->name, wst->uid, wst->gid, wst->muid, wst->extension,
 		wst->n_uid, wst->n_gid, wst->n_muid);
 	err = 0;
 	clnt = fid->clnt;
