Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbYDKXN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbYDKXN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 19:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbYDKXNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 19:13:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756905AbYDKXNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 19:13:18 -0400
Date: Fri, 11 Apr 2008 16:12:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bongani Hlope <bonganilinux@mweb.co.za>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Shutdown and Reboot Regression 2.6.25-rc[78]
In-Reply-To: <200804112342.48830.bonganilinux@mweb.co.za>
Message-ID: <alpine.LFD.1.00.0804111605390.3143@woody.linux-foundation.org>
References: <200804112241.44626.bonganilinux@mweb.co.za> <alpine.LFD.1.00.0804111352390.3143@woody.linux-foundation.org> <200804112342.48830.bonganilinux@mweb.co.za>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Apr 2008, Bongani Hlope wrote:
> 
> After about 4 restarts and 4 reboots, 2.6.25-rc9 seems to work fine with and 
> without the revert. I'll do some more testing.  The assembly output files for 
> kernel/printk.c don't seem that different between rc9 and rc7. I'll see what 
> else I can test.

Ok, I suspect it may be timing-dependent and slightly random.

Sadly, that is absolutely the case where "git bisect" works the worst. The 
end result of bisection will basically be _totally_ random if even one of 
the "git bisect bad/good" choises were wrong - doing a binary search is 
a very efficient way to find the buggy commit, but it also means that a 
single wrong turn will efficiently find a commit that is somewhere totally 
different.

So if your shutdown/reboot regression is even slightly non-deterministic, 
it makes "git bisect" rather less powerful (you can still do bisection, 
but you just need to be extra careful and probably try multiple shutdowns 
with a suspect kernel just to be absolutely sure you mark a kernel good 
only if you're *really* sure it's good. Marking a kernel bad is much 
safer, since you'd presumably only do that when you have actually seen the 
bug in action)..

Of course, even when you're really really careful, if it really is 
timing-dependent, the bug may show up with a unrelated commit just because 
it changes timing. Those kinds of bugs tend to be fairly rare, but they do 
occasionally happen.

		Linus
