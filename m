Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbZFHNeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbZFHNeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbZFHNdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:33:14 -0400
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:55545 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbZFHNdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:33:06 -0400
From: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: [PATCH 5/5] sunrpc/auth_gss: Call rcu_barrier() on module unload.
To: "David S. Miller" <davem@davemloft.net>
Cc: Jesper Dangaard Brouer <hawk@comx.dk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, wg@grandegger.com,
       vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
       Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Date: Mon, 08 Jun 2009 15:11:48 +0200
Message-ID: <20090608131148.10052.39869.stgit@localhost>
In-Reply-To: <20090608130959.10052.54590.stgit@localhost>
References: <20090608130959.10052.54590.stgit@localhost>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the module uses rcu_call() we should make sure that all
rcu callback has been completed before removing the code.

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---

 net/sunrpc/auth_gss/auth_gss.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index e630b38..66d458f 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -1548,6 +1548,7 @@ static void __exit exit_rpcsec_gss(void)
 {
 	gss_svc_shutdown();
 	rpcauth_unregister(&authgss_ops);
+	rcu_barrier(); /* Wait for completion of call_rcu()'s */
 }
 
 MODULE_LICENSE("GPL");

