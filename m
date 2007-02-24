Return-Path: <linux-kernel-owner+w=401wt.eu-S933325AbXBXBwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbXBXBwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 20:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933326AbXBXBwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 20:52:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:41667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933325AbXBXBws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 20:52:48 -0500
Date: Sat, 24 Feb 2007 02:52:44 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: Zach Brown <zab@zabbo.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
Message-ID: <20070224015244.GC2201@wotan.suse.de>
References: <20070223153743.GA26141@wotan.suse.de> <5FD7605C-E132-4893-86FA-F76DDFB16389@zabbo.net> <f2b55d220702231731l10d36e66h67dd185feb52e8a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220702231731l10d36e66h67dd185feb52e8a5@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 05:31:30PM -0800, Michael K. Edwards wrote:
> On 2/23/07, Zach Brown <zab@zabbo.net> wrote:
> >I'd love to see a generic implementation of RCU hashing that
> >subsystems can then take advantage of.  It's long been on the fun
> >side of my todo list.  The side I never get to :/.
> 
> There's an active thread on netdev about implementing an RCU hash.
> I'd suggest a 2-left (or possibly even k-left) hash for statistical
> reasons discussed briefly there, and in greater depth in a paper by
> Michael Mitzenmacher at
> www.eecs.harvard.edu/~michaelm/NEWWORK/postscripts/iproute.ps.
> Despite his paper's emphasis on hardware parallelism, there's a bigger
> win associated with Poisson statistics and decreasing occupation
> fraction (and therefore collision probability) in successive hashes.

Thanks for the link, I'll take a look.

I'm *pretty* sure that my algorithm will work with any kind of data
structure. It could even change from one to another completely different
data structure.

The important point is that, when a switch is in progress, the data
structure effectively becomes the union of the old and the new. Readers
insert items only into the new structure, but it is implicit that they
have checked for collisions in the union (in the case where collisions are
possible).

And finally, (you probably gathered this, but I'll just make it clear),
I haven't implemented a lockless hash lookup. The dcache already has this.
My algorithm is a lockless dynamic data structure switch, rather than
having anything specifically to do with a specific type of hash, or even
a hash at all. So yes, it should be applicable to resizing a 2-left hash or
whatever.

Thanks,
Nick
