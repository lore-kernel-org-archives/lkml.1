Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYAICrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYAICrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYAICrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:47:13 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34581 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbYAICrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:47:12 -0500
Subject: Re: [PATCH 0/4] add task handling notifier
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Beulich <jbeulich@novell.com>, hch@infradead.org, pagg@oss.sgi.com,
       erikj@sgi.com, pj@sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080108141424.de5d8fba.akpm@linux-foundation.org>
References: <476A780C.76E4.0078.0@novell.com>
	 <20071223122621.GA19310@infradead.org>
	 <20071225140526.547a882f.akpm@linux-foundation.org>
	 <47838ACB.76E4.0078.0@novell.com>
	 <20080108141424.de5d8fba.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 08 Jan 2008 18:47:00 -0800
Message-Id: <1199846820.17010.166.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-08 at 14:14 -0800, Andrew Morton wrote:
> On Tue, 08 Jan 2008 13:38:03 +0000
> "Jan Beulich" <jbeulich@novell.com> wrote:
> 
> > >>> Andrew Morton <akpm@linux-foundation.org> 25.12.07 23:05 >>>
> > >On Sun, 23 Dec 2007 12:26:21 +0000 Christoph Hellwig <hch@infradead.org> wrote:
> > >
> > >> On Thu, Dec 20, 2007 at 01:11:24PM +0000, Jan Beulich wrote:
> > >> > With more and more sub-systems/sub-components leaving their footprint
> > >> > in task handling functions, it seems reasonable to add notifiers that
> > >> > these components can use instead of having them all patch themselves
> > >> > directly into core files.
> > >> 
> > >> I agree that we probably want something like this.  As do some others,
> > >> so we already had a few a few attempts at similar things.  The first one
> > >> is from SGI and called PAGG (http://oss.sgi.com/projects/pagg/) and also
> > >> includes allocating per-task data for it's users.  Then also from SGI
> > >> there has been a simplified version called pnotify that's also available
> > >> from the website above.
> > >> 
> > >> Later Matt Helsley had something called "Task Watchers" which lwn has
> > >> an article on: http://lwn.net/Articles/208117/.
> > >> 
> > >> For some reason neither ever made a lot of progess (performance
> > >> problems?).
> > >> 
> > >
> > >I had it in -mm, sorted out all the problems but ended up not pulling the
> > >trigger.
> > >
> > >Problem is, it adds runtime overhead purely for the convenience of kernel
> > >programmers, and I don't think that's a good tradeoff.
> > >
> > >Sprinkling direct calls into a few well-known sites won't kill us, and
> > >we've survived this long.  Why not keep doing that, and save everyone a few
> > >cycles?
> > 
> > Am I to conclude then that there's no point in addressing the issues other
> > people pointed out? While I (obviously, since I submitted the patch disagree),
> > I'm not certain how others feel. My main point for disagreement here is (I'm
> > sorry to repeat this) that as long as certain code isn't allowed into the kernel
> > I think it is not unreasonable to at least expect the kernel to provide some
> > fundamental infrastructure that can be used for those (supposedly
> > unacceptable) bits. All I did here was utilizing the base infrastructure I want
> > added to clean up code that appeared pretty ad-hoc.
> > 
> 
> Ah.  That's a brand new requirement.

In all fairness it's not really a brand new requirement -- just one that
wasn't strongly emphasized during prior attempts to get something like
this in.

I had a mostly-working patch for this on top of the Task Watchers v2
patch set. I never posted that specific patch because it had a race with
module unloading and the fix only increased the overhead you were
unhappy with. I mentioned it briefly in my lengthy [PATCH 0/X]
description for Task Watchers v2 (http://lwn.net/Articles/207873/):

"TODO:
...
I'm working on three more patches that add support for creating a task
watcher from within a module using an ELF section. They haven't recieved
as much attention since I've been focusing on measuring the performance
impact of these patches."

<snip>

Would tainting the kernel upon registration of out-of-tree "notifiers"
be more acceptable?

Cheers,
	-Matt Helsley

