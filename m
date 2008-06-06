Return-Path: <linux-kernel-owner+w=401wt.eu-S933155AbYFFXtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155AbYFFXtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 19:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbYFFXs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 19:48:59 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:26216 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226AbYFFXs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 19:48:58 -0400
X-BigFish: VPS-18(z34a4nz1432R98dR1805Mzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4849CCA3.7040102@am.sony.com>
Date: Fri, 6 Jun 2008 16:47:47 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <adrian.bunk@movial.fi>
CC: linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
 translation
References: <48447615.5050806@am.sony.com> <20080604103353.GC27335@cs181133002.pp.htv.fi> <4846E44A.1010601@am.sony.com> <20080604194002.GF4189@cs181133002.pp.htv.fi>
In-Reply-To: <20080604194002.GF4189@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2008 23:48:42.0220 (UTC) FILETIME=[D9BE3AC0:01C8C82F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> I think the only serious numbers would come from taking some hardware 
> and feature set (file systems, network options, etc.), and then 
> optimizing by hand the smallest .config possible for both cases.
> 
> Do you have anything in this direction?
Not exactly.  I have some automated tests which measure the
compile-time and runtime memory affect of adjusting various kernel
options.  I do have, for 4 different architectures, a "smallest"
config that I've was hand-tuning for each arch.
Unfortunately, I started this some months ago and didn't
finish tuning these minimum configs.  They bitrotted, and now
none of them yeild bootable kernels for their respective boards.

I suppose I could dust this off and take another stab at it to
get some more results.

I wouldn't mind seeing min-configs for some boards in the main
source tree.

I think this has been discussed before, and one problem is
agreeing on what feature set to include in such configs.
At a minimum, it would be nice to have a few nice examples
of really, really small configs for things like qemus for different
architectures (just to give embedded developers who are working
on size a starting point).

> OK, that's a visible difference.
> 
> Are these 30 patches each gaining 4kB or are there a few patches that 
> bring most gain?
It's a spectrum.  One or two yield something over 20k, a few more
yield about 15k, then there's a long tail going down from about 8k
to very small savings (I should look at the size results more often,
some of these are not worth carrying around.  I've been just
maintaining the whole group as a set, and haven't looked at
the size effect of individual patches/options for a while.)

Oh, and if anyone is wondering why I started with a 7k one,
rather than something else with more "punch", it was a
relatively simple one (and it's option name started with
a letter near the beginning of the alphabet ;-)

> And are you only measuring the kernel image size or also theruntime 
> memory usage?
I also measure runtime, but my current test is not very good.
I do everything over an NFS-mount, and any network hiccups during boot
disturb the memory footprint.  I'm just using a simple "free"
over telnet, and comparing that vs. a baseline.

I suppose a simple "fix" would be to boot each test kernel several
times and discard outlying data points.

A few linux-tiny patches have little effect on kernel image size,
but a nice effect on runtime memory.  (e.g. There's one that changes
some mempool settings, that has only a 1k compile-time effect,
but a 12k runtime effect.)

I've been building up a table with real numbers, but I found
several problem areas with my test.  I'll try to get some numbers
out early next week.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

