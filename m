Return-Path: <linux-kernel-owner+w=401wt.eu-S934501AbXLNA1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501AbXLNA1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763907AbXLNA0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:26:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36807 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763787AbXLNA0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:26:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: Could not set non-blocking flag with 2.6.24-rc5
Date: Fri, 14 Dec 2007 01:45:39 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20071213201601.GA5831@dose.home.local>
In-Reply-To: <20071213201601.GA5831@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712140145.39791.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 13 of December 2007, Tino Keitel wrote:
> Hi folks,
> 
> I often build Debian packages inside a chroot. Today I discovered a
> failure during an "aptitude update", which is a command to download new
> package lists for the package management. In strace, the lines around
> the failure look like this:
> 
> 99% [Working])         = 14 14
> [pid  5986] select(6, [3 4 5], [], NULL, {0, 500000}) = 0 (Timeout)
> [pid  5986] gettimeofday({1197576353, 670510}, NULL) = 0
> [pid  5986] rt_sigprocmask(SIG_BLOCK, [WINCH], [], 8) = 0
> [pid  5986] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
> 99% [Working])         = 14 14
> [pid  5986] select(6, [3 4 5], [], NULL, {0, 500000}) = 0 (Timeout)
> [pid  5986] gettimeofday({1197576354, 173902}, NULL) = 0
> [pid  5986] rt_sigprocmask(SIG_BLOCK, [WINCH], [], 8) = 0
> [pid  5986] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
> 99% [Working])         = 14 14
> [pid  5986] select(6, [3 4 5], [], NULL, {0, 500000} <unfinished ...>
> [pid  5988] <... select resumed> )      = 1 (in [3], left {105, 0})
> [pid  5988] read(3, "", 56559)          = 0
> [pid  5988] fcntl64(-1, F_GETFL)        = -1 EBADF (Bad file
> descriptor)
> [pid  5988] fcntl64(-1, F_SETFL,
> O_ACCMODE|O_CREAT|O_EXCL|O_NOCTTY|O_TRUNC|O_APPEND|O_SYNC|O_ASYNC|O_DIRECT|O_LARGEFILE|O_DIRECTORY|O_NOFOLLOW|O_NOATIME|0xfff8003c)
> = -1 EBADF (Bad file descriptor)
> [pid  5988] write(2, ""..., 41FATAL -> Could not set non-blocking flag
> )         = 41
> [pid  5988] write(2, ""..., 19Bad file descriptor)         = 19
> [pid  5988] write(2, ""..., 1
> )          = 1
> [pid  5988] exit_group(100)             = ?
> Process 5988 detached
> 
> This happened with a kernel after 2.6.24-rc5
> (4af75653031c6d454b4ace47c1536f0d2e727e3e). I rebooted into 2.6.23.8
> and it worked. Now I rebooted into 2.6.24-rc5 again and was able to
> reproduce the failure, so it looks like a kernel issue to me.

Yes, it does.

I'm not sure who to forward it to, though.  Andrew, can you help, please?
