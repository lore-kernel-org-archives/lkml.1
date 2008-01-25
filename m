Return-Path: <linux-kernel-owner+w=401wt.eu-S1760629AbYAYVGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629AbYAYVGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbYAYVF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:05:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:44988 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757749AbYAYVF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:05:58 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+szdJwo1esRfaR4Tituys5Ut6pEio8aLU0yIGfTD
	ArxNoJyBt4W94G
Date: Fri, 25 Jan 2008 22:05:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] driver: tcm825x - fix logical typo error
In-Reply-To: <20080125202720.GD7233@cvg>
Message-ID: <Pine.LNX.4.64.0801252159140.9538@axis700.grange>
References: <20080125202720.GD7233@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008, Cyrill Gorcunov wrote:

> This patch does fix potential NULL pointer dereference
> due to logical typo error.
> 
> The issue is pointed out by
> Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> Index: linux-2.6.git/drivers/media/video/tcm825x.c
> ===================================================================
> --- linux-2.6.git.orig/drivers/media/video/tcm825x.c	2008-01-23 19:01:47.000000000 +0300
> +++ linux-2.6.git/drivers/media/video/tcm825x.c	2008-01-25 23:13:15.000000000 +0300
> @@ -851,7 +851,7 @@ static int tcm825x_probe(struct i2c_clie
>  	sensor->platform_data = client->dev.platform_data;
>  
>  	if (sensor->platform_data == NULL
> -	    && !sensor->platform_data->is_okay())
> +	    || !sensor->platform_data->is_okay())
>  		return -ENODEV;
>  
>  	sensor->v4l2_int_device = &tcm825x_int_device;

Now that it missed 2.6.24, you probably want to send it to -stable too. 
Even though the patch is trivial, it might be a good idea to cc: v4l2 
maintainer and / or driver author.

Thanks
Guennadi
---
Guennadi Liakhovetski
