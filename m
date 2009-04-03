Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbZDCAld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbZDCAld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZDCAlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:41:25 -0400
Received: from cmpxchg.org ([85.214.51.133]:51331 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbZDCAlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:41:24 -0400
Date: Fri, 3 Apr 2009 02:39:26 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] kbuild: work around distcc/icecc madness
Message-ID: <20090403003926.GA11444@cmpxchg.org>
References: <alpine.LFD.2.00.0903192121300.29264@localhost.localdomain> <1237551797.24626.96.camel@twins> <alpine.LFD.2.00.0903201658140.29264@localhost.localdomain> <1237576568.4667.34.camel@laptop> <alpine.LFD.2.00.0903202240370.29264@localhost.localdomain> <20090402235646.GA9052@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402235646.GA9052@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 01:56:46AM +0200, Johannes Weiner wrote:
> On Fri, Mar 20, 2009 at 10:57:38PM +0100, Thomas Gleixner wrote:
> > On Fri, 20 Mar 2009, Peter Zijlstra wrote:
> > > > Changing from distcc to gcc will start a full rebuild on linus tree as
> > > > well.
> > > 
> > > I just tried:
> > > 
> > > root@twins:/mnt/build/linux-2.6# /mnt/md0/cross/bin/x86_64-linux-gcc --version
> > > x86_64-linux-gcc (GCC) 4.3.1 20080510 (prerelease)
> > > Copyright (C) 2008 Free Software Foundation, Inc.
> > > This is free software; see the source for copying conditions.  There is NO
> > > warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> > > 
> > > root@twins:/mnt/build/linux-2.6# gcc --version
> > > gcc (Ubuntu 4.3.2-1ubuntu12) 4.3.2
> > > Copyright (C) 2008 Free Software Foundation, Inc.
> > > This is free software; see the source for copying conditions.  There is NO
> > > warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> > > 
> > > The build with the distcc x86_64-linux-gcc compiler and the install
> > > using the host compiler works just fine on Linus' tree.
> > 
> > Hmm, I went through all the Makefile changes and we do not touch those
> > bits at all.
> > 
> > Can you check whether builddir/scripts/mod/.empty.o.cmd has
> > -DCONFIG_AS_CFI in the command line ?
> > 
> > Can you check that file after you built -tip (w/o my patch) and after
> > your make install started to rebuild the tree ?
> 
> Perhaps 'make V=2 install' can also help figuring out why the targets
> are rebuilt?

Sheesh, please ignore.
