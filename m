Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816Ab0ARXVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab0ARXVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 18:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759Ab0ARXVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 18:21:54 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:41999 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab0ARXVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 18:21:53 -0500
Date: Tue, 19 Jan 2010 12:21:48 +1300
From: Simon Horman <horms@verge.net.au>
To: Mohan Reddy <mohanreddykv@gmail.com>
Cc: wensong@linux-vs.org, ja@ssi.bg, linux-kernel@vger.kernel.org,
       lvs-devel@vger.kernel.org
Subject: Re: [PATCH] IPVS: SCTP Tranport Load Balancing Support to IPVS
Message-ID: <20100118232148.GB20302@verge.net.au>
References: <20100118175009.GA7812@mohan-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118175009.GA7812@mohan-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 11:20:11PM +0530, Mohan Reddy wrote:
> This patch adds SCTP packet load balancing support to IPVS. This patch is written against linux-2.6.32.3 kernel. This has been written based on the SCTP FSM desribed in the RFC 4960. All the posibilities of chunks have been taken care. 
> 
> Once the IPVS receives an SCTP packet with INIT chunk we will create a 
> connection object and chooses a real and forward the packet based on the
> forwarding method. After creating the connection we will drive the FSM based 
> on the chunks(in this code they are called as events). The return packet from
> the server will be an INIT ACK chunck, then we will move the FSM state to
> IP_VS_S_INIT_ACK_SER. Like this all the chunks have next states. 
> 
> As all the packets are destined to the virtual server (VIP) we haven't handled
> multihomed endpoints.
> 
> 
> Signed-off-by : Venkata Mohan Reddy Koppula <mohanreddykv@gmail.com>
> 
> 
>   

Hi,

I haven't had time to review your patch properly yet.
But I have two minor comments.

Firstly, could you please base your work on Patrick McHardy's nf-next-2.6
tree or at least Dave Miller's the net-next-2.6 tree. At this stage it just
looks like you'll need to re-diff the patch.

[snip]

> diff -Npaur linux-2.6.32.3/net/netfilter/ipvs/Kconfig linux-2.6.32.3_new/net/netfilter/ipvs/Kconfig
> --- linux-2.6.32.3/net/netfilter/ipvs/Kconfig	2010-01-07 04:37:45.000000000 +0530
> +++ linux-2.6.32.3_new/net/netfilter/ipvs/Kconfig	2010-01-16 21:19:54.772760964 +0530
> @@ -100,6 +100,12 @@ config	IP_VS_PROTO_AH
>  	  This option enables support for load balancing AH (Authentication
>  	  Header) transport protocol. Say Y if unsure.
>  
> +config  IP_VS_PROTO_SCTP
> +	bool "SCTP load balancing support"

You need 

	select CRC32C

here.

> +	---help---
> +	  This option enables support for load balancing SCTP transport
> +	  protocol. Say Y if unsure.
> +
>  comment "IPVS scheduler"
>  
>  config	IP_VS_RR

[snip]
