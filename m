Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbZLKFqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbZLKFqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZLKFqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:46:46 -0500
Received: from cantor.suse.de ([195.135.220.2]:47596 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbZLKFqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:46:45 -0500
Date: Thu, 10 Dec 2009 21:46:14 -0800
From: Greg KH <gregkh@suse.de>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: David Brownell <david-b@pacbell.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       dsilvers@simtec.co.uk, ben@simtec.co.uk, akpm@linux-foundation.org
Subject: Re: [PATCH 3/3] gpiolib: use chip->names for symlinks, always use
	gpioN for device names
Message-ID: <20091211054614.GA23644@suse.de>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <200912101939.30446.david-b@pacbell.net> <20091211034711.GA2773@suse.de> <200912102013.59329.david-b@pacbell.net> <20091211043849.GA18007@suse.de> <1260509771.12346.138.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260509771.12346.138.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 07:36:11AM +0200, Artem Bityutskiy wrote:
> On Thu, 2009-12-10 at 20:38 -0800, Greg KH wrote:
> > On Thu, Dec 10, 2009 at 08:13:58PM -0800, David Brownell wrote:
> > > On Thursday 10 December 2009, Greg KH wrote:
> > > > 
> > > > > IMO a "good" solution in this space needs to accept that
> > > > > those names are not going to be globally unique ... but
> > > > > that they'll be unique within some context, of necessity.
> > > > > 
> > > > > If Greg doesn't want to see those names under classes,
> > > > > so be it ... but where should they then appear?
> > > > 
> > > > As a sysfs file within the device directory called 'name'? ?Then just
> > > > grep through the tree to find the right device, that also handles
> > > > duplicates just fine, right?
> > > 
> > > I want a concrete example.  Those chip->names things don't
> > > seem helpful to me though...
> > > 
> > > If for example I were building a JTAG adapter on Linux, it
> > > might consist of a spidev node (chardev) plus a handful of
> > > GPIOs.  So "the device directory" would be the sysfs home
> > > of that spidev node (or some variant)?  And inside that
> > > directory would be files named after various signals that
> > > are used as GPIOs ... maybe SRST, TRST, and DETECT to start
> > > with?  Holding some cookie that gets mapped to those GPIO's
> > > sysfs entries?
> > 
> > Um, I really don't know, as I don't know the GPIO subsystem, nor why you
> > all have this problem in the first place :)
> > 
> > I also find it funny that you think changing the kernel is easier than
> > userspace, that's a strange situation.
> 
> User-space does not know which GPIO number is what. E.g., is the
> "power_button" GPIO number 6 or 99? It just does not have this
> information.
> 
> Kernel knows this, either because it was compiled for a specific board
> revision, or it got this information from the bootloader.
> 
> And the whole idea is to make kernel export this name. Currently, the
> kernel exports only the numbers in sysfs, which is not enough.

Then export a file with the name somewhere as well.  Why not put that in
the directory you were going to point the symlink at?

> And because gpiolib is designed as it is designed, we found that having
> additional link in /sys/class/gpio is the nicest solution from gpiolib's
> POW. It just fits naturally to the existing design.
> 
> And no, we do not have per-gpio struct device, so we cannot add a new
> "name" attribute there. We need to either persuade you to accept our
> solution or make you take closer look at gpoiolib subsystem and suggest
> us the right way to go :-)

If you don't have a struct device, then what are you going to generate a
symlink to?

And sorry, I'm swamped with other work right now, I honestly have no
time to dig into the gpio subsystem.

thanks,

greg k-h
