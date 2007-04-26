Return-Path: <linux-kernel-owner+w=401wt.eu-S933036AbXDZGhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036AbXDZGhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXDZGhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:37:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40159 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933036AbXDZGhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:37:35 -0400
Date: Wed, 25 Apr 2007 23:37:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <m1abwvofke.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.64.0704252328340.30340@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
 <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com>
 <m1abwvofke.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, Eric W. Biederman wrote:

> You are trying to couple something that has no business being coupled
> as it reduces the system usability when you couple them.

What I am coupling? The approach solves a series of issues as far as I can 
tell.

> > But that is due to the VM (at least Linus tree) having no defrag methods.
> > mm has Mel's antifrag methods and can do it.
> 
> This is fundamental.  Fragmentation when you multiple chunk sizes
> cannot be solved without a the ability to move things in memory,
> whereas it doesn't exist when you only have a single chunk size.

We have that ability (although in a limited form) right now.
 
> > Yes you get lots of small request *because* we do not support defrag and 
> > cannot large contiguous allocations.
> 
> Lots of small requests are fundamental.  If lots of small requests were
> not fundamental we would gets large requests scatter gather requests.

That is a statement of faith in small requests? Small requests are 
fundamental so we want them?

> > Ummm the other arches read 16k blocks of contigous memory. That is not 
> > supported on 4k platforms right now. I guess you you move those to vmalloc 
> > areas? Want to hack the filesystems for this?
> 
> Freak no.  You teach the code how to have a block in multiple physical
> pages. 

This aint gonna work without something that stores the information about 
how the pieces come together. Teach the code.... More hacks.
 
> > There are multiple scaling issues in the kernel. What you propose is to 
> > add hack over hack into the VM to avoid having to deal with 
> > defragmentation. That in turn will cause churn with hardware etc
> > etc.
> 
> No. I propose to avoid all designs that have the concept of
> fragmentation.

There are such designs? You can limit fragmentation but not avoid it.

> There is an argument for having struct page control more than 4K
> of memory even when the hardware page size is 4K.  But that is a
> separate problem.  And by only having one size we still don't
> get fragmentation.

We have fragmentation because we cannot limit our allocation sizes to 4k. 
The stack is already 8k and there are subsystems that need more (f.e. 
for jumbo frames). Then there is the huge page subsystem that is used to 
avoid the TLB pressure that comes with small pages.

I think we are doing our typical community thing of running away from the 
problem and developing ways to explain why our traditional approaches are 
right.

