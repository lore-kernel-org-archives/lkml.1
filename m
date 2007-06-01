Return-Path: <linux-kernel-owner+w=401wt.eu-S932136AbXFAUop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbXFAUop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762874AbXFAUoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:44:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46273 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762805AbXFAUog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:44:36 -0400
Date: Fri, 1 Jun 2007 22:44:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/9] Conditional Calls - Hash Table
Message-ID: <20070601204434.GN7217@one.firstfloor.org>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.398040643@polymtl.ca> <p731wgxds85.fsf@bingen.suse.de> <20070601160802.GL11166@waste.org> <20070601164623.GB4112@Krystal> <20070601170739.GA11115@waste.org> <20070601174510.GG7217@one.firstfloor.org> <20070601180654.GB7641@Krystal> <20070601193558.GH7217@one.firstfloor.org> <20070601203306.GA14316@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601203306.GA14316@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 04:33:06PM -0400, Mathieu Desnoyers wrote:
> * Andi Kleen (andi@firstfloor.org) wrote:
> > > Yes, but as you have probably understood, I want to have everything
> > > embedded at the cond_call() site rather than polluting the rest of the
> > > code with declarations.
> > 
> > A cond call is essentially a fancy variable. And the Linux kernel
> > is written in C and in C you declare variables before you use them.
> > Also it would allow compile time checking against typos and 
> > allow removing some nasty hash table code. The proposal sounds like a 
> > clear winner to me. 
> > 
> 
> You could not declare in advance a structure that would contain pointers
> to every load immediate instruction of the optimized cond_calls. Unless

To find them you just walk the sections.  Changing cond call is a slow
path operation. That is similar to how the smp lock switching
works today.

> I understand that if we limit ourselves to applications like the two
> toy examples I proposed (enabling profiling and bug fixups), it could
> make sense to try to declare a variable somewhere and later use it in
> the body of functions (except the fact that it cannot work, due to
> incapacity to declare pointers to each load immediate instruction, as
> stated above). Even if it would work, the main purpose here is to
> support the Linux Kernel Markers, where the goal is to provide the
> ability to declare a marker within the body of a function without
> requiring more hassle than a printk, but with less performance impact
> than the latter. Also, we would not want the whole kernel to recompile
> simply because someone chose to add one or two marker in his own driver
> to extract some more information and had to add them to some globally
> included header file.

Sounds similar to config.h then when Kconfig keeps track of those
dependencies for the CONFIG_*s and only recompiles what is needed. Perhaps 
this infrastructure could be reused.

-Andi  
