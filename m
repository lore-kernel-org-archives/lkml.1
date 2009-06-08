Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbZFHNdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbZFHNdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbZFHNdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:33:07 -0400
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:55547 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbZFHNdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:33:06 -0400
X-Greylist: delayed 1303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jun 2009 09:33:05 EDT
From: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: [PATCH 3/5] can: af_can.c use rcu_barrier() on module unload.
To: "David S. Miller" <davem@davemloft.net>
Cc: Jesper Dangaard Brouer <hawk@comx.dk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, wg@grandegger.com,
       vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
       Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Date: Mon, 08 Jun 2009 15:11:38 +0200
Message-ID: <20090608131138.10052.5408.stgit@localhost>
In-Reply-To: <20090608130959.10052.54590.stgit@localhost>
References: <20090608130959.10052.54590.stgit@localhost>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This module uses rcu_call() thus it should use rcu_barrier()
on module unload.

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---

 net/can/af_can.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 10f0528..e733725 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -903,6 +903,8 @@ static __exit void can_exit(void)
 	}
 	spin_unlock(&can_rcvlists_lock);
 
+	rcu_barrier(); /* Wait for completion of call_rcu()'s */
+
 	kmem_cache_destroy(rcv_cache);
 }
 

