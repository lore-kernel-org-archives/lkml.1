Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbYBJKFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbYBJKFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 05:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYBJKFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 05:05:33 -0500
Received: from www.tglx.de ([62.245.132.106]:55989 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbYBJKFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 05:05:31 -0500
Date: Sun, 10 Feb 2008 11:03:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [git pull] hrtimer/ntp bugfixes
Message-ID: <alpine.LFD.1.00.0802101037470.12988@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull hrtimer and ntp bugfixes from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git master

Following problems are addressed by these patches:

  - ntp: fix incorrect drift compensation 

  - hrtimer: fix a stupid restart handling thinko, which keeps a
    	     stale pointer in the restart block.

Thanks,
	tglx

----

John Stultz (1):
      ntp: correct inconsistent interval/tick_length usage

Oleg Nesterov (3):
      hrtimer: fix *rmtp handling in hrtimer_nanosleep()
      hrtimer: fix *rmtp/restarts handling in compat_sys_nanosleep()
      hrtimer: don't modify restart_block->fn in restart functions

 include/linux/hrtimer.h |    2 +-
 include/linux/timex.h   |    9 ++++++-
 kernel/compat.c         |   43 +++++++++++++++++++++++++++++++++---
 kernel/hrtimer.c        |   55 +++++++++++++++++++++++------------------------
 kernel/posix-timers.c   |   17 ++------------
 kernel/time/ntp.c       |    4 ---
 6 files changed, 78 insertions(+), 52 deletions(-)
