Return-Path: <linux-kernel-owner+w=401wt.eu-S1762593AbXFRLyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762593AbXFRLyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 07:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761384AbXFRLyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 07:54:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbXFRLyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 07:54:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AF_RXRPC: Return the number of bytes buffered in
	rxrpc_send_data()
To: bunk@stusta.de
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, dhowells@redhat.com
Date: Mon, 18 Jun 2007 12:52:36 +0100
Message-ID: <20070618115236.23639.71608.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Return the number of bytes buffered in rxrpc_send_data().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-output.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/rxrpc/ar-output.c b/net/rxrpc/ar-output.c
index 591c442..cc9102c 100644
--- a/net/rxrpc/ar-output.c
+++ b/net/rxrpc/ar-output.c
@@ -640,6 +640,7 @@ static int rxrpc_send_data(struct kiocb *iocb,
 			goto efault;
 		sp->remain -= copy;
 		skb->mark += copy;
+		copied += copy;
 
 		len -= copy;
 		segment -= copy;
@@ -709,6 +710,8 @@ static int rxrpc_send_data(struct kiocb *iocb,
 
 	} while (segment > 0);
 
+success:
+	ret = copied;
 out:
 	call->tx_pending = skb;
 	_leave(" = %d", ret);
@@ -725,7 +728,7 @@ call_aborted:
 
 maybe_error:
 	if (copied)
-		ret = copied;
+		goto success;
 	goto out;
 
 efault:

