Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbZCWUIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbZCWUIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbZCWUHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:07:50 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:24735 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbZCWUHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:07:49 -0400
Subject: Re: [PATCH 0/2] Make the Unevictable LRU available on NOMMU
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Howells <dhowells@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       kosaki.motohiro@jp.fujitsu.com, torvalds@linux-foundation.org,
       peterz@infradead.org, nrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@surriel.com
In-Reply-To: <20090321102044.GA3427@cmpxchg.org>
References: <1237565305.27431.48.camel@lts-notebook>
	 <20090312100049.43A3.A69D9226@jp.fujitsu.com>
	 <20090313173343.10169.58053.stgit@warthog.procyon.org.uk>
	 <28c262360903131727l4ef41db5xf917c7c5eb4825a8@mail.gmail.com>
	 <12759.1237566272@redhat.com> <1237573815.27431.122.camel@lts-notebook>
	 <20090321102044.GA3427@cmpxchg.org>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 23 Mar 2009 16:07:40 -0400
Message-Id: <1237838860.7334.59.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-21 at 11:20 +0100, Johannes Weiner wrote:
> On Fri, Mar 20, 2009 at 02:30:15PM -0400, Lee Schermerhorn wrote:
> > On Fri, 2009-03-20 at 16:24 +0000, David Howells wrote:
> > > Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> > > 
> > > > I just want to point out [again :)] that removing the ramfs pages from
> > > > the lru will prevent them from being migrated
> > > 
> > > This is less of an issue for NOMMU kernels, since you can't migrate pages that
> > > are mapped.
> > 
> > 
> > Agreed.  So, you could eliminate them [ramfs pages] from the lru for
> > just the nommu kernels, if you wanted to go that route.
> 
> These pages don't come with much overhead anymore when they sit on the
> unevictable list, right?  So I don't see much point in special casing
> them all over the place.

I agree:  not much overhead; no NEED to special case.  I was only
agreeing with David, that it would be OK to keep them off the LRU for
NOMMU kernels.  
> 
> I have a patchset that decouples the unevictable lru feature from
> mlock, enables the latter on nommu and then makes sure ramfs pages go
> immediately to the unevictable list so they don't need the scanner to
> move them.  This is just wiring up of features we already have.

Yeah.  I didn't do it that way, because I didn't see any benefit in
doing that for ram disk pages.   If one doesn't run vmscan, having the
pages on the normal lru doesn't hurt.  If you do need to run vmscan,
moving them to the unevictable list from there seems the least of your
problems :).  And, doing in the pagevec flush function adds overhead to
the fault path.  Granted, it's amortized over PAGEVEC_SIZE pages.  Would
probably we worth measuring the performance cost.  And any code size
increase--NOMMU kernel users might care about that.

> 
> I will sent this mondayish, need to test it more especially on a NOMMU
> setup.

Saw them.  Will take a look...

Lee

