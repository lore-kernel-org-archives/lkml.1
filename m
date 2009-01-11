Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZAKSJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZAKSJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 13:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbZAKSIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 13:08:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43453 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbZAKSIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 13:08:54 -0500
Date: Sun, 11 Jan 2009 19:23:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Andi Kleen <andi@firstfloor.org>, Theodore Tso <tytso@mit.edu>,
       Johannes Berg <johannes@sipsolutions.net>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add b+tree library
Message-ID: <20090111182317.GN26290@one.firstfloor.org>
References: <2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com> <1231587428.3803.0.camel@johannes> <2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com> <20090110183921.GD20611@logfs.org> <1231613042.3706.16.camel@johannes> <87fxjrgd9s.fsf@basil.nowhere.org> <20090110202315.GE20611@logfs.org> <20090110212740.GE31579@mit.edu> <20090110222656.GJ26290@one.firstfloor.org> <20090111082010.GA30090@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111082010.GA30090@logfs.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I only listed the proposals I've heard about before, not necessarily 
endorsing them.

> The number of people that truly understand what Judy trees do may be
> single-digit.  Main disadvantage I see is that Judy trees heavily rely
> on repacking nodes over and over.  Part of Judy is a memory manager with
> essentially slab caches for nodes with 2, 4, 6, 8, 12, 16, 24, 32, 48,
> 64, 96, 128, 192, 256, 384 and 512 words.

Well complicated code is en vogue recently :-) 

> Splay trees are still binary trees, so the fan-out argument is identical
> to that against rbtrees.  If we have to pull in a cacheline, we might as
> well use all of it.
> 
> Skip lists are just a Bad Idea(tm).  In O(x) notation they behave like
> binary trees, waste cachelines left and right, use more memory, depend
> on a sufficiently good random() function,...  I guess you never closely
> looked at them, because anyone who does tries to forget them as fast as
> possible.

Using the radix trees more would be also an alternative.

I honestly don't know how they will all perform in the kernel that is why I 
thought it would be a good idea to just try them out. But I'm not 
volunteering to code it up, so it was more an idle thought.

Doing that would be a reasonable student project. In fact I've been asked 
about this sort of thing by students in the past.

Cleaning up the rbtree interface to be a little more abstract
would be probably a good idea in general. I never really
liked the open coded searches.

-Andi

