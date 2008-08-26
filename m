Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbYHZXwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbYHZXwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 19:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYHZXwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 19:52:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752184AbYHZXwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 19:52:20 -0400
Date: Tue, 26 Aug 2008 16:51:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <20080826232411.GC11734@cs181140183.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0808261648140.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <200808261111.19205.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
 <20080826183051.GB10925@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org> <20080826205916.GB11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
 <20080826232411.GC11734@cs181140183.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Aug 2008, Adrian Bunk wrote:
> > 
> > We're much better off with a 1% code-size reduction than forcing big 
> > stacks on people. The 4kB stack option is also a good way of saying "if it 
> > works with this, then 8kB is certainly safe".
> 
> You implicitely assume both would solve the same problem.

I'm just saying that your logic doesn't hold water.

If we can save kernel stack usage, then a 1% increase in kernel size is 
more than worth it.

> While 4kB stacks are something we anyway never got 100% working

What? Don't be silly. 

Linux _historically_ always used 4kB stacks.

No, they are likely not usable on x86-64, but dammit, they should be more 
than usable on x86-32 still.

> But I do not think the problem you'd solve with 
> -fno-inline-functions-called-once is big enough to warrant the size 
> increase it causes.

You continually try to see the inlining as a single solution to one 
problem (debuggability, stack, whatever).

The biggest problem with gcc inlining has always been that it has been 
_unpredictable_. It causes problems in many different ways. It has caused 
stability issues due to gcc versions doing random things. It causes the 
stack expansion. It makes stack traces harder for debugging, etc.

If it was any one thing, I wouldn't care. But it's exactly the fact that 
it causes all these problems in different areas.

			Linus
