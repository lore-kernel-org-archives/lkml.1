Return-Path: <linux-kernel-owner+w=401wt.eu-S1031125AbXDQQNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031125AbXDQQNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031127AbXDQQNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:13:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:63785 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031125AbXDQQNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:13:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uAuk027Z0A7wSoiGu8X6+Vl7udp5SxQJhP8MQFRv6sWhSmFG/OQnm1COOOKAKGLdJ3aGAqbPqUTlr9+0OrQ6VyEIW7pj4MvQ2nUkIWGO/qhCwMwR3UwVGQR9eyTAhwAZoIxqpboIO7lAUOgdBc1Q2wh7nIMZ2pLm7YjEHxSGleo=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Date: Tue, 17 Apr 2007 12:12:55 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
References: <20070416220715.GA4071@elte.hu> <200704170053.58611.gene.heskett@gmail.com> <20070417061849.GA12385@elte.hu>
In-Reply-To: <20070417061849.GA12385@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704171212.55528.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2007, Ingo Molnar wrote:
>* Gene Heskett <gene.heskett@gmail.com> wrote:
>> This one (v2-rc2) is not a keeper I'm sorry to say, Ingo.  v2-rc0 was
>> much better.  Watching amanda run with htop, kmails composer is being
>> subjected to 5 to 10 second pauses, and htop says that gzip -best
>> isn't getting more that 15% of the cpu, and the /amandatapes drive is
>> being written to in a regular pattern that seems to be the cause of
>> the pauses according to gkrellm, which also seems to track the size of
>> the writes, and can show anything from 4.3k to 54 megs as being
>> written in one cycle of its screen update.
>
>ok - fortunately the delta between -v2-rc0 and -v2-final is pretty
>small. One difference is the child-runs-first fix. To restore the
>parent-runs-first logic, do this:
>
I'm running 21-rc7-CFS-v2-rc0.1 now.

>	echo 0 > /proc/sys/kernel/sched_child_runs_first

This is currently a 1.  Reset to 0 by the above.

>does this make any difference?

Hard to tell, not much running except fetchmail/procmail and this composer.

>
>If not then pretty much the only other change was the nice level tweak i
>did. Could you try to grab a few snapshots of scheduling state via
>something like:
>
>   while sleep 1; do cat /proc/sched_debug >> to-ingo.txt; done
The crf1.txt is with it=1, the cfr0.txt is with it zeroed.

>(and tell me the PID of the kmail composer, to make sure i'm checking
>the right task's behavior.)

And I let the crf0 version run longer as I was looking for the composer's pid, 
but htop (or I) can't see it.  Even a ps -e isn't seeing it!  But its 
running, I'm actively typing in it.  So you get 3 files, the third one called 
ps-e.txt, in private mail.  I thought it was called composer, I really did.

>
>also, as a separate experiment, could you perhaps run this script as
>root:
>
>   cd /proc; for N in [1-9]*; do renice -n 0 $N; done
>
>this will move all tasks in the system to nice level 0 and should make
>any nice level handling logic in the scheduler irrelevant. Do you have X
>reniced perhaps?
>
>Lots of system threads have negative or positive nice levels, so once
>you have executed this script, only a reboot will be a practical way to
>restore it to the previous settings.
>
>	Ingo



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I have many CHARTS and DIAGRAMS..
