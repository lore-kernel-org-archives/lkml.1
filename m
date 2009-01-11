Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbZAKIUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbZAKIUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 03:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZAKIUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 03:20:44 -0500
Received: from lazybastard.de ([212.112.238.170]:51608 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbZAKIUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 03:20:43 -0500
Date: Sun, 11 Jan 2009 09:20:11 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Theodore Tso <tytso@mit.edu>, Johannes Berg <johannes@sipsolutions.net>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add b+tree library
Message-ID: <20090111082010.GA30090@logfs.org>
References: <1231584446.3685.21.camel@johannes> <2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com> <1231587428.3803.0.camel@johannes> <2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com> <20090110183921.GD20611@logfs.org> <1231613042.3706.16.camel@johannes> <87fxjrgd9s.fsf@basil.nowhere.org> <20090110202315.GE20611@logfs.org> <20090110212740.GE31579@mit.edu> <20090110222656.GJ26290@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090110222656.GJ26290@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 January 2009 23:26:56 +0100, Andi Kleen wrote:
> 
> > Finally, are b+tree so much better than rbtrees that it would be
> > worthwhile to just *replace* rbtrees with b+trees?  Or is the problem
> 
> There've been a couple of proposals like this over the years, also
> with other data structures like judy trees (which seem to bring
> the cache line optimization Joern talks about to even more extreme).
> splay trees seem to be also a popular suggestion, although they've
> considered dubious by other people (including me). Another
> alternative would be skip lists. 

The number of people that truly understand what Judy trees do may be
single-digit.  Main disadvantage I see is that Judy trees heavily rely
on repacking nodes over and over.  Part of Judy is a memory manager with
essentially slab caches for nodes with 2, 4, 6, 8, 12, 16, 24, 32, 48,
64, 96, 128, 192, 256, 384 and 512 words.

Splay trees are still binary trees, so the fan-out argument is identical
to that against rbtrees.  If we have to pull in a cacheline, we might as
well use all of it.

Skip lists are just a Bad Idea(tm).  In O(x) notation they behave like
binary trees, waste cachelines left and right, use more memory, depend
on a sufficiently good random() function,...  I guess you never closely
looked at them, because anyone who does tries to forget them as fast as
possible.

> Also I don't remember there was ever a big discussion about
> rbtrees vs other trees -- it was just that Andrea liked
> them and added a convenient library and some point and other
> people found it convenient too and started using it.
> 
> But it's unclear how much all that would really help.
> 
> I always thought it might be advanteous to look at a little
> more abstract interface for the existing rbtree users (shouldn't
> be that hard, the interface is already not too bad) and then just 
> let some students implement a couple of backend data structures
> for that interface and then run some benchmarks.
> 
> I don't think it's a good idea to add a b*tree library
> and use it only from a few users though. After all it's
> a lot of code and that should have a clear benefit.

Quoting Dave Chinner:
| I think a btree library would be useful - there are places where
| people are using rb-trees instead of btree simply because it's
| easier to use the rbtree than it is to implement a btree library.
| I can think of several places I could use such a library for
| in-memory extent representation....

Jörn

-- 
Joern's library part 15:
http://www.knosof.co.uk/cbook/accu06a.pdf
