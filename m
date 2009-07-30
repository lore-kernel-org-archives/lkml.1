Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbZG3SvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbZG3SvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 14:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZG3SvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 14:51:20 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:50084 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZG3SvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 14:51:19 -0400
Date: Thu, 30 Jul 2009 19:50:44 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ohad Ben-Cohen <ohad@bencohen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Philip Langdale <philipl@overt.org>, ian@mnementh.co.uk,
       pierre@ossman.eu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-l@jasper.es,
       Adrian Hunter <adrian.hunter@nokia.com>, Madhusudhan <madhu.cr@ti.com>
Subject: Re: [PATCH] sdio: add CD disable support
Message-ID: <20090730185044.GH3058@console-pimps.org>
References: <1248954848.5396.6.camel@localhost> <20090730124543.GF3058@console-pimps.org> <bd5b16740907300855y2ee0f76fv5886606fcee241b7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd5b16740907300855y2ee0f76fv5886606fcee241b7@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 06:55:14PM +0300, Ohad Ben-Cohen wrote:
> On Thu, Jul 30, 2009 at 3:45 PM, Matt Fleming<matt@console-pimps.org> wrote:
> > Do you have a follow-up patch to make use of this new functionality?
> 
> Well, sort of:
> 
> The patch sets disable_cd for TI wl1271 embedded wlan sdio device on a
> ZOOM2 platform.
> 
> Since the patch is very board/device specific, we first route it via
> internal maintainers, so it is not posted yet.
> 
> It's nothing fancy:
> 
> diff --git a/arch/arm/mach-omap2/mmc-twl4030.c
> b/arch/arm/mach-omap2/mmc-twl4030.c
> index 5b64bf1..caa8b16 100644
> --- a/arch/arm/mach-omap2/mmc-twl4030.c
> +++ b/arch/arm/mach-omap2/mmc-twl4030.c
> @@ -81,6 +81,7 @@ static struct embedded_sdio_data omap_wifi_emb_data = {
>  		.wide_bus       = 1,
>  		.high_power     = 0,
>  		.high_speed     = 0,
> +		.disable_cd	= 1,
>  	},
>  	.funcs  = wifi_func_array,
>  	.num_funcs = 2,

Ah, that's fair enough then. I just wanted to make sure that a patch
that used this functionality was in the pipeline :-)

As David has already said, both comments need fixing up. It is the host
controller driver that decides whether to disable the DAT[3] pull-up,
not the card. If you make those changes then you can add my Acked-by.
