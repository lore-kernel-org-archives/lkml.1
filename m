Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbYHAO2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbYHAO2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 10:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYHAO14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 10:27:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46883 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYHAO1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 10:27:55 -0400
Date: Fri, 1 Aug 2008 16:28:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Bert Wesarg <bert.wesarg@googlemail.com>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PULL] typesafe callbacks for kthread and stop_machine
Message-ID: <20080801142806.GX23938@one.firstfloor.org>
References: <200807311452.36025.rusty@rustcorp.com.au> <20080731140643.GO23938@one.firstfloor.org> <200808011039.30195.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808011039.30195.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 10:39:29AM +1000, Rusty Russell wrote:
> On Friday 01 August 2008 00:06:43 Andi Kleen wrote:
> > On Thu, Jul 31, 2008 at 02:52:35PM +1000, Rusty Russell wrote:
> > > Just the two places I look after.  And this time the conglomerate patch
> > > is included below for more random commentry.
> >
> > I must say I personally don't like the wrapper macros that you require
> > for each function that uses this. A wrapper macro has a large impact
> > on code readability because everyone following a call chain has
> > to do an additional grep/open file etc. step. I have my doubts not having
> > casts outweights that disadvantage.
> 
> Yes, but the benefits of using them everywhere is that they do become part of 
> the landscape.  "Oh, that's a typesafe callback, OK".

It's still an additional step slowing the reader/debugger/maintainer/etc.
down even when he recognizes that pattern.

> > I know that gcc has this funky transparent union extension that
> > glibc socket() uses to allow different address types without casts.
> > It has the advantage of not needing wrapper macros. Any chance of
> > using that instead? Or has that one been considered already and
> > discarded?
> 
> That's aimed at a slightly different case, where the function knows what types 
> it can get.  But that doesn't work for truly generic callbacks: the type is 
> completely controlled by the caller. ie. we want to allow whatever type 
> matches the arg.

In my experience often call backs are just numbers. Wouldn't we get a significant
part of the benefit by just allowing void * and unsigned long by default? (that
can be done with the gcc extension)

Or alternatively perhaps just teach sparse about this common pattern by adding
new annotations (new annotations would be fine for me, i just don't like
the additional indirection)

-Andi
