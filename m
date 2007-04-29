Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbXD2QIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbXD2QIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 12:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbXD2QIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 12:08:19 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:39946 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412AbXD2QIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 12:08:18 -0400
Message-ID: <4634C2F0.8050101@free.fr>
Date: Sun, 29 Apr 2007 18:08:16 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070217 Iceape/1.1.1 (Debian-1.1.1-2)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Lee Revell <rlrevell@joe-job.com>, tglx@linutronix.de,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: High Resolution Timer DOS
References: <4633C269.9050806@free.fr> <1177798389.7646.320.camel@localhost.localdomain> <75b66ecd0704281537s54134967ybc3ddef0b87b6bf5@mail.gmail.com> <20070429071743.GA4532@elte.hu>
In-Reply-To: <20070429071743.GA4532@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------010809070107050100080302"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010809070107050100080302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> * Lee Revell <rlrevell@joe-job.com> wrote:
> 
>>> Well, it is not really a DoS. The rescheduling of the process is 
>>> limited by the scheduler and the available CPU time (depending on 
>>> the number of runnable tasks in the system).
>> Shouldn't an unprivileged process be rate limited somehow to avoid 
>> flooding the machine with interrupts?  We restrict nonroot users from 
>> setting the RTC interrupt rate higher than 64Hz for a similar reason 
>> (granted, this limit dates back to the 486 days and should probably be 
>> increased to 1024 Hz).
> 
> No. An interrupt in this case is really just 'CPU time used up', and an 
> unprivileged process can take up as much CPU time as the scheduler 
> allows. So it's _not_ a DoS, and neither is any other unprivileged 
> infinit loop (or high-rate context-switching task) a DoS.
Ok, may be DOS was not the correct term, but with the 2.6.21 hrt there 
is a great difference between an infinite loop and the high-rate 
context-switching task (you can try attached programs).
With the first I the system is still responsive, with the latter it 
isn't (new process take lot's of time to get created, other process are 
very slow).
If it is "just 'CPU time used up'", why I see a such difference between 
the 2 cases ?

Maybe the current scheduler failed to handle correctly this case ?


Matthieu

--------------010809070107050100080302
Content-Type: text/x-csrc;
 name="infinite_loop.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="infinite_loop.c"

#include <string.h>
#include <sys/time.h>
#include <time.h>

int main()
{
	struct timeval tv;
	while (1)
		gettimeofday(&tv, NULL);
}

--------------010809070107050100080302
Content-Type: text/x-csrc;
 name="small_sleep.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="small_sleep.c"

int main()
{
	while (1)
		usleep(1);
}

--------------010809070107050100080302--
