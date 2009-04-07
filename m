Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbZDGOeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbZDGOeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZDGOeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:34:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35679 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbZDGOeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:34:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] RxRPC: Error handling for rxrpc_alloc_connection()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, error27@gmail.com, linux-afs@lists.infradead.org,
       linux-kernel@vger.kernel.org
Date: Tue, 07 Apr 2009 15:32:52 +0100
Message-ID: <20090407143252.8151.73731.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

rxrpc_alloc_connection() doesn't return an error code on failure, it just
returns NULL.  IS_ERR(NULL) is false.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-connection.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/net/rxrpc/ar-connection.c b/net/rxrpc/ar-connection.c
index 0f1218b..67e38a0 100644
--- a/net/rxrpc/ar-connection.c
+++ b/net/rxrpc/ar-connection.c
@@ -343,9 +343,9 @@ static int rxrpc_connect_exclusive(struct rxrpc_sock *rx,
 		/* not yet present - create a candidate for a new connection
 		 * and then redo the check */
 		conn = rxrpc_alloc_connection(gfp);
-		if (IS_ERR(conn)) {
-			_leave(" = %ld", PTR_ERR(conn));
-			return PTR_ERR(conn);
+		if (!conn) {
+			_leave(" = -ENOMEM");
+			return -ENOMEM;
 		}
 
 		conn->trans = trans;
@@ -508,9 +508,9 @@ int rxrpc_connect_call(struct rxrpc_sock *rx,
 		/* not yet present - create a candidate for a new connection and then
 		 * redo the check */
 		candidate = rxrpc_alloc_connection(gfp);
-		if (IS_ERR(candidate)) {
-			_leave(" = %ld", PTR_ERR(candidate));
-			return PTR_ERR(candidate);
+		if (!candidate) {
+			_leave(" = -ENOMEM");
+			return -ENOMEM;
 		}
 
 		candidate->trans = trans;

