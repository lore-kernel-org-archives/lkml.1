Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYHZXZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYHZXZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 19:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYHZXZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 19:25:01 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:58621 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbYHZXZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 19:25:00 -0400
Date: Wed, 27 Aug 2008 02:24:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
	bisected
Message-ID: <20080826232411.GC11734@cs181140183.pp.htv.fi>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <200808261111.19205.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org> <20080826183051.GB10925@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org> <20080826205916.GB11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 02:04:57PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 26 Aug 2008, Adrian Bunk wrote:
> > 
> > If you think we have too many stacksize problems I'd suggest to consider 
> > removing the choice of 4k stacks on i386, sh and m68knommu instead of 
> > using -fno-inline-functions-called-once:
> 
> Don't be silly. That makes the problem _worse_.
> 
> We're much better off with a 1% code-size reduction than forcing big 
> stacks on people. The 4kB stack option is also a good way of saying "if it 
> works with this, then 8kB is certainly safe".
>...

You implicitely assume both would solve the same problem.

While 4kB stacks are something we anyway never got 100% working, the 
cases where gcc inlining functions causes a critical increase in stack 
usage are usually not that hard to find, and once found the fix is 
trivial.

We should anyway monitor stack usages better since we have frequent 
programming errors in this area, and problems caused by gcc can this
way be detected en passant.

You have a good point that aiming at 4kB makes 8kB a very safe choice.

But I do not think the problem you'd solve with 
-fno-inline-functions-called-once is big enough to warrant the size 
increase it causes.

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

