Return-Path: <linux-kernel-owner+w=401wt.eu-S1763674AbXFAUdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763674AbXFAUdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762231AbXFAUdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:33:11 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:64401 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762026AbXFAUdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:33:09 -0400
Date: Fri, 1 Jun 2007 16:33:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/9] Conditional Calls - Hash Table
Message-ID: <20070601203306.GA14316@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.398040643@polymtl.ca> <p731wgxds85.fsf@bingen.suse.de> <20070601160802.GL11166@waste.org> <20070601164623.GB4112@Krystal> <20070601170739.GA11115@waste.org> <20070601174510.GG7217@one.firstfloor.org> <20070601180654.GB7641@Krystal> <20070601193558.GH7217@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070601193558.GH7217@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:17:10 up 4 days,  4:55,  2 users,  load average: 1.38, 1.53, 1.08
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> > Yes, but as you have probably understood, I want to have everything
> > embedded at the cond_call() site rather than polluting the rest of the
> > code with declarations.
> 
> A cond call is essentially a fancy variable. And the Linux kernel
> is written in C and in C you declare variables before you use them.
> Also it would allow compile time checking against typos and 
> allow removing some nasty hash table code. The proposal sounds like a 
> clear winner to me. 
> 

You could not declare in advance a structure that would contain pointers
to every load immediate instruction of the optimized cond_calls. Unless
I'm wrong, this idea just can't be implemented in C.

> > Also, if we have the same cond_calls in different modules, in which
> > module shall it be defined ?
> 
> In one of them. Like all other variables in C.
> 

I understand that if we limit ourselves to applications like the two
toy examples I proposed (enabling profiling and bug fixups), it could
make sense to try to declare a variable somewhere and later use it in
the body of functions (except the fact that it cannot work, due to
incapacity to declare pointers to each load immediate instruction, as
stated above). Even if it would work, the main purpose here is to
support the Linux Kernel Markers, where the goal is to provide the
ability to declare a marker within the body of a function without
requiring more hassle than a printk, but with less performance impact
than the latter. Also, we would not want the whole kernel to recompile
simply because someone chose to add one or two marker in his own driver
to extract some more information and had to add them to some globally
included header file.

Therefore, due to the use of cond_calls within markers, I strongly
prefer the dynamic implementation I proposed to implementations
requiring additional variable declaration and frequent header changes.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
