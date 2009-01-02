Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbZABSUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbZABSUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757732AbZABSUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:20:38 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:51594 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594AbZABSUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:20:37 -0500
Message-ID: <495E5A78.2000203@oracle.com>
Date: Fri, 02 Jan 2009 10:18:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH -next] sunrpc: fix RDMA dependency
References: <20090102203303.f314a99a.sfr@canb.auug.org.au>
In-Reply-To: <20090102203303.f314a99a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.495E5A7B.00BE:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

SUNRPC_XPRT_RDMA uses Infiniband RDMA support, so make it depend on
that kconfig symbol for clean builds.

net/built-in.o: In function `rpcrdma_ep_disconnect':
(.text+0x9c2a8): undefined reference to `rdma_disconnect'
net/built-in.o: In function `rpcrdma_create_id':
verbs.c:(.text+0x9c39f): undefined reference to `rdma_create_id'
verbs.c:(.text+0x9c3e3): undefined reference to `rdma_resolve_addr'
verbs.c:(.text+0x9c439): undefined reference to `rdma_resolve_route'
verbs.c:(.text+0x9c482): undefined reference to `rdma_destroy_id'
net/built-in.o: In function `rpcrdma_ep_destroy':
(.text+0x9c84d): undefined reference to `rdma_destroy_qp'
net/built-in.o: In function `rpcrdma_ia_close':
(.text+0x9cb44): undefined reference to `rdma_destroy_qp'
net/built-in.o: In function `rpcrdma_ia_close':
(.text+0x9cb4b): undefined reference to `rdma_destroy_id'
net/built-in.o: In function `rpcrdma_ia_open':
(.text+0x9cdb4): undefined reference to `rdma_destroy_id'
net/built-in.o: In function `rpcrdma_ep_connect':
(.text+0x9d2dd): undefined reference to `rdma_destroy_id'
net/built-in.o: In function `rpcrdma_ep_connect':
(.text+0x9d2eb): undefined reference to `rdma_destroy_qp'
net/built-in.o: In function `rpcrdma_ep_connect':
(.text+0x9d2f8): undefined reference to `rdma_destroy_id'
net/built-in.o: In function `rpcrdma_ep_connect':
(.text+0x9d319): undefined reference to `rdma_create_qp'
net/built-in.o: In function `rpcrdma_ep_connect':
(.text+0x9d3e0): undefined reference to `rdma_connect'
net/built-in.o: In function `svc_rdma_detach':
svc_rdma_transport.c:(.text+0x9ddbb): undefined reference to `rdma_disconnect'
net/built-in.o: In function `__svc_rdma_free':
svc_rdma_transport.c:(.text+0x9f041): undefined reference to `rdma_destroy_id'
net/built-in.o: In function `svc_rdma_accept':
svc_rdma_transport.c:(.text+0x9f362): undefined reference to `rdma_create_qp'
svc_rdma_transport.c:(.text+0x9f388): undefined reference to `rdma_create_qp'
svc_rdma_transport.c:(.text+0x9f553): undefined reference to `rdma_accept'
svc_rdma_transport.c:(.text+0x9f682): undefined reference to `rdma_destroy_id'
net/built-in.o: In function `svc_rdma_create':
svc_rdma_transport.c:(.text+0x9f70e): undefined reference to `rdma_create_id'
svc_rdma_transport.c:(.text+0x9f739): undefined reference to `rdma_bind_addr'
svc_rdma_transport.c:(.text+0x9f762): undefined reference to `rdma_listen'
svc_rdma_transport.c:(.text+0x9f79e): undefined reference to `rdma_destroy_id'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc:      J. Bruce Fields <bfields@fieldses.org>
cc:      Trond Myklebust <Trond.Myklebust@netapp.com>
cc:      Roland Dreier <rolandd@cisco.com>
---
 fs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090102.orig/fs/Kconfig
+++ linux-next-20090102/fs/Kconfig
@@ -1305,7 +1305,7 @@ config SUNRPC_GSS
 
 config SUNRPC_XPRT_RDMA
 	tristate
-	depends on SUNRPC && INFINIBAND && EXPERIMENTAL
+	depends on SUNRPC && INFINIBAND_ADDR_TRANS && EXPERIMENTAL
 	default SUNRPC && INFINIBAND
 	help
 	  This option enables an RPC client transport capability that

-- 
~Randy
