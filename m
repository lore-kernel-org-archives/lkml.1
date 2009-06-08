Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZFHKZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZFHKZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 06:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbZFHKZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 06:25:19 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42878 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbZFHKZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 06:25:18 -0400
Date: Mon, 8 Jun 2009 06:25:08 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: davem@davemloft.net, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] ftrace: change the export format of trace_kfree_skb()
Message-ID: <20090608102508.GA4304@hmsreliant.think-freely.org>
References: <4A2CD77F.7080609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2CD77F.7080609@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 05:18:55PM +0800, Xiao Guangrong wrote:
> Use %pf instead of %p to output the function's address, use 0x%04X instead
> of %u to output the skb's protocol
> 
> Before patch:
> 
>           <idle>-0     [000] 60144.542521: kfree_skb: skbaddr=de7b8240 protocol=2048 location=c1365429
>           <idle>-0     [000] 60164.488153: kfree_skb: skbaddr=da66f900 protocol=2048 location=c1365429
>           <idle>-0     [000] 60193.493933: kfree_skb: skbaddr=deaeb480 protocol=4 location=c134ec25
>           <idle>-0     [000] 60253.118421: kfree_skb: skbaddr=de7c4900 protocol=4 location=c134ec25
>           
> After patch:
> 
>             bash-2587  [001] 97685.781173: kfree_skb: skbaddr=deb9cc00 protocol=0x0000 location=netlink_unicast
>             bash-2587  [000] 97686.501121: kfree_skb: skbaddr=df9bb840 protocol=0x0000 location=netlink_unicast
>           <idle>-0     [000] 97696.200184: kfree_skb: skbaddr=df741240 protocol=0x0800 location=ip_rcv
>           <idle>-0     [000] 97696.200198: kfree_skb: skbaddr=dfb3de40 protocol=0x0800 location=ip_rcv
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  include/trace/events/skb.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>  mode change 100644 => 100755 include/trace/events/skb.h
> 
> diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
> old mode 100644
> new mode 100755
> index 1e8fabb..a58bef8
> --- a/include/trace/events/skb.h
> +++ b/include/trace/events/skb.h
> @@ -30,7 +30,7 @@ TRACE_EVENT(kfree_skb,
>  		__entry->location = location;
>  	),
>  
> -	TP_printk("skbaddr=%p protocol=%u location=%p",
> +	TP_printk("skbaddr=%p protocol=0x%04X location=%pf",
>  		__entry->skbaddr, __entry->protocol, __entry->location)
>  );

No objection to the code change, but whats with the new mode?  Why are you
making the file executable?

Neil

