Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbXHCGov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbXHCGov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 02:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756418AbXHCGon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 02:44:43 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:52170 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327AbXHCGom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 02:44:42 -0400
To: peterz@infradead.org
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-reply-to: <1186091062.11797.34.camel@lappy> (message from Peter Zijlstra on
	Thu, 02 Aug 2007 23:44:22 +0200)
Subject: per bdi dirty balancing (was Re: kupdate weirdness)
References: <E1IGL4G-00088R-00@dorka.pomaz.szeredi.hu>
	 <20070801141439.ff1c29f9.akpm@linux-foundation.org>
	 <E1IGcyd-00025s-00@dorka.pomaz.szeredi.hu>
	 <20070802121806.d7071ba1.akpm@linux-foundation.org>
	 <E1IGgS3-0002ib-00@dorka.pomaz.szeredi.hu> <1186091062.11797.34.camel@lappy>
Message-Id: <E1IGqsn-0003uq-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 03 Aug 2007 08:43:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(cc restored)

> > > There were heaps of problems in there and it is surprising how few people
> > > were hitting them.  Ordered-mode journalling filesystems will fix it all up
> > > behind the scenes, of course.
> > > 
> > > I just have a bad feeling about that code - list_heads are the wrong data
> > > structure and it all needs to be ripped and redone using some indexable
> > > data structure.  There has been desultory discussion, but nothing's
> > > happening and nothing will happen in the medium term, so we need to keep
> > > on whapping bandainds on it.
> > 
> > The reason why I'm looking at that code is because of those
> > balance_dirty_pages() deadlocks.  I'm not perfectly happy with the
> > per-pdi-per-cpu counters Peter's patch is introducing.
> 
> What is your biggest concern regarding them?

Complexity.  I've started to review the patches, and they are just too
damn complex.

For example introducing the backing_dev_info initializer and
destructor adds potential bugs if we miss to add them somewhere.

Now maybe this is unavoidable.  I'm just trying to look for a solution
involving less uncertanties and complexities.

My plan is to extract the minimal set of features from your patchset,
that solves the dirty balancing deadlocks and submit them as quickly
as possible.

After that we can look at trying to solve the more ambitious problem
of the slow vs. fast devices in a way that not only you can understand ;)

How's that?

Miklos
