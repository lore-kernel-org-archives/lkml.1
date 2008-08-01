Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbYHADg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbYHADg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 23:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYHADgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 23:36:19 -0400
Received: from ozlabs.org ([203.10.76.45]:33853 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbYHADgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 23:36:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PULL] typesafe callbacks for kthread and stop_machine
Date: Fri, 1 Aug 2008 10:39:29 +1000
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Bert Wesarg <bert.wesarg@googlemail.com>,
       Tejun Heo <htejun@gmail.com>
References: <200807311452.36025.rusty@rustcorp.com.au> <20080731140643.GO23938@one.firstfloor.org>
In-Reply-To: <20080731140643.GO23938@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808011039.30195.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 August 2008 00:06:43 Andi Kleen wrote:
> On Thu, Jul 31, 2008 at 02:52:35PM +1000, Rusty Russell wrote:
> > Just the two places I look after.  And this time the conglomerate patch
> > is included below for more random commentry.
>
> I must say I personally don't like the wrapper macros that you require
> for each function that uses this. A wrapper macro has a large impact
> on code readability because everyone following a call chain has
> to do an additional grep/open file etc. step. I have my doubts not having
> casts outweights that disadvantage.

Yes, but the benefits of using them everywhere is that they do become part of 
the landscape.  "Oh, that's a typesafe callback, OK".

If this were just about neatness, I'd share your doubts.  But I want to be 
able to change the type of a var and have the compiler complain when I hand 
it to a function which expects the old type.  This bit me a few months back, 
leading to this experiment.

> I know that gcc has this funky transparent union extension that
> glibc socket() uses to allow different address types without casts.
> It has the advantage of not needing wrapper macros. Any chance of
> using that instead? Or has that one been considered already and
> discarded?

That's aimed at a slightly different case, where the function knows what types 
it can get.  But that doesn't work for truly generic callbacks: the type is 
completely controlled by the caller. ie. we want to allow whatever type 
matches the arg.

Hope that clarifies,
Rusty.
