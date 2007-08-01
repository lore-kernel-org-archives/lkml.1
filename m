Return-Path: <linux-kernel-owner+w=401wt.eu-S1751517AbXHAVEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbXHAVEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbXHAVDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:03:55 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:49558 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbXHAVDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:03:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ptLbGiUD0HthJCTZyLnf7QusuFsSpHvo6FkS2PooZc+dnKaIBCSQfpwYCLE/kWxt30DTCHnve5KvLhyxtZQgzUSxfqGWiVkSW+4yCIYJ1SgIMI4DsMf50jOg0w/7IQitcIn9suH1umzg5ztY0Bddy77rzf21KiBdmU0iYVwUUoI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: Re: [PATCH 30] drivers/ide/arm/icside.c: kmalloc + memset conversion to kzalloc
Date: Wed, 1 Aug 2007 23:01:48 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, rmk@arm.linux.org.uk
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200707311958.20683.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311958.20683.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708012301.48963.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 July 2007, Mariusz Kozlowski wrote:
> Is this a bug? In original verison memset cleared sizeof(state) bytes
> instead of sizeof(*state). If it was intentional then this patch is invalid.
> If not intentional -> valid :) Please review.

Yes, it is a bug so this patch is a valid bugfix. :-)

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

>  drivers/ide/arm/icside.c | 18883 -> 18849 (-34 bytes)
> 
>  drivers/ide/arm/icside.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

applied

> --- linux-2.6.23-rc1-mm1-a/drivers/ide/arm/icside.c	2007-07-26 13:07:41.000000000 +0200
> +++ linux-2.6.23-rc1-mm1-b/drivers/ide/arm/icside.c	2007-07-31 11:32:27.000000000 +0200
> @@ -682,13 +682,12 @@ icside_probe(struct expansion_card *ec,
>  	if (ret)
>  		goto out;
> 
> -	state = kmalloc(sizeof(struct icside_state), GFP_KERNEL);
> +	state = kzalloc(sizeof(struct icside_state), GFP_KERNEL);
>  	if (!state) {
>  		ret = -ENOMEM;
>  		goto release;
>  	}
> 
> -	memset(state, 0, sizeof(state));
>  	state->type	= ICS_TYPE_NOTYPE;
>  	state->dev	= &ec->dev;
> 
