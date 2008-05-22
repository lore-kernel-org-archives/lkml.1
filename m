Return-Path: <linux-kernel-owner+w=401wt.eu-S934856AbYEVJhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934856AbYEVJhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 05:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936307AbYEVJgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 05:36:54 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:37637 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936285AbYEVJgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 05:36:51 -0400
Message-ID: <48353D6D.8010603@miraclelinux.com>
Date: Thu, 22 May 2008 18:31:25 +0900
From: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH 0/1] MAZE: Mazed processes monitor
References: <48297FD0.2090905@miraclelinux.com> <87y76d7w0n.fsf@basil.nowhere.org>
In-Reply-To: <87y76d7w0n.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2008.5.22.21216
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Thank you for your comment and proposal.

> How about you implement a way to change the RLIMIT_CPU limit
> of a running task (and possibly fix it to use a finer grained unit
> if you need <1s resolution).
>
> Then you could run a user space daemon running with lower priority that just regularly resets the RLIMIT_CPUs of all running processes.
>
> If some RT process uses so much time that the user daemon cannot
> keep up its cpu time limit will be eventually exceeded and it will
> be killed.
>
> I think that would be a far cleaner and generic way to implement
> this.
>
> -Andi

I also watch normal processes, which run into infinite loop but
cleanly scheduled out by sched when a time slice expires.
In this case, your deamon still can reset the counter.

> Isn't that very similar to RLIMIT_CPU? The main difference seems to be
> that they're regularly reset and that they can be more fine grained
> than seconds.

The differences with MAZE and rlimit are as follows.
  - MAZE detects excessive CPU cycle usage, but rlimits limits total amount
    of CPU usage.
    MAZE can safely handle CPU intensive but correctly running processes.

  - User processes can add watched processes in MAZE.

  - MAZE allows users to choose a way how to act on the process,
    selecting which signal to send.

Following example shows the differences of features MZE and rlimit

----
void foo(void)
{
     for(;;);
}
----
This code receives a signal shortly,
if registered under either rlimit or MAZE.

----
void foo(void)
{
     for(;;) {
         sleep(1);
     }
}
----
This code receives a signal in case of rlimit.
But, it doesn't receive a signal under MAZE.
There are cases when you need to distinguish these two types.

Thanks.
Hirofumi Nakagawa


