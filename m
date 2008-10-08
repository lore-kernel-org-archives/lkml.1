Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbYJHDM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbYJHDM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 23:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbYJHDMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 23:12:49 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50859 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379AbYJHDMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 23:12:48 -0400
Date: Tue, 7 Oct 2008 20:12:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-netdev@vger.kernel.org, josh@freedesktop.org
Subject: Re: [patch][rfc] ddds: "dynamic dynamic data structure" algorithm,
	for adaptive dcache hash table sizing
Message-ID: <20081008031245.GC7101@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081007064834.GA5959@wotan.suse.de> <20081007.140825.40261432.davem@davemloft.net> <20081008024813.GC6499@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008024813.GC6499@wotan.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 04:48:13AM +0200, Nick Piggin wrote:
> On Tue, Oct 07, 2008 at 02:08:25PM -0700, David Miller wrote:
> > From: Nick Piggin <npiggin@suse.de>
> > Date: Tue, 7 Oct 2008 08:48:34 +0200
> > 
> > > I'm cc'ing netdev because Dave did express some interest in using this for
> > > some networking hashes, and network guys in general are pretty cluey when it
> > > comes to hashes and such ;)
> > 
> > Interesting stuff.
> > 
> > Paul, many months ago, forwarded to me a some work done by Josh
> > Triplett called "rcuhashbash" which had similar objectives.  He did
> > post it to linux-kernel, and perhaps even your ideas are inspired by
> > his work, I don't know. :-)
> 
> Hmm yes I did see that. It's not too similar, as it focuses on re-keying
> an existing element into the same hash table. ddds can't do that kind of
> thing (the underlying data structure isn't visible to the algorithm, so
> it can't exactly modify data structures in-place), although in another
> sense it is more general because the transfer function could transfer
> items into another hash table and re-key them as it goes (if it did that,
> it could probably use Josh's "atomic" re-keying algorithm too).
> 
> But largely it does seem like they are orthogonal (if I'm reading
> rcuhashbash correctly).

IIRC, one of the weaknesses of rcuhashbash was that the elements had
to be copied in some cases.  Josh has been working on a variant that
(hopefully) allows elements to be moved without copying, as is required
by dcache.

							Thanx, Paul
