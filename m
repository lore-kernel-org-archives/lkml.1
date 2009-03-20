Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbZCTQCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbZCTQCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 12:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbZCTQBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 12:01:52 -0400
Received: from www.tglx.de ([62.245.132.106]:37240 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbZCTQBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 12:01:52 -0400
Date: Fri, 20 Mar 2009 17:00:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] kbuild: work around distcc/icecc madness
In-Reply-To: <1237551797.24626.96.camel@twins>
Message-ID: <alpine.LFD.2.00.0903201658140.29264@localhost.localdomain>
References: <alpine.LFD.2.00.0903192121300.29264@localhost.localdomain> <1237551797.24626.96.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Peter Zijlstra wrote:
> Yes, this makes it mostly work again... however,
> 
> On -linus I can do:
>   
> # cat distmake
> 
>   #!/bin/bash
> 
>   ARCH=$1; shift
> 
>   export LD="nice -n19 ${ARCH}-linux-ld"
>   export AS="distcc ${ARCH}-linux-as"
>   export CC="distcc ${ARCH}-linux-gcc"
> 
>   make LD="$LD" AS="$AS" CC="$CC" -j $DISTCC_SLOTS "$@"
> 
> # distmake x86_64 bzImage
> 
> to build the tree, and then use: 
> 
> # make install
> 
> to install the resulting image. Note how the second make will use the
> system gcc and not the distcc with cross arch toolchain.
> 
> This will still start a full rebuild on -tip. When I change my script to
> use distmake x86_64 install, things work again after this patch.

Changing from distcc to gcc will start a full rebuild on linus tree as
well.

Thanks,

	tglx
