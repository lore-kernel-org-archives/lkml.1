Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbYDXApk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbYDXApk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 20:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYDXApc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 20:45:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45882 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYDXApb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 20:45:31 -0400
Date: Wed, 23 Apr 2008 17:45:16 -0700
From: Arjan van de Ven <arjan@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080423174516.0982a325@laptopd505.fenrus.org>
In-Reply-To: <20080423233652.GT103491721@sgi.com>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	<20080418142934.38ce6bf4.akpm@linux-foundation.org>
	<20080419142329.GA5339@elte.hu>
	<1208928421.9060.22.camel@pasglop>
	<20080423233652.GT103491721@sgi.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
To: T David Chinner <dgc@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008 09:36:52 +1000
David Chinner <dgc@sgi.com> wrote:

> On Wed, Apr 23, 2008 at 03:27:01PM +1000, Benjamin Herrenschmidt
> wrote:
> > On Sat, 2008-04-19 at 16:23 +0200, Ingo Molnar wrote:
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > >  config 4KSTACKS
> > > > >  	bool "Use 4Kb for kernel stacks instead of 8Kb"
> > > > > -	depends on DEBUG_KERNEL
> > > > >  	depends on X86_32
> > > > > +	default y
> > > > 
> > > > This patch will cause kernels to crash.
> > > 
> > > what mainline kernels crash and how will they crash? Fedora and
> > > other distros have had 4K stacks enabled for years:
> > > 
> > >   $ grep 4K /boot/config-2.6.24-9.fc9
> > >   CONFIG_4KSTACKS=y
> > > 
> > > and we've conducted tens of thousands of bootup tests with all
> > > sorts of drivers and kernel options enabled and have yet to see a
> > > single crash due to 4K stacks. So basically the kernel default
> > > just follows the common distro default now. (distros and users
> > > can still disable it)
> > 
> > Do we routinely test nasty scenarii such as a GFP_KERNEL allocation
> > deep in a call stack trying to swap something out to NFS ?
> 
> I doubt it, because this is the place that a local XFS filesystem
> typically blows a 4k stack (direct memory reclaim triggering
> ->writepage). Boot testing does nothing to exercise the potential
> paths for stack overflows....
> 

THe good news is that direct reclaim is.. rare.
And I also doubt XFS is unique here; imagine the whole stacking thing on x86-64 just the same ...

I wonder if the direct reclaim path should avoid direct reclaim if the stack has only X bytes left.
(where the value of X is... well we can figure that one out later)

The rarity of direct reclaim during normal use ought to make this not a performance problem per se,
and the benefits go further than just "XFS" or "4K stacks".

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
