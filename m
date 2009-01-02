Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbZABNXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbZABNXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 08:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbZABNXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 08:23:08 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2499 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756410AbZABNXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 08:23:07 -0500
Date: Fri, 2 Jan 2009 08:23:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Mark Lord <lkml@rtr.ca>, Jan Scholz <scholz@fias.uni-frankfurt.de>
cc: Greg KH <gregkh@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: libusb broken on 2.6.28 x86_64 ?
In-Reply-To: <495DE060.8040707@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0901020820500.22914-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jan 2009, Mark Lord wrote:

> Greg KH wrote:
> ..
> > Hm, care to run 'git bisect'?
> ..
> 
> No, thanks.  But the number of USB core changes in 2.6.28 is rather small,
> so I just ended up looking at each of them in more detail.
> 
> This patch, below, FIXES it for me, by undoing a change from 2.6.28.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> 
> --- old/drivers/usb/core/driver.c	2008-12-24 18:26:37.000000000 -0500
> +++ linux/drivers/usb/core/driver.c	2009-01-02 04:34:11.000000000 -0500
> @@ -279,9 +279,7 @@
>  	 * altsetting means creating new endpoint device entries).
>  	 * When either of these happens, defer the Set-Interface.
>  	 */
> -	if (intf->cur_altsetting->desc.bAlternateSetting == 0)
> -		;	/* Already in altsetting 0 so skip Set-Interface */
> -	else if (!error && intf->dev.power.status == DPM_ON)
> +	if (!error && intf->dev.power.status == DPM_ON)
>  		usb_set_interface(udev, intf->altsetting[0].
>  				desc.bInterfaceNumber, 0);
>  	else

For a proper fix, see

	http://bugzilla.kernel.org/show_bug.cgi?id=12301#c13

A corresponding patch has been posted to linux-usb here:

	http://marc.info/?l=linux-usb&m=123074111001861&w=2

I have no idea what's going on with the 64-bit vs. 32-bit stuff, 
though.

Alan Stern

