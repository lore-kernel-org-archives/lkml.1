Return-Path: <linux-kernel-owner+w=401wt.eu-S933417AbZLMB2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbZLMB2b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933390AbZLMB2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:28:31 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40252 "HELO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933394AbZLMB2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:28:30 -0500
Date: Sat, 12 Dec 2009 20:10:56 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jean Delvare <jdelvare@suse.de>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Jeff Mahoney <jeffm@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fb/intelfb: Do not depend on EMBEDDED
In-Reply-To: <200912121419.18617.jdelvare@suse.de>
Message-ID: <alpine.DEB.2.00.0912122008570.23394@skynet.skynet.ie>
References: <200912121419.18617.jdelvare@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I am worried that the intelfb driver depends on EMBEDDED. I consider
> this an abuse of the EMBEDDED configuration option, which as I
> understand it was originally meant to expose fine-tuning options,
> rather than to arbitrarily disable drivers when not selected.

Since we merged a kms driver for Intel hw that supports all intel chipsets
and more importantly all the outputs on Intel chipsets, intelfb should
be considered legacy at the least and broken on > 50% of intel hw.

We left it in in that most ppl who wanted it were using it in embedded 
configs, whereas for most users it just doesn't work, like I don't thinkit
supports LVDS which means loading it on a laptop will trash it.

Dave


> 
> So I suggest that we drop this dependency now.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Dave Airlie <airlied@linux.ie>
> ---
> Jesse, in the original commit, you wrote that intelfb was "really a
> special purpose embedded driver". It looks like a perfectly standard
> framebuffer driver to me, which means that it may have users beyond
> embedded. For example I always prefer framebuffer over X for my
> servers. Or am I missing something and intelfb is really special?
> 
>  drivers/video/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.32.orig/drivers/video/Kconfig	2009-12-03 08:48:34.000000000 +0100
> +++ linux-2.6.32/drivers/video/Kconfig	2009-12-11 10:57:43.000000000 +0100
> @@ -1121,7 +1121,7 @@ config FB_CARILLO_RANCH
>  
>  config FB_INTEL
>  	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL && EMBEDDED
> +	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL
>  	select FB_MODE_HELPERS
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
> 
> 
