Return-Path: <linux-kernel-owner+w=401wt.eu-S1763283AbXLMUQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763283AbXLMUQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbXLMUQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:16:05 -0500
Received: from eazy.amigager.de ([213.239.192.238]:57378 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331AbXLMUQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:16:04 -0500
Date: Thu, 13 Dec 2007 21:16:01 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Could not set non-blocking flag with 2.6.24-rc5
Message-ID: <20071213201601.GA5831@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I often build Debian packages inside a chroot. Today I discovered a
failure during an "aptitude update", which is a command to download new
package lists for the package management. In strace, the lines around
the failure look like this:

99% [Working])         = 14 14
[pid  5986] select(6, [3 4 5], [], NULL, {0, 500000}) = 0 (Timeout)
[pid  5986] gettimeofday({1197576353, 670510}, NULL) = 0
[pid  5986] rt_sigprocmask(SIG_BLOCK, [WINCH], [], 8) = 0
[pid  5986] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
99% [Working])         = 14 14
[pid  5986] select(6, [3 4 5], [], NULL, {0, 500000}) = 0 (Timeout)
[pid  5986] gettimeofday({1197576354, 173902}, NULL) = 0
[pid  5986] rt_sigprocmask(SIG_BLOCK, [WINCH], [], 8) = 0
[pid  5986] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
99% [Working])         = 14 14
[pid  5986] select(6, [3 4 5], [], NULL, {0, 500000} <unfinished ...>
[pid  5988] <... select resumed> )      = 1 (in [3], left {105, 0})
[pid  5988] read(3, "", 56559)          = 0
[pid  5988] fcntl64(-1, F_GETFL)        = -1 EBADF (Bad file
descriptor)
[pid  5988] fcntl64(-1, F_SETFL,
O_ACCMODE|O_CREAT|O_EXCL|O_NOCTTY|O_TRUNC|O_APPEND|O_SYNC|O_ASYNC|O_DIRECT|O_LARGEFILE|O_DIRECTORY|O_NOFOLLOW|O_NOATIME|0xfff8003c)
= -1 EBADF (Bad file descriptor)
[pid  5988] write(2, ""..., 41FATAL -> Could not set non-blocking flag
)         = 41
[pid  5988] write(2, ""..., 19Bad file descriptor)         = 19
[pid  5988] write(2, ""..., 1
)          = 1
[pid  5988] exit_group(100)             = ?
Process 5988 detached

This happened with a kernel after 2.6.24-rc5
(4af75653031c6d454b4ace47c1536f0d2e727e3e). I rebooted into 2.6.23.8
and it worked. Now I rebooted into 2.6.24-rc5 again and was able to
reproduce the failure, so it looks like a kernel issue to me.

Regards,
Tino
