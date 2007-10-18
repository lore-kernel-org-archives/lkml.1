Return-Path: <linux-kernel-owner+w=401wt.eu-S1766016AbXJRT23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766016AbXJRT23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761665AbXJRT2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:28:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48986 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759116AbXJRT2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:28:06 -0400
Date: Thu, 18 Oct 2007 12:27:41 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices
Message-ID: <20071018192741.GA18786@kroah.com>
References: <Pine.LNX.4.44L0.0710181515560.2779-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0710181515560.2779-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 03:23:49PM -0400, Alan Stern wrote:
> This patch (as1004) fixes a refcounting bug in the development version
> of the block-device core.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> Kay, you have got to start testing your patches better!  Finding and
> fixing refcount errors is _not_ one of my favorite ways to pass the
> time.  For example, you could see what happens when you insert and
> unplug a USB flash disk a few times.
> 
> Greg, you'll probably want to just fold this in with Kay's 
> block-device.patch.
> 
> Alan Stern
> 
> 
> Index: usb-2.6/fs/partitions/check.c
> ===================================================================
> --- usb-2.6.orig/fs/partitions/check.c
> +++ usb-2.6/fs/partitions/check.c
> @@ -516,5 +516,4 @@ void del_gendisk(struct gendisk *disk)
>  	sysfs_remove_link(&block_depr, disk->dev.bus_id);
>  #endif
>  	device_del(&disk->dev);
> -	put_device(&disk->dev);
>  }

Are we sure this is correct?  Kay and I spent a lot of time (well, Kay
did all the work) a few weeks ago trying to track down a bug in this
area, and this was the solution from what I remember.

Kay, thoughts?

thanks,

greg k-h
