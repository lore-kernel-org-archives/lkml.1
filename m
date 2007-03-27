Return-Path: <linux-kernel-owner+w=401wt.eu-S1750740AbXC0IEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750740AbXC0IEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 04:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbXC0IEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 04:04:07 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:48753 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbXC0IEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 04:04:04 -0400
To: akpm@linux-foundation.org
CC: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <20070326234957.6b287dda.akpm@linux-foundation.org> (message from
	Andrew Morton on Mon, 26 Mar 2007 23:49:57 -0800)
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
References: <E1HVZyn-0008T8-00@dorka.pomaz.szeredi.hu>
	<20070326140036.f3352f81.akpm@linux-foundation.org>
	<E1HVwy4-0002UD-00@dorka.pomaz.szeredi.hu>
	<20070326153153.817b6a82.akpm@linux-foundation.org>
	<E1HW5am-0003Mc-00@dorka.pomaz.szeredi.hu>
	<20070326232214.ee92d8c4.akpm@linux-foundation.org>
	<E1HW6Ec-0003Tv-00@dorka.pomaz.szeredi.hu> <20070326234957.6b287dda.akpm@linux-foundation.org>
Message-Id: <E1HW6eb-0003WX-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 27 Mar 2007 10:03:41 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > There is surely no need to duplicate all that.
> > 
> > Yeah, we could teach generic_writepages() to conditionally not submit
> > for io just test/clear pte dirtyness.
> > 
> > Maybe that would be somewhat cleaner, dunno.
> > 
> > Then there are the ram backed filesystems, which don't have dirty
> > accounting and radix trees, and for which this pte walking is still
> > needed to provide semantics consistent with normal filesystems.
> 
> hm.
> 
> I don't know how important all this is, really - we've had this bug for
> ever and presumably we've already trained everyone to work around it.
> 
> What usage scenarios are people actually hurting from?  Is there anything
> interesting in the mysterious Novell Bugzilla #206431?

That's just a failing LTP testcase, not quite real life ;)

But Peter Staubach says a RH custumer has files written thorugh mmap,
which are not being backed up.

> Perhaps we can get away with doing something half-assed which covers most
> requirements...

OK.  At least I can split the patch into two half asses.

The big question is tmpfs and friends.  Those won't get any timestamp
update without additional page table walking.

Miklos
