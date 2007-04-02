Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbXDBQVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbXDBQVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 12:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXDBQVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 12:21:21 -0400
Received: from styx.suse.cz ([82.119.242.94]:45088 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752082AbXDBQVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 12:21:20 -0400
Date: Mon, 2 Apr 2007 16:48:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: dtor@insightbb.com, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stuart_hayes@dell.com
Subject: Re: usb hid: reset NumLock
In-Reply-To: <20070401222410.2ff7ecd7.zaitcev@redhat.com>
Message-ID: <Pine.LNX.4.64.0704021641190.3808@jikos.suse.cz>
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
 <Pine.LNX.4.64.0703312122100.6040@jikos.suse.cz> <20070401222410.2ff7ecd7.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007, Pete Zaitcev wrote:

> diff --git a/drivers/usb/input/hid-core.c b/drivers/usb/input/hid-core.c
> index ef09952..7338e81 100644
> --- a/drivers/usb/input/hid-core.c
> +++ b/drivers/usb/input/hid-core.c
> @@ -548,6 +548,28 @@ void usbhid_init_reports(struct hid_device *hid)
>  		warn("timeout initializing reports");
>  }
>  
> +/*
> + * Reset LEDs which BIOS might have left on.
> + */
> +static int hid_find_field_early(struct hid_device *hid, unsigned int page,
> +    unsigned int hid_code, struct hid_field **field);

Hi Pete,

could you please change the order of the two functions, so that you 
don't have to put the forward declaration here?

> +	/*
> +	 * Just reset Num Lock for now.
> +	 * This is called for non-keyboard devices too, so no printk if field
> +	 * is not found.
> +	 */

I'd say this is a little bit overcommented.

> The main reason is, I have a USB-to-PS/2 adapter where early acces to 
> LEDs does not work. Apparently, it is still initializing the PS/2 part 
> when it reports to USB that it's ready, and needs a delay. So, I figured 
> that I may be breaking some odd devices. Some may crash or whatnot. This 
> is why I asked Stuart to get me VID/PID for involved keyboards.

Fair enough, thanks.

Besides the trivial nitpicks above, I think that this fixed version is 
fine. So as soon as you have the VIDs and PIDs of the hardware which 
requires this, could you please update the patch and send it to me again?

Thanks,

-- 
Jiri Kosina
