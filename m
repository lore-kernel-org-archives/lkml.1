Return-Path: <linux-kernel-owner+w=401wt.eu-S934812AbXLQK2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934812AbXLQK2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 05:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXLQK2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 05:28:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864AbXLQK2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 05:28:12 -0500
Date: Mon, 17 Dec 2007 02:27:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: Could not set non-blocking flag with 2.6.24-rc5
Message-Id: <20071217022748.89bc49f4.akpm@linux-foundation.org>
In-Reply-To: <200712140145.39791.rjw@sisk.pl>
References: <20071213201601.GA5831@dose.home.local>
	<200712140145.39791.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 01:45:39 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Thursday, 13 of December 2007, Tino Keitel wrote:
> > Hi folks,
> > 
> > I often build Debian packages inside a chroot. Today I discovered a
> > failure during an "aptitude update", which is a command to download new
> > package lists for the package management. In strace, the lines around
> > the failure look like this:
> > 
> > 99% [Working])         = 14 14
> > [pid  5986] select(6, [3 4 5], [], NULL, {0, 500000}) = 0 (Timeout)
> > [pid  5986] gettimeofday({1197576353, 670510}, NULL) = 0
> > [pid  5986] rt_sigprocmask(SIG_BLOCK, [WINCH], [], 8) = 0
> > [pid  5986] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
> > 99% [Working])         = 14 14
> > [pid  5986] select(6, [3 4 5], [], NULL, {0, 500000}) = 0 (Timeout)
> > [pid  5986] gettimeofday({1197576354, 173902}, NULL) = 0
> > [pid  5986] rt_sigprocmask(SIG_BLOCK, [WINCH], [], 8) = 0
> > [pid  5986] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
> > 99% [Working])         = 14 14
> > [pid  5986] select(6, [3 4 5], [], NULL, {0, 500000} <unfinished ...>
> > [pid  5988] <... select resumed> )      = 1 (in [3], left {105, 0})
> > [pid  5988] read(3, "", 56559)          = 0
> > [pid  5988] fcntl64(-1, F_GETFL)        = -1 EBADF (Bad file
> > descriptor)
> > [pid  5988] fcntl64(-1, F_SETFL,
> > O_ACCMODE|O_CREAT|O_EXCL|O_NOCTTY|O_TRUNC|O_APPEND|O_SYNC|O_ASYNC|O_DIRECT|O_LARGEFILE|O_DIRECTORY|O_NOFOLLOW|O_NOATIME|0xfff8003c)
> > = -1 EBADF (Bad file descriptor)
> > [pid  5988] write(2, ""..., 41FATAL -> Could not set non-blocking flag
> > )         = 41
> > [pid  5988] write(2, ""..., 19Bad file descriptor)         = 19
> > [pid  5988] write(2, ""..., 1
> > )          = 1
> > [pid  5988] exit_group(100)             = ?
> > Process 5988 detached
> > 
> > This happened with a kernel after 2.6.24-rc5
> > (4af75653031c6d454b4ace47c1536f0d2e727e3e). I rebooted into 2.6.23.8
> > and it worked. Now I rebooted into 2.6.24-rc5 again and was able to
> > reproduce the failure, so it looks like a kernel issue to me.
> 
> Yes, it does.
> 
> I'm not sure who to forward it to, though.  Andrew, can you help, please?

hm, I missed this email, sorry.

That application is passing an fd of -1 into the kernel's fcntl64().  Could
be an application bug, could be a kernel change which triggered an
application bug, could be a kernel bug.

Can we see more of the strace output please?  Let's see if we can find
where the application got that -1 from.

