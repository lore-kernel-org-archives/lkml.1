Return-Path: <linux-kernel-owner+w=401wt.eu-S1946408AbXBIMLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946408AbXBIMLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946407AbXBIMLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:11:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946405AbXBIMLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:11:19 -0500
Date: Fri, 9 Feb 2007 13:11:18 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc][patch 0/3] a faster buffered write deadlock fix?
Message-ID: <20070209121118.GA510@wotan.suse.de>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070209004101.3e4a88fc.akpm@linux-foundation.org> <20070209095405.GA14398@wotan.suse.de> <20070209020954.4951256e.akpm@linux-foundation.org> <20070209103258.GC14398@wotan.suse.de> <20070209025249.0a87a435.akpm@linux-foundation.org> <20070209113116.GB11287@wotan.suse.de> <20070209034644.cc5fe40a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070209034644.cc5fe40a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 03:46:44AM -0800, Andrew Morton wrote:
> On Fri, 9 Feb 2007 12:31:16 +0100 Nick Piggin <npiggin@suse.de> wrote:
> 
> > > 
> > > We'll never, ever, ever update and test all filesytems.  What you're
> > > calling "legacy" code will be there for all time.
> > 
> > I didn't say all; I still prefer correct than fast;
> 
> For gawd's sake.  You can make the kernel less buggy by removing SMP
> support.

I'm talking about known bugs.

> Guess what?  Tradeoffs exist.

I agree that 60% is much too big of a hit for all filesystems. Which is
why I propose this new aop.

> > you are still free
> > to keep the fast-and-buggy code in the legacy path.
> 
> You make it sound like this is a choice.  It isn't.  Nobody is going to go
> in and convert all those filesystems.

IMO, once all the maintained filesystems are converted then it would be
a good choice to make. You think otherwise and I won't argue.

> > > 
> > > I haven't had time to look at the perform_write stuff yet.
> > > 
> > > > Of course I would still want my correct-but-slow version in that case,
> > > > but I just wouldn't care to argue if you still wanted to keep it fast.
> > > 
> > > This is write().  We just cannot go and double-copy all the memory or take
> > > mmap_sem and do a full pagetable walk in there.  It just means that we
> > > haven't found a suitable solution yet.
> > 
> > You prefer speed over correctness even for little used filessytems, which
> > is fine because I'm sick of arguing about it. The main thing for me is that
> > important filesystems can be correct and fast.
> 
> I wouldn't characterise it as "arguing".  It's development.  Going and
> sticking enormous slowdowns into write() to fix some bug which nobody is
> hitting is insane.

Actually I'm doing this because I try to fix real data corruption problems
which people are hitting. You told me I can't get those fixes in until I
fix this problem.

> We need to find a better fix, that's all.

I actually found perform_write to be a speedup. And if perform_write is
merged then I would be happy to not fix the prepare_write path, or wait for
someone to come up with a better fix.
