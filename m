Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbYGRWjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbYGRWjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbYGRWiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:38:52 -0400
Received: from bu3sch.de ([62.75.166.246]:44202 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756393AbYGRWiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:38:51 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v2] Add GPIO-based MMC/SD driver
Date: Sat, 19 Jul 2008 00:38:07 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: gregkh <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Piot Skamruk <piotr.skamruk@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org
References: <200807182201.33913.mb@bu3sch.de> <20080718151037.a54dec8a.randy.dunlap@oracle.com>
In-Reply-To: <20080718151037.a54dec8a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807190038.07501.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the comments.

On Saturday 19 July 2008 00:10:37 Randy Dunlap wrote:
> > +To add a new device, simply echo the configuration string to the "add" file.
> > +The config string is composed out of the following elements:
> > +
> > +DEVNAME DIpin DOpin CLKpin CSpin SPIMODE MAXBUSSPEED NO_SPI_DELAY CSACTIVELOW
> > +
> > +DEVNAME is a unique name string for the device.
> > +DIpin is the SPI DI GPIO pin.
> > +DOpin is the SPI DO GPIO pin.
> > +CLKpin is the SPI CLOCK GPIO pin.
> > +CSpin is the SPI CHIPSELECT GPIO pin.
> > +SPIMODE is the hardware mode the device will run at. Can be 0-3.
> > +MAXBUSSPEED is the maximum bus speed in Hertz.
> > +NO_SPI_DELAY can be 1 or 0. If it is 1, then the lowlevel SPI delay
> > +will not be performed. This is not standards compliant, but may be required
> > +to gain reasonable speeds on embedded hardware.
> > +CSACTIVELOW can be 1 or 0. If it is 1, the chip is considered to be selected, if CS
> > +is at a logical 0.
> > +
> 
> Would this be better done via configfs?  sysfs files are supposed to be
> single-value files.


Well, I really want to avoid over-engineering this thing.
I thought about using configfs, but that would require to keep lots of state
information across the operations.
So one would have to allocate a device with mkdir. Then configure the parameters.
And then somehow tell the kernel to register it. State has to be maintained over
this time and I'm not sure how that "register" operation would look like.
Writing a "1" to a "register" file? So why not write all config parameters
to an "add" file and be done with all the stuff. ;)

It all depends on how you define "one thing per file", IMO.
This "add" file does one thing. It creates a device. We must, of course, pass
some configuration parameters, too.

-- 
Greetings Michael.
