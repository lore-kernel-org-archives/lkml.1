Return-Path: <linux-kernel-owner+w=401wt.eu-S1761870AbYFDSwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761870AbYFDSwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757490AbYFDSwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:52:43 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:63979 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbYFDSwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:52:41 -0400
X-BigFish: VPS-32(z34a4nz1432R98dR7efV1805Mzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4846E44A.1010601@am.sony.com>
Date: Wed, 4 Jun 2008 11:51:54 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <adrian.bunk@movial.fi>
CC: linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
 translation
References: <48447615.5050806@am.sony.com> <20080604103353.GC27335@cs181133002.pp.htv.fi>
In-Reply-To: <20080604103353.GC27335@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2008 18:52:18.0383 (UTC) FILETIME=[1CEC8DF0:01C8C674]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> It seems to be always me who asks the controversial questions...:
> 
> Does the linux-tiny approach of adding a kconfig variable for each 5kB 
> of code actually make sense? I'm asking since an exploding amount of 
> kconfig variables and their interdependencies have a not so small 
> maintainance impact in the long term.

Others have expressed similar concerns.  Andi Kleen has brought this
up in the past, and highlighted another aspect of this that I think
is important - fragmenting the configuration space for testing.

That is, if different combinations of options are used, then the
testing results from different users may not be directly comparable.
This makes it harder to track down bugs.

In practice, I think these types of switches tend to get turned
on/off together.  This tends to ameliorate the testing and maintenance
issues. It might be worthwhile to coalesce these into fewer
options.  I'd be fine with overloading this particular
onto CONFIG_BASE_FULL, but I don't know what other people think.
Keeping the option separate means you have more flexibility - so
that you can, for example, turn off all but one feature that's
important to you.  (This seems like a pretty common

> And I'm wondering whether it's the best approach for reaching 
> measurable results. E.g. my small patch that removed 
> -maccumulate-outgoing-args on 32-bit x86 reduced the kernel size
> there for the CONFIG_CC_OPTIMIZE_FOR_SIZE=y case by at about 2.5% (sic)
> without adding any kconfig variables or #ifdef's.

These are certainly nice, but there's a limited number of whole-kernel
reduction options.  Kernel size accumulates by both wasteful
compiler output, and by the introduction or preservation of individual
features that are useless for embedded devices.  I think it's worthwhile
to attack both problems.

> Can you take a reasonable (best-case) .config for an existing device and 
> get the following numbers:
> - Ignoring patches that came from linux-tiny, by how many percent did 
>   the size of the kernel increase or decrease between 2.6.16 and 2.6.26?

Well, an initial comparison is at:
http://www.selenic.com/bloatwatch/?cmd=compare&part=%2F&v1=2.6.16&v2=2.6.25-rc2

This shows a size difference of 1.8 meg, but I'm pretty sure this
is with a default config (not optimized) and is not controlled very well
for changes in the config.

I can do a more controlled comparison if you're interested.

> - By how many percent did the kernel size decrease due to patches from
>   the linux-tiny project that added such kconfig options for a few kB 
>   of code in the same timeframe?

I'm not sure that's a good comparison, since Linux-tiny hasn't been
very active in that time period.  I would guess only about 3 or 4
Linux-tiny patches have made it into the kernel since 2.6.16.
The big wins for Linux-tiny were in the 2.6.10/11 kernels, where
most of the low-hanging fruit (size-wise) was gleaned.

But to address your point, you're right that no existing Linux-tiny
patch gets 2.5% reduction for the kernel.
In my own testing at Sony, the 30 or so Linux-tiny patches that
I use get me about 110k of reductions.  For me, this is about 5% of
my kernel size.   Note that my choice of options to achieve
reductions is pretty conservative.

There are diminishing returns here, and at some point it doesn't make
sense to continue.  I have a nagging feeling, though, that there
are a few more things where the bloat is pronounced (glances at
procfs and sysfs).

> My gut feeling is that the influence of this kind of linux-tiny patches 
> is hardly noticably compared to the overall code size development, but 
> if you have numbers that prove me wrong just point me to them and I'll 
> stand corrected.

It *does* feel a bit like fighting the tide with a teaspoon.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

