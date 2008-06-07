Return-Path: <linux-kernel-owner+w=401wt.eu-S1763289AbYFGRkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763289AbYFGRkG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 13:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbYFGRjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 13:39:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46967 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759450AbYFGRjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 13:39:53 -0400
Date: Sat, 7 Jun 2008 10:34:36 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: update checkpatch.pl to version 0.19
Message-ID: <20080607173436.GA17603@kroah.com>
References: <200806061922.m56JMJuq025990@hera.kernel.org> <20080606233037.GA8548@kroah.com> <20080606230239.c1a8c002.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606230239.c1a8c002.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 11:02:39PM -0700, Andrew Morton wrote:
> On Fri, 6 Jun 2008 16:30:37 -0700 Greg KH <greg@kroah.com> wrote:
> 
> > On Fri, Jun 06, 2008 at 07:22:25PM +0000, Linux Kernel Mailing List wrote:
> > > @@ -1920,23 +2004,16 @@ sub process {
> > >  				WARN("kfree(NULL) is safe this check is probabally not required\n" . $hereprev);
> > >  			}
> > >  		}
> > > -# check for needless usb_free_urb() checks
> > > -		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
> > > -			my $expr = $1;
> > > -			if ($line =~ /\busb_free_urb\(\Q$expr\E\);/) {
> > > -				WARN("usb_free_urb(NULL) is safe this check is probabally not required\n" . $hereprev);
> > > -			}
> > > -		}
> > >  
> > 
> > I'm curious as to why this check was removed.  Any specific reason?  It
> > was valid from what I can tell.
> 
> Because of the spelling?
> 
> If so, let's be consistent:
> 
> --- a/scripts/checkpatch.pl~a
> +++ a/scripts/checkpatch.pl
> @@ -1997,14 +1997,6 @@ sub process {
>  				$herecurr);
>  		}
>  
> -# check for needless kfree() checks
> -		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
> -			my $expr = $1;
> -			if ($line =~ /\bkfree\(\Q$expr\E\);/) {
> -				WARN("kfree(NULL) is safe this check is probabally not required\n" . $hereprev);
> -			}
> -		}
> -

That's the proverbial baby with the bathwater problem here, we can fix
spelling mistakes pretty easily :)

I'd prefer the original check to be put back, and the kfree(NULL) check
to remain as well, as it too is valid.

But I would like to find out first from Andy why this was removed.  Odds
are he wasn't keeping up with the changes upstream from his local copy,
which also might have caused other things to be removed over time :(

thanks,

greg k-h
