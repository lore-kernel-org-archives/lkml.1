Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZCTV7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZCTV7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 17:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZCTV7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 17:59:09 -0400
Received: from www.tglx.de ([62.245.132.106]:41606 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbZCTV7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 17:59:08 -0400
Date: Fri, 20 Mar 2009 22:57:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] kbuild: work around distcc/icecc madness
In-Reply-To: <1237576568.4667.34.camel@laptop>
Message-ID: <alpine.LFD.2.00.0903202240370.29264@localhost.localdomain>
References: <alpine.LFD.2.00.0903192121300.29264@localhost.localdomain>  <1237551797.24626.96.camel@twins>  <alpine.LFD.2.00.0903201658140.29264@localhost.localdomain> <1237576568.4667.34.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Peter Zijlstra wrote:
> > Changing from distcc to gcc will start a full rebuild on linus tree as
> > well.
> 
> I just tried:
> 
> root@twins:/mnt/build/linux-2.6# /mnt/md0/cross/bin/x86_64-linux-gcc --version
> x86_64-linux-gcc (GCC) 4.3.1 20080510 (prerelease)
> Copyright (C) 2008 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> root@twins:/mnt/build/linux-2.6# gcc --version
> gcc (Ubuntu 4.3.2-1ubuntu12) 4.3.2
> Copyright (C) 2008 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> The build with the distcc x86_64-linux-gcc compiler and the install
> using the host compiler works just fine on Linus' tree.

Hmm, I went through all the Makefile changes and we do not touch those
bits at all.

Can you check whether builddir/scripts/mod/.empty.o.cmd has
-DCONFIG_AS_CFI in the command line ?

Can you check that file after you built -tip (w/o my patch) and after
your make install started to rebuild the tree ?

Thanks,

	tglx
