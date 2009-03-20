Return-Path: <linux-kernel-owner+w=401wt.eu-S1760957AbZCTTQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760957AbZCTTQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbZCTTQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:16:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:49737 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbZCTTQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:16:25 -0400
Subject: Re: [PATCH] kbuild: work around distcc/icecc madness
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0903201658140.29264@localhost.localdomain>
References: <alpine.LFD.2.00.0903192121300.29264@localhost.localdomain>
	 <1237551797.24626.96.camel@twins>
	 <alpine.LFD.2.00.0903201658140.29264@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 20 Mar 2009 20:16:08 +0100
Message-Id: <1237576568.4667.34.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 17:00 +0100, Thomas Gleixner wrote:
> On Fri, 20 Mar 2009, Peter Zijlstra wrote:
> > Yes, this makes it mostly work again... however,
> > 
> > On -linus I can do:
> >   
> > # cat distmake
> > 
> >   #!/bin/bash
> > 
> >   ARCH=$1; shift
> > 
> >   export LD="nice -n19 ${ARCH}-linux-ld"
> >   export AS="distcc ${ARCH}-linux-as"
> >   export CC="distcc ${ARCH}-linux-gcc"
> > 
> >   make LD="$LD" AS="$AS" CC="$CC" -j $DISTCC_SLOTS "$@"
> > 
> > # distmake x86_64 bzImage
> > 
> > to build the tree, and then use: 
> > 
> > # make install
> > 
> > to install the resulting image. Note how the second make will use the
> > system gcc and not the distcc with cross arch toolchain.
> > 
> > This will still start a full rebuild on -tip. When I change my script to
> > use distmake x86_64 install, things work again after this patch.
> 
> Changing from distcc to gcc will start a full rebuild on linus tree as
> well.

I just tried:

root@twins:/mnt/build/linux-2.6# /mnt/md0/cross/bin/x86_64-linux-gcc --version
x86_64-linux-gcc (GCC) 4.3.1 20080510 (prerelease)
Copyright (C) 2008 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

root@twins:/mnt/build/linux-2.6# gcc --version
gcc (Ubuntu 4.3.2-1ubuntu12) 4.3.2
Copyright (C) 2008 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

The build with the distcc x86_64-linux-gcc compiler and the install
using the host compiler works just fine on Linus' tree.



