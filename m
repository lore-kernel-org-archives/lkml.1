Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbZAKUEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbZAKUEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 15:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZAKUE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 15:04:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905AbZAKUE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 15:04:27 -0500
Date: Sun, 11 Jan 2009 12:04:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Johannes Schindelin <Johannes.Schindelin@gmx.de>, git@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: current git kernel has strange problems during bisect
In-Reply-To: <20090111194258.GA4840@uranus.ravnborg.org>
Message-ID: <alpine.LFD.2.00.0901111200330.6528@localhost.localdomain>
References: <200901111602.53082.borntraeger@de.ibm.com> <200901111607.59054.borntraeger@de.ibm.com> <alpine.DEB.1.00.0901111613250.3586@pacific.mpi-cbg.de> <200901111620.03345.borntraeger@de.ibm.com> <alpine.LFD.2.00.0901111113150.6528@localhost.localdomain>
 <20090111194258.GA4840@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Jan 2009, Sam Ravnborg wrote:
> 
> The cost of moving this piece of history from one git tree to another
> git tree is that we make it harder to debug the kernel for the advanced user
> that knows how to do bisect.
> 
> It is not like this history would be lost - one just had to look
> somewhere else to find it.
> 
> That may be a bad pain/benefit ratio - time will tell.

Umm. No. 

Time is exactly what makes it useful. It will make all the downsides 
shrink, and the advantages stay.

> There should be a way to avoid such pain when bisecting without
> having to mark a semi-random (for the average person) commit as good.

Well, you don't actually have to mark that semi-random one as good either. 
What you can do is to just mark anything that _only_ contains fs/btrfs as 
good. IOW, you don't have to know the magic number - you just have to be 
told that "oh, if you only have btrfs files, and you're not actively 
bisecting a btrfs bug, just do 'git bisect good' and continue".

Yeah, you'll hit it a few times, but you don't even have to compile things 
or boot anything, so it's not actually going to be all that much slower 
than just knowing about the magic point either.

So now you can consider yourself told how to solve it. It wasn't that 
hard. And the advantage is that we have real history.

			Linus
