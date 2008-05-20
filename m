Return-Path: <linux-kernel-owner+w=401wt.eu-S1765581AbYETM44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765581AbYETM44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbYETM4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:56:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:34033 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbYETM4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:56:47 -0400
Date: Tue, 20 May 2008 14:56:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: JosephChan@via.com.tw
Cc: akpm@linux-foundation.org, geert@linux-m68k.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 1/9] viafb: VIA Frame Buffer Device Driver
Message-ID: <20080520125629.GB4052@ucw.cz>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67705@exchtp03.taipei.via.com.tw> <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67724@exchtp03.taipei.via.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67724@exchtp03.taipei.via.com.tw>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +    color depth:8 bpp, 16 bpp, 32 bpp
> +
> +    Support 2 D hardware accelerator for kernel 2.6.xx

Supports? . at end of line? Remove 2.6 reference as it will work in
2.7+, too, and this docs is not going into 2.4, anyway?


> +[Using the viafb module]
> +-- -- --------------------
> +    Start viafb with default settings,
> +        #modprobe viafb
> +
> +    Start viafb with with user options,
> +        #modprobe viafb mode=800x600 via_fb_bpp=16 refresh=60 
> +                  active_dev=CRT+DVI dvi_port = DVP1 mode1 = 1024 x768 
> +                  via_fb_bpp1 = 16 refresh1 = 60 SAMM_ON = 1
> +
> +    mode:
> +        640 x480(default)
> +        720 x480 
> +        800 x600 
> +        1024 x768
> +        ......
> +
> +    via_fb_bpp:
> +        8, 16, 32(default:32)
> +
> +    refresh:
> +        60, 75, 85, 100, 120(default:60)
> +
> +    lcd_dsp_method:
> +        0 : expandsion(default)

expansion?

> +        1 : centering
> +
> +    lcd_mode:
> +        0 : OPEN LDI(default)
> +        1 : SPWG

This needs to be explained, I guess.

> +    via_fb_accel:
> +        0 : No 2 D Hardware Acceleration(default)
> +        1 : 2 D Hardware Acceleration

Why does it default to no acceleration?

> +    SAMM_ON:
> +        0 : SAMM_ON disable(default)
> +        1 : SAMM_ON enable

...needs better explanation.

> +    second_size:
> +        This option is used to set second device memory size(MB) in
> SAMM case.
> +        The minimal size is 16. 
> +
> +    EPIA_DVI:
> +        This option is used to enable DVI on EPIA - M 
> +        0 : No DVI on EPIA - M(default)
> +        1 : DVI on EPIA - M
> +
> +    BusWidth:
> +        When using 24 - Bit Bus Width Digital Interface, this option
> should be set.
> +        12: 12-Bit LVDS or 12-Bit TMDS(default)
> +        24: 24-Bit LVDS or 24-Bit TMDS
> +
> +    LCDDualEdge:
> +        When using Dual Edge Panel, this option should be set.
> +        0 : No Dual Edge Panel(default)
> +        1 : Dual Edge Panel
> +
> +    video_dev:
> +        This option is used to specify video output devices(CRT, DVI,
> LCD) for duoview case.
> +        For example:
> +        To output video on DVI, we should use:
> +            modprobe viafb video_dev = DVI...
> +
> +    lcd_port:
> +	      This option is used to specify lcd output port,
> +        available values are "DVP0" "DVP1" "DFP_HIGHLOW" "DFP_HIGH"
> +	      "DFP_LOW", for external LCD + external DVI on
> CX700(External LCD is on DVP0), 
> +        we should use:
> +	          modprobe viafb lcd_port = DVP0...
> +
> +Note:

notes?

> +    1. CRT may not display properly for DuoView CRT & DVI display at
> +       the "640x480" PAL mode with DVI overscan enabled.
> +    2. When SAMM is enable, mode and mode1, via_fb_bpp and via_fb_bpp1,

enabled?

> +       refresh and refresh1 can be different.
> +    3. When console is depend on viafbinfo1, dynamically change

depend -- check spelling.

> +[Bootup with viafb]:
> +--------------------
> +    Add the following line to your lilo.conf:
> +        append =  "video=viafb:mode:1024x768,via_fb_bpp:32,refresh:85"

Hmm, who uses lilo these days?


> diff -Nur a/drivers/video/Kconfig b/drivers/video/Kconfig
> --- a/drivers/video/Kconfig	2008-05-06 07:05:59.000000000 -0400
> +++ b/drivers/video/Kconfig	2008-05-06 07:06:37.000000000 -0400
> @@ -1501,6 +1501,24 @@
>  	  (315/H/PRO, 55x, 650, 651, 740, 330, 661, 741, 760, 761) as
> well
>  	  as XGI V3XT, V5, V8 and Z7.
>  
> +config FB_VIA
> +	tristate "VIA UniChrome (Pro) and Chrome9 display support"
> +	depends on FB && PCI
> +	select FB_CFB_FILLRECT
> +	select FB_CFB_COPYAREA
> +	select FB_CFB_IMAGEBLIT
> +	select FB_SOFT_CURSOR
> +        help
> +          This is the frame buffer device driver for Graphics chips of
> VIA 
> +          UniChrome (Pro) Family
> (CLE266,PM800/CN400,P4M800CE/P4M800Pro/
> +          CN700/VN800,CX700/VX700,P4M890) and Chrome9 Family
> (K8M890,CN896
> +          /P4M900,VX800)
> +
> +          Say Y if you have a VIA UniChrome graphics board.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called viafb.

Strange indentation.

> +	} else {
> +		/* Diable VQ */

disable?

> +		switch (chip_info.gfx_chip_name) {
> +		case UNICHROME_K8M890:
> +		case UNICHROME_P4M900:
> +			MMIO_OUT32(0x41c, 0x00100000);
> +			MMIO_OUT32(0x420, 0x74301000);
> +			break;

Can we get symbolic names and comments here?

> +	case IGA1:
> +	default:
> +		temp &= 0x7FFFFFFF;
> +	}
> +	MMIO_OUT32(VIA_REG_CURSOR_MODE, temp); }

Check indentation.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
