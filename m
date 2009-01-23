Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbZAWXA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbZAWXA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 18:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757406AbZAWXAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 18:00:48 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:17619 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500AbZAWXAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 18:00:47 -0500
Message-ID: <497A4C0F.6050303@oracle.com>
Date: Fri, 23 Jan 2009 15:00:31 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Richard Holden <aciddeath@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       Eric Van Hensbergen <ericvh@gmail.com>
Subject: [patch -next] 9pnet_rdma build error
References: <20090123184826.f2c91472.sfr@canb.auug.org.au> <497A3ABD.5060708@gmail.com>
In-Reply-To: <497A3ABD.5060708@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.497A4C13.00D9:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Holden wrote:
> Stephen Rothwell wrote:
>> Hi all,
>>
>> News:  I will be on leave next week, so there will probably be no
>> linux-next release until Feb 2.
> 
> Error in net/9p caused by CONFIG_NET_9P =y and CONFIG_NET_9P_RDMA=m:
> CONFIG_NET_9P_RDMA is tristate, depending on infiniband which is a module.
> 
> Config and log attached.
> ERROR: "rdma_destroy_id" [net/9p/9pnet_rdma.ko] undefined!
> ERROR: "rdma_connect" [net/9p/9pnet_rdma.ko] undefined!
> ERROR: "rdma_create_id" [net/9p/9pnet_rdma.ko] undefined!
> ERROR: "rdma_create_qp" [net/9p/9pnet_rdma.ko] undefined!
> ERROR: "rdma_resolve_route" [net/9p/9pnet_rdma.ko] undefined!
> ERROR: "rdma_disconnect" [net/9p/9pnet_rdma.ko] undefined!
> ERROR: "rdma_resolve_addr" [net/9p/9pnet_rdma.ko] undefined!

Here is one possible patch for this.


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

--- linux-next-20090121.orig/fs/Kconfig
+++ linux-next-20090121/fs/Kconfig
@@ -1405,7 +1405,7 @@ config SUNRPC_GSS
 
 config SUNRPC_XPRT_RDMA
 	tristate
-	depends on SUNRPC && INFINIBAND && EXPERIMENTAL
+	depends on SUNRPC && INFINIBAND && INFINIBAND_ADDR_TRANS && EXPERIMENTAL
 	default SUNRPC && INFINIBAND
 	help
 	  This option allows the NFS client and server to support

-- 
~Randy
