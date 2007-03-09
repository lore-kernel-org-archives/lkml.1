Return-Path: <linux-kernel-owner+w=401wt.eu-S1767395AbXCIQtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767395AbXCIQtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767394AbXCIQtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:49:13 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:57742 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767395AbXCIQtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:49:12 -0500
Message-ID: <45F19006.9060607@garzik.org>
Date: Fri, 09 Mar 2007 11:49:10 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Josh Triplett <josh@freedesktop.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Allow pktgen to work with loopback devices.
References: <45EEB011.5020606@freedesktop.org>
In-Reply-To: <45EEB011.5020606@freedesktop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Triplett wrote:
> pktgen currently only works on network devices with type ARPHRD_ETHER.  Add
> support for the loopback device, type ARPHRD_LOOPBACK.
> 
> I've tested this on my system, using a modified pktgen.conf-1-1 with
> s/eth1/lo/g, and it works fine; the network device statistics confirm packet
> transmission and receipt.
> 
> Thanks to Sarah Bailey for discovering and tracking down the problem.
> 
> Signed-off-by: Josh Triplett <josh@freedesktop.org>
> ---
> 
> I intentionally didn't change the error message "not an ethernet device".  For
> the purposes of pktgen, loopback devices act like ethernet devices.
> 
>  net/core/pktgen.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/core/pktgen.c b/net/core/pktgen.c
> index 74a9a32..6fc6f9d 100644
> --- a/net/core/pktgen.c
> +++ b/net/core/pktgen.c
> @@ -1930,7 +1930,7 @@ static struct net_device *pktgen_setup_dev(struct pktgen_dev *pkt_dev)
>  		printk("pktgen: no such netdevice: \"%s\"\n", pkt_dev->ifname);
>  		goto out;
>  	}
> -	if (odev->type != ARPHRD_ETHER) {
> +	if (odev->type != ARPHRD_LOOPBACK && odev->type != ARPHRD_ETHER) {
>  		printk("pktgen: not an ethernet device: \"%s\"\n",
>  		       pkt_dev->ifname);

I'll let DaveM queue this (or not)


