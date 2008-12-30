Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbYL3CRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbYL3CRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 21:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYL3CRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 21:17:38 -0500
Received: from iabervon.org ([66.92.72.58]:41778 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbYL3CRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 21:17:36 -0500
Date: Mon, 29 Dec 2008 21:17:35 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Igor Podlesny <for.poige+linux@gmail.com>
cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: > I even didn't have a backtrace.
In-Reply-To: <43d009740812282303r2015e6beyc2dae4c26d6aa686@mail.gmail.com>
Message-ID: <alpine.LNX.1.00.0812292044510.19665@iabervon.org>
References: <43d009740812282303r2015e6beyc2dae4c26d6aa686@mail.gmail.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008, Igor Podlesny wrote:

> 2008/12/29 Igor Podlesny <for.poige+linux@gmail.com>:
> > 2008/12/29 Willy Tarreau <w@1wt.eu>:
> >> On Mon, Dec 29, 2008 at 12:39:55PM +0700, Igor Podlesny wrote:
> > [...]
> >> Well, I won't say that I find them 100% rock solid, but you seem to be
> >> able to reproduce a lot of serious issues. Have you filed bug reports
> >> to get them fixed ? You cannot expect people to fix bugs they're not
> >> aware of !
> >
> >        I even didn't have a backtrace. What's to fill in? "It just crashed 2
> > times, Dear Bugzilla"? :-)
> >
> 	BTW, I wonder -- can the kernel store crash related information (if
> any) in RAM, at certain addresses, so it can survive warm reboot and
> get displayed "in dmesg" on the next boot?

Usually, you get one of:

 - some bus is locked, and the CPU can't get kernel code from RAM, let 
   alone write anything anywhere
 - triple fault, and the system spontaneously reboots
 - system is unaware that anything's wrong, but nothing runs
 - any attempt to get data useful for debugging hangs
 - system is alive enough that you can interact with it and get info

That doesn't leave a big possibility for the kernel to determine that the 
system has crashed and put something in memory for a warm reboot to find. 
There isn't really any case where the kernel reboots intentionally in a 
context where it thinks the system is crashing but has the ability to do 
lots of information gathering.

About the only common reasons for the kernel to panic these days are a 
missing filesystem or hardware driver, such that it can't find a root 
partition or init, and these really ought to allow the user to debug 
interactively (at least scroll up and look at messages) unless the system 
is configured to reboot.

On your original question: your .config and boot dmesg, and anything 
similar about the situations (like, "both times I was running hwclock" or 
"I was copying big files over XFS..."). If you can trigger it reliably or 
at least repeatably, that's at least as good as a backtrace.

You might post the oopses from your kernel logs, too. Also, 
failing-to-suspend tends to leave useful messages in dmesg and not be too 
hard to explain (at least as compared to failing to resume), and there's 
been a push for getting all drivers to support suspending, even ones for 
desktop hardware, so that can probably be fixed (of course, relatively few 
people actually try suspending desktops, so it's easier for bugs to go 
unnoticed there).

	-Daniel
*This .sig left intentionally blank*
