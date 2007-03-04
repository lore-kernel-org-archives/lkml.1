Return-Path: <linux-kernel-owner+w=401wt.eu-S932080AbXCDBKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbXCDBKV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 20:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096AbXCDBKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 20:10:21 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51002 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080AbXCDBKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 20:10:19 -0500
Date: Sat, 3 Mar 2007 17:10:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric St-Laurent <ericstl34@sympatico.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070303171016.f0fe422c.akpm@linux-foundation.org>
In-Reply-To: <1172967299.8493.34.camel@perkele>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<1172967299.8493.34.camel@perkele>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 19:14:59 -0500 Eric St-Laurent <ericstl34@sympatico.ca> wrote:

> On Sat, 2007-03-03 at 12:29 -0800, Andrew Morton wrote:
> 
> 
> > There is much more which could be done to make this code smarter, but I
> > think the lesson here is that we can produce a far, far better result doing
> > this work in userspace than we could ever hope to do with an in-kernel
> > implementation.  There are some enhancement suggestions in the
> > documentation file.
> 
> While I think that more user space applications should use fadvise() to
> avoid polluting the page cache with unneeded data, I still think the
> kernel should be more fair in regard to page cache management.
> 
> Personally, I've experienced some sluggish performance after copying
> large files around. Even more when using NFS. It's difficult to file a
> bug report for "interactive feel", I don't know how to measure it. I
> just feel it's a weak aspect of the OS.

yeah.  It'd be worth spending some time, try to come up with some set of
commands which produce an effect which you find objectionable.

> Surely it's possible to make the kernel a little bit better to protect
> the page cache from abuse, from simple or badly designed applications.
> 
> Why fairness is provided by the process scheduler with good results, yet
> it somewhat easy for a process to cause slowdowns from page cache usage.
> 
> My personal opinion is that the VM seem tuned for database types
> workloads.

VM hasn't actually been tuned *for* anything much at all, really.  Looking
back on it, much of the tweaking in there has been to avoid really bad
situations.  We put much work into avoiding the 100%, 1000% or 10000%
slowdowns, but not a lot of work into providing the 15% speedups.

So it may well be that the result is not particularly great at anything,
but it's also not horridly bad at anything, either.  Or at least, it's not
supposed to be.

> Of course, making the page cache more fair to prevent one
> process to use most of it will most likely slowdown database type
> applications.

databases actually like to manage their own cache via various means.  There
are some situations in which bulk IO activities can trash the databases's
cache.  That's the sort of thing which this tool is trying to help address.

> Maybe the situation should be reversed, much like the process scheduler.
> Fairness by default, and the possibility to request for more system
> resources by asking for them with necessary privileges. Much like
> SCHED_FIFO policy.

Well.  If the CPU scheduler makes a mistake, we see 5% or 15% degredations.
 If VM make a mistake (or fails to read the operator's mind), we go to disk
and can suffer 1000% degredations or worse.

