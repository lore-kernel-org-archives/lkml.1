Return-Path: <linux-kernel-owner+w=401wt.eu-S965257AbXCNNeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965257AbXCNNeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 09:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933910AbXCNNeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 09:34:18 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:59404 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933905AbXCNNeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 09:34:17 -0400
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
	Take 2
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
In-Reply-To: <20070314125330.GA13168@elte.hu>
References: <20070314050819.536207642@goodmis.org>
	 <p73slc8863r.fsf@bingen.suse.de>  <20070314125330.GA13168@elte.hu>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 09:33:30 -0400
Message-Id: <1173879210.31159.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 13:53 +0100, Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Steven Rostedt <rostedt@goodmis.org> writes:
> > > 
> > > So I spent last night hacking up something to try to make a common 
> > > ground for all code that is shared between x86_64 and i386.  I 
> > > called this
> > > 
> > >    arch/x86
> > 
> > NACK. I think the current ways work just fine.
> 
> i agree. We've recently factored out quite a bit of common code between 
> i386 and x86_64 recently: genirq, gtod/clocksource and clockevents.

But those are things that can mostly be shared across all archs.

> 
> and that's how i think unification of architectures should be done: move 
> code into kernel/* and drivers/*, _not_ into another architecture. That 
> way all architectures benefit.
> 

I'm OK with it, although I did waste a lot of effort making those
patches (But I speak better in C than in English, or any other verbal
language, so it wasn't that bad). But if you look at the code that was
merged, I'm not sure many other archs will benefit. How many archs use
mtrr's? Perhaps these still can go into the drivers directory with a bit
of work. Don't know, I'm not that close to that code to be sure, and
don't have the time to find out ATM.


But at least there needs to be a more common way to share files between
the two archs. Having a file with just a single line of:

#include "../../i386/kernel/mycommoncode.c"

is not that elegant. The make files are, perhaps, a bit better.  Another
thing that happens a lot with these shared funcs in these files, is
finding them . Since "make TAGS" doesn't bother to check i386 when run
with ARCH=x86_64. The first time I searched for early_printk while
developing i386 took me an hour, since my search scripts don't check
other archs (I've changed that since).  I thought that the function was
one of these macro created functions, and was non-arch specific (didn't
look into arch).

So, when creating new shared code, what's the "proper" way?

-- Steve

