Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZEONGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZEONGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbZEONGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:06:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44124 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbZEONF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:05:59 -0400
Date: Fri, 15 May 2009 15:05:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
Message-ID: <20090515130547.GA1976@elf.ucw.cz>
References: <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com> <alpine.DEB.1.10.0905121708470.14226@qirst.com> <20090514092909.GG1365@ucw.cz> <alpine.DEB.1.10.0905141546040.1381@qirst.com> <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com> <20090514213403.GB14741@elf.ucw.cz> <1242337299.28440.47.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242337299.28440.47.camel@nimitz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > -	printk(KERN_ERR "%s: kill process %d (%s) score %li or a child\n",
> > > > +	printk(KERN_ERR "No available memory %s: "
> > > > +			"kill process %d (%s) score %li or a child\n",
> > > >  					message, task_pid_nr(p), p->comm, points);
> > > 
> > > "No available memory" still suggests that plugging in more memory is the
> > > right solution.
> > 
> > And... on correctly working kernel, it is, right?
> > 
> > If you have no swap space and too many applications, you plug more
> > memory. (Or invent some swap).
> > 
> > If you misconfigured cgroups, you give more memory to them.
> > 
> > If your applications mlocked 900MB and you have 1GB, you need to plug
> > more memory.
> > 
> > So... when is plugging more memory _not_ valid answer? AFAICT it is
> > when it is some kernel problem, resulting in memory not being
> > reclaimed fast enough....
> 
> I recently had a problem (~2.6.27) where the user did an mlock() of ~95%
> of memory then started doing ftp tests.  The machine also had 64k base
> pages.  We let you dirty ~30% of memory, so they were able to dirty 6x
> more memory than what we even had to work with.  We OOMed pretty fast
> every time.

Ok, so kernel should be fixed to make limits 30% of non-mlocked
memory.

> This is actually a pretty common scenario for the HPC and database
> folks.  They go sucking up and locking as much memory as they can get
> their hands on.  Adding memory never helps them because they'll use up
> whatever is there.

Well, but it is uncommon everywhere else. If you have desktop system,
job size is pretty much constant. If you have too little memory, you
OOM.

Even with mlock, if mlock size is constant (like 1GB), adding memory
will help.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
