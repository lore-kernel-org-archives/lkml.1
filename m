Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbYHZWFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbYHZWFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYHZWFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:05:30 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:55617 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbYHZWF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:05:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=iBScwBUxYcjRd8RVOQYYEU+d9crV4aFymTUtE0BbErqrvb6lWxEFd9aG87eUapHFc4
         v/i39Ar7sqaKaZtXZqAW/6JBUwcpnre3IYtU6vK0Fb89QKhQ2XIkYziYIIgF2AWzEtFV
         1PUtq6PnZp4I7zWKkw8b5IoKa1gp+9/qILL0Q=
Subject: [PATCH] afs: fsclient.c sparse endian annotations of operation_ID
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 15:05:26 -0700
Message-Id: <1219788326.6069.40.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/afs/fsclient.c:319:11: warning: restricted __be32 degrades to integer
fs/afs/fsclient.c:465:21: warning: incorrect type in assignment (different base types)
fs/afs/fsclient.c:465:21:    expected restricted __be32 [usertype] operation_ID
fs/afs/fsclient.c:465:21:    got int
fs/afs/fsclient.c:510:21: warning: incorrect type in assignment (different base types)
fs/afs/fsclient.c:510:21:    expected restricted __be32 [usertype] operation_ID
fs/afs/fsclient.c:510:21:    got int
fs/afs/fsclient.c:1304:10: warning: restricted __be32 degrades to integer
fs/afs/fsclient.c:1366:21: warning: incorrect type in assignment (different base types)
fs/afs/fsclient.c:1366:21:    expected restricted __be32 [usertype] operation_ID
fs/afs/fsclient.c:1366:21:    got int
fs/afs/fsclient.c:1417:21: warning: incorrect type in assignment (different base types)
fs/afs/fsclient.c:1417:21:    expected restricted __be32 [usertype] operation_ID
fs/afs/fsclient.c:1417:21:    got int
fs/afs/fsclient.c:1463:21: warning: incorrect type in assignment (different base types)
fs/afs/fsclient.c:1463:21:    expected restricted __be32 [usertype] operation_ID
fs/afs/fsclient.c:1463:21:    got int

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/afs/fsclient.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 023b95b..2928067 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -316,7 +316,7 @@ static int afs_deliver_fs_fetch_data(struct afs_call *call,
 	case 0:
 		call->offset = 0;
 		call->unmarshall++;
-		if (call->operation_ID != FSFETCHDATA64) {
+		if (call->operation_ID != __constant_htonl(FSFETCHDATA64)) {
 			call->unmarshall++;
 			goto no_msw;
 		}
@@ -462,7 +462,7 @@ static int afs_fs_fetch_data64(struct afs_server *server,
 	call->reply3 = buffer;
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
-	call->operation_ID = FSFETCHDATA64;
+	call->operation_ID = __constant_htonl(FSFETCHDATA64);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -507,7 +507,7 @@ int afs_fs_fetch_data(struct afs_server *server,
 	call->reply3 = buffer;
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
-	call->operation_ID = FSFETCHDATA;
+	call->operation_ID = __constant_htonl(FSFETCHDATA);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -1301,7 +1301,7 @@ static int afs_deliver_fs_store_status(struct afs_call *call,
 
 	/* unmarshall the reply once we've received all of it */
 	store_version = NULL;
-	if (call->operation_ID == FSSTOREDATA)
+	if (call->operation_ID == __constant_htonl(FSSTOREDATA))
 		store_version = &call->store_version;
 
 	bp = call->buffer;
@@ -1363,7 +1363,7 @@ static int afs_fs_setattr_size64(struct afs_server *server, struct key *key,
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
 	call->store_version = vnode->status.data_version + 1;
-	call->operation_ID = FSSTOREDATA;
+	call->operation_ID = __constant_htonl(FSSTOREDATA);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -1414,7 +1414,7 @@ static int afs_fs_setattr_size(struct afs_server *server, struct key *key,
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
 	call->store_version = vnode->status.data_version + 1;
-	call->operation_ID = FSSTOREDATA;
+	call->operation_ID = __constant_htonl(FSSTOREDATA);
 
 	/* marshall the parameters */
 	bp = call->request;
@@ -1460,7 +1460,7 @@ int afs_fs_setattr(struct afs_server *server, struct key *key,
 	call->reply = vnode;
 	call->service_id = FS_SERVICE;
 	call->port = htons(AFS_FS_PORT);
-	call->operation_ID = FSSTORESTATUS;
+	call->operation_ID = __constant_htonl(FSSTORESTATUS);
 
 	/* marshall the parameters */
 	bp = call->request;
-- 
1.6.0.340.g84854



