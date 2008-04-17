Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYDQU4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYDQU4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 16:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYDQU4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 16:56:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734AbYDQU4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 16:56:04 -0400
Date: Thu, 17 Apr 2008 13:55:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, hpa@zytor.com, penberg@cs.helsinki.fi
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417135541.17dca96f.akpm@linux-foundation.org>
In-Reply-To: <19f34abd0804171339l7aab0895wb7e82534c4ab8b9a@mail.gmail.com>
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
	<20080417083000.GA4935@elte.hu>
	<20080417014054.ea788f1f.akpm@linux-foundation.org>
	<20080417090626.GA14383@elte.hu>
	<20080417021813.04df7912.akpm@linux-foundation.org>
	<20080417093025.GA17389@elte.hu>
	<20080417023603.672d1032.akpm@linux-foundation.org>
	<19f34abd0804171147l4403d49aoeab005105a90392b@mail.gmail.com>
	<20080417124353.30fe1d06.akpm@linux-foundation.org>
	<19f34abd0804171339l7aab0895wb7e82534c4ab8b9a@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 22:39:55 +0200
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> Hi Andrew,
> 
> Thank you very much for the review of this patch. Those are hard to
> come by, and I've posted kmemcheck to LKML already 3 or 4 times, with
> relatively sparse response. I mean, the fact that they were ALL
> whitespace damaged, but discovered by nobody, quite plainly tells me
> that nobody actually tried to apply it (except perhaps Daniel Walker,
> but we never realized it was whitespace damage causing the problems).
> The patches that Ingo took into x86 were probably sent as an
> attachment...

hm.  Our review problem is well-understood.

> to Ingo before sending this to the list, so he should know. But it
> should not have been part of this patch, I agree.
> 
> >  >  early_param("kmemcheck", param_kmemcheck);
> >
> >  kmemcheck= is documented in at least three places, which is nice, but it
> >  isn't mentioned in the place where we document kernel-parameters:
> >  Documentation/kernel-parameters.txt.  A brief section there which directs
> >  the user to the extended docs would be fine.
> >
> >  early_param() is unusual - we normally use __setup().  I assume there's a
> >  reason for using early_param(), but that reason cannot be discerned from
> >  reading the code.  A /*comment*/ is the way to fix that.
> 
> The reason is that we need to set this before kmalloc() is ever
> called. A comment will come.
> 
> But it seems that __setup() is what is really missing a comment. I
> don't know what it is or how it works, and the comments around the
> definition are not very helpful. Maybe somebody could enlighten me?

It makes my head spin too.  Reading through the first bit of
init/main.c:start_kernel() is your best hope, sorry.

> >  > +static pte_t *
> >  > +address_get_pte(unsigned int address)
> >
> >  This is not the preferred way of laying out function declarations but I've
> >  basically given up on this one.
> >
> >         (void *)address
> >
> >  is more common, but I'm close to giving up on that too.
> >
> >  >  static int
> >  > -show_addr(uint32_t addr)
> >  > +show_addr(uint32_t address)
> >
> >  u32 is preferred, but ditto.
> 
> This will be turned into unsigned long with 64-bit support. (Hopefully
> we can get that working too.)
> 
> Changing these to match the rest of the kernel is no problem for me.
> It is not the way I would write it, but Pekka and Ingo has already
> forced me to write if () instead of if(), so there should be no reason
> to stop here! :-)

These things are OK as-is, I think.  It'd be somewhat less nice in
situations where newly-added code was inconsistent with surrounding
existing code but it's still hardly a huge problem.

> >  Perhaps we should get all this code onto the list(s) for re-review.  It's
> >  been a while..
> 
> I'm not sure it would make much of a difference, except perhaps for
> you, if you want to review it all. (My latest post to LKML had 0
> replies in total. Well, except private e-mail exchange with Ingo and
> Pekka; they should know the code already. Once again, thanks to them
> for helping me.) Do you still want me to post it again?

mm...  I wouldn't mind taking a closer look at it all.  That documentation
file makes it _much_ easier to review the code, and the review becomes more
effective than it would otherwise be.

> 
> PS: And it's not that I do that much testing/reviewing myself. But I
> do think I have the excuse of being a newbie at this :-)

You're in good company ;)
