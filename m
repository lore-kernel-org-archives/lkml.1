Return-Path: <linux-kernel-owner+w=401wt.eu-S934007AbXCTXgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934007AbXCTXgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 19:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934089AbXCTXgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 19:36:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:41775 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934007AbXCTXge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 19:36:34 -0400
Date: Tue, 20 Mar 2007 16:34:32 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       Ismail D?nmez <ismail@pardus.org.tr>, Adrian Bunk <bunk@stusta.de>,
       Thomas Meyer <thomas@m3y3r.de>, Tobias Diedrich <ranma@tdiedrich.de>
Subject: Re: [PATCH 2.6.21-rc4] ieee1394: fix oops on "modprobe -r ohci1394" after network class_device conversion
Message-ID: <20070320233432.GA20228@kroah.com>
References: <200703140642.28390.ismail@pardus.org.tr> <200703150051.29945.ismail@pardus.org.tr> <45F88E8B.90403@s5r6.in-berlin.de> <200703150249.04169.ismail@pardus.org.tr> <tkrat.5965dca5154c0fa2@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.5965dca5154c0fa2@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 10:43:22PM +0100, Stefan Richter wrote:
> The networking subsystem has been converted from class_device to device
> but ieee1394 hasn't.  This results in a 100% reproducible NULL pointer
> dereference if the ohci1394 driver module is unloaded while the eth1394
> module is still loaded.
> http://lkml.org/lkml/2006/11/16/147
> http://lkml.org/lkml/2007/3/14/4
> 
> This is a regression in 2.6.21-rc1.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
> 
> Works for me.  I still can connect to an OS X box via eth1394 after that
> and modprobe -r ohci1394 before modprobe -r eth1394 works again.
> 
> Index: linux-2.6.21-rc4/drivers/ieee1394/eth1394.c
> ===================================================================
> --- linux-2.6.21-rc4.orig/drivers/ieee1394/eth1394.c	2007-03-16 19:24:44.000000000 +0100
> +++ linux-2.6.21-rc4/drivers/ieee1394/eth1394.c	2007-03-20 22:28:49.000000000 +0100
> @@ -586,7 +586,10 @@ static void ether1394_add_host (struct h
>          }
>  
>  	SET_MODULE_OWNER(dev);
> +#if 0
> +	/* FIXME - Is this the correct parent device anyway? */
>  	SET_NETDEV_DEV(dev, &host->device);
> +#endif

That's interesting.  What does 'tree /sys/class/net/' look like with
this patch applied?  Does the eth1394 device now live off in
/sys/device/virtual?

If so, I guess this is ok for now as we can wait for the rewrite of the
ieee1394 subsystem to get the linking done correctly :)

thanks,

greg k-h
