Return-Path: <linux-kernel-owner+w=401wt.eu-S1762479AbZLKEiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762479AbZLKEiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762467AbZLKEir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:38:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762451AbZLKEio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:38:44 -0500
Date: Thu, 10 Dec 2009 20:38:49 -0800
From: Greg KH <gregkh@suse.de>
To: David Brownell <david-b@pacbell.net>
Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>, dbrownell@users.sourceforge.net,
       linux-kernel@vger.kernel.org, dsilvers@simtec.co.uk, ben@simtec.co.uk,
       Artem.Bityutskiy@nokia.com, akpm@linux-foundation.org
Subject: Re: [PATCH 3/3] gpiolib: use chip->names for symlinks, always use
	gpioN for device names
Message-ID: <20091211043849.GA18007@suse.de>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <200912101939.30446.david-b@pacbell.net> <20091211034711.GA2773@suse.de> <200912102013.59329.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912102013.59329.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 08:13:58PM -0800, David Brownell wrote:
> On Thursday 10 December 2009, Greg KH wrote:
> > 
> > > IMO a "good" solution in this space needs to accept that
> > > those names are not going to be globally unique ... but
> > > that they'll be unique within some context, of necessity.
> > > 
> > > If Greg doesn't want to see those names under classes,
> > > so be it ... but where should they then appear?
> > 
> > As a sysfs file within the device directory called 'name'? ?Then just
> > grep through the tree to find the right device, that also handles
> > duplicates just fine, right?
> 
> I want a concrete example.  Those chip->names things don't
> seem helpful to me though...
> 
> If for example I were building a JTAG adapter on Linux, it
> might consist of a spidev node (chardev) plus a handful of
> GPIOs.  So "the device directory" would be the sysfs home
> of that spidev node (or some variant)?  And inside that
> directory would be files named after various signals that
> are used as GPIOs ... maybe SRST, TRST, and DETECT to start
> with?  Holding some cookie that gets mapped to those GPIO's
> sysfs entries?

Um, I really don't know, as I don't know the GPIO subsystem, nor why you
all have this problem in the first place :)

I also find it funny that you think changing the kernel is easier than
userspace, that's a strange situation.

Anyway, I assumed that you already have a struct device for the GPIO
devices, right?  Put it in there was what I was thinking, but as I don't
understand your current layout, I really don't know.

> I confess I'd still think a symlink from that directory
> to the real GPIO would be easier to work with...

No, don't do that, no symlinks from a class please.

thanks,

greg k-h
