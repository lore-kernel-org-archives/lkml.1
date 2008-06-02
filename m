Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbYFBLTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbYFBLTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbYFBLS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:18:57 -0400
Received: from stinky.trash.net ([213.144.137.162]:33154 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbYFBLS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:18:56 -0400
Message-ID: <4843D71A.5090107@trash.net>
Date: Mon, 02 Jun 2008 13:18:50 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Rami Rosen <ramirose@gmail.com>
CC: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-2.6] [NETFILTER] Misc Cleanups.
References: <20080601.234549.229050768.davem@davemloft.net>	 <4843C183.4060008@trash.net> <eb3ff54b0806020411p16531d2chb05061a6d209b406@mail.gmail.com>
In-Reply-To: <eb3ff54b0806020411p16531d2chb05061a6d209b406@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rami Rosen wrote:
> Hi,
>   - Thanks for your comments; I was not aware that this issues occur
> in other places too; attached here is another patch, fixing where
> applicable in ip6_queue and nfnetlink_queue.
> 
>   1) in net/ipv6/netfilter/ip6_queue.c
>     - No need to perform data_len = 0 in the switch command, since data_len
> 	   is initialized to 0 in the beginning of the
> ipq_build_packet_message() method
>     - We can reach nlmsg_failure only from one place; skb is sure to be NULL
> 	     when getting there; since skb is NULL, there is no need to check this fact
> 	     and call kfree_skb().
> 
> 2) in net/netfilter/nfnetlink_queue.c:
>     - No need to perform data_len = 0 in the switch command, since data_len
> 	   is initialized to 0 in the beginning of the
> nfqnl_build_packet_message() method
> 
> (Note: here, as opposed to previous patch, nlmsg_failure must check
> skb and free it if it is not NULL, so the call to kfree_skb() is
> needed , so it is not removed)


I've queued this patch and the previous one (without the procfs
bits) as one combined patch for 2.6.27, thanks.

