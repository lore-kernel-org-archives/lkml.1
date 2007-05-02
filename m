Return-Path: <linux-kernel-owner+w=401wt.eu-S1767042AbXEBSFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767042AbXEBSFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767044AbXEBSFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:05:55 -0400
Received: from haxent.com ([65.99.219.155]:4410 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767042AbXEBSFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:05:52 -0400
Message-ID: <4638D2FE.3060706@haxent.com.br>
Date: Wed, 02 May 2007 15:05:50 -0300
From: Davi Arnaut <davi@haxent.com.br>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
References: <20070502052235.914764000@haxent.com.br>	 <20070502053427.123392000@haxent.com.br>	 <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>	 <20070502095503.a06f5472.dada1@cosmosbay.com>	 <a36005b50705020108o6fb7495ak2383ae64e49c48a0@mail.gmail.com>	 <20070502104936.674a4b54.dada1@cosmosbay.com>	 <a36005b50705020939j491ced9ekf3f4203fc8b865a3@mail.gmail.com>	 <4638C37D.7050503@haxent.com.br>	 <a36005b50705021010l5c7badc6ub61228f14fdbb28a@mail.gmail.com>	 <4638CC6D.6080505@haxent.com.br> <a36005b50705021049k44881c5er1b9e61d64618ae1e@mail.gmail.com>
In-Reply-To: <a36005b50705021049k44881c5er1b9e61d64618ae1e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On 5/2/07, Davi Arnaut <davi@haxent.com.br> wrote:
>> NO! Every single waiter of the _file descriptor_ is waked, not of the 
>> futex.
>
> And how is this better?  In this world of yours a program must have
> one file descriptor for each single futex which is used like this *per
> thread*.  There can be hundreds, thousands of threads.  And there can
> be large numbers of futexes, too.
>

The usage cases of yours are quite different from mine. We don't use a
single file descriptor to to manage various resources. The worker threads
are _not going_ to have a file descriptor, _only_ the event dispatching 
(poll)
thread. The worker threads are just going to increase the futex value and
call FUTEX_WAKE in case the previous value was 0.

A pollable futex is even more useful for _single_ threaded programs that
don't want to go into lengthy hacks to monitor events coming from the 
outside
world.

I, at least, don't want to port my epoll applications to yet another event
notification facility.

> This is not going to fly.  You reach the file descriptor limit just
> with this.  And this in many processes on the system.
>
>
>> davi@karmic:~/git/linux-2.6$ find patches/ -name *.patch |grep -v
>> syscall | wc -l
>> 10
>>
>> davi@karmic:~/git/linux-2.6$ find patches/ -name *.patch |grep -v
>> syscall |grep futex
>> patches/pollfs-futex-async-wait.patch
>> patches/pollfs-futex.patch
>
> I don't know what  you want to show here.  You 10 new syscalls?  You
> have two patches alone modifying futexes?  And 22 patches in total.
> That's not "a lot"?

No. 12 patches are for i386/x86_64 obligatory syscall housekeeping. I don't
want to sound rude, but have you actually looked at the patches?

--
Davi Arnaut
