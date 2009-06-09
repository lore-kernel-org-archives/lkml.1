Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbZFIJjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbZFIJjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 05:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbZFIJjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 05:39:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:53887 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbZFIJjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 05:39:23 -0400
Date: Tue, 9 Jun 2009 11:39:18 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native kernels
Message-ID: <20090609093918.GC16940@wotan.suse.de>
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 08:02:14AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 4 Jun 2009, Rusty Russell wrote:
> > >
> > > Turn off HIGHMEM64G, please (and HIGHMEM4G too, for that matter - you
> > > can't compare it to a no-highmem case).
> > 
> > Thanks, your point is demonstrated below.  I don't think HIGHMEM4G is 
> > unreasonable for a distro tho, so I turned that on instead.
> 
> Well, I agree that HIGHMEM4G is a _reasonable_ thing to turn on.
> 
> The thing I disagree with is that it's at all valid to then compare to 
> some all-software feature thing. HIGHMEM doesn't expand any esoteric 
> capability that some people might use - it's about regular RAM for regular 
> users.
> 
> And don't get me wrong - I don't like HIGHMEM. I detest the damn thing. I 
> hated having to merge it, and I still hate it. It's a stupid, ugly, and 
> very invasive config option. It's just that it's there to support a 
> stupid, ugly and very annoying fundamental hardware problem.

I was looking forward to be able to get rid of it... unfortunately
other 32-bit architectures are starting to use it again :(

I guess it is not incredibly intrusive for generic mm code. A bit
of kmap sprinkled around which is actually quite a useful delimiter
of where pagecache is addressed via its kernel mapping.

Do you hate more the x86 code? Maybe that can be removed?

