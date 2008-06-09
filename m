Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbYFIIdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbYFIIdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 04:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbYFIIdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 04:33:12 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2213 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYFIIdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 04:33:10 -0400
Date: Mon, 9 Jun 2008 09:33:01 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: update checkpatch.pl to version 0.19
Message-ID: <20080609083301.GA6701@shadowen.org>
References: <200806061922.m56JMJuq025990@hera.kernel.org> <20080606233037.GA8548@kroah.com> <20080606230239.c1a8c002.akpm@linux-foundation.org> <20080607173436.GA17603@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080607173436.GA17603@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2008 at 10:34:36AM -0700, Greg KH wrote:
> On Fri, Jun 06, 2008 at 11:02:39PM -0700, Andrew Morton wrote:
> > On Fri, 6 Jun 2008 16:30:37 -0700 Greg KH <greg@kroah.com> wrote:
> > 
> > > On Fri, Jun 06, 2008 at 07:22:25PM +0000, Linux Kernel Mailing List wrote:
> > > > @@ -1920,23 +2004,16 @@ sub process {
> > > >  				WARN("kfree(NULL) is safe this check is probabally not required\n" . $hereprev);
> > > >  			}
> > > >  		}
> > > > -# check for needless usb_free_urb() checks
> > > > -		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
> > > > -			my $expr = $1;
> > > > -			if ($line =~ /\busb_free_urb\(\Q$expr\E\);/) {
> > > > -				WARN("usb_free_urb(NULL) is safe this check is probabally not required\n" . $hereprev);
> > > > -			}
> > > > -		}
> > > >  
> > > 
> > > I'm curious as to why this check was removed.  Any specific reason?  It
> > > was valid from what I can tell.
> > 
> > Because of the spelling?
> > 
> > If so, let's be consistent:
> > 
> > --- a/scripts/checkpatch.pl~a
> > +++ a/scripts/checkpatch.pl
> > @@ -1997,14 +1997,6 @@ sub process {
> >  				$herecurr);
> >  		}
> >  
> > -# check for needless kfree() checks
> > -		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
> > -			my $expr = $1;
> > -			if ($line =~ /\bkfree\(\Q$expr\E\);/) {
> > -				WARN("kfree(NULL) is safe this check is probabally not required\n" . $hereprev);
> > -			}
> > -		}
> > -
> 
> That's the proverbial baby with the bathwater problem here, we can fix
> spelling mistakes pretty easily :)
> 
> I'd prefer the original check to be put back, and the kfree(NULL) check
> to remain as well, as it too is valid.
> 
> But I would like to find out first from Andy why this was removed.  Odds
> are he wasn't keeping up with the changes upstream from his local copy,
> which also might have caused other things to be removed over time :(

That look to be my fault.  Lost something that got merged by some other
route.  I really need a workable solution to the tests problem so I can
work with real per change deltas.

I do try and check things are not removed erroneously.  Seems I did a
poor job on that one tho.  The delta was pretty heafty as I remember, so
I missed it.

The issue I have is I have a comprehensive test suite which is kept in
lock step with checkpatch itself, all in my own tree.  Now that is just
noise for mainline.  What I want to be able to do is keep that in lock
step with developments in my tree, but not merge it upstream.  So far
I've not found a workable solution with git for that.

Anyhow I will sort out where that check has gone and reinstate it.
Perhaps for the next release I will move to pushing Andrew as a set of
patches, not a delta that would stop this occuring again.

-apw
