Return-Path: <linux-kernel-owner+w=401wt.eu-S932841AbZFLJth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841AbZFLJth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758959AbZFLJtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:49:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001AbZFLJtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:49:17 -0400
Date: Fri, 12 Jun 2009 11:49:19 +0200
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu, cl@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: slab: setup allocators earlier in the boot sequence
Message-ID: <20090612094918.GH24044@wotan.suse.de>
References: <20090612075427.GA24044@wotan.suse.de> <1244793592.30512.17.camel@penberg-laptop> <20090612080236.GB24044@wotan.suse.de> <1244793879.30512.19.camel@penberg-laptop> <1244796291.7172.87.camel@pasglop> <84144f020906120149k6cbe5177vef1944d9d216e8b2@mail.gmail.com> <20090612091304.GE24044@wotan.suse.de> <1244798660.7172.102.camel@pasglop> <20090612093046.GG24044@wotan.suse.de> <1244799865.7172.112.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244799865.7172.112.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 07:44:25PM +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2009-06-12 at 11:30 +0200, Nick Piggin wrote:
> > On Fri, Jun 12, 2009 at 07:24:20PM +1000, Benjamin Herrenschmidt wrote:
> > Yeah but it doesn't do it in the page allocator so it isn't
> > really useful as a general allocator flags tweak. ATM it only
> > helps this case of slab allocator hackery.
> 
> I though I did it in page_alloc.c too but I'm happy to be told what I
> missed :-) The intend is certainly do have a general allocator flag
> tweak.

Oh, no I missed that sorry you did. I'd be a bit worried about
wanting it as a general allocator tweak. Even suspending IO
for suspend/resume... it would be better to try solving that
ordering by design and if not then perhaps add something
to mm/vmscan.c rather than modify gfp flags all the way
down.


