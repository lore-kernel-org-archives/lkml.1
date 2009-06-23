Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbZFWPar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbZFWPar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZFWP3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:29:49 -0400
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:49568 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZFWP3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:29:47 -0400
X-Greylist: delayed 1554 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2009 11:29:46 EDT
From: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: [PATCH 06/10] ipv6: Use rcu_barrier() on module unload.
To: "David S. Miller" <davem@davemloft.net>
Cc: Jesper Dangaard Brouer <hawk@comx.dk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, dougthompson@xmission.com,
       bluesmoke-devel@lists.sourceforge.net, axboe@kernel.dk,
       "Patrick McHardy" <kaber@trash.net>, christine.caulfield@googlemail.com,
       Trond.Myklebust@netapp.com, linux-wireless@vger.kernel.org,
       johannes@sipsolutions.net, yoshfuji@linux-ipv6.org,
       shemminger@linux-foundation.org, linux-nfs@vger.kernel.org,
       bfields@fieldses.org, neilb@suse.de, linux-ext4@vger.kernel.org,
       tytso@mit.edu, adilger@sun.com, netfilter-devel@vger.kernel.org
Date: Tue, 23 Jun 2009 17:04:24 +0200
Message-ID: <20090623150424.22490.47149.stgit@localhost>
In-Reply-To: <20090623150330.22490.87327.stgit@localhost>
References: <20090623150330.22490.87327.stgit@localhost>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ipv6 module uses rcu_call() thus it should use rcu_barrier() on
module unload.
---

 net/ipv6/af_inet6.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 85b3d00..caa0278 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -1284,6 +1284,8 @@ static void __exit inet6_exit(void)
 	proto_unregister(&udplitev6_prot);
 	proto_unregister(&udpv6_prot);
 	proto_unregister(&tcpv6_prot);
+
+	rcu_barrier(); /* Wait for completion of call_rcu()'s */
 }
 module_exit(inet6_exit);
 

