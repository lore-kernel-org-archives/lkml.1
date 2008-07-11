Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYGKFWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYGKFWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 01:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYGKFWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 01:22:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49699 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbYGKFWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 01:22:41 -0400
Message-ID: <4876EE17.5050800@garzik.org>
Date: Fri, 11 Jul 2008 01:22:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Laurent Pinchart <laurentp@cse-semaphore.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH linux-next-20080704] Fix missing exports for net/phy/mdio-bitbang.c
References: <s5hlk0dwxvi.wl%tiwai@suse.de>
In-Reply-To: <s5hlk0dwxvi.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> {alloc,free}_mdio_bitbang() are not exported while they are used in
> mdio-ofgpio driver.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> ---
> diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/phy/mdio-bitbang.c
> index 2747b1f..c01b780 100644
> --- a/drivers/net/phy/mdio-bitbang.c
> +++ b/drivers/net/phy/mdio-bitbang.c
> @@ -177,6 +177,7 @@ struct mii_bus *alloc_mdio_bitbang(struct mdiobb_ctrl *ctrl)
>  
>  	return bus;
>  }
> +EXPORT_SYMBOL(alloc_mdio_bitbang);
>  
>  void free_mdio_bitbang(struct mii_bus *bus)
>  {
> @@ -185,5 +186,6 @@ void free_mdio_bitbang(struct mii_bus *bus)
>  	module_put(ctrl->ops->owner);
>  	kfree(bus);
>  }
> +EXPORT_SYMBOL(free_mdio_bitbang);
>  
>  MODULE_LICENSE("GPL");

applied


