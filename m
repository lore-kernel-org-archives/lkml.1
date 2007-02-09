Return-Path: <linux-kernel-owner+w=401wt.eu-S1946377AbXBILq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946377AbXBILq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 06:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946376AbXBILq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 06:46:59 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46001 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946370AbXBILq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 06:46:58 -0500
Date: Fri, 9 Feb 2007 03:46:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc][patch 0/3] a faster buffered write deadlock fix?
Message-Id: <20070209034644.cc5fe40a.akpm@linux-foundation.org>
In-Reply-To: <20070209113116.GB11287@wotan.suse.de>
References: <20070208105437.26443.35653.sendpatchset@linux.site>
	<20070209004101.3e4a88fc.akpm@linux-foundation.org>
	<20070209095405.GA14398@wotan.suse.de>
	<20070209020954.4951256e.akpm@linux-foundation.org>
	<20070209103258.GC14398@wotan.suse.de>
	<20070209025249.0a87a435.akpm@linux-foundation.org>
	<20070209113116.GB11287@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007 12:31:16 +0100 Nick Piggin <npiggin@suse.de> wrote:

> > > > > But that all becomes legacy path, so do we really care? Supposing fs
> > > > > maintainers like perform_write, then after the main ones have implementations
> > > > > we could switch over to the slow-but-correct prepare_write legacy path.
> > > > > Or we could leave it, or we could use Linus's slightly-less-buggy scheme...
> > > > > by that point I expect I'd be sick of arguing about it ;)
> > > > 
> > > > It's worth "arguing" about.  This is write().  What matters more??
> > > 
> > > That's the legacy path that uses prepare/commit (ie. supposing that all
> > > major filesystems did get converted to perform_write).
> > 
> > We'll never, ever, ever update and test all filesytems.  What you're
> > calling "legacy" code will be there for all time.
> 
> I didn't say all; I still prefer correct than fast;

For gawd's sake.  You can make the kernel less buggy by removing SMP
support.

Guess what?  Tradeoffs exist.

> you are still free
> to keep the fast-and-buggy code in the legacy path.

You make it sound like this is a choice.  It isn't.  Nobody is going to go
in and convert all those filesystems.

> > 
> > I haven't had time to look at the perform_write stuff yet.
> > 
> > > Of course I would still want my correct-but-slow version in that case,
> > > but I just wouldn't care to argue if you still wanted to keep it fast.
> > 
> > This is write().  We just cannot go and double-copy all the memory or take
> > mmap_sem and do a full pagetable walk in there.  It just means that we
> > haven't found a suitable solution yet.
> 
> You prefer speed over correctness even for little used filessytems, which
> is fine because I'm sick of arguing about it. The main thing for me is that
> important filesystems can be correct and fast.

I wouldn't characterise it as "arguing".  It's development.  Going and
sticking enormous slowdowns into write() to fix some bug which nobody is
hitting is insane.

We need to find a better fix, that's all.
