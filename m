Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbYLaCdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbYLaCdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 21:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYLaCcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 21:32:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43510 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbYLaCcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 21:32:47 -0500
Date: Wed, 31 Dec 2008 03:46:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Peter W. Morreale" <pmorreale@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] pdflush fix and enhancement
Message-ID: <20081231024609.GQ496@one.firstfloor.org>
References: <20081230231152.10427.50620.stgit@hermosa.site> <87fxk5ur0h.fsf@basil.nowhere.org> <1230688589.3470.45.camel@hermosa.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230688589.3470.45.camel@hermosa.site>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 06:56:29PM -0700, Peter W. Morreale wrote:
> The rational is simply because one-size may not fit all.  Currently
> there is minimalistic tuning wrt pdflush thread creation. 

Thanks. Please put this into the commit description for future
reference. 

Some comments below.

> Each pdflush thread arbitrarily decides to create another thread solely
> on the basis of all currently existing threads being busy for >= one
> second.  So this can result in NCPUS pdflush threads being created
> 'concurrently' should all existing threads wind up in the idle check at
> the same time (I have seen this).  Or it can result in a thread being

So perhaps a simple lock serializing creation of new pdflush threads
would avoid the problem?

> More to the point, on small systems with few file systems, what is the
> point of having 8 (the current max) threads competing with each other on
> a single disk?  Likewise, on a 64-way, or larger system with dozens of
> filesystems/disks, why wouldn't I want more background flushing?

That makes some sense, but perhaps it would be better to base the default
size on the number of underlying block devices then?

Ok one issue there is that there are lots of different types of 
block devices, e.g. a big raid array may look like a single disk.
Still I suspect defaults based on the block devices would do reasonably
well.

> 
> I actually think the question is: Why not allow the admin to control
> this?  Since it seems like this is a matter of policy based on machine
> configuration. 

The kernel should know the current machine config and most 
admins don't really want to do very fine grained configuration;
they expect the system to perform well out of the box. That is
why it is adventageous to try to come up with good auto tuning.

> And btw Andi, I should have cc'ed you on this, I know from the flush
> code that you were heavily involved.  I only cc'ed Peter Z. since his
> name was in pdflush.c.  My apologies.  

No problem, but I think you're confusing me with someone else :). I don't
remember ever hacking on this. Perhaps you thought of Andrew Morton
who did pdflush originally.

-Andi

-- 
ak@linux.intel.com
