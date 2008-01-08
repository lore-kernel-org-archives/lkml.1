Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbYAHWVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbYAHWVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbYAHWUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:20:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755146AbYAHWUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:20:36 -0500
Date: Tue, 8 Jan 2008 14:14:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jan Beulich" <jbeulich@novell.com>
Cc: hch@infradead.org, pagg@oss.sgi.com, erikj@sgi.com, pj@sgi.com,
       matthltc@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] add task handling notifier
Message-Id: <20080108141424.de5d8fba.akpm@linux-foundation.org>
In-Reply-To: <47838ACB.76E4.0078.0@novell.com>
References: <476A780C.76E4.0078.0@novell.com>
	<20071223122621.GA19310@infradead.org>
	<20071225140526.547a882f.akpm@linux-foundation.org>
	<47838ACB.76E4.0078.0@novell.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jan 2008 13:38:03 +0000
"Jan Beulich" <jbeulich@novell.com> wrote:

> >>> Andrew Morton <akpm@linux-foundation.org> 25.12.07 23:05 >>>
> >On Sun, 23 Dec 2007 12:26:21 +0000 Christoph Hellwig <hch@infradead.org> wrote:
> >
> >> On Thu, Dec 20, 2007 at 01:11:24PM +0000, Jan Beulich wrote:
> >> > With more and more sub-systems/sub-components leaving their footprint
> >> > in task handling functions, it seems reasonable to add notifiers that
> >> > these components can use instead of having them all patch themselves
> >> > directly into core files.
> >> 
> >> I agree that we probably want something like this.  As do some others,
> >> so we already had a few a few attempts at similar things.  The first one
> >> is from SGI and called PAGG (http://oss.sgi.com/projects/pagg/) and also
> >> includes allocating per-task data for it's users.  Then also from SGI
> >> there has been a simplified version called pnotify that's also available
> >> from the website above.
> >> 
> >> Later Matt Helsley had something called "Task Watchers" which lwn has
> >> an article on: http://lwn.net/Articles/208117/.
> >> 
> >> For some reason neither ever made a lot of progess (performance
> >> problems?).
> >> 
> >
> >I had it in -mm, sorted out all the problems but ended up not pulling the
> >trigger.
> >
> >Problem is, it adds runtime overhead purely for the convenience of kernel
> >programmers, and I don't think that's a good tradeoff.
> >
> >Sprinkling direct calls into a few well-known sites won't kill us, and
> >we've survived this long.  Why not keep doing that, and save everyone a few
> >cycles?
> 
> Am I to conclude then that there's no point in addressing the issues other
> people pointed out? While I (obviously, since I submitted the patch disagree),
> I'm not certain how others feel. My main point for disagreement here is (I'm
> sorry to repeat this) that as long as certain code isn't allowed into the kernel
> I think it is not unreasonable to at least expect the kernel to provide some
> fundamental infrastructure that can be used for those (supposedly
> unacceptable) bits. All I did here was utilizing the base infrastructure I want
> added to clean up code that appeared pretty ad-hoc.
> 

Ah.  That's a brand new requirement.

The requirement which I thought we were addressing was "clean the code up
by adding a notifier chain so multiple subsystems don't need to patch in
hard-coded calls".

  My contention is that the code clarity which this gains isn't worth the
  runtime cost.



Now we have a new requirement: "allow out-of-tree code to hook into these
spots without needing to patch those few callsites".

I think we'd need a pretty detailed description of the pain which this
would relieve before we would take such an extraordinary step.  What are
those (unidentified) add-on features doing at present?  Patching calls into
fork.c/exec.c/exit.c?
