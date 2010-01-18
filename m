Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046Ab0ARTRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0ARTRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 14:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756028Ab0ARTRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 14:17:51 -0500
Received: from mail.perches.com ([173.55.12.10]:1257 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260Ab0ARTRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 14:17:50 -0500
Subject: Re: [PATCH] video/matrox: Checkpatch cleanups for matroxfb_crtc2.c
From: Joe Perches <joe@perches.com>
To: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>, Krzysztof Helt <krzysztof.h1@wp.pl>,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <201001181934.49519.PeterHuewe@gmx.de>
References: <201001181934.49519.PeterHuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 11:17:49 -0800
Message-ID: <1263842269.26846.122.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 19:34 +0100, Peter Hüwe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> Date: Mon, 18 Jan 2010 19:21:02 +0100
> This patch fixes all 77 errors reported by checkpatch - no functional
> change was made. The line over 80 chars warnings were left untouched.
> diff --git a/drivers/video/matrox/matroxfb_crtc2.c b/drivers/video/matrox/matroxfb_crtc2.c
> index 78414ba..790ca47 100644
> --- a/drivers/video/matrox/matroxfb_crtc2.c
> +++ b/drivers/video/matrox/matroxfb_crtc2.c
> @@ -42,42 +43,41 @@ static int matroxfb_dh_setcolreg(unsigned regno, unsigned red, unsigned green,
>  	blue = CNVT_TOHW(blue, m2info->fbcon.var.blue.length);
>  	transp = CNVT_TOHW(transp, m2info->fbcon.var.transp.length);
>  
> -	col = (red << m2info->fbcon.var.red.offset)     |
> -	      (green << m2info->fbcon.var.green.offset) |
> -	      (blue << m2info->fbcon.var.blue.offset)   |
> -	      (transp << m2info->fbcon.var.transp.offset);
> +	col =	(red << m2info->fbcon.var.red.offset)		|
> +			(green << m2info->fbcon.var.green.offset)	|
> +			(blue << m2info->fbcon.var.blue.offset)		|
> +			(transp << m2info->fbcon.var.transp.offset);

I think this is not an improvement.

[]

> +	case 16:
> +		tmp = 0x00400000;
> +		break;
>  /*		case 32: */

Even in a comment, you should change this indent.

[]
> @@ -428,133 +435,133 @@ static int matroxfb_dh_ioctl(struct fb_info *info,
>  	DBG(__func__)
>  
>  	switch (cmd) {
> -		case FBIOGET_VBLANK:
> -			{
> -				struct fb_vblank vblank;
> -				int err;
> -
> -				err = matroxfb_dh_get_vblank(m2info, &vblank);
> -				if (err)
> -					return err;
> -				if (copy_to_user((void __user *)arg, &vblank, sizeof(vblank)))
> -					return -EFAULT;
> -				return 0;
> -			}

I suggest putting the open braces on the same line as the case
because that's the more common (~2:1) kernel style and it saves
an indent level

	switch (foo) {
	case: bar {
	}
	}

[]

> +	case MATROXFB_SET_OUTPUT_MODE:
> +	case MATROXFB_GET_OUTPUT_MODE:
> +	case MATROXFB_GET_ALL_OUTPUTS:
> +		{
> +			return minfo->fbcon.fbops->fb_ioctl(&minfo->fbcon, cmd, arg);
> +		}

unnecessary braces, 1 indent level deeper than necessary.

cheers, Joe

