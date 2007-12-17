Return-Path: <linux-kernel-owner+w=401wt.eu-S936320AbXLQMUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936320AbXLQMUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 07:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936179AbXLQMTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 07:19:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48204 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935996AbXLQMTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:19:19 -0500
Date: Mon, 17 Dec 2007 13:19:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Andi Kleen <andi@firstfloor.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: RFC: remove __read_mostly
Message-ID: <20071217121948.GB31999@one.firstfloor.org>
References: <20071213222044.GH21616@stusta.de> <20071213235432.GA26669@fattire.cabal.ca> <p73tzmmf72u.fsf@bingen.suse.de> <20071217023339.ce3da56c.akpm@linux-foundation.org> <20071217115336.d06427d3.dada1@cosmosbay.com> <20071217030743.da80e6a8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217030743.da80e6a8.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 03:07:43AM -0800, Andrew Morton wrote:
> On Mon, 17 Dec 2007 11:53:36 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
> > n Mon, 17 Dec 2007 02:33:39 -0800
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Fri, 14 Dec 2007 01:33:45 +0100 Andi Kleen <andi@firstfloor.org> wrote:
> > > 
> > > > Kyle McMartin <kyle@mcmartin.ca> writes:
> > > > 
> > > > > I'd bet, in the __read_mostly case at least, that there's no
> > > > > improvement in almost all cases.
> > > > 
> > > > I bet you're wrong. Cache line behaviour is critical, much more
> > > > than pipeline behaviour (which unlikely affects). That is because
> > > > if you eat a cache miss it gets really expensive, which e.g.
> > > > a mispredicted jump is relatively cheap in comparison. We're talking
> > > > one or more orders of magnitude.
> > > 
> > > So...  once we've moved all read-mostly variables into __read_mostly, what
> > > is left behind in bss?
> > > 
> > > All the write-often variables.  All optimally packed together to nicely
> > > maximise cacheline sharing.
> > 
> > This is why it's important to group related variables together, so that they share
> > same cacheline.
> 
> Not feasible.  The linker is (I believe) free to place them anywhere it
> likes unless we go and aggregate them in a struct.

It won't normally though (they are put linear for each object file)
and if you really want to make sure you can always use a special section.

> The insidious thing about this is that is is highly dependent upon
> compiler/linker version and upon kernel config.  So performance differences

I'm not aware of the order of global variables changing that much.
Especially the linker seems to keep it rather stable.

> end up with a better result: all those read-mostly, read-rarely variables (and
> there are a lot of those) could be very usefully deployed by packing them
> in between the write-often variables.
> 
> It's crying out for a performance-guided solution.

My problem with profile feedback is that it will make it impossible
to ever recreate kernel binaries after the fact. So decoding of random
oopses would become much harder.

-Andi


