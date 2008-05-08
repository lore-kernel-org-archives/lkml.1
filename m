Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbYEHHl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbYEHHl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 03:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYEHHlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 03:41:51 -0400
Received: from smtp1.kolej.mff.cuni.cz ([78.128.192.10]:60634 "EHLO
	smtp1.kolej.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbYEHHlt (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 03:41:49 -0400
X-Greylist: delayed 1365 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2008 03:41:49 EDT
X-Envelope-From: zajio1am@artax.karlin.mff.cuni.cz
Date: Thu, 8 May 2008 09:41:34 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: JosephChan@via.com.tw
Cc: akpm@linux-foundation.org, geert@linux-m68k.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 7/9] viafb: VIA Frame Buffer Device Driver
Message-ID: <20080508074134.GB11121@localhost.localdomain>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F6775A@exchtp03.taipei.via.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F6775A@exchtp03.taipei.via.com.tw>
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 07:09:44PM +0800, JosephChan@via.com.tw wrote:
> +static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
> +{
> +	switch (cmd) {
> +	case VIAFB_GET_CHIP_INFO:	/*struct chip_information chip_info ; */
> +	if (copy_to_user((void __user *)arg, &chip_info, sizeof(chip_info)))
> +		return -EFAULT;
> +		break;
> +	case VIAFB_GET_INFO_SIZE:
> +		return put_user(sizeof(viainfo), argp);
> +	case VIAFB_GET_INFO:
> +		return ioctl_get_viafb_info(arg);
...
> +	case VIAFB_GET_RESOLUTION:

Some of these ioctls looks like they duplicate standard fbdev ioctls.
What is a reason for that?

> +int get_mode_index(int hres, int vres, int flag)
> +{
> +	DEBUG_MSG(KERN_INFO "get_mode_index!\n");
> +
> +	if (flag == 0) {
> +		if (hres == 480 && vres == 640) {
> +			resMode = VIA_RES_480X640;
> +			mode = "480x640";
> +		} else if (hres == 640 && vres == 480) {
> +			resMode = VIA_RES_640X480;
> +			mode = "640x480";
> +		} else if (hres == 800 && vres == 480) {
> +			resMode = VIA_RES_800X480;
> +			mode = "800x480";
> +		} else if (hres == 800 && vres == 600) {
> +			resMode = VIA_RES_800X600;
> +			mode = "800x600";
> +		} else if (hres == 1024 && vres == 768) {
> +			resMode = VIA_RES_1024X768;
> +			mode = "1024x768";
...

This is particularly ugly function. Some loop through a table is perhaps
better than 250 lines of such if statements, isn't it?

> +		if (!strncmp(this_opt, "mode=", 5)) {
> +			mode = kmalloc(strlen(this_opt + 4), GFP_KERNEL);
> +			strcpy(mode, this_opt + 5);
> +		} else if (!strncmp(this_opt, "mode1=", 6)) {
> +			mode1 = kmalloc(strlen(this_opt + 5), GFP_KERNEL);
> +			strcpy(mode1, this_opt + 6);
> +		} else if (!strncmp(this_opt, "bpp=", 4)) {
> +			via_fb_bpp = simple_strtoul(this_opt + 4, NULL, 0);
> +		} else if (!strncmp(this_opt, "bpp1=", 5)) {
> +			via_fb_bpp1 = simple_strtoul(this_opt + 5, NULL, 0);
> +		} else if (!strncmp(this_opt, "refresh=", 8)) {
> +			refresh = simple_strtoul(this_opt + 8, NULL, 0);
> +		} else if (!strncmp(this_opt, "refresh1=", 9)) {
> +			refresh1 = simple_strtoul(this_opt + 9, NULL, 0);

Most drivers accept default mode specification like 1024x768-16@60
(see Documentation/fb/modedb.txt). Is there a reason to have separate
bpp= and refresh= ?

-- 
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."
