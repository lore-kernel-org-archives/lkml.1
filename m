Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYKCTTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYKCTTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYKCTSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:18:47 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:23666 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbYKCTSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:18:46 -0500
Date: Mon, 3 Nov 2008 11:17:31 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       sfr <sfr@canb.auug.org.au>
Cc: rolandd@cisco.com, ericvh@gmail.com, akpm <akpm@linux-foundation.org>,
       davem@davemloft.net, netdev <netdev@vger.kernel.org>
Subject: [PATCH] net/9p: limit RDMA to INET
Message-Id: <20081103111731.d12dbb84.randy.dunlap@oracle.com>
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

linux-next:

Make 9p's RDMA option depend on INET since it uses Infiniband rdma_*
functions and that code depends on INET.  Otherwise 9p can try to
use symbols which don't exist.

ERROR: "rdma_destroy_id" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_connect" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_create_id" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_create_qp" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_resolve_route" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_disconnect" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_resolve_addr" [net/9p/9pnet_rdma.ko] undefined!

I used an if/endif block so that the menu items would remain
presented together.

Also correct an article adjective.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/9p/Kconfig |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- linux-next-20081103.orig/net/9p/Kconfig
+++ linux-next-20081103/net/9p/Kconfig
@@ -13,22 +13,24 @@ menuconfig NET_9P
 
 	  If unsure, say N.
 
+if NET_9P
+
 config NET_9P_VIRTIO
-	depends on NET_9P && EXPERIMENTAL && VIRTIO
+	depends on EXPERIMENTAL && VIRTIO
 	tristate "9P Virtio Transport (Experimental)"
 	help
 	  This builds support for a transports between
 	  guest partitions and a host partition.
 
 config NET_9P_RDMA
-	depends on NET_9P && INFINIBAND && EXPERIMENTAL
+	depends on INET && INFINIBAND && EXPERIMENTAL
 	tristate "9P RDMA Transport (Experimental)"
 	help
-	  This builds support for a RDMA transport.
+	  This builds support for an RDMA transport.
 
 config NET_9P_DEBUG
 	bool "Debug information"
-	depends on NET_9P
 	help
 	  Say Y if you want the 9P subsystem to log debug information.
 
+endif
