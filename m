Return-Path: <linux-kernel-owner+w=401wt.eu-S1753014AbZJBVRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbZJBVRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZJBVRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:17:15 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:38929 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbZJBVRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:17:14 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] procfs: provide stack information for threads
References: <1238511505.364.61.camel@matrix> <20090401193135.GA12316@elte.hu>
	<1244146873.20012.6.camel@wall-e>
X-Yow: I'm having a MID-WEEK CRISIS!
Date: Fri, 02 Oct 2009 23:17:14 +0200
In-Reply-To: <1244146873.20012.6.camel@wall-e> (Stefani Seibold's message of
	"Thu, 04 Jun 2009 22:21:13 +0200")
Message-ID: <m2eipl7axx.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold <stefani@seibold.net> writes:

> This is the newest version of the formaly named "detailed stack info"
> patch which give you a better overview of the userland application stack
> usage, especially for embedded linux.
>
> Currently you are only able to dump the main process/thread stack usage
> which is showed in /proc/pid/status by the "VmStk" Value. But you get no
> information about the consumed stack memory of the the threads.
>
> There is an enhancement in the /proc/<pid>/{task/*,}/*maps and which
> marks the vm mapping where the thread stack pointer reside with "[thread
> stack xxxxxxxx]". xxxxxxxx is the start address of the stack.
>
> Also there is a new entry "stack usage" in /proc/<pid>/{task/*,}/status
> which will you give the current stack usage in kb.
>
> I also fixed stack base address in /proc/<pid>/task/*/stat to the base
> address of the associated thread stack and not the one of the main
> process. This makes more sense.

That does not work right.  I sometimes get meaningless values printed
for the stack usage in /proc/*/status (like 18014398509480456 kB), and
the stack start in /proc/*/stat is wrong.  Apparently task->stack_start
contains the stack start of the _parent_ process.

$ awk '{printf "%x\n", $28}' /proc/self/stat; grep stack /proc/self/maps /proc/$$/maps
ffd34990
/proc/self/maps:ffa9c000-ffab1000 rw-p 00000000 00:00 0                                  [stack]
/proc/4054/maps:ffd22000-ffd37000 rw-p 00000000 00:00 0                                  [stack]

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
