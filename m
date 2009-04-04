Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbZDDLCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbZDDLCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 07:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbZDDLCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 07:02:04 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:1861 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbZDDLCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 07:02:03 -0400
Date: Sat, 4 Apr 2009 13:03:31 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: spock@gentoo.org
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] vga16fb: fix color component length for pseudocolor
 modes
Message-Id: <20090404130331.52ce51f4.krzysztof.h1@poczta.fm>
In-Reply-To: <20090402122613.GA16899@tria>
References: <20090330220523.GA6993@spock.one.pl>
	<20090401185856.44d89699.krzysztof.h1@poczta.fm>
	<20090402122613.GA16899@tria>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 5ce2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009 14:26:13 +0200
Michal Januszewski <spock@gentoo.org> wrote:

> vga16fb incorrectly sets the length of the color fields to 6 or 2 bits
> for PSEUDOCOLOR modes, for which either 8 or 4 bits are used per pixel.
> Fix this by setting the length to 8 or 4, respectively.
> 
> Signed-off-by: Michal Januszewski <spock@gentoo.org>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>


> diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
> index 5b29389..8f1eb7f 100644
> --- a/drivers/video/vga16fb.c
> +++ b/drivers/video/vga16fb.c
> @@ -506,7 +506,7 @@ static int vga16fb_check_var(struct fb_var_screeninfo *var,
>  	var->red.offset = var->green.offset = var->blue.offset = 
>  	var->transp.offset = 0;
>  	var->red.length = var->green.length = var->blue.length =
> -		(par->isVGA) ? 6 : 2;
> +		(par->isVGA) ? 8 : 4;
>  	var->transp.length = 0;
>  	var->activate = FB_ACTIVATE_NOW;
>  	var->height = -1;
> @@ -1324,7 +1324,7 @@ static int __init vga16fb_probe(struct platform_device *dev)
>  	par->palette_blanked = 0;
>  	par->vesa_blanked = 0;
>  
> -	i = par->isVGA? 6 : 2;
> +	i = par->isVGA? 8 : 4;
>  	
>  	vga16fb_defined.red.length   = i;
>  	vga16fb_defined.green.length = i;
> 

----------------------------------------------------------------------
Kredyt z doplata, nawet 200 000 zl. Sprawdz!
http://link.interia.pl/f20fc

