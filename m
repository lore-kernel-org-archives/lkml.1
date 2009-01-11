Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbZAKTl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbZAKTl1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZAKTlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:41:18 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:36812 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZAKTlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:41:18 -0500
Date: Sun, 11 Jan 2009 20:42:58 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Johannes Schindelin <Johannes.Schindelin@gmx.de>, git@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: current git kernel has strange problems during bisect
Message-ID: <20090111194258.GA4840@uranus.ravnborg.org>
References: <200901111602.53082.borntraeger@de.ibm.com> <200901111607.59054.borntraeger@de.ibm.com> <alpine.DEB.1.00.0901111613250.3586@pacific.mpi-cbg.de> <200901111620.03345.borntraeger@de.ibm.com> <alpine.LFD.2.00.0901111113150.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901111113150.6528@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> For bisect, it's indeed somewhat annoying, and we could have perhaps done 
> some things a bit differently, but it's about the closest you can get to 
> "real history" without making the first btrfs merge-point a _total_ 
> disaster.
> 
> For bisect purposes, if you know you're not chasing down a btrfs issue, 
> you can do
> 
> 	git bisect good 34353029534a08e41cfb8be647d734b9ce9ebff8
> 
> where that commit 34353029 is the last one which has _just_ the btrfs 
> files. The next commit is when it does "Merge Btrfs into fs/btrfs", and 
> that one has the whole kernel tree again.

The cost of moving this piece of history from one git tree to another
git tree is that we make it harder to debug the kernel for the advanced user
that knows how to do bisect.

It is not like this history would be lost - one just had to look
somewhere else to find it.

That may be a bad pain/benefit ratio - time will tell.

There should be a way to avoid such pain when bisecting without
having to mark a semi-random (for the average person) commit as good.
As in something that is present when the average bisect user pull the tree,
and not something the user has to do afterwards.

	Sam
