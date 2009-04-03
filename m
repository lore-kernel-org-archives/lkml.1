Return-Path: <linux-kernel-owner+w=401wt.eu-S1763298AbZDCNiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763298AbZDCNiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbZDCNim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:38:42 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:38641 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753434AbZDCNil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:38:41 -0400
Date: Fri, 3 Apr 2009 15:38:37 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Simmons <jsimmons@infradead.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbdev: move logo externs to header file
In-Reply-To: <20090403123143.GA15598@uranus.ravnborg.org>
Message-ID: <alpine.LRH.2.00.0904031537250.32353@vixen.sonytel.be>
References: <alpine.LRH.2.00.0904031157550.32353@vixen.sonytel.be> <20090403123143.GA15598@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009, Sam Ravnborg wrote:
> On Fri, Apr 03, 2009 at 01:45:40PM +0200, Geert Uytterhoeven wrote:
> > Now we have __initconst, we can finally move the external declarations for the
> > various Linux logo structures to <linux/linux_logo.h>.
> > 
> > Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> > Acked-By: James Simmons <jsimmons@infradead.org>
> > ---
> > James' ack dates back to the previous submission (way to long ago), when the
> > logos were still __initdata, which caused failures on some platforms with some
> > toolchain versions.
> > 
> > Note: you have to remove the generated logos, as they're not automatically
> > regenerated if scripts/pnmtologo.c changes.
> 
> Something like this to fix that bug?

Yep, after s/pnmtlogo/pnmtologo/g
(it cannot work as-is, as there's one place where you did spell `pnmtologo'
 correctly ;-)

Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

> Untested as I'm busy atm.
> 
> 	Sam
> 
> diff --git a/drivers/video/logo/Makefile b/drivers/video/logo/Makefile
> index b91251d..6a26982 100644
> --- a/drivers/video/logo/Makefile
> +++ b/drivers/video/logo/Makefile
> @@ -37,22 +37,24 @@ extra-y += $(call logo-cfiles,_clut224,ppm)
>  # Gray 256
>  extra-y += $(call logo-cfiles,_gray256,pgm)
>  
> +pnmtlogo := scripts/pnmtologo
> +
>  # Create commands like "pnmtologo -t mono -n logo_mac_mono -o ..."
>  quiet_cmd_logo = LOGO    $@
> -	cmd_logo = scripts/pnmtologo \
> +	cmd_logo = $(pnmtologo) \
>  			-t $(patsubst $*_%,%,$(notdir $(basename $<))) \
>  			-n $(notdir $(basename $<)) -o $@ $<
>  
> -$(obj)/%_mono.c: $(src)/%_mono.pbm FORCE
> +$(obj)/%_mono.c: $(src)/%_mono.pbm $(pnmtlogo) FORCE
>  	$(call if_changed,logo)
>  
> -$(obj)/%_vga16.c: $(src)/%_vga16.ppm FORCE
> +$(obj)/%_vga16.c: $(src)/%_vga16.ppm $(pnmtlogo) FORCE
>  	$(call if_changed,logo)
>  
> -$(obj)/%_clut224.c: $(src)/%_clut224.ppm FORCE
> +$(obj)/%_clut224.c: $(src)/%_clut224.ppm $(pnmtlogo) FORCE
>  	$(call if_changed,logo)
>  
> -$(obj)/%_gray256.c: $(src)/%_gray256.pgm FORCE
> +$(obj)/%_gray256.c: $(src)/%_gray256.pgm $(pnmtlogo) FORCE
>  	$(call if_changed,logo)
>  
>  # Files generated that shall be removed upon make clean

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
