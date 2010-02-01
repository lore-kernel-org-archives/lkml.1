Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0BANZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 08:25:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45920 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab0BANZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 08:25:34 -0500
Date: Mon, 1 Feb 2010 14:25:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Miklos Szeredi <miklos@szeredi.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: dentries: dentry defragmentation
Message-ID: <20100201132527.GK29555@one.firstfloor.org>
References: <20100129204931.789743493@quilx.com> <20100129205007.832823807@quilx.com> <20100129220044.GA31305@ZenIV.linux.org.uk> <20100201070835.GE9085@laptop> <20100201101013.GG29555@one.firstfloor.org> <20100201101645.GF12759@laptop> <20100201102253.GI29555@one.firstfloor.org> <20100201103526.GG12759@laptop> <20100201104544.GJ29555@one.firstfloor.org> <20100201105635.GI12759@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201105635.GI12759@laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > 
> > > Right, but as you can see it is complex to do it this way. And I
> > > think for reclaim driven targetted reclaim, then it needn't be so
> > > inefficient because you aren't restricted to just one page, but
> > > in any page which is heavily fragmented (and by definition there
> > > should be a lot of them in the system).
> > 
> > Assuming you can identify them quickly.
> 
> Well because there are a large number of them, then you are likely
> to encounter one very quickly just off the LRU list.

There were some cases in the past where this wasn't the case.
But yes some uptodate numbers on this would be good.

Also it doesn't address the second case here quoted again.

> > There are really two different cases here:
> > - Run out of memory: in this case i just want to find all the objects
> > of any page, ideally of not that recently used pages.
> > - I am very fragmented and want a specific page freed to get a 2MB
> > region back or for hwpoison:  same, but do it for a specific page.
> > 
>
> 
> I still don't think it adds much weight. Especially if you can just
> try an inefficient scan.

Also see second point below.
>  
> 
> > But soft hwpoison isn't the only user. The other big one would
> > be for large pages or other large page allocations.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
