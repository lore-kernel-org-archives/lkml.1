Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbXEIQNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbXEIQNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 12:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbXEIQNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 12:13:32 -0400
Received: from canuck.infradead.org ([209.217.80.40]:42319 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbXEIQNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 12:13:31 -0400
Date: Wed, 9 May 2007 08:40:39 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Chris Rankin <rankincj@yahoo.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] Bug creating USB endpoints in 2.6.20.x
	(kernel bug 8198)
Message-ID: <20070509154039.GA27681@kroah.com>
References: <602729.80444.qm@web52910.mail.re2.yahoo.com> <4641CD01.6010309@gmail.com> <20070509145747.GA27259@kroah.com> <4641E245.7040603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4641E245.7040603@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 05:01:25PM +0200, Tejun Heo wrote:
> Greg KH wrote:
> > On Wed, May 09, 2007 at 03:30:41PM +0200, Tejun Heo wrote:
> >> Chris Rankin wrote:
> >>> --- Tejun Heo <htejun@gmail.com> wrote:
> >>>> So, we can fix the problem Chris is seeing by breaking module unload (by
> >>>> allowing it to unload too early).  It doesn't sound too hot but module
> >>>> unloading race is much less likely than sysfs node deletion/open race.
> >>> Yikes! Just temporary breakage, I hope :-)!! The only modules I unload on a regular basis these
> >>> days are things like "microcode", which the init scripts take care of as part of the boot-up
> >>> process.
> >> Okay, here's a half-assed fix.  With this patch applied, if you try to
> >> unload a module while you're opening it's dev attribute, kernel will
> >> oops later when the file is accessed or closed later but it should fix
> >> the bug winecfg triggers.  I really dunno how to fix this the right way
> >> in the stable kernel.  Better ideas?  Anyone?
> > 
> > This looks like the correct fix, the only reason I made this dynamic was
> > to properly set up the module owner.  And now that you have removed that
> > link in your sysfs rework, it can go and become static again.
> > 
> > Oh, and this isn't a "device node", it's just a text file that contains
> > the major:minor number for a device node to be created from.
> > 
> > So, care to fix up the class code too and send a patch with a
> > signed-off-by:?
> 
> I think the proper fix for -stable is to free the structure in
> device_release().  I asked Chris to test it.  After he confirms, I'll
> send a proper patch with S-O-B.

Ah, yes, that's the correct fix for this.

thanks,

greg k-h
