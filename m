Return-Path: <linux-kernel-owner+w=401wt.eu-S966830AbXJPWVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966830AbXJPWVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966787AbXJPWVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:21:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58094 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966662AbXJPWVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:21:13 -0400
Date: Tue, 16 Oct 2007 15:20:37 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: stern@rowland.harvard.edu, david-b@pacbell.net,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
Message-ID: <20071016222037.GA23793@kroah.com>
References: <20071015.165828.59656315.davem@davemloft.net> <Pine.LNX.4.44L0.0710161107510.4418-100000@iolanthe.rowland.org> <20071016.150631.122031826.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016.150631.122031826.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 03:06:31PM -0700, David Miller wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
> Date: Tue, 16 Oct 2007 11:23:58 -0400 (EDT)
> 
> > Unfortunately that simply isn't possible.  No matter what you do, the 
> > user can always unload ehci-hcd and then load it back in again.
> 
> Yes we can, by making OHCI and EHCI one module with a top-level
> dispatch.  If you enable both OHCI and EHCI, the top-level
> module will dispatch the host initializations in the correct order.
> 
> This is what I've suggested from the beginning.

Wait, you can have hardware with both EHCI and UHCI too.  Does that mean
we should merge all three together?  I don't think so :)

But perhaps we can order the hardware init stuff from all three together
like this into a separate module they all depend on.  In a way, that's
what the lock tried to do, right?  Are we just not catching all places
we could have hardware being talked to by two modules at the same time?

thanks,

greg k-h
