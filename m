Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbXF3Jr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbXF3Jr0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 05:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbXF3JrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 05:47:19 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:30046 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbXF3JrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 05:47:18 -0400
Date: Sat, 30 Jun 2007 12:47:11 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@uk.ibm.com>
Subject: Re: [RFC] automatic CC generation for patch submission
Message-ID: <20070630094711.GB1297@localdomain>
References: <20070630023451.GA21593@localdomain> <20070630040123.GI6087@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070630040123.GI6087@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 06:01:23AM +0200, Adrian Bunk wrote:
> On Sat, Jun 30, 2007 at 05:34:51AM +0300, Dan Aloni wrote:
> >...
> > Basically, instead of manually figuring out who to add to CC
> > when sending a patch to LKML by looking at MAINTAINERS, a 
> > script can look at '.maintainers' files spread across the
> > source tree and automatically generate a proper list of CCs
> > for a patch.
> >...
> > To illustrate: If a patch affects a file under 
> > drivers/net/e1000, the CC script will look at these files
> > 
> >   drivers/net/e1000/.maintainers
> >   drivers/net/.maintainers
> >   drivers/.maintainers
> >   .maintainers
> > 
> > ... to gather up the mailing list addresses or an individual 
> > maintainer inbox address.
> >...
> > Any comments?
> 
> As Auke said, maintaining the information in MAINTAINERS would be 
> better.

Yes, I tend to agree.
 
> And another important use case that shouldn't require much extra work 
> would be to do the same for bug reports.

Yes, however for bug reports it isn't always possible to tell which
subsystem or files would get fixed once the bug is understood. 
Perhaps it would be good once the bug report reaches the stage where 
patches are made.

> Generally, you should keep in mind that it must fit into the workflow of 
> the people who should use it. E.g. I could imagine that it might make 
> more sense if you write a small tool that takes a patch or a path and 
> outputs email addresses instead of a huge tool that tries to solve too 
> many problems at once and doesn't fit into the workflow of most people.

I absolutely agree - in fact I was thinking of this as a nice
addition to scripts/checkpatch.pl. For example:

   Your patch has no obvious style problems and is ready for submission.
   When submitting this particular patch, you should CC to:

   e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org

However my Perl hacking capabilities (or incapabilities thereof) 
wouldn't do good to that script I suppose.

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
