Return-Path: <linux-kernel-owner+w=401wt.eu-S1945920AbXBVACp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945920AbXBVACp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945922AbXBVACp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:02:45 -0500
Received: from nz-out-0506.google.com ([64.233.162.234]:15743 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945920AbXBVACn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:02:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gNHf4Hhb2jbXV5Zg/HGy88h2DyrnGz17r8oawNIr9KvXWCKet4/ovYPLGCXabRq/uitzzmpLMa1CEdgLmGv7i7yVP+ZpjpUHFDGpYOcvHHgfZMdlFgSfUuDwsKa/vCzz1nEbe5Xjjh7Kb0O3ylyVLhD0uYmk4PGRE1gCcK/q9ls=
Subject: Re: [PATCH] fbdev driver for S3 Trio/Virge, updated
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Ondrej Zajicek <santiago@crfreenet.org>
Cc: James Simmons <jsimmons@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20070209193405.GB2637@localhost.localdomain>
References: <20070209193405.GB2637@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 08:05:33 +0800
Message-Id: <1172102733.4217.38.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 20:34 +0100, Ondrej Zajicek wrote: 
> This patch adds driver for S3 Trio / S3 Virge. Driver is tested
> with most versions of S3 Trio and S3 Virge, on i386.
> It is tested both as compiled-in and module. It is against
> linux-2.6.20 .
> 
> This is version 3. There are some minor modifications from version 2
> (mostly coding style cleanups).

Nice, the first driver to use tileblit :-)

Since this driver is already in the -mm tree, can you resubmit a diff
against that? 

> +
> +static const struct vga_regset s3_h_total_regs[]        = {{0x00, 0, 7}, {0x5D, 0, 0}, VGA_REGSET_END};
> +static const struct vga_regset s3_h_display_regs[]      = {{0x01, 0, 7}, {0x5D, 1, 1}, VGA_REGSET_END};
> +static const struct vga_regset s3_h_blank_start_regs[]  = {{0x02, 0, 7}, {0x5D, 2, 2}, VGA_REGSET_END};
> +static const struct vga_regset s3_h_blank_end_regs[]    = {{0x03, 0, 4}, {0x05, 7, 7}, VGA_REGSET_END};
> +static const struct vga_regset s3_h_sync_start_regs[]   = {{0x04, 0, 7}, {0x5D, 4, 4}, VGA_REGSET_END};
> +static const struct vga_regset s3_h_sync_end_regs[]     = {{0x05, 0, 4}, VGA_REGSET_END};
> +
> +static const struct vga_regset s3_v_total_regs[]        = {{0x06, 0, 7}, {0x07, 0, 0}, {0x07, 5, 5}, {0x5E, 0, 0}, VGA_REGSET_END};
> +static const struct vga_regset s3_v_display_regs[]      = {{0x12, 0, 7}, {0x07, 1, 1}, {0x07, 6, 6}, {0x5E, 1, 1}, VGA_REGSET_END};
> +static const struct vga_regset s3_v_blank_start_regs[]  = {{0x15, 0, 7}, {0x07, 3, 3}, {0x09, 5, 5}, {0x5E, 2, 2}, VGA_REGSET_END};
> +static const struct vga_regset s3_v_blank_end_regs[]    = {{0x16, 0, 7}, VGA_REGSET_END};
> +static const struct vga_regset s3_v_sync_start_regs[]   = {{0x10, 0, 7}, {0x07, 2, 2}, {0x07, 7, 7}, {0x5E, 4, 4}, VGA_REGSET_END};
> +static const struct vga_regset s3_v_sync_end_regs[]     = {{0x11, 0, 3}, VGA_REGSET_END};
> +
> +static const struct vga_regset s3_line_compare_regs[]   = {{0x18, 0, 7}, {0x07, 4, 4}, {0x09, 6, 6}, {0x5E, 6, 6}, VGA_REGSET_END};
> +static const struct vga_regset s3_start_address_regs[]  = {{0x0d, 0, 7}, {0x0c, 0, 7}, {0x31, 4, 5}, {0x51, 0, 1}, VGA_REGSET_END};
> +static const struct vga_regset s3_offset_regs[]         = {{0x13, 0, 7}, {0x51, 4, 5}, VGA_REGSET_END}; /* set 0x43 bit 2 to 0 */
> +

Within reason, try to limit each line to 80 columns.


> +
> +/* image data is MSB-first, fb structure is MSB-first too */
> +static inline u32 expand_color(u32 c)
> +{
> +	return ((c & 1) | ((c & 2) << 7) | ((c & 4) << 14) | ((c & 8) << 21)) * 0xFF;
> +}
> +
> +/* s3fb_iplan_imageblit silently assumes that almost everything is 8-pixel aligned */

Hmn, same thing with vga16fb... Perhaps we should bring back the
fontwidth flag of 2.2 and 2.4 kernels.


> +
> +static int s3fb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
> +				u_int transp, struct fb_info *fb)
> +{
> +	switch (fb->var.bits_per_pixel) {
> +	case 0:
> +	case 4:
> +		if (regno >= 16)
> +			return -EINVAL;
> +
> +		if ((fb->var.bits_per_pixel == 4) &&
> +		    (fb->var.nonstd == 0)) {
> +			outb(0xF0, VGA_PEL_MSK);
> +			outb(regno*16, VGA_PEL_IW);
> +		} else {
> +			outb(0x0F, VGA_PEL_MSK);
> +			outb(regno, VGA_PEL_IW);
> +		}
> +		outb(red >> 10, VGA_PEL_D);
> +		outb(green >> 10, VGA_PEL_D);
> +		outb(blue >> 10, VGA_PEL_D);
> +		break;
> +	case 8:
> +		if (regno >= 256)
> +			return -EINVAL;
> +
> +		outb(0xFF, VGA_PEL_MSK);
> +		outb(regno, VGA_PEL_IW);
> +		outb(red >> 10, VGA_PEL_D);
> +		outb(green >> 10, VGA_PEL_D);
> +		outb(blue >> 10, VGA_PEL_D);
> +		break;
> +	case 16:
> +		if (regno >= 16)
> +			return -EINVAL;

Just return success without doing anything. I presume this is
truecolor.
> +
> +		if (fb->var.green.length == 5)
> +			((u32*)fb->pseudo_palette)[regno] = ((red & 0xF800) >> 1) |
> +				((green & 0xF800) >> 6) | ((blue & 0xF800) >> 11);
> +		else if (fb->var.green.length == 6)
> +			((u32*)fb->pseudo_palette)[regno] = (red & 0xF800) |
> +				((green & 0xFC00) >> 5) | ((blue & 0xF800) >> 11);
> +		else return -EINVAL;

Same here. 
> +		break;
> +	case 24:
> +	case 32:
> +		if (regno >= 16)
> +			return -EINVAL;

And here. 
> +
> +		((u32*)fb->pseudo_palette)[regno] = ((transp & 0xFF00) << 16) | ((red & 0xFF00) << 8) |
> +			(green & 0xFF00) | ((blue & 0xFF00) >> 8);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}

[snip]

> +
> +/* Pan the display */
> +
> +static int s3fb_pan_display(struct fb_var_screeninfo *var, struct fb_info *info) {
> +
> +	unsigned int offset;
> +
> +	/* Validate the offsets */
> +	if ((var->xoffset + var->xres) > var->xres_virtual)
> +		return -EINVAL;
> +	if ((var->yoffset + var->yres) > var->yres_virtual)
> +		return -EINVAL;

You need not validate the offsets, fb_pan_display() does this for you.

> +
> +	/* Calculate the offset */
> +	if (var->bits_per_pixel == 0) {
> +		offset = (var->yoffset / 16) * (var->xres_virtual / 2) + (var->xoffset / 2);
> +		offset = offset >> 2;
> +	} else {
> +		offset = (var->yoffset * info->fix.line_length) +
> +			 (var->xoffset * var->bits_per_pixel / 8);
> +		offset = offset >> 2;
> +	}
> +
> +	/* Set the offset */
> +	svga_wcrt_multi(s3_start_address_regs, offset);
> +
> +	return 0;
> +}
> +
> +/* ------------------------------------------------------------------------- */
> +
> +/* Frame buffer operations */
> +
> +static struct fb_ops s3fb_ops = {
> +	.owner		= THIS_MODULE,
> +	.fb_open	= s3fb_open,
> +	.fb_release	= s3fb_release,
> +	.fb_check_var	= s3fb_check_var,
> +	.fb_set_par	= s3fb_set_par,
> +	.fb_setcolreg	= s3fb_setcolreg,
> +	.fb_blank	= s3fb_blank,
> +	.fb_pan_display	= s3fb_pan_display,
> +	.fb_fillrect	= s3fb_fillrect,
> +	.fb_copyarea	= cfb_copyarea,

No s3fb_copyarea :-). Usually it's the other way around,
imageblit is unaccelerated.

> +	.fb_imageblit	= s3fb_imageblit,
> +};
> +

Tony

