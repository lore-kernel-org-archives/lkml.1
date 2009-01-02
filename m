Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbZABSTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbZABSTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757994AbZABSTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:19:34 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:33449 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715AbZABSTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:19:33 -0500
Message-ID: <495E5A82.9000603@oracle.com>
Date: Fri, 02 Jan 2009 10:18:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH -next] 9p: fix RDMA dependency
References: <20090102203303.f314a99a.sfr@canb.auug.org.au>
In-Reply-To: <20090102203303.f314a99a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.495E5A85.00AD:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

NET_9P_RDMA uses Infiniband RDMA, which is controlled by the
INFINIBAND_ADDR_TRANS kconfig symbol, so fix NET_9P so that it builds
cleanly.

Found by inspection (suspicion) and then forced via kconfig.

ERROR: "rdma_destroy_id" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_connect" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_create_id" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_create_qp" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_resolve_route" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_disconnect" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_resolve_addr" [net/9p/9pnet_rdma.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc:      Eric Van Hensbergen <ericvh@gmail.com>
cc:      Roland Dreier <rolandd@cisco.com>
---
 net/9p/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090102.orig/net/9p/Kconfig
+++ linux-next-20090102/net/9p/Kconfig
@@ -23,7 +23,7 @@ config NET_9P_VIRTIO
 	  guest partitions and a host partition.
 
 config NET_9P_RDMA
-	depends on INET && INFINIBAND && EXPERIMENTAL
+	depends on INET && INFINIBAND_ADDR_TRANS && EXPERIMENTAL
 	tristate "9P RDMA Transport (Experimental)"
 	help
 	  This builds support for an RDMA transport.

-- 
~Randy
