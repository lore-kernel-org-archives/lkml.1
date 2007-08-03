Return-Path: <linux-kernel-owner+w=401wt.eu-S1761005AbXHCHPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005AbXHCHPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 03:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbXHCHPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 03:15:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49591 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbXHCHPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 03:15:30 -0400
Subject: Re: per bdi dirty balancing (was Re: kupdate weirdness)
From: Peter Zijlstra <peterz@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <E1IGqsn-0003uq-00@dorka.pomaz.szeredi.hu>
References: <E1IGL4G-00088R-00@dorka.pomaz.szeredi.hu>
	 <20070801141439.ff1c29f9.akpm@linux-foundation.org>
	 <E1IGcyd-00025s-00@dorka.pomaz.szeredi.hu>
	 <20070802121806.d7071ba1.akpm@linux-foundation.org>
	 <E1IGgS3-0002ib-00@dorka.pomaz.szeredi.hu>
	 <1186091062.11797.34.camel@lappy>
	 <E1IGqsn-0003uq-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Fri, 03 Aug 2007 09:15:27 +0200
Message-Id: <1186125327.12034.121.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-03 at 08:43 +0200, Miklos Szeredi wrote:
> (cc restored)
> 
> > > > There were heaps of problems in there and it is surprising how few people
> > > > were hitting them.  Ordered-mode journalling filesystems will fix it all up
> > > > behind the scenes, of course.
> > > > 
> > > > I just have a bad feeling about that code - list_heads are the wrong data
> > > > structure and it all needs to be ripped and redone using some indexable
> > > > data structure.  There has been desultory discussion, but nothing's
> > > > happening and nothing will happen in the medium term, so we need to keep
> > > > on whapping bandainds on it.
> > > 
> > > The reason why I'm looking at that code is because of those
> > > balance_dirty_pages() deadlocks.  I'm not perfectly happy with the
> > > per-pdi-per-cpu counters Peter's patch is introducing.
> > 
> > What is your biggest concern regarding them?
> 
> Complexity.  I've started to review the patches, and they are just too
> damn complex.
> 
> For example introducing the backing_dev_info initializer and
> destructor adds potential bugs if we miss to add them somewhere.

yeah, that was/is a pain.

> Now maybe this is unavoidable.  I'm just trying to look for a solution
> involving less uncertanties and complexities.
> 
> My plan is to extract the minimal set of features from your patchset,
> that solves the dirty balancing deadlocks and submit them as quickly
> as possible.

I had hoped to post a new version yesterday, but lets hope for today.

> After that we can look at trying to solve the more ambitious problem
> of the slow vs. fast devices in a way that not only you can understand ;)

Drad, and here I thought all that documentation in the proportions lib
would have solved that :-(


