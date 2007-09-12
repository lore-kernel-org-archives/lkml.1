Return-Path: <linux-kernel-owner+w=401wt.eu-S933790AbXILLjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790AbXILLjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765436AbXILLja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:39:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53391 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765235AbXILLj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:39:29 -0400
Date: Wed, 12 Sep 2007 04:39:07 -0700
From: Greg KH <greg@kroah.com>
To: Heiko Schocher <hs@denx.de>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Detlev Zundel <dzu@denx.de>
Subject: Re: SYSFS: need a noncaching read
Message-ID: <20070912113907.GA24087@kroah.com>
References: <1189503798.6674.46.camel@Zeus.EmbLux> <20070912053207.GH23573@pengutronix.de> <20070912100123.GA23182@kroah.com> <1189595612.6659.23.camel@Zeus.EmbLux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189595612.6659.23.camel@Zeus.EmbLux>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 01:13:32PM +0200, Heiko Schocher wrote:
> Hello Greg
> 
> Am Mittwoch, den 12.09.2007, 03:01 -0700 schrieb Greg KH:
> > On Wed, Sep 12, 2007 at 07:32:07AM +0200, Robert Schwebel wrote:
> > > On Tue, Sep 11, 2007 at 11:43:17AM +0200, Heiko Schocher wrote:
> > > > I have developed a device driver and use the sysFS to export some
> > > > registers to userspace.
> > > 
> > > Uuuh, uggly. Don't do that. Device drivers are there to abstract things,
> > > not to play around with registers from userspace.
> > > 
> > > > I opened the sysFS File for one register and did some reads from this
> > > > File, but I alwas becoming the same value from the register, whats not
> > > > OK, because they are changing. So I found out that the sysFS caches
> > > > the reads ... :-(
> > > 
> > > Yes, it does. What you can do is close()ing the file handle between
> > > accesses, which makes it work but is slow.
> > 
> > Do an lseek back to 0 and then re-read, you will get called in your
> > driver again.
> 
> No thats not true. I thought this too, but if I make a:
> 
> seek (fd, 0L, SEEK_SET);
> 
> in Userspace, there is no retrigger in the sysFS, my driver is *not*
> called again. So I made a own sysfs_seek function, which does retrigger
> the driver ...

Hm, are you sure?  Otherwise the poll() stuff would not work at all.

> Is this really wanted in the sysFS, that there is no way to retrigger a
> read?

Yes, use the sysfs poll/select stuff to do that.

And "sysfs" has no upper-case letters :)

thanks,

greg k-h
