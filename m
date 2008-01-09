Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbYAIDWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbYAIDWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYAIDWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:22:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43732 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535AbYAIDWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:22:11 -0500
Date: Tue, 8 Jan 2008 19:22:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Jan Beulich <jbeulich@novell.com>, hch@infradead.org, pagg@oss.sgi.com,
       erikj@sgi.com, pj@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] add task handling notifier
Message-Id: <20080108192207.4646e574.akpm@linux-foundation.org>
In-Reply-To: <1199846820.17010.166.camel@localhost.localdomain>
References: <476A780C.76E4.0078.0@novell.com>
	<20071223122621.GA19310@infradead.org>
	<20071225140526.547a882f.akpm@linux-foundation.org>
	<47838ACB.76E4.0078.0@novell.com>
	<20080108141424.de5d8fba.akpm@linux-foundation.org>
	<1199846820.17010.166.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jan 2008 18:47:00 -0800 Matt Helsley <matthltc@us.ibm.com> wrote:

> > > 
> ...
> > > Am I to conclude then that there's no point in addressing the issues other
> > > people pointed out? While I (obviously, since I submitted the patch disagree),
> > > I'm not certain how others feel. My main point for disagreement here is (I'm
> > > sorry to repeat this) that as long as certain code isn't allowed into the kernel
> > > I think it is not unreasonable to at least expect the kernel to provide some
> > > fundamental infrastructure that can be used for those (supposedly
> > > unacceptable) bits. All I did here was utilizing the base infrastructure I want
> > > added to clean up code that appeared pretty ad-hoc.
> > > 
> > 
> > Ah.  That's a brand new requirement.
> 
> In all fairness it's not really a brand new requirement -- just one that
> wasn't strongly emphasized during prior attempts to get something like
> this in.
> 
> I had a mostly-working patch for this on top of the Task Watchers v2
> patch set. I never posted that specific patch because it had a race with
> module unloading and the fix only increased the overhead you were
> unhappy with. I mentioned it briefly in my lengthy [PATCH 0/X]
> description for Task Watchers v2 (http://lwn.net/Articles/207873/):
> 
> "TODO:
> ...
> I'm working on three more patches that add support for creating a task
> watcher from within a module using an ELF section. They haven't recieved
> as much attention since I've been focusing on measuring the performance
> impact of these patches."
> 
> <snip>
> 
> Would tainting the kernel upon registration of out-of-tree "notifiers"
> be more acceptable?

How does that work?  module.c does the register/deregister on behalf of the
module?

I certainly encourage people to disagreee with me here, but my current
thinking is:

- the cleanup aspect isn't worth the runtime overhead and

- the support-modular-users aspect is largely new and would need a lot
  more description and justification (with examples) before we can even
  begin to evaluate it.

