Return-Path: <linux-kernel-owner+w=401wt.eu-S1030263AbXCFVrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030263AbXCFVrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030266AbXCFVrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:47:11 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:23425 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030260AbXCFVrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:47:09 -0500
Subject: Re: [patch 2/8] update ctime and mtime for mmaped write
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, staubach@redhat.com, hugh@veritas.com
In-Reply-To: <E1HOh8r-0006Sp-00@dorka.pomaz.szeredi.hu>
References: <20070306180443.669036741@szeredi.hu>
	 <20070306180549.312408559@szeredi.hu> <1173213151.4718.16.camel@lappy>
	 <E1HOh8r-0006Sp-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 22:47:01 +0100
Message-Id: <1173217621.4718.27.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 22:24 +0100, Miklos Szeredi wrote:
> > I'm not liking this, its not a constant operation as the name implies.
> 
> OK, I'll think of something better.
> 
> > And it style is a bit out of line with the rest of rmap.
> > 
> > The thing it actually does is page_mkclean(), all it doesn't do is
> > setting the pte read-only.
> > 
> > I can understand you wanting to avoid the overhead of the minor faults
> > resulting from using page_mkclean(), but I'm not sure its worth it.
> 
> It would be nice if the cost of MS_ASYNC wouldn't be too high.  And I
> do have the feeling that minor faults are far more expensive than
> cleaning the dirty bit in the ptes.
> 
> Do you have any numbers?

None what so ever, but I always think of msync as a rare function
(infrequent when compared to (minor) faults overall). But I don't have
numbers backing that up either.

Also, the radix tree scan you do isn't exactly cheap either. 

So what I was wondering is whether its worth optimizing this at the cost
of another rmap walker. (one with very dubious semantics at that - it
clears the pte dirty bit but doesn't particularly care about that nor
does it respect the PG_dirty / PTE dirty relation)

