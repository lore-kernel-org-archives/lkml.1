Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbYIZTpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbYIZTpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYIZTpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:45:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:55626 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbYIZTpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:45:41 -0400
Date: Fri, 26 Sep 2008 10:59:22 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Hannes Reinecke <hare@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] PM: use pm_op methods for device types
Message-ID: <20080926175922.GA767@kroah.com>
References: <20080925220635.GA12175@kroah.com> <Pine.LNX.4.44L0.0809260948580.2395-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0809260948580.2395-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 09:56:55AM -0400, Alan Stern wrote:
> On Thu, 25 Sep 2008, Greg KH wrote:
> 
> > On Thu, Sep 25, 2008 at 11:27:02PM +0200, Rafael J. Wysocki wrote:
> > > On Thursday, 25 of September 2008, Alan Stern wrote:
> > > > This patch (as1141) adds code to use the device type's pm_op methods,
> > > > if they are defined.  It fixes a regression in the USB PM code; the
> > > > various suspend and resume methods are defined in the device type
> > > > rather than in the bus, because USB devices have to be handled
> > > > differently from USB interfaces.  Without the patch, those methods
> > > > never get called.
> > > > 
> > > > The patch also fixes a couple of spelling errors.
> > > 
> > > Hm, these changes are not needed in the current mainline, so there's a patch
> > > in -next that removes the code added by this patch.
> > > 
> > > It might be better to find that patch and drop it instead, IMO.
> > 
> > I agree, I think we would have seen more bugs if mainline can't suspend
> > with a USB device attached, right?
> > 
> > confused,
> 
> Okay, I was confused too.  Looking more closely, it's apparent that 
> mainline is okay and the problem was introduced by Hannes Reinecke's 
> 
> driver-core-remove-suspend-resume-callbacks-for-device-type.patch
> 
> which states that the suspend/resume callbacks in struct device_type
> are unused.  It may be true that the legacy suspend/resume methods are
> unused, but the new pm_ops methods definitely are used.
> 
> Therefore part or all of Hannes patch should be reverted.  And the 
> mainline is okay as it stands.

Ah, ick.

Hannes, care to respin this patch based on this information?

thanks,

greg k-h
