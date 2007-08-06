Return-Path: <linux-kernel-owner+w=401wt.eu-S933610AbXHFUh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610AbXHFUh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932564AbXHFUhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:37:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34765 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261AbXHFUhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:37:09 -0400
Message-ID: <46B78672.9090808@linux.vnet.ibm.com>
Date: Mon, 06 Aug 2007 15:37:06 -0500
From: Brian King <brking@linux.vnet.ibm.com>
Reply-To: brking@linux.vnet.ibm.com
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
CC: santil@us.ibm.com, jgarzik@pobox.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/ibmveth.c: memset fix
References: <200708062217.04361.m.kozlowski@tuxland.pl>
In-Reply-To: <200708062217.04361.m.kozlowski@tuxland.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski wrote:
> Hello,
> 
> 	Looks like memset() is zeroing wrong nr of bytes.

Good catch, however, I think we can just remove this memset altogether
since the memory gets allocated via kzalloc.

-Brian


> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/net/ibmveth.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.23-rc1-mm2-a/drivers/net/ibmveth.c	2007-08-01 08:43:46.000000000 +0200
> +++ linux-2.6.23-rc1-mm2-b/drivers/net/ibmveth.c	2007-08-06 20:34:44.000000000 +0200
> @@ -963,7 +963,7 @@ static int __devinit ibmveth_probe(struc
>  {
>  	int rc, i;
>  	struct net_device *netdev;
> -	struct ibmveth_adapter *adapter = NULL;
> +	struct ibmveth_adapter *adapter;
> 
>  	unsigned char *mac_addr_p;
>  	unsigned int *mcastFilterSize_p;
> @@ -997,7 +997,7 @@ static int __devinit ibmveth_probe(struc
>  	SET_MODULE_OWNER(netdev);
> 
>  	adapter = netdev->priv;
> -	memset(adapter, 0, sizeof(adapter));
> +	memset(adapter, 0, sizeof(*adapter));
>  	dev->dev.driver_data = netdev;
> 
>  	adapter->vdev = dev;
> -
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
