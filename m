Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbXFPQZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbXFPQZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 12:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbXFPQZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 12:25:23 -0400
Received: from canuck.infradead.org ([209.217.80.40]:60859 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbXFPQZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 12:25:22 -0400
Date: Sat, 16 Jun 2007 09:24:34 -0700
From: Greg KH <greg@kroah.com>
To: david@lang.hm
Cc: Crispin Cowan <crispin@novell.com>, Pavel Machek <pavel@ucw.cz>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
Message-ID: <20070616162434.GB20990@kroah.com>
References: <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070615234925.GB15056@kroah.com> <Pine.LNX.4.64.0706151656170.12349@asgard.lang.hm> <20070616003132.GB30127@kroah.com> <Pine.LNX.4.64.0706160101470.7557@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706160101470.7557@asgard.lang.hm>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 01:09:06AM -0700, david@lang.hm wrote:
>  On Fri, 15 Jun 2007, Greg KH wrote:
> 
> >>> Usually you don't do that by doing a 'mv' otherwise you are almost
> >>> guaranteed stale and mixed up content for some period of time, not to
> >>> mention the issues surrounding paths that might be messed up.
> >>
> >>  on the contrary, useing 'mv' is by far the cleanest way to do this.
> >>
> >>  mv htdocs htdocs.old;mv htdocs.new htdocs
> >>
> >>  this makes two atomic changes to the filesystem, but can generate 
> >> thousands
> >>  to millions of permission changes as a result.
> >
> > I agree, and yet, somehow, SELinux today handles this just fine, right?
> > :)
> 
>  no it doesn't, SELinux as-is should take no action when the above command is 
>  run, but SELinux implementing path-based permissions will have to relabel 
>  every file or directory in both trees.

Agreed.

> > Let's worry about speed issues later on when a working implementation is
> > produced, I'm still looking for the logical reason a system like this
> > can not work properly based on the expected AA interface to users.
> 
>  if you are willing to live with the race conditions from the slow 
>  (re)labeling and write the software to scan the entire system to figure out 
>  the right policies (and then use inotify to watch the entire system for 
>  changes and (re)label the appropriate files) and accept that you can't get 
>  any granular security for filesystems that don't nativly support it you 
>  could make SELinux behave like AA.

You make it sound like such a pretty picture :)

Anyway, I don't think there are "race conditions", just a bit of a delay
at times for situations that are not common or "normal operations".  And
as I think the speed issues can be drasticly reduced, I don't think
that's a really big deal just yet.  I'm trying to determine if there's
any logical reason why we can't do this and have yet to see proof of
that.

>  but why should they be required to? are you saying that the LSM hooks are 
>  not a valid API and should be removed with all future security modules being 
>  based on SELinux?

Woah, that's a huge logical jump that I am not willing to make at this
point in time.

The reason I am proposing this for AA is due to the impeadance between
the AA model and how the kernel internally works.  A number of core
kernel  VFS developers have objected to the AA code and changes because
of this problem and me and Pavel are here working to try to resolve this
in a way that is acceptable to everyone involved (kernel developers and
AA developers and AA end users.)

I'll leave the whole "LSM should be just replaced with SELinux"
discussion for later, as it is not relevant to this current topic at
all.

thanks,

greg k-h
