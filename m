Return-Path: <linux-kernel-owner+w=401wt.eu-S1031772AbXFHSxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031772AbXFHSxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937664AbXFHSwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:52:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34237 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937350AbXFHSww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:52:52 -0400
Date: Fri, 8 Jun 2007 11:47:39 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Grant Wilson <gww@swandive.no-ip.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.22-rc4-mm1
Message-ID: <20070608184739.GB14268@kroah.com>
References: <20070608042358.GB20483@kroah.com> <Pine.LNX.4.44L0.0706081001040.3473-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0706081001040.3473-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 10:06:21AM -0400, Alan Stern wrote:
> On Thu, 7 Jun 2007, Greg KH wrote:
> 
> > On Thu, Jun 07, 2007 at 10:53:29AM -0400, Alan Stern wrote:
> > > To tell you the truth, I rather think there's not much point in keeping
> > > usb-try-to-debug-bug-8561.patch around.  Anything seriously wrong that
> > > it could catch ought to have shown up long ago.  And it is now clear
> > > that bug 8561 has nothing to do with this; it is a programming error
> > > common to many of the USB serial drivers.  (Still waiting to hear back 
> > > from Paulo Pereira whether the fix to the USB Option driver works...)
> > 
> > What error in the usb-serial drivers are you speaking about?
> 
> The one addressed by usb-option-fix-usage-of-urb-status-abuse.patch.  I 
> thought it might be worthwhile to spend some time fixing all of these.
> Here's a quick summary showing the extent of the problem (note that 
> not all the usages are in error):

Ah, yeah, I cleaned up a lot of them a while ago, but they keep creaping
back.

I _really_ think we need to just get rid of that field and pass the
status in the urb callback.  That would fix this problem once and for
all.

But, from what I remember, the uhci host controller didn't make it easy
for me to acomplish this.  Or it might have been another host
controller, can't remember anymore...

So, anyone looking to make up some patches that touch every USB driver
in the tree?  I'd be glad to take them :)

thanks,

greg k-h
