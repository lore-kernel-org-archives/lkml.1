Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbXD0Xu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbXD0Xu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757919AbXD0Xu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:50:26 -0400
Received: from omta05ps.mx.bigpond.com ([144.140.83.195]:62033 "EHLO
	omta05ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918AbXD0XuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:50:09 -0400
Message-ID: <46328C28.5040908@bigpond.net.au>
Date: Sat, 28 Apr 2007 09:50:00 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>, jgarzik@pobox.com
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux-2.6.21 hangs during post boot initialization phase
References: <463166C2.6060106@bigpond.net.au> <alpine.LFD.0.98.0704262035410.9964@woody.linux-foundation.org> <46319297.905@bigpond.net.au> <20070427122247.GA19017@hmsreliant.homelinux.net> <4632088C.8000509@bigpond.net.au> <20070427171150.GF19017@hmsreliant.homelinux.net>
In-Reply-To: <20070427171150.GF19017@hmsreliant.homelinux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07ps.mx.bigpond.com from [138.130.231.4] using ID pwil3058@bigpond.net.au at Fri, 27 Apr 2007 23:50:06 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> On Sat, Apr 28, 2007 at 12:28:28AM +1000, Peter Williams wrote:
>> Neil Horman wrote:
>>> On Fri, Apr 27, 2007 at 04:05:11PM +1000, Peter Williams wrote:
> 
> Damn, This is what happens when I try to do things too quickly.  I missed one
> spot in my last patch where I replaced skb with rx_skb.  Its not critical, but
> it should improve sis900 performance by quite a bit.  This applies on top of the
> last two patches.  Sorry about that.
> 
> Thanks & Regards
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> 
>  sis900.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
>  
> diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
> index 7e44939..db59dce 100644
> --- a/drivers/net/sis900.c
> +++ b/drivers/net/sis900.c
> @@ -1790,7 +1790,7 @@ static int sis900_rx(struct net_device *net_dev)
>  			/* give the socket buffer to upper layers */
>  			rx_skb = sis_priv->rx_skbuff[entry];
>  			skb_put(rx_skb, rx_size);
> -			skb->protocol = eth_type_trans(rx_skb, net_dev);
> +			rx_skb->protocol = eth_type_trans(rx_skb, net_dev);
>  			netif_rx(rx_skb);
>  
>  			/* some network statistics */

My system also boots OK after I add this patch.  Can't tell whether it's 
improved the performance or not.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
