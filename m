Return-Path: <linux-kernel-owner+w=401wt.eu-S2993145AbXCIVXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993145AbXCIVXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993148AbXCIVXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:23:32 -0500
Received: from waste.org ([66.93.16.53]:40165 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993145AbXCIVXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:23:31 -0500
Date: Fri, 9 Mar 2007 15:10:58 -0600
From: Matt Mackall <mpm@selenic.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Message-ID: <20070309211058.GH10394@waste.org>
References: <20070309053931.GA10459@waste.org> <20070309075358.GA10394@waste.org> <20070309082057.GB10394@waste.org> <200703091939.05535.kernel@kolivas.org> <20070309204623.GE10394@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309204623.GE10394@waste.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 02:46:24PM -0600, Matt Mackall wrote:
> A priori, this load should be manageable by RSDL as the interactive
> loads are all pretty small. So I wrote a little Python script that
> basically continuously memcpys some 16MB chunks of memory:
> 
> #!/usr/bin/python
> a = "a" * 16 * 1024 * 1024
> while 1:
>     b = a[1:] + "b"
>     a = b[1:] + "c"
> 
> I've got 1.5G of RAM, so I can run quite a few of these without
> killing my pagecache. This should test whether a) Beryl's actually
> running up against memory bandwidth issues and b) whether "simple"
> static loads work. As you can see, running 5 instances of this script
> leaves me in good shape still. 10 is still in "ok" territory, with top
> showing each getting 9.7-10% of the CPU. 15 starts to feel sluggish.
> 20 the mouse jumps a bit and I got an MP3 skip. 30 is getting pretty
> bad, but still not as bad as the make -j 5 load.
> 
> My suspicion is the problem lies in giving too much quanta to
> newly-started processes.

I've also tried 10+ instances of each of the following:

forkload:
#!/bin/sh
./forkload&

execload:
#!/bin/sh
exec ./execload

And it's quite well-behaved in both cases.

Also, if I run:

for a in 1 2 3 4 5; do mkdir $a; cp .config $a; make O=$a & done

..I get mostly good behavior with some occassional snags. Things run
much better than make -j 5. Unfortunately, that doesn't make my kernel
get built faster.

-- 
Mathematics is the supreme nostalgia of our time.
