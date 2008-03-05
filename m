Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbYCEVh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbYCEVh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbYCEVhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:37:48 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:43158 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbYCEVhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:37:47 -0500
Date: Wed, 5 Mar 2008 21:36:37 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Pavel Machek <pavel@ucw.cz>
cc: Christian Kujau <lists@nerdbynature.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc3: 34TB vmalloc total -- overflow in /proc/meminfo?
In-Reply-To: <20080305212139.GA31999@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0803052127380.5344@blonde.site>
References: <20080305090610.GA30024@atrey.karlin.mff.cuni.cz>
 <alpine.DEB.1.00.0803052038410.8658@sheep.housecafe.de>
 <Pine.LNX.4.64.0803052045430.821@blonde.site> <20080305212139.GA31999@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Pavel Machek wrote:
> > > > CommitLimit:   4132360 kB
> > > > Committed_AS:    27684 kB
> > > > VmallocTotal: 34359738367 kB
> > > > VmallocUsed:     18112 kB
> > > > VmallocChunk: 34359720115 kB
> > 
> > I don't see what Pavel's issue is with this: it's simply a fact that
> > with a 64-bit kernel, we've lots of virtual address space to spare
> > for vmalloc.  What would be surprising is for VmallocUsed to get up
> > as high as that.
> 
> Hmm... ok, I see, I thought "clearly this overflowed somewhere", and I

The (mis)alignment does makes it look that way,
but no, it's not an overflow in this case.

> was wrong, it is expected result.
> 
> Still.... what is 34TB of vmalloc space good for when we can only ever
> allocate 4GB (because that is how much physical memory we have?)? To
> prevent fragmentation? 

Well, what else would you want to use that space for?  If there were
a compelling reason to tune it according to how much physical memory
you have (and you're right, that we want a good surplus of address
space so as to avoid silly limitations by fragmentation), I guess
that could have been done.  But why bother if there's no reason?

It's a hard life, there's just too much room to spare in 64-bit ;)

Hugh
