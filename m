Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab0BXUVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:21:46 -0500
Received: from edu-smtp-02.edutel.nl ([88.159.1.222]:42098 "EHLO
	edu-smtp-02.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab0BXUVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:21:45 -0500
Message-ID: <4B8585DE.50701@neli.hopto.org>
Date: Wed, 24 Feb 2010 21:02:38 +0100
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Alexandre Bounine <alexb@tundra.com>
CC: mporter@kernel.crashing.org, alexandreb@tundra.com,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       thomas.moll.ext@nsn.com, thomas.moll@sysgo.com
Subject: Re: [PATCH 1/7] RapidIO: Add IDT CPS/TSI switches
References: <20100224151447.GA13661@kaneng01.tundra.com>
In-Reply-To: <20100224151447.GA13661@kaneng01.tundra.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Bounine wrote:
> @@ -369,6 +380,10 @@ static struct rio_dev __devinit *rio_set
>  			     rdev->rswitch->switchid);
>  		rio_route_set_ops(rdev);
>  
> +		if (do_enum && rdev->rswitch->clr_table)
> +			rdev->rswitch->clr_table(port, destid, hopcount,
> +						 RIO_GLOBAL_TABLE);
> +
>  		list_add_tail(&rswitch->node, &rio_switches);
>  
>  	} else

Why clear the tables here, why not in rio_enum_peer?

> +DECLARE_RIO_ROUTE_OPS(RIO_VID_TUNDRA, RIO_DID_TSI572, tsi57x_route_add_entry, tsi57x_route_get_entry, tsi57x_route_clr_table);
> +DECLARE_RIO_ROUTE_OPS(RIO_VID_TUNDRA, RIO_DID_TSI574, tsi57x_route_add_entry, tsi57x_route_get_entry, tsi57x_route_clr_table);
> +DECLARE_RIO_ROUTE_OPS(RIO_VID_TUNDRA, RIO_DID_TSI577, tsi57x_route_add_entry, tsi57x_route_get_entry, tsi57x_route_clr_table);
> +DECLARE_RIO_ROUTE_OPS(RIO_VID_TUNDRA, RIO_DID_TSI578, tsi57x_route_add_entry, tsi57x_route_get_entry, tsi57x_route_clr_table);

Can the 568 and 578 driver be shared? Have a 5xx driver?

Micha
