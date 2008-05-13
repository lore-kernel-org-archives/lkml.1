Return-Path: <linux-kernel-owner+w=401wt.eu-S1761714AbYEMVIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761714AbYEMVIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbYEMVIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:08:32 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:53104 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758459AbYEMVIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:08:31 -0400
To: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH 0/1] MAZE: Mazed processes monitor
From: Andi Kleen <andi@firstfloor.org>
References: <48297FD0.2090905@miraclelinux.com>
Date: Tue, 13 May 2008 23:07:52 +0200
In-Reply-To: <48297FD0.2090905@miraclelinux.com> (Hirofumi Nakagawa's message of "Tue, 13 May 2008 20:47:28 +0900")
Message-ID: <87y76d7w0n.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 May 2008 21:00:52.0542 (UTC) FILETIME=[6DD54DE0:01C8B53C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hirofumi Nakagawa <hnakagawa@miraclelinux.com> writes:

> This patch provides the mazed process monitor,named MAZE.
> MAZE's purpose is to notify or terminate registered processes when they are mazed.
> The definition of mazed process is a process using excessive CPU cycles,
> that is long time keeping TASK_RUNNING state.

Isn't that very similar to RLIMIT_CPU? The main difference seems to be 
that they're regularly reset and that they can be more fine grained 
than seconds.

How about you implement a way to change the RLIMIT_CPU limit
of a running task (and possibly fix it to use a finer grained unit
if you need <1s resolution).

Then you could run a user space daemon running with lower priority that 
just regularly resets the RLIMIT_CPUs of all running processes.

If some RT process uses so much time that the user daemon cannot
keep up its cpu time limit will be eventually exceeded and it will
be killed.

I think that would be a far cleaner and generic way to implement
this.

-Andi
