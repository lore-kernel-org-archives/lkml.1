Return-Path: <linux-kernel-owner+w=401wt.eu-S1764018AbYCEXcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764018AbYCEXcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYCEXcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:32:39 -0500
Received: from www.tglx.de ([62.245.132.106]:44695 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651AbYCEXci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:32:38 -0500
Date: Thu, 6 Mar 2008 00:31:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/5] vmalloc: do not check for freed locks on user maps
In-Reply-To: <200803060956.43671.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.1.00.0803060029131.3099@apollo.tec.linutronix.de>
References: <20080305154829.185609547@linutronix.de> <200803060328.20349.nickpiggin@yahoo.com.au> <alpine.LFD.1.00.0803051803070.3099@apollo.tec.linutronix.de> <200803060956.43671.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Nick Piggin wrote:

> On Thursday 06 March 2008 04:20, Thomas Gleixner wrote:
> > On Thu, 6 Mar 2008, Nick Piggin wrote:
> > > On Thursday 06 March 2008 03:03, Thomas Gleixner wrote:
> > > > User maps do not contain kernel internal objects. No need to check
> > > > them.
> > >
> > > Why not? Depends on your definition of kernel internal... and
> > > objects ;)
> > >
> > > Drivers could create and manage some objects in this vmalloc
> > > area. They are no longer internal if you map them to userspace,
> > > but I still don't think you want to vunmap it until those
> > > object lifetimes are finished.
> >
> > Well, in case of the locks I have a hard time to figure out how you
> > use a spinlock/mutex with a user space address. The same applies for
> > timers or other objects used by kernel subsystems. So when the driver
> > writer creates an kernel related object in the vmalloc space, he has
> > to use the kernel mapping which is unmapped separate, right ?
> 
> This is the kernel mapping. The user mapping is unmapped when
> the userspace munmaps.

Ok, my misinterpretation of that flag. Is the user space unmap in the
same code path ? If yes, how can it be distinguished from the kernel
space unmap ?

Thanks,

	tglx
