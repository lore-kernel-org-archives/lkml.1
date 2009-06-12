Return-Path: <linux-kernel-owner+w=401wt.eu-S933400AbZFLJow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400AbZFLJow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758598AbZFLJop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:44:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:46177 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbZFLJoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:44:44 -0400
Subject: Re: slab: setup allocators earlier in the boot sequence
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu, cl@linux-foundation.org,
       akpm@linux-foundation.org
In-Reply-To: <20090612093046.GG24044@wotan.suse.de>
References: <1244792079.7172.74.camel@pasglop>
	 <1244792745.30512.13.camel@penberg-laptop>
	 <20090612075427.GA24044@wotan.suse.de>
	 <1244793592.30512.17.camel@penberg-laptop>
	 <20090612080236.GB24044@wotan.suse.de>
	 <1244793879.30512.19.camel@penberg-laptop>
	 <1244796291.7172.87.camel@pasglop>
	 <84144f020906120149k6cbe5177vef1944d9d216e8b2@mail.gmail.com>
	 <20090612091304.GE24044@wotan.suse.de> <1244798660.7172.102.camel@pasglop>
	 <20090612093046.GG24044@wotan.suse.de>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 19:44:25 +1000
Message-Id: <1244799865.7172.112.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 11:30 +0200, Nick Piggin wrote:
> On Fri, Jun 12, 2009 at 07:24:20PM +1000, Benjamin Herrenschmidt wrote:
> > 
> > > It's OK. I'd make it gfp_notsmellybits, and avoid the ~.
> > > And read_mostly.
> > 
> > read_mostly is fine. gfp_notsmellybits isn't a nice name :-) Make it
> > gfp_allowedbits then. I did it backward on purpose though as the risk of
> > "missing" bits here (as we may add new ones) is higher and it seemed to
> > me generally simpler to just explicit spell out the ones to forbid
> > (also, on powerpc,  &~ is one instruction :-)
> 
> But just do the ~ in the assignment. No missing bits :)

Heh, ok.
> Yeah but it doesn't do it in the page allocator so it isn't
> really useful as a general allocator flags tweak. ATM it only
> helps this case of slab allocator hackery.

I though I did it in page_alloc.c too but I'm happy to be told what I
missed :-) The intend is certainly do have a general allocator flag
tweak.

Cheers,
Ben.


