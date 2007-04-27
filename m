Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbXD0RMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbXD0RMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbXD0RMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:12:33 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3485 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629AbXD0RMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:12:30 -0400
Date: Fri, 27 Apr 2007 13:11:50 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jgarzik@pobox.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux-2.6.21 hangs during post boot initialization phase
Message-ID: <20070427171150.GF19017@hmsreliant.homelinux.net>
References: <463166C2.6060106@bigpond.net.au> <alpine.LFD.0.98.0704262035410.9964@woody.linux-foundation.org> <46319297.905@bigpond.net.au> <20070427122247.GA19017@hmsreliant.homelinux.net> <4632088C.8000509@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4632088C.8000509@bigpond.net.au>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 12:28:28AM +1000, Peter Williams wrote:
> Neil Horman wrote:
> >On Fri, Apr 27, 2007 at 04:05:11PM +1000, Peter Williams wrote:

Damn, This is what happens when I try to do things too quickly.  I missed one
spot in my last patch where I replaced skb with rx_skb.  Its not critical, but
it should improve sis900 performance by quite a bit.  This applies on top of the
last two patches.  Sorry about that.

Thanks & Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 sis900.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

 
diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
index 7e44939..db59dce 100644
--- a/drivers/net/sis900.c
+++ b/drivers/net/sis900.c
@@ -1790,7 +1790,7 @@ static int sis900_rx(struct net_device *net_dev)
 			/* give the socket buffer to upper layers */
 			rx_skb = sis_priv->rx_skbuff[entry];
 			skb_put(rx_skb, rx_size);
-			skb->protocol = eth_type_trans(rx_skb, net_dev);
+			rx_skb->protocol = eth_type_trans(rx_skb, net_dev);
 			netif_rx(rx_skb);
 
 			/* some network statistics */
