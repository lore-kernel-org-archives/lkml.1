Return-Path: <linux-kernel-owner+w=401wt.eu-S1761941AbXE2Rmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761941AbXE2Rmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbXE2Rmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:42:33 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751180AbXE2Rmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:42:32 -0400
Date: Tue, 29 May 2007 10:42:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel
 chipset
In-Reply-To: <465C5C16.7020001@rtr.ca>
Message-ID: <alpine.LFD.0.98.0705291030390.26602@woody.linux-foundation.org>
References: <465C566E.4030009@rtr.ca> <alpine.LFD.0.98.0705290945520.26602@woody.linux-foundation.org>
 <465C5C16.7020001@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 May 2007, Mark Lord wrote:
> 
> Ugh.  Is there a way to tell bisect to only work around the USB updates?

Well, you _can_ actually give "git bisect" a pathspec (the same way you 
git "git log" and friends), and tell it to only care about stuff that 
changed that pathspec.

However, that was broken in some older git versions, and in general hasn't 
had a huge amount of testing even in new ones, so I'm a tad nervous about 
recommending people do it. But yes, you should be able to say

	git bisect start drivers/usb/
	git bisect good v2.6.21
	git bisect bad v2.6.22-rc3

and off you go. However, if you do this, you need to make sure that you 
have at LEAST git-1.5.1.

The other downside of path limiting is that if it turns out that the bug 
was really introduced by something else, and just happened to _look_ like 
it's USB-related, the path limiting will then cause "git bisect" to blame 
a commit that just happens to be the next commit after the _real_ bug was 
introduced.

In this case, I don't think it's likely to be an issue, but it *could* 
obviously be something else.

(In contrast, the non-path-limited "git bisect" should work in pretty much 
any situation and with any git version)

> Still, that'll take a few hours, and frankly I'm getting sick of having
> to re-debug the USB layer with each new kernel rev.

Yeah, I'm not surprised. USB is probably the worst possible case for 
suspend/resume (at least if you ignore ACPI-related problems). It's nasty.

> Got a pointer to the "bisect how-to" ?

It's so disgustingly simple that I don't think we've ever done any 
specific bisection tutorial, but the "git-bisect" man-page does exist, and 
it talks about the only half-way interesting case, namely the case where 
the automatic selection of a half-way point causes git to pick a point 
that doesn't work for some other reason (ie stupid compile problem or 
whatever). In which case you have to pick another one manually.

So that kind of gotcha is at least _mentioned_ in the git-bisect man-page, 
even if it doesn't get much further than that.

There's also the git users manual, but I think the man-page is more 
detailed. But for future reference, just do

	git user manual

in google, and press "I'm feeling lucky". It finds the right thing at 
least for me (and at least right now).

			Linus
