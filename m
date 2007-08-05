Return-Path: <linux-kernel-owner+w=401wt.eu-S1763197AbXHEJug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763197AbXHEJug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 05:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbXHEJu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 05:50:27 -0400
Received: from 1wt.eu ([62.212.114.60]:1152 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbXHEJu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 05:50:27 -0400
Date: Sun, 5 Aug 2007 11:49:16 +0200
From: Willy Tarreau <w@1wt.eu>
To: Axel Reinhold <axel@freakout.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Bug in 2.4.35 when compiled gcc>=4.2.0 and -march=c3
Message-ID: <20070805094916.GE6002@1wt.eu>
References: <200708050856.l758u4ou031651@bongo.freakout.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708050856.l758u4ou031651@bongo.freakout.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 10:56:04AM +0200, Axel Reinhold wrote:
> i found a bug in linux-2.4.35.
> 
> the bug produces a crashing kernel when compiled
> with gcc >=4.2.0 and VIA C3 optimized -march=c3
> (CONFIG_MCYRIXIII=y)
> 
> this issue was first discussed on the gcc bugzilla:
>  http://gcc.gnu.org/bugzilla/show_bug.cgi?id=32264
> 
> and tracked down to the include/asm-i386/hw_irq.h
> module with the help of the gcc guys:
> 
> (pluto at agmk dot net) wrote:
> >yup, i see something new :)
> >
> >please look at line 12137 of i8259.i:
> >
> >__attribute__((regparm(0))) void call_do_IRQ(void); __asm__(...
> >
> >as you can see there is a semicolon after call_do_IRQ(void)
> >and following asm statement isn't treated as a function body.
> >in this way -O1 -f{no-}unit-at-a-time accidentally produces
> >different code. it's not a gcc bug.
> >
> >linux-2.4.35/include/asm-i386/hw_irq.h
> >contains these evil macros.
> 
> is there a chance to fix this?
> these macros a far beyond my capabilities to fix.

That's one of the ugliest things I've discovered to date !
I have no idea how to fix it, I'm downloading gcc-4.2 right now to try
to find a solution. I've never compiled 2.4 with gcc 4.2, so there may
be surprises.

Regards,
Willy

