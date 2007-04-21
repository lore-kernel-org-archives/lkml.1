Return-Path: <linux-kernel-owner+w=401wt.eu-S1751752AbXDUS41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbXDUS41 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 14:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXDUS41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 14:56:27 -0400
Received: from smtpout.mac.com ([17.250.248.171]:64748 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbXDUS40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 14:56:26 -0400
In-Reply-To: <20070421164241.GF2986@holomorphy.com>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <20070421154614.GA26169@elte.hu> <20070421161818.GC7840@1wt.eu> <alpine.LFD.0.98.0704210931370.9964@woody.linux-foundation.org> <20070421164241.GF2986@holomorphy.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <E1192E83-5E64-4782-8F92-DDCA09CA2F55@mac.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Sat, 21 Apr 2007 14:55:51 -0400
To: William Lee Irwin III <wli@holomorphy.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 21, 2007, at 12:42:41, William Lee Irwin III wrote:
> On Sat, 21 Apr 2007, Willy Tarreau wrote:
>>> If you remember, with 50/50, I noticed some difficulties to fork  
>>> many processes. I think that during a fork(), the parent has a  
>>> higher probability of forking other processes than the child. So  
>>> at least, we should use something like 67/33 or 75/25 for parent/ 
>>> child.
>
> On Sat, Apr 21, 2007 at 09:34:07AM -0700, Linus Torvalds wrote:
>> It would be even better to simply have the rule:
>>  - child gets almost no points at startup
>>  - but when a parent does a "waitpid()" call and blocks, it will  
>> spread  out its points to the childred (the "vfork()" blocking is  
>> another case that is really the same).
>> This is a very special kind of "priority inversion" logic: you  
>> give higher priority to the things you wait for. Not because of  
>> holding any locks, but simply because a blockign waitpid really is  
>> a damn big hint that "ok, the child now works for the parent".
>
> An in-kernel scheduler API might help. void yield_to(struct  
> task_struct *)?
>
> A userspace API might be nice, too. e.g. int sched_yield_to(pid_t).

It might be nice if it was possible to actively contribute your CPU  
time to a child process.  For example:
int sched_donate(pid_t pid, struct timeval *time, int percentage);

Maybe a way to pass CPU time over a UNIX socket (analogous to  
SCM_RIGHTS), along with information on what process/user passed it   
That would make it possible to really fix X properly on a local  
system.  You could make the X client library pass CPU time to the X  
server whenever it requests a CPU-intensive rendering operation.   
Ordinarily X would nice all of its client service threads to +10, but  
when a client passes CPU time to its thread over the socket, then its  
service thread temporarily gets the scheduling properties of the  
client.  I'm not a scheduler guru, but that's what makes the most  
sense from an application-programmer point of view.

Cheers,
Kyle Moffett

