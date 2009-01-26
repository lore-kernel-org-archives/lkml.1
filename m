Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZAZTbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZAZTbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZAZTa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:30:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752718AbZAZTaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:30:55 -0500
Date: Mon, 26 Jan 2009 11:30:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: npiggin@suse.de, mingo@elte.hu, linux-arch@vger.kernel.org,
       rusty@rustcorp.com.au, travis@sgi.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       arjan@infradead.org, hpa@zytor.com, tglx@linutronix.de,
       Ying Han <yinghan@google.com>, Mike Waychison <mikew@google.com>
Subject: Re: [git pull] cpus4096 tree, part 3
Message-Id: <20090126113026.4d9682e3.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0901261107280.5284@localhost.localdomain>
References: <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain>
	<20090102203839.GA26850@elte.hu>
	<alpine.LFD.2.00.0901021531140.3179@localhost.localdomain>
	<20090103193859.GB9805@elte.hu>
	<alpine.LFD.2.00.0901031225020.3179@localhost.localdomain>
	<20090103203621.GA2491@elte.hu>
	<20090103213856.GA24138@elte.hu>
	<alpine.LFD.2.00.0901031347570.3179@localhost.localdomain>
	<20090103223723.GA17047@elte.hu>
	<20090105011416.GG32239@wotan.suse.de>
	<20090105011630.GI32239@wotan.suse.de>
	<20090126110054.bdddbf38.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0901261107280.5284@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 11:09:59 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 26 Jan 2009, Andrew Morton wrote:
> > > +	write = error_code & PF_WRITE;
> > 
> > What's going on here?  We set `error_code' to PF_WRITE, which is some
> > x86-specific thing.
> 
> No. We set "write" to non-zero if it was a write fault.
> 
> > >  	fault = handle_mm_fault(mm, vma, address, write);
> > 
> > and then pass it into handle_mm_fault(), which is expecting a bunch of
> > flags in the FAULT_FLAG_foo domain.
> 
> No. "handle_mm_fault()" takes an integer that is non-zero if it's a write, 
> zero if it's a read. That's how it has _always_ worked.
> 
> I don't see where you find that FAULT_FLAG_foo thing. That's much deeper 
> down, when people do things like
> 
>         unsigned int flags = FAULT_FLAG_NONLINEAR |
>                                 (write_access ? FAULT_FLAG_WRITE : 0);
> 
> based on that whole "write_access" flag.
> 

OK, thanks.  It's actually page_fault-retry-with-nopage_retry.patch
which got those things confused, and then confused me.  I'll go address
that in the other thread..


