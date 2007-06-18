Return-Path: <linux-kernel-owner+w=401wt.eu-S1765366AbXFRSfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765366AbXFRSfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762597AbXFRSfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:35:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52912 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763061AbXFRSfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:35:38 -0400
Date: Mon, 18 Jun 2007 11:35:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Carlo Wood <carlo@alinoe.com>
cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
       y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
In-Reply-To: <20070618181225.GB8054@alinoe.com>
Message-ID: <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org>
References: <20070617182254.GA17595@alinoe.com> <20070617195805.GA6125@alinoe.com>
 <20070617214905.GA6207@alinoe.com> <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org>
 <20070618181225.GB8054@alinoe.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 Jun 2007, Carlo Wood wrote:
> 
> I suppose you mean: ... then you WILL get sensible values out of git
> bisect. But, since I already did a real "git bisect" without giving it
> random points, I am afraid you jumped conclusions.

Hey, fair enough.

That said, your "git bisect" really *does* act oddly.

> However, I can easily reproduce it. From my history file I can see that I started with:
> 
>    git bisect start
>    git bisect bad v2.6.22-rc5
>    git bisect good 99f9f3d49cbc7d944476f6fde53a77ec789ab2aa

Goodie. 

> I wrote everything down on paper (the git id's and whether they
> were good or bad), so I can reproduce it with:

I can follow along, but I get *totally*different* git bisection points!

> hikaru:/usr/src/kernel/git/linux-2.6>git bisect start
> hikaru:/usr/src/kernel/git/linux-2.6>git bisect bad v2.6.22-rc5
> hikaru:/usr/src/kernel/git/linux-2.6>git bisect good 99f9f3d49cbc7d944476f6fde53a77ec789ab2aa
> Bisecting: 128 revisions left to test after this
> D       include/asm-blackfin/macros.h
> M       scripts/package/Makefile
> D       scripts/package/builddeb

You seem to have a modified tree! What are those modifications to the 
blackfin macros.h etc files?

You *should* have gotten this:

	[torvalds@woody linux]$ git bisect start
	[torvalds@woody linux]$ git bisect bad v2.6.22-rc5
	[torvalds@woody linux]$ git bisect good 99f9f3d49cbc7d944476f6fde53a77ec789ab2aa
	Bisecting: 127 revisions left to test after this
	[9808901b6c63a1c850b072e624c228901a9eaf10] Blackfin serial driver: ignore framing and parity errors

but those are just off by one, at least (127 vs 128 commits left).

> [cf68676222e54cd0a31efd968da00e65f9a0963f] Blackfin serial driver: actually implement the break_ctl() function
> hikaru:/usr/src/kernel/git/linux-2.6>git bisect good
> Bisecting: 111 revisions left to test after this

And that's totally broken. Even if I don't use the "9808901b6" commit, and 
use your "cf686762" commit, I get:

	[torvalds@woody linux]$ git bisect good cf68676222e54cd0a31efd968da00e65f9a0963f
	Bisecting: 63 revisions left to test after this
	[aba297927d1d558c7a94548135133bdf9172708a] Merge master.kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6

Notice? The "127 revisions left to test after this" has become "63 
revisions left to test after this".

That number should be cut in half each time. And you shouldn't get some 
strange dirty tree indications.

It might be worth it just making sure your git is ok. It really is acting 
oddly. What version is it?

		Linus
