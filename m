Return-Path: <linux-kernel-owner+w=401wt.eu-S932894AbZFLIos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894AbZFLIos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZFLIok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:44:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:42647 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561AbZFLIoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:44:39 -0400
Subject: Re: slab: setup allocators earlier in the boot sequence
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu, cl@linux-foundation.org,
       akpm@linux-foundation.org
In-Reply-To: <20090612080236.GB24044@wotan.suse.de>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>
	 <1244770230.7172.4.camel@pasglop> <1244779009.7172.52.camel@pasglop>
	 <1244780756.7172.58.camel@pasglop> <1244783235.7172.61.camel@pasglop>
	 <Pine.LNX.4.64.0906120913460.26843@melkki.cs.Helsinki.FI>
	 <1244792079.7172.74.camel@pasglop>
	 <1244792745.30512.13.camel@penberg-laptop>
	 <20090612075427.GA24044@wotan.suse.de>
	 <1244793592.30512.17.camel@penberg-laptop>
	 <20090612080236.GB24044@wotan.suse.de>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 18:44:19 +1000
Message-Id: <1244796259.7172.86.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 10:02 +0200, Nick Piggin wrote:
> Fair enough, but this can be done right down in the synchronous
> reclaim path in the page allocator. This will catch more cases
> of code using the page allocator directly, and should be not
> as hot as the slab allocator.
> 
Yes except that slab has explicit local_irq_enable() when __GFP_WAIT is
set so we also need to deal with that for the boot case.

But again, this is a lot less of an issue if you use my proposed patch
instead which just applies a mask of "forbidden" bits rather than a
conditional branch based on the system state. It will also allow for
more fine grained masking out if we decide, for example, that at some
stage we want to mask out GFP_IO etc...

Cheers,
Ben.


