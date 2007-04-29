Return-Path: <linux-kernel-owner+w=401wt.eu-S1161383AbXD2VUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161383AbXD2VUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161395AbXD2VUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:20:36 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161383AbXD2VUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:20:06 -0400
Date: Sun, 29 Apr 2007 14:19:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Uwe Bugla <uwe.bugla@gmx.de>
cc: linux-dvb@linuxtv.org, mkruky@linuxtv.org, mchehab@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Critical points about kernel 2.6.21 and pseudo-authorities
In-Reply-To: <20070429205925.129920@gmx.net>
Message-ID: <alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org>
References: <20070429182209.267430@gmx.net>
 <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>
 <20070429205925.129920@gmx.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Apr 2007, Uwe Bugla wrote:
> 
> I have been trying diff and other tools in various variants (except 
> git-bisect that I cannot handle because I do not understand the practice 
> of it).

git bisect is _really_ simple if you already have a git tree anyway. And 
even if you don't, getting one isn't really hard either. Just do

	git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6

and you have a tree (it will take a little while - it's going to dowload 
about 170MB or so of stuff, so the initial clone is going to be a bit 
painful unless you have a fast internet connection).

Once you have the git tree, assuming that 2.6.21-rc7 worked for you, it's 
really as easy as just saying

	git bisect start
	git bisect good v2.6.21-rc7
	git bisect bad v2.6.21

and git will think for a short while (most of the time is going to be 
checking out the new tree) and give you a tree to test.

Just build, boot, and test that tree.

If it was fine, do

	git bisect good

and git will pick a new tree to test. And if it wasn't, instead just do 
"git bisect bad", and git will pick _another_ version to test. Do this a 
few times, and git will tell you which commit introduced them.

There were just 125 commits in between 2.6.21-rc7 and the final one, so it 
should be quite quick - bisection basically does a binary search, so doing 
seven reboots should have you with the result.

The fact that it already works in 2.6.21-git2 obviously means that _I_ end 
up being less interested, but the -stable tree people would love to hear 
what broke!

> I like small and effective kernels instead of blown up RAM waste.
> This is no Windoze, man, this is Linux!

Yes. But if you cannot be polite and *RESPECTFUL*, you won't get anywhere 
at all.

This is Linux, not Windows. But that also means that those developers that 
you denigrate aren't getting paid by you, and if you don't show them 
respect, they'll totally ignore you.

		Linus
