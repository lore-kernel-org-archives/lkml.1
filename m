Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbYCQQrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbYCQQrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 12:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYCQQrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 12:47:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:8875 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbYCQQrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 12:47:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,513,1199692800"; 
   d="scan'208";a="306989103"
Message-ID: <47DE9E5C.6080603@intel.com>
Date: Mon, 17 Mar 2008 09:37:48 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: jeffrey.t.kirsher@intel.com, ayyappan.veeraiyan@intel.com,
       john.ronciak@intel.com, jesse.brandeburg@intel.com,
       auke-jan.h.kok@intel.com, e1000-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/7] drivers/net/ixgb/ixgb_main.c: remove unused variable
References: <Pine.LNX.4.64.0803151703520.24178@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0803151703520.24178@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Mar 2008 16:38:45.0248 (UTC) FILETIME=[5E16F000:01C8884D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, i'll pass it along. ty

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The variable num_group_tail_writes is initialized but never used otherwise.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> type T;
> identifier i;
> constant C;
> @@
> 
> (
> extern T i;
> |
> - T i;
>   <+... when != i
> - i = C;
>   ...+>
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
>  drivers/net/ixgb/ixgb_main.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff -u -p a/drivers/net/ixgb/ixgb_main.c b/drivers/net/ixgb/ixgb_main.c
> --- a/drivers/net/ixgb/ixgb_main.c 2008-03-12 14:13:13.000000000 +0100
> +++ b/drivers/net/ixgb/ixgb_main.c 2008-03-15 11:16:23.000000000 +0100
> @@ -2088,14 +2088,12 @@ ixgb_alloc_rx_buffers(struct ixgb_adapte
>  	struct ixgb_buffer *buffer_info;
>  	struct sk_buff *skb;
>  	unsigned int i;
> -	int num_group_tail_writes;
>  	long cleancount;
>  
>  	i = rx_ring->next_to_use;
>  	buffer_info = &rx_ring->buffer_info[i];
>  	cleancount = IXGB_DESC_UNUSED(rx_ring);
>  
> -	num_group_tail_writes = IXGB_RX_BUFFER_WRITE;
>  
>  	/* leave three descriptors unused */
>  	while(--cleancount > 2) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

