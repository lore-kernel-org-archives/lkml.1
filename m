Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbZFOK1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbZFOK1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZFOK1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:27:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:57547 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbZFOK1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:27:35 -0400
Date: Mon, 15 Jun 2009 12:27:37 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090615102737.GA20461@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI> <20090615081831.GA5411@osiris.boeblingen.de.ibm.com> <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com> <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop> <1245059859.23207.16.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245059859.23207.16.camel@penberg-laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 12:57:39PM +0300, Pekka Enberg wrote:
> On Mon, 2009-06-15 at 19:51 +1000, Benjamin Herrenschmidt wrote:
> > I think the boot order is too likely to change to make it a sane thing
> > to have all call sites "know" at what point they are in the boot
> > process. In your example, what does GFP_BOOT would mean ? Before
> > scheduler is initialized ? before interrupts are on ?
> 
> Btw, I think this is a pretty important point. Linus suggested trying to
> make slab initialization even earlier than what we now have. If we do
> require GFP_BOOT annotations, then we'd need to sprinkle those all over
> the place when we do that.

I don't understand. You'd be converting all these from bootmem
anyway, so where's the problem?

 
> So from code shuffling point of view, it's better to support GFP_KERNEL
> (almost) everywhere rather than require special annotations.

Nor this. We require special allocation annotations *everywhere*
according to context. Why is using GFP_KERNEL for unsleeping
allocations a good thing if we have GFP_ATOMIC etc?

We could also mask off __GFP_WAIT from allocations when we take
a spinlock or enter an interrupt, right?

Init code doesn't deserve to be more lazy than anybody else, and
part of the reason why such a core piece of code is so crufty
is exactly because people have been lazy there.

