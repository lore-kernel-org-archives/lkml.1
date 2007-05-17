Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbXEQMpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbXEQMpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbXEQMpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:45:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34422 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbXEQMpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:45:00 -0400
Date: Thu, 17 May 2007 05:43:33 -0700
From: Greg KH <greg@kroah.com>
To: Ben Collins <ben.collins@ubuntu.com>
Cc: Roland Dreier <rdreier@cisco.com>, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Ganesh Varadarajan <ganesh@veritas.com>
Subject: Re: [linux-usb-devel] [PATCH] Remove duplicate ID in ipaq driver
Message-ID: <20070517124333.GB20055@kroah.com>
References: <1179348840.6510.16.camel@cunning> <ada1whgmqlx.fsf@cisco.com> <1179351408.6510.24.camel@cunning>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179351408.6510.24.camel@cunning>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 05:36:48PM -0400, Ben Collins wrote:
> On Wed, 2007-05-16 at 13:59 -0700, Roland Dreier wrote:
> > >  	/* The first entry is a placeholder for the insmod-specified device */
> >  > -	{ USB_DEVICE(0x049F, 0x0003) },
> > 
> > Is it obvious why this patch is correct?  Especially given the
> > comment just before the line you delete, and the code
> > 
> > 	if (vendor) {
> > 		ipaq_id_table[0].idVendor = vendor;
> > 		ipaq_id_table[0].idProduct = product;
> > 	}
> > 
> > in ipaq_init()?
> 
> My mistake, quick on the patching going through this dupe list.
> 
> Might I add that this is terrible use of the device table, though.
> Clutters userspace, and adds processing to module-init-tools programs.

It's a hold-over from the times when we didn't have the sysfs "add a new
id" interface for usb-serial drivers, which only recently was created.

So we just have to live with it, and the infinitesimal speed hit it
creates :)

thanks,

greg k-h
