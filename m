Return-Path: <linux-kernel-owner+w=401wt.eu-S1757704AbXHXKlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704AbXHXKlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 06:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbXHXKlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 06:41:18 -0400
Received: from hu-out-0506.google.com ([72.14.214.232]:59577 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbXHXKlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 06:41:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=WsjWaOKaqfv6BfUp0b1oJe6dpKncdagUqlN9HODlT5m/cO2dUc0QM99BJhoj5HDfLD7spNqNJBDO3yBqkVbbMSR02o+L6+4upixSq0og66hAd5skPFSk+YTkE1/iY3xx784izKgmvibQGDEoAZs7hrdTFySdyVghSj1+Z/UuypI=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH 09/30] mtd: Don't cast kmalloc() return value in drivers/mtd/maps/pmcmsp-flash.c
Date: Fri, 24 Aug 2007 11:41:06 +0100
User-Agent: KMail/1.9.1
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com> <5ebfb93eca0dd43cf17876e643079cbcfeb3111c.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <5ebfb93eca0dd43cf17876e643079cbcfeb3111c.1187912217.git.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708241141.06358.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2007 00:52, Jesper Juhl wrote:
> kmalloc() returns a void pointer.
> No need to cast it.

> -	msp_flash = (struct mtd_info **)kmalloc(
> -			fcnt * sizeof(struct map_info *), GFP_KERNEL);
> -	msp_parts = (struct mtd_partition **)kmalloc(
> -			fcnt * sizeof(struct mtd_partition *), GFP_KERNEL);
> -	msp_maps = (struct map_info *)kmalloc(
> -			fcnt * sizeof(struct mtd_info), GFP_KERNEL);
> +	msp_flash = kmalloc(fcnt * sizeof(struct map_info *), GFP_KERNEL);
> +	msp_parts = kmalloc(fcnt * sizeof(struct mtd_partition *), GFP_KERNEL);
> +	msp_maps = kmalloc(fcnt * sizeof(struct mtd_info), GFP_KERNEL);
>  	memset(msp_maps, 0, fcnt * sizeof(struct mtd_info));

This one wants kzalloc.

> -		msp_parts[i] = (struct mtd_partition *)kmalloc(
> -			pcnt * sizeof(struct mtd_partition), GFP_KERNEL);
> +		msp_parts[i] = kmalloc(pcnt * sizeof(struct mtd_partition),
> +			GFP_KERNEL);
>  		memset(msp_parts[i], 0, pcnt * sizeof(struct mtd_partition));
>
>  		/* now initialize the devices proper */

Same
--
vda
