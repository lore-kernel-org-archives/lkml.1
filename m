Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbXB1XRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbXB1XRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 18:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbXB1XRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 18:17:42 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47274 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbXB1XRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 18:17:40 -0500
Date: Wed, 28 Feb 2007 15:11:03 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Dale Farnsworth" <dale@farnsworth.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-mips@linux-mips.org,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 1/2] mv643xx_eth: move mac_addr inside of
 mv643xx_eth_platform_data
Message-ID: <20070228151103.0c5a320d@freekitty>
In-Reply-To: <20070228224031.GA8233@xyzzy.farnsworth.org>
References: <20070228224031.GA8233@xyzzy.farnsworth.org>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007 15:40:31 -0700
"Dale Farnsworth" <dale@farnsworth.org> wrote:

> The information contained within platform_data should be self-contained.
> Replace the pointer to a MAC address with the actual MAC address in
> struct mv643xx_eth_platform_data.
> 
> Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
> 
> Index: b/drivers/net/mv643xx_eth.c
> ===================================================================
> --- a/drivers/net/mv643xx_eth.c
> +++ b/drivers/net/mv643xx_eth.c
> @@ -1380,7 +1380,9 @@ static int mv643xx_eth_probe(struct plat
>  
>  	pd = pdev->dev.platform_data;
>  	if (pd) {
> -		if (pd->mac_addr)
> +		static u8 zero_mac_addr[6] = { 0 };
> +
> +		if (memcmp(pd->mac_addr, zero_mac_addr, 6) != 0)
>  			memcpy(dev->dev_addr, pd->mac_addr, 6);


is_zero_ether_addr() is faster/cleaner for this

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
