Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbZAGETG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbZAGETG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 23:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbZAGERH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 23:17:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754250AbZAGERE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 23:17:04 -0500
Date: Tue, 6 Jan 2009 20:16:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Subject: Re: 2.6.29 -mm merge plans
Message-Id: <20090106201657.bf9faa38.akpm@linux-foundation.org>
In-Reply-To: <200901071405.51642.nickpiggin@yahoo.com.au>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<200901071306.45210.nickpiggin@yahoo.com.au>
	<20090106181647.e22b27d2.akpm@linux-foundation.org>
	<200901071405.51642.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009 14:05:51 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Wednesday 07 January 2009 13:16:47 Andrew Morton wrote:
> > On Wed, 7 Jan 2009 13:06:44 +1100 Nick Piggin <nickpiggin@yahoo.com.au> 
> wrote:
> > > On Wednesday 07 January 2009 10:13:44 Andrew Morton wrote:
> > > > (cc added)
> > > >
> > > > On Tue, 6 Jan 2009 17:57:44 -0500
> > > >
> > > > Christoph Hellwig <hch@infradead.org> wrote:
> > > > > On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> > > > > > softirq-introduce-statistics-for-softirq.patch
> > > > > > proc-export-statistics-for-softirq-to-proc.patch
> > > > > > proc-update-document-for-proc-softirqs-and-proc-stat.patch
> > > > >
> > > > > Why is this in procfs?
> > > >
> > > > softirq stuff in /proc seems appropriate?  It's alongside
> > > > /proc/interrupts.  We could put it in /trendy-fs-of-the-day, but what
> > > > would it gain us?
> > >
> > > Haven't we kind of agreed to use sysfs for things like this? A few years
> > > too late to be raising objections now ;)
> > >
> > > One problem I have with sysfs is that it (the directory structure, rather
> > > than the sysfs code itself) really needs to be policed and maintained
> > > by a central and coherent place/person with taste. Otherwise people put
> > > their own random crap with their own random naming schemes and becomes
> > > a crazy mess.
> > >
> > > softirqs are not hardware but purely kernel subsystem construct, as such
> > > they probably go under /sys/kernel/. People unfortunately have already
> > > added random crap to the /sys/kernel/ root directory, but future
> > > additions really should go into a good subdirectory structure (putting it
> > > into the root directory is equivalent to ditching all subdirectories from
> > > /proc/sys/).
> >
> > All sounds like pointless wank^Wbikeshed painting to me.
> 
> Really? Our userspace ABI? You think it works bestter when there is as
> little thought as possible put into it and everybody just does what
> they feel is best?

If I thought that, I would say it.

> 
> > > /sys/kernel/softirq/*, I suggest.
> >
> > What would that *improve*?
> 
> It would be logically in the right place.

That's STILL not a *reason*.  Nobody has provded a reason.

Here's a reason: look in /proc.  It contains "interrupts", "irq",
"vmstat", "meminfo", etc.  All simple files which provide realtime view
of core kernel activity.  Which is precisely what /proc/softirq does!

So putting it in /proc/softirq is "logical", and yanking it out and
stuffing it in some random other place for reasons which nobody can
explain is illogical.

Plus the patch adds a summary line to the existing /proc/stat.  Which
is also logical.  Do we do that in debugfs too?

