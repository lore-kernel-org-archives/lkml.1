Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbYJHD1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbYJHD1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 23:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYJHD1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 23:27:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbYJHD1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 23:27:17 -0400
Date: Wed, 8 Oct 2008 05:27:15 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-netdev@vger.kernel.org, josh@freedesktop.org
Subject: Re: [patch][rfc] ddds: "dynamic dynamic data structure" algorithm, for adaptive dcache hash table sizing
Message-ID: <20081008032714.GD6499@wotan.suse.de>
References: <20081007064834.GA5959@wotan.suse.de> <20081007.140825.40261432.davem@davemloft.net> <20081008024813.GC6499@wotan.suse.de> <20081008031245.GC7101@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008031245.GC7101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 08:12:45PM -0700, Paul E. McKenney wrote:
> On Wed, Oct 08, 2008 at 04:48:13AM +0200, Nick Piggin wrote:
> > On Tue, Oct 07, 2008 at 02:08:25PM -0700, David Miller wrote:
> > > From: Nick Piggin <npiggin@suse.de>
> > > Date: Tue, 7 Oct 2008 08:48:34 +0200
> > > 
> > > > I'm cc'ing netdev because Dave did express some interest in using this for
> > > > some networking hashes, and network guys in general are pretty cluey when it
> > > > comes to hashes and such ;)
> > > 
> > > Interesting stuff.
> > > 
> > > Paul, many months ago, forwarded to me a some work done by Josh
> > > Triplett called "rcuhashbash" which had similar objectives.  He did
> > > post it to linux-kernel, and perhaps even your ideas are inspired by
> > > his work, I don't know. :-)
> > 
> > Hmm yes I did see that. It's not too similar, as it focuses on re-keying
> > an existing element into the same hash table. ddds can't do that kind of
> > thing (the underlying data structure isn't visible to the algorithm, so
> > it can't exactly modify data structures in-place), although in another
> > sense it is more general because the transfer function could transfer
> > items into another hash table and re-key them as it goes (if it did that,
> > it could probably use Josh's "atomic" re-keying algorithm too).
> > 
> > But largely it does seem like they are orthogonal (if I'm reading
> > rcuhashbash correctly).
> 
> IIRC, one of the weaknesses of rcuhashbash was that the elements had
> to be copied in some cases.

Yes, I noticed that.


>  Josh has been working on a variant that
> (hopefully) allows elements to be moved without copying, as is required
> by dcache.

So is it able to actually resize the hash table? If so, I couldn't quite see
how it works; if not, I'd be interested to know what is the application to
dcache. Josh?

Thanks,
Nick

