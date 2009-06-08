Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZFHNZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZFHNZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZFHNZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:25:12 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:24180 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbZFHNZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:25:09 -0400
X-RZG-AUTH: :I2ANY0W6W/eA95XfH/xfO6gOxLxTty/udEMngcJ/VAKW226lDNJVyuYELDI/Mbox
X-RZG-CLASS-ID: mo00
Message-ID: <4A2D112A.4000308@hartkopp.net>
Date: Mon, 08 Jun 2009 15:24:58 +0200
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jesper Dangaard Brouer <hawk@comx.dk>
CC: "David S. Miller" <davem@davemloft.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, wg@grandegger.com,
       vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
       Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 3/5] can: af_can.c use rcu_barrier() on module unload.
References: <20090608130959.10052.54590.stgit@localhost> <20090608131138.10052.5408.stgit@localhost>
In-Reply-To: <20090608131138.10052.5408.stgit@localhost>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Dangaard Brouer wrote:
> This module uses rcu_call() thus it should use rcu_barrier()
> on module unload.
> 
> Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>

Thanks Jesper for pointing at this issue!

Acked-By: Oliver Hartkopp <oliver@hartkopp.net>

Btw. i do agree with theses patches to be a bug fix that should go into
2.6.30-rc8 as well as into the stable series.

Best regards,
Oliver


> ---
> 
>  net/can/af_can.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index 10f0528..e733725 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -903,6 +903,8 @@ static __exit void can_exit(void)
>  	}
>  	spin_unlock(&can_rcvlists_lock);
>  
> +	rcu_barrier(); /* Wait for completion of call_rcu()'s */
> +
>  	kmem_cache_destroy(rcv_cache);
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

