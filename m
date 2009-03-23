Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbZCWU2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbZCWU2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbZCWU15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:27:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55831 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbZCWU14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:27:56 -0400
Date: Mon, 23 Mar 2009 16:25:03 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090323202503.GD18774@redhat.com>
References: <20090321014244.9ADF1FC3AB@magilla.sf.frob.com> <20090321074301.GA19384@elte.hu> <20090321013912.ed6039c9.akpm@linux-foundation.org> <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu> <20090321214852.GA5262@redhat.com> <20090322120811.GD19826@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090322120811.GD19826@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sun, Mar 22, 2009 at 01:08:11PM +0100, Ingo Molnar wrote:
> [...]
> > In my own limited kernel-building experience, I find the debuginfo 
> > data conveniently and instantly available after every "make".  Can 
> > you elaborate how is it harder for you to incidentally make it 
> > than for someone to download it?
> 
> Four reasons:
> 
> 1)
> 
> I have CONFIG_DEBUG_INFO turned off in 99.9% of my kernel builds, 
> because it slows down the kernel build times significantly: [...]

OK, 15% longer time.

> 2)
> 
> When the kernel build becomes IO-bound [...]
>   without:   870.36 user 292.79 system 3:32.10 elapsed  548% CPU
>   with:      929.65 user 384.55 system 8:28.70 elapsed  258% CPU

OK, lots of network traffic.
 
> 3) [...]
> Try to build 1.6 GB of dirty data on ext3 and run into an fsync() in 
> your editor ... you'll sit there twiddling thumbs for a minute or 
> more.

Now don't go blaming us for ext3 & fsync & not having a low enough
/proc/sys/vm/dirty_background_ratio.


> 4)
> Or yet another metric - Linux distro package overhead. Try 
> installing a debuginfo package: [...]

Same as 3).


> And this download has to be repeated for _every_ minor kernel 
> upgrade.

Actually, no.  If you just want to run the newly built kernel
somewhere else on your network, you can run a systemtap compile server
on your build machine, and let the systemtap network client do ~RPCs
to get at the data.


> The solution?)
> 
> Dunno - but i definitely think we should think bigger:
> 
> The fundamental disconnect i believe seems to come from the fact 
> that most user-space projects are relatively small, so debuginfo 
> bloat is a secondary issue there.

(Well, the fedora debuginfo archive shows a couple of packages of
similar or greater heft than the kernel - openoffice.org, qt3, ...)


> A few random ideas:
> 
> [...] why not build debuginfo on the fly, when a debugging 
> session requires it? Rarely do we need debuginfo for more than a 
> fraction of the whole kernel. [...]
> I mean, lets _use_ the fact that we have source code available, more 
> intelligently. It takes zero time to build detailed debuginfo for a 
> portion of a tree. [...]

Something like that might be made to work.

Note that this backs away from earlier claims that we can make do
without debuginfo, or that the compiler can't be trusted to build the
stuff.  We all agree it'd be nice if made it better and made a little
less.


- FChE
