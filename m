Return-Path: <linux-kernel-owner+w=401wt.eu-S932174AbYDUOSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbYDUOSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756965AbYDUORy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:17:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48149 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741AbYDUORx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:17:53 -0400
Date: Mon, 21 Apr 2008 16:17:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel.send@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: memtest bootparam
Message-ID: <20080421141735.GS9554@elte.hu>
References: <200804181717.m3IHHicT031344@hera.kernel.org> <20080418145202.c96460a2.akpm@linux-foundation.org> <20080419133333.GC23873@elf.ucw.cz> <86802c440804191354q45fdedelce0ec38ba52f3880@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440804191354q45fdedelce0ec38ba52f3880@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> >  > OK.  Did the new memtest feature get documented anywhere, btw?  
> >  > I'm only vaguely aware of its existence.
> >
> >  Actually it would be nice if memtest was global, not x86-specific, 
> >  feature.
> >
> >  I had some fun with arm running with 256mb, when only 128mb was 
> >  present. It booted succesfully...
> 
> depends if you have find_e820_area_size in you platform. that need 
> reserve_early...
> 
> maybe we need to make reserve_early generic at first.

e820 is very x86 specific - i think the proper interface would be to 
move the memtest feature to the bootmem subsystem. I.e. to run it once 
all the early reservations have been flushed into bootmem - but before 
we free all bootmem pages into the page allocator.

this still leaves a rather large amount of RAM to be tested, and keeps 
it all cross-arch as well. Hm?

	Ingo
