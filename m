Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbYCCM6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbYCCM6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYCCM6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:58:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbYCCM6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:58:02 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] RxRPC: Fix rxrpc_recvmsg()'s returning of msg_name
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: cg2v@andrew.cmu.edu, dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Mon, 03 Mar 2008 12:57:56 +0000
Message-ID: <20080303125756.27957.68446.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix rxrpc_recvmsg() to return msg_name correctly.  We shouldn't overwrite the
*msg struct, but should rather write into msg->msg_name (there's a '&' unary
operator that shouldn't be there).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-recvmsg.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/net/rxrpc/ar-recvmsg.c b/net/rxrpc/ar-recvmsg.c
index f19121d..a39bf97 100644
--- a/net/rxrpc/ar-recvmsg.c
+++ b/net/rxrpc/ar-recvmsg.c
@@ -143,7 +143,8 @@ int rxrpc_recvmsg(struct kiocb *iocb, struct socket *sock,
 		/* copy the peer address and timestamp */
 		if (!continue_call) {
 			if (msg->msg_name && msg->msg_namelen > 0)
-				memcpy(&msg->msg_name, &call->conn->trans->peer->srx,
+				memcpy(msg->msg_name,
+				       &call->conn->trans->peer->srx,
 				       sizeof(call->conn->trans->peer->srx));
 			sock_recv_timestamp(msg, &rx->sk, skb);
 		}

