Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbXBNN2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbXBNN2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 08:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932279AbXBNN2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 08:28:46 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:17058 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbXBNN2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 08:28:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=QUSg7fwNwtAso9Xf9jtEwgBVYtOkJEqtVVOte1OmtagRdXBp0hOi6ksMRIsb0W07C5htVgXaD7jmjsX6i34DBCio8kb+JQ4UcBufoF0zUJPv/q0VA9mOLtYAuq6Jw3CuejFkq9GiHLii70cCUDRdot5qRIbUh0lm49FmfzsAFZM=
Date: Wed, 14 Feb 2007 15:28:34 +0200
To: Mark Brown <broonie@sirena.org.uk>
Cc: Tim Hockin <thockin@hockin.org>, Jeff Garzik <jgarzik@pobox.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] natsemi: Add support for using MII port with no PHY
Message-ID: <20070214132834.GA4436@Ahmed>
References: <20070214100203.413293000@sirena.org.uk> <20070214100226.540001000@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214100226.540001000@sirena.org.uk>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 10:02:04AM +0000, Mark Brown wrote:

> Signed-Off-By: Mark Brown <broonie@sirena.org.uk>
> 
[...]
> -		if (np->phy_addr_external == PHY_ADDR_NONE) {
> +		/* If we're ignoring the PHY it doesn't matter if we can't
> +		 * find one. */
> +		if (!np->ignore_phy && np->phy_addr_external == PHY_ADDR_NONE) {
[...]
> +	if (!np->ignore_phy) {
> +		/* The link status field is latched: it remains low
> +		 * after a temporary link failure until it's read. We
> +		 * need the current link status, thus read twice.
> +		 */
> +		mdio_read(dev, MII_BMSR);
> +		bmsr = mdio_read(dev, MII_BMSR);
[...]
>  	/*
> +	 * If we're ignoring the PHY then autoneg and the internal
> +	 * transciever are really not going to work so don't let the
> +	 * user select them.
> +	 */
> +	if (np->ignore_phy && (ecmd->autoneg == AUTONEG_ENABLE ||

A trivial comment actually, Is there a point to write multi-line comments 
in two different formats ?

Thanks,

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
