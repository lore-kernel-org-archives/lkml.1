Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZAJWMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZAJWMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZAJWMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:12:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38692 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZAJWMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:12:37 -0500
Date: Sat, 10 Jan 2009 23:26:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Theodore Tso <tytso@mit.edu>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Andi Kleen <andi@firstfloor.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add b+tree library
Message-ID: <20090110222656.GJ26290@one.firstfloor.org>
References: <1231584446.3685.21.camel@johannes> <2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com> <1231587428.3803.0.camel@johannes> <2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com> <20090110183921.GD20611@logfs.org> <1231613042.3706.16.camel@johannes> <87fxjrgd9s.fsf@basil.nowhere.org> <20090110202315.GE20611@logfs.org> <20090110212740.GE31579@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110212740.GE31579@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Finally, are b+tree so much better than rbtrees that it would be
> worthwhile to just *replace* rbtrees with b+trees?  Or is the problem

There've been a couple of proposals like this over the years, also
with other data structures like judy trees (which seem to bring
the cache line optimization Joern talks about to even more extreme).
splay trees seem to be also a popular suggestion, although they've
considered dubious by other people (including me). Another
alternative would be skip lists. 

Also I don't remember there was ever a big discussion about
rbtrees vs other trees -- it was just that Andrea liked
them and added a convenient library and some point and other
people found it convenient too and started using it.

But it's unclear how much all that would really help.

I always thought it might be advanteous to look at a little
more abstract interface for the existing rbtree users (shouldn't
be that hard, the interface is already not too bad) and then just 
let some students implement a couple of backend data structures
for that interface and then run some benchmarks.

I don't think it's a good idea to add a b*tree library
and use it only from a few users though. After all it's
a lot of code and that should have a clear benefit.

-Andi
-- 
ak@linux.intel.com
