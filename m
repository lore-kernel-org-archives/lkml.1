Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbYBQR5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbYBQR5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYBQR5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:57:10 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:59007 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbYBQR5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:57:08 -0500
Date: Sun, 17 Feb 2008 18:56:52 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/7] net/rxrpc: Use BUG_ON
Message-ID: <Pine.LNX.4.64.0802171856240.28055@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

if (...) BUG(); should be replaced with BUG_ON(...) when the test has no
side-effects to allow a definition of BUG_ON that drops the code completely.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ disable unlikely @ expression E,f; @@

(
  if (<... f(...) ...>) { BUG(); }
|
- if (unlikely(E)) { BUG(); }
+ BUG_ON(E);
)

@@ expression E,f; @@

(
  if (<... f(...) ...>) { BUG(); }
|
- if (E) { BUG(); }
+ BUG_ON(E);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/net/rxrpc/ar-accept.c b/net/rxrpc/ar-accept.c
--- a/net/rxrpc/ar-accept.c 2007-06-02 22:32:46.000000000 +0200
+++ b/net/rxrpc/ar-accept.c 2008-02-17 16:42:48.000000000 +0100
@@ -156,8 +156,7 @@ static int rxrpc_accept_incoming_call(st
 						  false);
 			spin_unlock(&call->lock);
 			notification = NULL;
-			if (ret < 0)
-				BUG();
+			BUG_ON(ret < 0);
 		}
 		spin_unlock(&call->conn->state_lock);
 
diff -u -p a/net/rxrpc/ar-ack.c b/net/rxrpc/ar-ack.c
--- a/net/rxrpc/ar-ack.c 2007-06-02 22:32:46.000000000 +0200
+++ b/net/rxrpc/ar-ack.c 2008-02-17 16:42:54.000000000 +0100
@@ -814,8 +814,7 @@ static int rxrpc_post_message(struct rxr
 		spin_lock_bh(&call->lock);
 		ret = rxrpc_queue_rcv_skb(call, skb, true, fatal);
 		spin_unlock_bh(&call->lock);
-		if (ret < 0)
-			BUG();
+		BUG_ON(ret < 0);
 	}
 
 	return 0;
