Return-Path: <linux-kernel-owner+w=401wt.eu-S1751660AbZLKFSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbZLKFSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZLKFSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:18:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbZLKFSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:18:32 -0500
Date: Thu, 10 Dec 2009 21:18:02 -0800
From: Greg KH <gregkh@suse.de>
To: David Brownell <david-b@pacbell.net>
Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>, linux-kernel@vger.kernel.org,
       dsilvers@simtec.co.uk, ben@simtec.co.uk, Artem.Bityutskiy@nokia.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 3/3] gpiolib: use chip->names for symlinks, always use
	gpioN for device names
Message-ID: <20091211051802.GA18914@suse.de>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <200912102013.59329.david-b@pacbell.net> <20091211043849.GA18007@suse.de> <200912102113.06973.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912102113.06973.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 09:13:06PM -0800, David Brownell wrote:
> On Thursday 10 December 2009, Greg KH wrote:
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
> > > ...
> > 
> > Um, I really don't know, as I don't know the GPIO subsystem, nor why you
> > all have this problem in the first place :)
> 
> Maybe Jani can provide a more concrete example.
> 
> 
> > I also find it funny that you think changing the kernel is easier than
> > userspace, that's a strange situation.
> 
> I don't recall saying that.  :)
> 
> It's a case of kernel having access to system data that's not
> otherwise exported to userspace.  It knows how the various bits
> of hardware fit together ... and in this case wants to export
> associations between some GPIOs and some other hardware.  Given
> that, userspace can pick things up.
> 
>  
> > Anyway, I assumed that you already have a struct device for the GPIO
> > devices, right?  Put it in there was what I was thinking, but as I don't
> > understand your current layout, I really don't know.
> 
> There are gpio_chip devices, for a set of GPIOs.  But not for
> the individual GPIOs.
> 
> 
> > > I confess I'd still think a symlink from that directory
> > > to the real GPIO would be easier to work with...
> > 
> > No, don't do that, no symlinks from a class please.
> 
> I didn't catch a reason for that request... could you
> explain that?

It only causes confusion and you would be the only subsystem needing
such a strange thing, causing me to believe something is wrong with the
request.

Also see Kay's response, it was better :)

thanks,

greg k-h

> 
> - Dave
