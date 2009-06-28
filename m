Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZF1VBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZF1VBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbZF1VA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:00:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45157 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZF1VA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:00:57 -0400
Date: Sun, 28 Jun 2009 23:00:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org, earl_chew@agilent.com,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when using pipes in core_pattern
Message-ID: <20090628210054.GB6760@one.firstfloor.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090626104804.GA7337@hmsreliant.think-freely.org> <20090626092001.32e35e17.akpm@linux-foundation.org> <20090628193112.GA6760@one.firstfloor.org> <20090628135235.10f9b153.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090628135235.10f9b153.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 01:52:35PM -0700, Andrew Morton wrote:
> On Sun, 28 Jun 2009 21:31:12 +0200 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > One way would be to add a new sysctl-externs.h and then put all the
> > > declarations in there.  That file gets included by sysctl.c and by each
> > > file which shares a global with sysctl.c
> > 
> > Long ago I had a experimental patch to put sysctls into a new ELF section. The 
> > you could simply put a DEFINE_SYSCTL(....) into the appropiate source file
> > which defined the variable and most of the tables went.
> > 
> > No externs, no mess, no patch collisions, everything much nicer.
> > 
> > The only problem was that it didn't support the numerical sysctl
> > space, so that would need to be removed first.
> > 
> > It's deprecated for quite some time now:
> > 
> >   if (msg_count < 5) {
> >                 msg_count++;
> >                 printk(KERN_INFO
> >                         "warning: process `%s' used the deprecated sysctl "
> >                         "system call with ", current->comm);
> > 
> > Should it finally go now? If yes I could polish up the old patch again.
> > 
> 
> I suspect that it will be a long time before we can actually remove the
> numerical sysctl support, if ever.  In _theory_ we should support it

To my knowledge the only one that is really commonly used is the one
used by glibc, but that can be kept of course.

> for ever.  But in practice, we could probably remove it with a minimum
> of disruption a few years hence, but it's hard to work this out.

One alternative would be to just keep a translation table
numerical -> symbolic for now and remove that later. That would
still not need any externs at least.

Or perhaps make a explicit CONFIG_SYSCTL_NUMERICAL and ask
users to report in.

> 
> When was the last time we saw a "warning: process `%s' used the
> obsolete bdflush system call" warning?  A quick google here says 2004. 
> Is that data?  A bit, I guess.

bdflush? 

> Maybe Eric has thought about this issue?

feature-removal says Sep 2010 (which seems a bit long in the future)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
