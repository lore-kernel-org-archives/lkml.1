Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbYKLVG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbYKLVG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYKLVGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:06:18 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:44517 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYKLVGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:06:17 -0500
Date: Wed, 12 Nov 2008 13:05:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, ericvh@gmail.com,
       akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       v9fs-developer@lists.sourceforge.net, netdev <netdev@vger.kernel.org>
Subject: [PATCH linux-next 3rd time] 9p: restrict RDMA usage
Message-Id: <20081112130517.73c3e13a.randy.dunlap@oracle.com>
In-Reply-To: <20081112182818.6e259488.sfr@canb.auug.org.au>
References: <20081112182818.6e259488.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.491B4533.00DA:SCFSTAT928724,ss=1,fgs=0
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
