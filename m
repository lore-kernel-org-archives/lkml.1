Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZLBWHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZLBWHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 17:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbZLBWHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 17:07:18 -0500
Received: from gir.skynet.ie ([193.1.99.77]:56138 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbZLBWHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 17:07:17 -0500
Date: Wed, 2 Dec 2009 22:07:18 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH] uswsusp: automatically free the in-memory image once
	s2disk has finished with it
Message-ID: <20091202220718.GI1457@csn.ul.ie>
References: <4B1575AC.6080904@tuffmail.co.uk> <20091201214529.GA1457@csn.ul.ie> <200912012253.08522.rjw@sisk.pl> <4B16545B.3090703@tuffmail.co.uk> <20091202122019.GD1457@csn.ul.ie> <4B16797C.3010304@tuffmail.co.uk> <20091202211107.GA20830@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091202211107.GA20830@elf.ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 10:11:07PM +0100, Pavel Machek wrote:
> On Wed 2009-12-02 14:28:12, Alan Jenkins wrote:
> > The original in-kernel suspend (swsusp) frees the in-memory hibernation
> > image before powering off the machine.  s2disk doesn't, so there is
> > _much_ less free memory when it tries to power off.
> > 
> > This is a gratuitous difference.  The userspace suspend interface
> > /dev/snapshot only allows the hibernation image to be read once.
> > Once the s2disk program has read the last page, we can free the entire
> > image.
> > 
> > This avoids a hang after writing the hibernation image which was
> > triggered by commit 5f8dcc21211a3d4e3a7a5ca366b469fb88117f61
> > "page-allocator: split per-cpu list into one-list-per-migrate-type":
> 
> Yes, you work around page-allocator hang. But is it right thing to do?
> 

What's wrong with it? The hang is likely because the allocator has no
memory to work with. The patch in question makes small changes to the
amount of available memory but it shouldn't matter on uni-core. Some
structures are slightly larger but it's extremely borderline. I'm at a
loss to explain actually why it makes a difference untill things were
extremely borderline to begin with.

> I mean... Power down should not be too memory-critical. Why can't new
> page allocator handle that?
> 

The allocator isn't new. I wouldn't have expected power-down to make any
allocation at all but clearly it is.

> (And yes, when page allocator is fixed we may want to do something
> like that, but...)
> 

At the moment, I'm not sure what needs fixing in there. There is no
memory and it gets stuck in a loop. I better stand up if I'm going to
pull something out of my ass :/


-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
