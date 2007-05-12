Return-Path: <linux-kernel-owner+w=401wt.eu-S1761946AbXELAlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761946AbXELAlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 20:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758892AbXELAlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 20:41:04 -0400
Received: from mail.screens.ru ([213.234.233.54]:57252 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757793AbXELAlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 20:41:02 -0400
Date: Sat, 12 May 2007 04:40:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Message-ID: <20070512004057.GA540@tv-sign.ru>
References: <200705110035.32229.rjw@sisk.pl> <200705110036.26617.rjw@sisk.pl> <20070511123959.190adfaf.akpm@linux-foundation.org> <200705112240.54304.rjw@sisk.pl> <alpine.LFD.0.98.0705111555090.3986@woody.linux-foundation.org> <20070511232024.GA489@tv-sign.ru> <alpine.LFD.0.98.0705111629390.3986@woody.linux-foundation.org> <20070511234819.GA508@tv-sign.ru> <alpine.LFD.0.98.0705111656240.3986@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705111656240.3986@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Linus Torvalds wrote:
> 
> On Sat, 12 May 2007, Oleg Nesterov wrote:
> > 
> > things change, ->mm is not stable if the kernel thread does use_mm/unuse_mm.
> 
> ->mm is not stable *regardless*!
> 
> Trivial examples:
>  - kernel thread does execve()
>  - user thread does exit().

Yes sure. Quoting myself,
	>
	>  true->false means daemonize() or do_exit(), seems harmless.
	>
	>  false->true means exec from kernel space. That is why FREEZER_KERNEL_THREADS
	>  in fact means all tasks, not only kernel threads.
	>

> The use "use_mm()" and "unuse_mm()" things are total red herrings.
> 
> If the freezer depends on the difference between user and kernel threads, 
> then THAT PATCH IS BUGGY. It's that simple.

This is another story, I can't comment because I am not educated enough.

However, in my opininon THAT PATCH has nothing to do with this problem.
It just improves the code that we already have.

> > However, the return value == 0 does not change in that particular case,
> > exactly because is_user_space() takes task_lock().
> 
> As does exit_mm() etc.

Note the "in that particular case".

> See? The locking was pointless. Exactly because you release the lock 
> before the user can actually do anything about the return value!

Yes. See the "Quoting myself" above.

> Anyway, I think the whole freezer thing is broken. There's no reason to 
> freeze kernel threads. 

It is not perfect. Rafael tries to improve it.

Do we need freezer? Should we freeze kernel threads? I can't judge. I tried
to read a long thread about suspend, and failed to understand it.

I personally think we can simplify things if CPU-hotplug use freezer, at least.

Oleg.

