Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbXCaRBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbXCaRBz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 13:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbXCaRBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 13:01:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34571 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbXCaRBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 13:01:54 -0400
Date: Sat, 31 Mar 2007 10:02:07 -0700
From: Greg KH <greg@kroah.com>
To: Cong WANG <xiyou.wangcong@gmail.com>
Cc: Pedram M <pmessri@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: submitting kernel janitorials
Message-ID: <20070331170207.GA14596@kroah.com>
References: <9c9aa5d00703310627v7688a865p11ea1aa52e249b16@mail.gmail.com> <2375c9f90703310637o38f6c748n835f3b119b0a1c43@mail.gmail.com> <9c9aa5d00703310640m6f4cf55aidc3cba706a8d3bff@mail.gmail.com> <2375c9f90703310652w284dc313obb579b2b0dc62c76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2375c9f90703310652w284dc313obb579b2b0dc62c76@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 09:52:30PM +0800, Cong WANG wrote:
> 2007/3/31, Pedram M <pmessri@gmail.com>:
> >Ok thanks,
> >
> >I've sent one already, could you please double check:
> >
> >@@ -4590,7 +4590,7 @@
> >        printk("stli_findpcibrds()\n");
> > #endif
> >
> >-       while ((dev = pci_find_device(PCI_VENDOR_ID_STALLION,
> >+       while ((dev = pci_get_device(PCI_VENDOR_ID_STALLION,
> >            PCI_DEVICE_ID_ECRA, dev))) {
> >                if ((rc = stli_initpcibrd(BRD_ECPPCI, dev)))
> >                        return(rc);
> >
> >
> >That as an example for file:
> >
> >drivers/char/istallion.c
> >
> >
> >Thanks,
> >Pedram
> 
> Why did you delete the list? Please don't do that.
> 
> In fact, I am a newbie too. I know pci_find* functions are deprecated
> and gcc will warn that. And I think we should replace them. You can
> try to make patches for them and submit them to  Greg. (Greg, is that
> OK?)

You can cc: me, so I will review them, but the patch needs to go through
the specific driver maintainer.

And PLEASE NOTE, this kind of conversion is not a simple
search-and-replace type task, you need to be aware of the device
reference count issues with the pci_get_device() call.  Please read the
documentation for the function for details.

thanks,

greg k-h
