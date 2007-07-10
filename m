Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbXGJOd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbXGJOd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 10:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbXGJOdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 10:33:21 -0400
Received: from ms-smtp-02.texas.rr.com ([24.93.47.41]:64596 "EHLO
	ms-smtp-02.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbXGJOdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 10:33:20 -0400
From: Dave McCracken <dave.mccracken@oracle.com>
To: Mel Gorman <mel@skynet.ie>
Subject: Re: -mm merge plans -- anti-fragmentation
Date: Tue, 10 Jul 2007 09:29:45 -0500
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de,
       kenchen@google.com, jschopp@austin.ibm.com, apw@shadowen.org,
       kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl,
       y-goto@jp.fujitsu.com, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20070710102043.GA20303@skynet.ie>
In-Reply-To: <20070710102043.GA20303@skynet.ie>
Organization: Oracle Corp
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707100929.46153.dave.mccracken@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2007, Mel Gorman wrote:
> >  Mel's page allocator work.  Might merge this, but I'm still not hearing
> >  sufficiently convincing noises from a sufficient number of people over
> > this.
>
> This is a long on-going story. It bounces between people who say it's not a
> complete solution and everything should have the 100% ability to defragment
> and the people on the other side that say it goes a long way to solving
> their problem. I've cc'd some of the parties that have expressed any
> interest in the last year.

I find myself wondering what "sufficiently convincing noises" are.  I think we 
can all agree that in the current kernel order>0 allocations are a disaster.  
They simply aren't useable once the system fragments.  I think we can also 
all agree that 100% defragmentation is impossible without rewriting the 
kernel to avoid the hard-coded virtual->physical relationship we have now.

With that said, the only remaining question I see is whether we need order>0 
allocations.  If we do, then Mel's patches are clearly the right thing to do.  
They have received a lot of testing (if just by virtue of being in -mm for so 
long), and have shown to greatly increase the availability of order>0 pages.

The sheer list of patches lined up behind this set is strong evidence that 
there are useful features which depend on a working order>0.  When you add in 
the existing code that has to struggle with allocation failures or resort to 
special pools (ie hugetlbfs), I see a clear vote for the need for this patch.

Some object because order>0 will still be able to fail.  I point out that 
order==0 can also fail, though we go to great lengths to prevent it.  Mel's 
patches raise the success rate of order>0 to within a few percent of 
order==0.  All this means is callers will need to decide how to handle the 
infrequent failure.  This should be true no matter what the order.

I strongly vote for merging these patches.  Let's get them in mainline where 
they can do some good.

Dave McCracken
