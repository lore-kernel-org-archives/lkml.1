Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbXLOCyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbXLOCyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 21:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbXLOCyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 21:54:11 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:47055 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbXLOCyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 21:54:10 -0500
Date: Fri, 14 Dec 2007 20:52:07 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Could not set non-blocking flag with 2.6.24-rc5
In-reply-to: <fa.2D6HRLjr6ibJZfUZ3+G8Q2ex4ig@ifi.uio.no>
To: tino.keitel@gmx.de
Cc: linux-kernel@vger.kernel.org
Message-id: <47634157.7080004@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.2D6HRLjr6ibJZfUZ3+G8Q2ex4ig@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tino Keitel wrote:
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

With this part of strace output it seems like an obvious userspace bug 
(calling fcntl on a -1 file descriptor). Could be some other change in 
behavior or timing difference is triggering the bug,however.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

