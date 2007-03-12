Return-Path: <linux-kernel-owner+w=401wt.eu-S932489AbXCLVnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbXCLVnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932516AbXCLVnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:43:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:49499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489AbXCLVne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:43:34 -0400
Date: Mon, 12 Mar 2007 14:41:49 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Slaby <jirislaby@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: rmmod uhci_hcd -> BUG: atomic counter underflow
Message-ID: <20070312214149.GA5950@kroah.com>
References: <45F584CB.3050800@gmail.com> <Pine.LNX.4.44L0.0703121715490.2480-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0703121715490.2480-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 05:25:09PM -0400, Alan Stern wrote:
> On Mon, 12 Mar 2007, Jiri Slaby wrote:
> 
> > Jiri Slaby napsal(a):
> > > Alan Stern napsal(a):
> > >> On Mon, 12 Mar 2007, Jiri Slaby wrote:
> > >>> After rmmoding of uhci_hcd on fresh booted 2.6.21-rc3-mm2 I got this:
> > >>>
> > >>> BUG: atomic counter underflow at:
> > > [...]
> > >>>   [<c01db754>] kobject_put+0x14/0x16
> > >>>   [<c01db8a3>] kobject_unregister+0x22/0x25
> > >>>   [<c024c987>] bus_remove_driver+0x75/0x82
> > >>>   [<c024d3b8>] driver_unregister+0xb/0x18
> > >>>   [<c01e7020>] pci_unregister_driver+0x13/0x73
> > >>>   [<f88dbbd9>] uhci_hcd_cleanup+0xd/0x2d [uhci_hcd]
> > > [...]
> > >> Would it be possible for you to add the atomic counter underflow check 
> > >> to 2.6.21-rc3 and see if the problem still occurs?  If it doesn't, 
> > >> that's a good indication the USB stack isn't guilty -- the bus 
> > >> registration code hasn't changed for several kernel releases.
> > > 
> > > Yes.
> > 
> > I can confirm, that this issue went upstream and is currently present there.
> 
> I found the problem, but I don't know how to fix it.  Hopefully Greg or 
> Rusty will know.
> 
> There are two bugs in kernel/module.c:module_remove_driver(), right at the 
> end of the routine:
> 
> 	/*
> 	 * Undo the additional reference we added in module_add_driver()
> 	 * via kset_find_obj()
> 	 */
> 	if (drv->mod_name)
> 		kobject_put(&drv->kobj);
> 

This code is reverted in 2.6.21-rc3-git7 as it was incorrect as you have
properly determined.

So, can people please test with a kernel newer than that?

thanks,

greg k-h
