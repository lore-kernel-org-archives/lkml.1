Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbZENVmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbZENVmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 17:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbZENVlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 17:41:50 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44278 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbZENVlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 17:41:49 -0400
Subject: Re: Misleading OOM messages
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090514213403.GB14741@elf.ucw.cz>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0905121708470.14226@qirst.com>
	 <20090514092909.GG1365@ucw.cz>
	 <alpine.DEB.1.10.0905141546040.1381@qirst.com>
	 <1242333519.15391.210.camel@nimitz>
	 <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com>
	 <1242335120.15391.242.camel@nimitz>
	 <alpine.DEB.1.10.0905141729180.30187@qirst.com>
	 <20090514213403.GB14741@elf.ucw.cz>
Content-Type: text/plain
Date: Thu, 14 May 2009 14:41:39 -0700
Message-Id: <1242337299.28440.47.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 23:34 +0200, Pavel Machek wrote:
> On Thu 2009-05-14 17:30:02, Christoph Lameter wrote:
> > On Thu, 14 May 2009, Dave Hansen wrote: 
> > > -	printk(KERN_ERR "%s: kill process %d (%s) score %li or a child\n",
> > > +	printk(KERN_ERR "No available memory %s: "
> > > +			"kill process %d (%s) score %li or a child\n",
> > >  					message, task_pid_nr(p), p->comm, points);
> > 
> > "No available memory" still suggests that plugging in more memory is the
> > right solution.
> 
> And... on correctly working kernel, it is, right?
> 
> If you have no swap space and too many applications, you plug more
> memory. (Or invent some swap).
> 
> If you misconfigured cgroups, you give more memory to them.
> 
> If your applications mlocked 900MB and you have 1GB, you need to plug
> more memory.
> 
> So... when is plugging more memory _not_ valid answer? AFAICT it is
> when it is some kernel problem, resulting in memory not being
> reclaimed fast enough....

I recently had a problem (~2.6.27) where the user did an mlock() of ~95%
of memory then started doing ftp tests.  The machine also had 64k base
pages.  We let you dirty ~30% of memory, so they were able to dirty 6x
more memory than what we even had to work with.  We OOMed pretty fast
every time.

Now, that situation never gets better when you add more memory.  It only
gets worse because that "30% of memory number" takes longer and longer
to write out to the disk.

This is actually a pretty common scenario for the HPC and database
folks.  They go sucking up and locking as much memory as they can get
their hands on.  Adding memory never helps them because they'll use up
whatever is there.

-- Dave

