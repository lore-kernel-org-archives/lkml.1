Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbZA3Xqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbZA3Xqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZA3XqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:46:04 -0500
Received: from ns2.suse.de ([195.135.220.15]:33179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757886AbZA3XqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:46:01 -0500
Date: Fri, 30 Jan 2009 15:44:11 -0800
From: Greg KH <gregkh@suse.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent
	VM_LOCKED file segments
Message-ID: <20090130234411.GB11628@suse.de>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com> <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain> <1233259410.2315.75.camel@lts-notebook> <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain> <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain> <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com> <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain> <20090130055639.GA30950@suse.de> <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain> <Pine.LNX.4.64.0901301724010.1563@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901301724010.1563@blonde.anvils>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 05:40:24PM +0000, Hugh Dickins wrote:
> On Fri, 30 Jan 2009, Linus Torvalds wrote:
> > On Thu, 29 Jan 2009, Greg KH wrote:
> > > 
> > > Which version was the "non-cleanup" version that should be added to the
> > > stable trees?
> > 
> > There were two different versions:
> > 
> > 	From: Andrew Morton <akpm@linux-foundation.org>
> > 	Subject: Re: possible bug in mmap_region() in linux-2.6.28 kernel
> > 	Message-Id: <20090128134350.034ac6a7.akpm@linux-foundation.org>
> > 
> > 	From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> > 	Subject: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED file segments
> > 	Message-Id: <1233259410.2315.75.camel@lts-notebook>
> > 
> > and I'm actually not at all sure which one should go into stable (or if we 
> > should just pick the same one that went into mainline). 
> > 
> ...
> > 
> > But none of the above really changes the fact that the patch I committed 
> > to mainline was really quite fundamentally more invasive than either of 
> > the "simple" patches. All three patches are small, with mine arguably the 
> > smallest of the lot, but mine actually changed semantics, while Andrew's 
> > and Lee's patch literally only fix the invalid pointer use.
> > 
> > I'll leave it to others to decide which one goes into -stable. I 
> > personally don't really think it matters. I argue above that mine is 
> > pretty safe and thus perfectly fine even for -stable, but reality has a 
> > habit of sometimes disagreeing with me. Dang.
> 
> I'd say one of the non-cleanup versions for -stable
> (but I've not compared them to see which one is better).

Ok, based on both of your comments about this, and the fact that the
in-tree one did break something, I'll go look at Andrew and Lee's
versions and pick one of them for -stable.

thanks,

greg k-h
