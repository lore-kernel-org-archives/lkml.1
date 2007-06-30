Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbXF3M0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbXF3M0c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 08:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXF3M0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 08:26:24 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45183 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754798AbXF3M0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 08:26:23 -0400
Date: Sat, 30 Jun 2007 14:26:48 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Dan Aloni <da-x@monatomic.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@uk.ibm.com>
Subject: Re: [RFC] automatic CC generation for patch submission
Message-ID: <20070630122648.GJ6087@stusta.de>
References: <20070630023451.GA21593@localdomain> <20070630040123.GI6087@stusta.de> <20070630094711.GB1297@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070630094711.GB1297@localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 12:47:11PM +0300, Dan Aloni wrote:
> On Sat, Jun 30, 2007 at 06:01:23AM +0200, Adrian Bunk wrote:
> > On Sat, Jun 30, 2007 at 05:34:51AM +0300, Dan Aloni wrote:
> > >...
> > > Basically, instead of manually figuring out who to add to CC
> > > when sending a patch to LKML by looking at MAINTAINERS, a 
> > > script can look at '.maintainers' files spread across the
> > > source tree and automatically generate a proper list of CCs
> > > for a patch.
> > >...
> > > To illustrate: If a patch affects a file under 
> > > drivers/net/e1000, the CC script will look at these files
> > > 
> > >   drivers/net/e1000/.maintainers
> > >   drivers/net/.maintainers
> > >   drivers/.maintainers
> > >   .maintainers
> > > 
> > > ... to gather up the mailing list addresses or an individual 
> > > maintainer inbox address.
> > >...
> > > Any comments?
> > 
> > As Auke said, maintaining the information in MAINTAINERS would be 
> > better.
> 
> Yes, I tend to agree.
>  
> > And another important use case that shouldn't require much extra work 
> > would be to do the same for bug reports.
> 
> Yes, however for bug reports it isn't always possible to tell which
> subsystem or files would get fixed once the bug is understood. 
> Perhaps it would be good once the bug report reaches the stage where 
> patches are made.

Don't aim for perfection.

If your program also accepts a path or file as input (instead of 
extracting it from a patch) you'll get it with nearly zero extra effort.

> > Generally, you should keep in mind that it must fit into the workflow of 
> > the people who should use it. E.g. I could imagine that it might make 
> > more sense if you write a small tool that takes a patch or a path and 
> > outputs email addresses instead of a huge tool that tries to solve too 
> > many problems at once and doesn't fit into the workflow of most people.
> 
> I absolutely agree - in fact I was thinking of this as a nice
> addition to scripts/checkpatch.pl. For example:
> 
>    Your patch has no obvious style problems and is ready for submission.
>    When submitting this particular patch, you should CC to:
> 
>    e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org

checkpatch.pl checks a patch, not an email.

And e.g. in my workflow there isn't any technical correlation between 
some "Cc:" field in a patch and the recipients of the email containing 
it since I'm not using any fancy scripts for maintaining and sending 
patches.

> However my Perl hacking capabilities (or incapabilities thereof) 
> wouldn't do good to that script I suppose.

A tool that simply would output some email addresses to Cc when given a 
patch is something I would most likely use since it would fit in my 
workflow and replace manual looks at MAINTAINERS.

Something big is less likely to be adapted unless it nearly perfectly 
suits the needs of the people intended to use it.

But it's your program, so it's your choice what you implement and in 
what language you implement it.

> Dan Aloni

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

