Return-Path: <linux-kernel-owner+w=401wt.eu-S933303AbXBEUWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303AbXBEUWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933309AbXBEUWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:22:15 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:2351 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303AbXBEUWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:22:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=O4SY56D3oPAsT1mxPeQCCQUtKGHWRgNCdEwUrVenYdmTUDk3k/WMkQ8Yd3Y8TQhrznorFPmBG38TLhyx1KfaDQmu8jH+JZYqSZ5nuyyOEk9MsEj32na/BFK2YhJPIKRrPVYwlS9bfPLvDwHti8w3Y8NUp+QkiIlu0qFRemQwXTM=
Date: Mon, 5 Feb 2007 23:22:06 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: ebs@ebshome.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linuxppc-embedded@ozlabs.org
Subject: Re: [PATCH 2.6.20] ibm_emac: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070205202206.GD11055@martell.zuzino.mipt.ru>
References: <20070205165429.GD3896@Ahmed> <20070205165916.GK3896@Ahmed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205165916.GK3896@Ahmed>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 06:59:16PM +0200, Ahmed S. Darwish wrote:
> A patch to use ARRAY_SIZE macro already defined in kernel.h.

OK, but checks you're changing are strange. idx there is signed so

	BUG_ON(idx < 0 || idx > ARRAY_SIZE());

should be more appropriate.

> --- a/drivers/net/ibm_emac/ibm_emac_debug.c
> +++ b/drivers/net/ibm_emac/ibm_emac_debug.c
> @@ -132,7 +132,7 @@ void emac_dbg_register(int idx, struct ocp_enet_private *dev)
>  {
>  	unsigned long flags;
>  
> -	if (idx >= sizeof(__emacs) / sizeof(__emacs[0])) {
> +	if (idx >= ARRAY_SIZE(__emacs)) {

no __vi, no cookie. :)

>  		printk(KERN_WARNING
>  		       "invalid index %d when registering EMAC for debugging\n",
>  		       idx);
> @@ -148,7 +148,7 @@ void mal_dbg_register(int idx, struct ibm_ocp_mal *mal)
>  {
>  	unsigned long flags;
>  
> -	if (idx >= sizeof(__mals) / sizeof(__mals[0])) {
> +	if (idx >= ARRAY_SIZE(__mals)) {
>  		printk(KERN_WARNING
>  		       "invalid index %d when registering MAL for debugging\n",
>  		       idx);

