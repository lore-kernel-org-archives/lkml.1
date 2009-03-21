Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbZCUKWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbZCUKWg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 06:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZCUKW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 06:22:27 -0400
Received: from cmpxchg.org ([85.214.51.133]:52639 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbZCUKW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 06:22:26 -0400
Date: Sat, 21 Mar 2009 11:20:44 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: David Howells <dhowells@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       kosaki.motohiro@jp.fujitsu.com, torvalds@linux-foundation.org,
       peterz@infradead.org, nrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@surriel.com
Subject: Re: [PATCH 0/2] Make the Unevictable LRU available on NOMMU
Message-ID: <20090321102044.GA3427@cmpxchg.org>
References: <1237565305.27431.48.camel@lts-notebook> <20090312100049.43A3.A69D9226@jp.fujitsu.com> <20090313173343.10169.58053.stgit@warthog.procyon.org.uk> <28c262360903131727l4ef41db5xf917c7c5eb4825a8@mail.gmail.com> <12759.1237566272@redhat.com> <1237573815.27431.122.camel@lts-notebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237573815.27431.122.camel@lts-notebook>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 02:30:15PM -0400, Lee Schermerhorn wrote:
> On Fri, 2009-03-20 at 16:24 +0000, David Howells wrote:
> > Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> > 
> > > I just want to point out [again :)] that removing the ramfs pages from
> > > the lru will prevent them from being migrated
> > 
> > This is less of an issue for NOMMU kernels, since you can't migrate pages that
> > are mapped.
> 
> 
> Agreed.  So, you could eliminate them [ramfs pages] from the lru for
> just the nommu kernels, if you wanted to go that route.

These pages don't come with much overhead anymore when they sit on the
unevictable list, right?  So I don't see much point in special casing
them all over the place.

I have a patchset that decouples the unevictable lru feature from
mlock, enables the latter on nommu and then makes sure ramfs pages go
immediately to the unevictable list so they don't need the scanner to
move them.  This is just wiring up of features we already have.

I will sent this mondayish, need to test it more especially on a NOMMU
setup.

	Hannes
