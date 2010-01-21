Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204Ab0AUKVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0AUKVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 05:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961Ab0AUKVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 05:21:51 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:58029 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab0AUKVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 05:21:50 -0500
Date: Thu, 21 Jan 2010 11:21:47 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: David Miller <davem@davemloft.net>
Cc: vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/9] net/sctp: Eliminate useless code
In-Reply-To: <20100120.150343.236848237.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.1001211121280.13529@ask.diku.dk>
References: <Pine.LNX.4.64.1001161657570.28745@ask.diku.dk> <4B574702.4040602@hp.com>
 <20100120.150343.236848237.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variable newinet is initialized twice to the same (side effect-free)
expression.  Drop one initialization.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@forall@
idexpression *x;
identifier f!=ERR_PTR;
@@

x = f(...)
... when != x
(
x = f(...,<+...x...+>,...)
|
* x = f(...)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/sctp/socket.c                   |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 67fdac9..f6d1e59 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6359,7 +6359,7 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 		    struct sctp_association *asoc)
 {
 	struct inet_sock *inet = inet_sk(sk);
-	struct inet_sock *newinet = inet_sk(newsk);
+	struct inet_sock *newinet;
 
 	newsk->sk_type = sk->sk_type;
 	newsk->sk_bound_dev_if = sk->sk_bound_dev_if;
