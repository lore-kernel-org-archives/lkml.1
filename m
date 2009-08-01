Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbZHAHy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbZHAHy0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 03:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZHAHyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 03:54:25 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:37317 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZHAHyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 03:54:25 -0400
Message-ID: <4A73F44E.1010508@gmail.com>
Date: Sat, 01 Aug 2009 09:52:46 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, drepper@redhat.com, jens@mcbone.net,
       mingo@elte.hu, peterz@infradead.org, sonnyrao@us.ibm.com,
       stable@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH v2] execve: must clear current->clear_child_tid
References: <200907312142.n6VLgKfx021454@imap1.linux-foundation.org> <20090731222959.GA8195@redhat.com> <alpine.LFD.2.01.0907311732250.3304@localhost.localdomain> <20090731175101.1699d653.akpm@linux-foundation.org> <20090801015434.GA755@redhat.com> <4A73DCBE.7080309@gmail.com> <20090801064438.GA30800@redhat.com>
In-Reply-To: <20090801064438.GA30800@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 01 Aug 2009 09:52:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov a écrit :
> On 08/01, Eric Dumazet wrote:
>> I only wonder about core dumping, since mm_release() is also used by exiting tasks.
>>
>> Isnt clear_child_tid used by gdb or other debugger ?
> 
> Afaics it is not...
> 
> At least, I can't see how gdb (or any other user-space app) can figure
> out the value of ->clear_child_tid.
> 

Yep, this was from old Unixes time, when core file included the 'u' structure ...

Dont worry ;)


> 
> 
> Not that this really matters, but please note also that it is possible
> that the coredumping task has ->clear_child_tid == NULL anyway, even
> without this change. The PF_SIGNALED check in mm_release() is not 100&
> reliable.
> 
> Suppose a thread T sleeps in do_exit()->ptrace_event(PT_TRACE_EXIT) path.
> Another thread starts a coredump and kills T via zap_process(). This wakes
> up T, it calls exit_mm()->mm_release() without PF_SIGNALED.
> 
> Oleg.
> 

