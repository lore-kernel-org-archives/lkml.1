Return-Path: <linux-kernel-owner+w=401wt.eu-S1760869AbYGRXCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbYGRXCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbYGRXCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:02:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:37934 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbYGRXCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:02:43 -0400
Date: Fri, 18 Jul 2008 15:59:52 -0700
From: Greg KH <greg@kroah.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Piot Skamruk <piotr.skamruk@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org
Subject: Re: [PATCH v2] Add GPIO-based MMC/SD driver
Message-ID: <20080718225952.GA4909@kroah.com>
References: <200807182201.33913.mb@bu3sch.de> <20080718151037.a54dec8a.randy.dunlap@oracle.com> <200807190038.07501.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807190038.07501.mb@bu3sch.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 12:38:07AM +0200, Michael Buesch wrote:
> Thanks for the comments.
> 
> On Saturday 19 July 2008 00:10:37 Randy Dunlap wrote:
> > > +To add a new device, simply echo the configuration string to the "add" file.
> > > +The config string is composed out of the following elements:
> > > +
> > > +DEVNAME DIpin DOpin CLKpin CSpin SPIMODE MAXBUSSPEED NO_SPI_DELAY CSACTIVELOW
> > > +
> > > +DEVNAME is a unique name string for the device.
> > > +DIpin is the SPI DI GPIO pin.
> > > +DOpin is the SPI DO GPIO pin.
> > > +CLKpin is the SPI CLOCK GPIO pin.
> > > +CSpin is the SPI CHIPSELECT GPIO pin.
> > > +SPIMODE is the hardware mode the device will run at. Can be 0-3.
> > > +MAXBUSSPEED is the maximum bus speed in Hertz.
> > > +NO_SPI_DELAY can be 1 or 0. If it is 1, then the lowlevel SPI delay
> > > +will not be performed. This is not standards compliant, but may be required
> > > +to gain reasonable speeds on embedded hardware.
> > > +CSACTIVELOW can be 1 or 0. If it is 1, the chip is considered to be selected, if CS
> > > +is at a logical 0.
> > > +
> > 
> > Would this be better done via configfs?  sysfs files are supposed to be
> > single-value files.
> 
> 
> Well, I really want to avoid over-engineering this thing.
> I thought about using configfs, but that would require to keep lots of state
> information across the operations.
> So one would have to allocate a device with mkdir. Then configure the parameters.
> And then somehow tell the kernel to register it. State has to be maintained over
> this time and I'm not sure how that "register" operation would look like.
> Writing a "1" to a "register" file? So why not write all config parameters
> to an "add" file and be done with all the stuff. ;)
> 
> It all depends on how you define "one thing per file", IMO.
> This "add" file does one thing. It creates a device. We must, of course, pass
> some configuration parameters, too.

We have precidence with this for the device id being "added" to a driver
at run time in PCI and USB.  Not that I really like this, I do think
configfs would be better to do this with here instead of sysfs.

That being said, as this is a new sysfs file, please break this
documentation up into a file in the Documentation/ABI directory instead
of here.

thanks,

greg k-h
