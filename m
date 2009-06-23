Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbZFWRAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbZFWRAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758439AbZFWRAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:00:18 -0400
Received: from mx2.netapp.com ([216.240.18.37]:14719 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524AbZFWRAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:00:16 -0400
X-IronPort-AV: E=Sophos;i="4.42,276,1243839600"; 
   d="scan'208";a="195006649"
Subject: Re: [PATCH 04/10] sunrpc: Use rcu_barrier() on unload.
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Jesper Dangaard Brouer <hawk@comx.dk>
Cc: "David S. Miller" <davem@davemloft.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, dougthompson@xmission.com,
       bluesmoke-devel@lists.sourceforge.net, axboe@kernel.dk,
       Patrick McHardy <kaber@trash.net>, christine.caulfield@googlemail.com,
       linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
       yoshfuji@linux-ipv6.org, shemminger@linux-foundation.org,
       linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de,
       linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@sun.com,
       netfilter-devel@vger.kernel.org
In-Reply-To: <20090623150414.22490.14888.stgit@localhost>
References: <20090623150330.22490.87327.stgit@localhost>
	 <20090623150414.22490.14888.stgit@localhost>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Tue, 23 Jun 2009 12:59:13 -0400
Message-Id: <1245776353.9586.1.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 23 Jun 2009 17:00:06.0681 (UTC) FILETIME=[0F245890:01C9F424]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 17:04 +0200, Jesper Dangaard Brouer wrote:
> The sunrpc module uses rcu_call() thus it should use rcu_barrier() on
> module unload.
> 
> Have not verified that the possibility for new call_rcu() callbacks
> has been disabled.  As a hint for checking, the functions calling
> call_rcu() (unx_destroy_cred and generic_destroy_cred) are
> registered as crdestroy function pointer in struct rpc_credops.
> 
> Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
> ---
> 
>  net/sunrpc/sunrpc_syms.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/sunrpc/sunrpc_syms.c b/net/sunrpc/sunrpc_syms.c
> index 843629f..adaa819 100644
> --- a/net/sunrpc/sunrpc_syms.c
> +++ b/net/sunrpc/sunrpc_syms.c
> @@ -66,6 +66,7 @@ cleanup_sunrpc(void)
>  #ifdef CONFIG_PROC_FS
>  	rpc_proc_exit();
>  #endif
> +	rcu_barrier(); /* Wait for completion of call_rcu()'s */
>  }
>  MODULE_LICENSE("GPL");
>  module_init(init_sunrpc);
> 

Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
