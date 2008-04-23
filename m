Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbYDWXhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbYDWXhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 19:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYDWXhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 19:37:09 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35260 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752393AbYDWXhI (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 19:37:08 -0400
Date: Thu, 24 Apr 2008 09:36:52 +1000
From: David Chinner <dgc@sgi.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080423233652.GT103491721@sgi.com>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <1208928421.9060.22.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208928421.9060.22.camel@pasglop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 03:27:01PM +1000, Benjamin Herrenschmidt wrote:
> On Sat, 2008-04-19 at 16:23 +0200, Ingo Molnar wrote:
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > >  config 4KSTACKS
> > > >  	bool "Use 4Kb for kernel stacks instead of 8Kb"
> > > > -	depends on DEBUG_KERNEL
> > > >  	depends on X86_32
> > > > +	default y
> > > 
> > > This patch will cause kernels to crash.
> > 
> > what mainline kernels crash and how will they crash? Fedora and other 
> > distros have had 4K stacks enabled for years:
> > 
> >   $ grep 4K /boot/config-2.6.24-9.fc9
> >   CONFIG_4KSTACKS=y
> > 
> > and we've conducted tens of thousands of bootup tests with all sorts of 
> > drivers and kernel options enabled and have yet to see a single crash 
> > due to 4K stacks. So basically the kernel default just follows the 
> > common distro default now. (distros and users can still disable it)
> 
> Do we routinely test nasty scenarii such as a GFP_KERNEL allocation deep
> in a call stack trying to swap something out to NFS ?

I doubt it, because this is the place that a local XFS filesystem
typically blows a 4k stack (direct memory reclaim triggering
->writepage). Boot testing does nothing to exercise the potential
paths for stack overflows....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
