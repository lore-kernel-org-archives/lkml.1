Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbYFVCCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbYFVCCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 22:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYFVCC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 22:02:29 -0400
Received: from ruckus.brouhaha.com ([64.62.206.2]:57604 "EHLO
	ruckus.brouhaha.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYFVCC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 22:02:28 -0400
Message-ID: <36111.71.139.37.220.1214100148.squirrel@ruckus.brouhaha.com>
In-Reply-To: <e2e108260806210938k4ba12874t5f46e524ee188ab3@mail.gmail.com>
References: <40921.64.62.206.10.1214006079.squirrel@ruckus.brouhaha.com>
    <e2e108260806210938k4ba12874t5f46e524ee188ab3@mail.gmail.com>
Date: Sat, 21 Jun 2008 19:02:28 -0700 (PDT)
Subject: Re: Any lightweight way for one thread to force another thread to 
     suspend execution?
From: "Eric Smith" <eric@brouhaha.com>
To: linux-kernel@vger.kernel.org
Cc: "Bart Van Assche" <bart.vanassche@gmail.com>
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart wrote:
> Trying to suspend another thread synchronously is a bad idea because
> this can easily trigger deadlocks. E.g. if you suspend a thread while
> that thread holds a lock on a mutex, your application will deadlock.

I understand that and am willing to take responsibility for ensuring
that my application doesn't get into that situation.  Basically I'm
trying to port something that ran on a strict priority preemptive
kernel (on a single processor) to run on a Linux SMP system, so I
need a higher priority thread to completely preempt a lower priority
thread, even though the lower priority thread might be running on
another processor.

As far as I can tell, pthreads doesn't solve this problem, which is
unfortunately, since in other respects pthreads looks like it is
mostly suitable for use in porting code from other real-time kernels
to Linux.

It appears that some pthreads implementations add a nonstandard
pthread_suspend() that can do this.  What I'm looking for is a way
to efficiently implement pthrad_suspend() on Linux, ideally with
a minimum of system calls.

It seems to me that in principle, if the kernel provided a way to do
this, it should be able to suspend a thread that wasn't currently
executing merely by changing some of that thread's metadata, while
suspending a thread that is executing on another processor would be
more expensive since it would be necessary to force an interrupt
on that processor, etc.

Thanks,
Eric

