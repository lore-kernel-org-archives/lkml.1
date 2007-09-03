Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbXICMxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbXICMxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 08:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbXICMxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 08:53:24 -0400
Received: from ns2.suse.de ([195.135.220.15]:42760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735AbXICMxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 08:53:23 -0400
From: Andi Kleen <ak@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] i386: per-CPU double fault TSS and stack
Date: Mon, 3 Sep 2007 14:45:33 +0200
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <46D42DC7.76E4.0078.0@novell.com> <200709011233.12256.ak@suse.de> <46DBFF65.76E4.0078.0@novell.com>
In-Reply-To: <46DBFF65.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709031445.33435.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> It costs 4.xx k space per CPU - perhaps a constraint for embedded?

Not a major one.

> >In fact I would prefer to just eliminate CONFIG_DOUBLEFAULT (imho
> >it always a bad idea because the amount of code it saves is miniscule)
> > instead of adding such a ifdef maze.
>
> It's configurable for embedded only anyway, and I think there's some value
> in allowing it to be configured off for that environment.
>

With less ifdefs then please.

>
> >> +				BUG_ON(page_count(page));
> >> +				init_page_count(page);
> >> +				free_pages(stack, j);
> >> +				stack += (PAGE_SIZE << j);
> >
> >In 2.4-aa I added a alloc_pages_exact() for this. I don't think such games
> > should be played outside page_alloc.c. I would recommend to readd
> > alloc_pages_exact() and then use it.
>
> Will need to track that patch down.

http://www.kernel.org/pub/linux/kernel/people/andrea/kernels/v2.4/2.4.23aa3/00_module-gfp-7
But it'll need quite some changes for 2.6 anyways.


> >> -#define DOUBLEFAULT_STACKSIZE (1024)
> >> -static unsigned long doublefault_stack[DOUBLEFAULT_STACKSIZE];
> >> -#define STACK_START (unsigned
> >> long)(doublefault_stack+DOUBLEFAULT_STACKSIZE) +extern unsigned long
> >> max_low_pfn;
> >
> >No externs in .c
>
> The question is - is it acceptable to declare max_low_pfn in any header?

Sure, why not?

-Andi
