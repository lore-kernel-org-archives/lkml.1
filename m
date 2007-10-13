Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbXJMBAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbXJMBAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 21:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759779AbXJMBAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 21:00:05 -0400
Received: from smtp2e.orange.fr ([80.12.242.113]:40608 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667AbXJMBAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 21:00:03 -0400
X-ME-UUID: 20071013005959742.B54417000092@mwinf2e21.orange.fr
Date: Sat, 13 Oct 2007 03:59:59 +0300
From: Samuel Ortiz <samuel@sortiz.org>
To: "hinko.kocevar@cetrtapot.si" <hinko.kocevar@cetrtapot.si>
Cc: irda-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [irda-users] [PATCH] mcs7780 needs to free allocated rx buffer
Message-ID: <20071013005959.GB8187@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <470F6A5E.9050703@cetrtapot.si>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470F6A5E.9050703@cetrtapot.si>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hinko,

On Fri, Oct 12, 2007 at 02:36:46PM +0200, hinko.kocevar@cetrtapot.si wrote:
> Hi,
> 
> While testing the mcs7780 based IrDA USB dongle I've stumbled upon
> memory leak in mcs_net_close(). Patch below fixes it.
Thanks for the fix. Applied to my local git, will push forward.

Cheers,
Samuel.


> Signed-off-by: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
> 
> Best regards,
> Hinko
> 
> ----
> 
> 

> --- linux-2.6.23/drivers/net/irda/mcs7780.c.orig	2007-10-12 14:02:55.000000000 +0200
> +++ linux-2.6.23/drivers/net/irda/mcs7780.c	2007-10-12 14:05:03.000000000 +0200
> @@ -678,6 +678,8 @@ static int mcs_net_close(struct net_devi
>  	/* Stop transmit processing */
>  	netif_stop_queue(netdev);
>  
> +	kfree_skb(mcs->rx_buff.skb);
> +
>  	/* kill and free the receive and transmit URBs */
>  	usb_kill_urb(mcs->rx_urb);
>  	usb_free_urb(mcs->rx_urb);

> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >> http://get.splunk.com/
> _______________________________________________
> irda-users mailing list
> irda-users@lists.sourceforge.net
> http://lists.sourceforge.net/lists/listinfo/irda-users


