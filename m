Return-Path: <linux-kernel-owner+w=401wt.eu-S964793AbXDAT2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793AbXDAT2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964801AbXDAT2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:28:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:45987 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S964793AbXDAT2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:28:54 -0400
X-Authenticated: #8376439
X-Provags-ID: V01U2FsdGVkX19UgHYfY/dU2FteeA5CiO5tdVYeOy6s9MCUgbNQ4X
	Np4DPgDyBwtKr0
To: linux-kernel@vger.kernel.org
Subject: Fwd: Re: WCHAN wrong for i386-kernel
From: "Gerhard Kurz" <gerhard.kurz@gmx.at>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.tp37gmkkckuthk@i386.10base2.at> <20070401183049.GA27614@elte.hu>
Content-Transfer-Encoding: 7bit
Date: Sun, 01 Apr 2007 21:28:41 +0200
Message-ID: <op.tp4dp3ltckuthk@i386.10base2.at>
In-Reply-To: <20070401183049.GA27614@elte.hu>
User-Agent: Opera Mail/9.10 (Linux)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



------- Forwarded message -------
From: "Ingo Molnar" <mingo@elte.hu>
To: "Gerhard Kurz" <gerhard.kurz@gmx.at>
Cc:
Subject: Re: WCHAN wrong for i386-kernel
Date: Sun, 01 Apr 2007 20:30:49 +0200


* Gerhard Kurz <gerhard.kurz@gmx.at> wrote:

> Hi,
>
> There is a minor bug in kernels for i386 (i found it in 2.6.14.2, but
> looking at the source code of 2.6.20, it should be there also).
>
> Symptom: For a task that sleeps e.g. in sys_nanosleep, the wchan value
> from get_wchan (in arch/i386/kernel/process.c) is wrong.
>
> Reason: To get the correct wchan value, all __sched functions must
> have a framepointer. Currently only the functions in kernel/sched.c
> are compiled with -fno-omit-frame-pointer. (see kernel/Makefile)
>
> But sys_nanosleep calls schedule_timeout_interruptible (in
> kernel/timer.c), which doesn't have a framepointer.

ah, indeed - nice find!

could you please report this to lkml too? It should be fixed, and by
sending it to lkml we make it sure that someone picks it up eventually,
if i dont get around fixing it in time.

	Ingo


