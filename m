Return-Path: <linux-kernel-owner+w=401wt.eu-S1766807AbXEBRFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766807AbXEBRFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766808AbXEBRFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:05:55 -0400
Received: from haxent.com ([65.99.219.155]:1624 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766807AbXEBRFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:05:54 -0400
Message-ID: <4638C4EF.1030302@haxent.com.br>
Date: Wed, 02 May 2007 14:05:51 -0300
From: Davi Arnaut <davi@haxent.com.br>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
References: <20070502052235.914764000@haxent.com.br>	 <20070502053427.123392000@haxent.com.br>	 <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>	 <46388677.4050706@haxent.com.br> <a36005b50705020946x6cc1cb96r9ddd2b364ba168d7@mail.gmail.com>
In-Reply-To: <a36005b50705020946x6cc1cb96r9ddd2b364ba168d7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On 5/2/07, Davi Arnaut <davi@haxent.com.br> wrote:
>> It's quite easy to implement this scheme by write()ing the futexes all
>> at once but that would break the one futex per fd association. For
>> atomicity: if one of the futexes can't be queued, we would rollback
>> (unqueue) the others.
>>
>> Sounds sane?
>
> I don't know how you use "unqueue" in this context.  If a queued futex
> is one which is /locked/ by te call, then yes, this is the semantics
> needed.  Atomically locking a number of futexes means that if one of
> the set cannot be locked all operations done to lock the others have
> to be undone.  It's an all-or-nothing situation.
The waits are queued, thus then can be "unqueued". It's quite simple to
extend futex_wait_queue() to support this, but again you are thinking of
locks while what I want is fast events.
> Locking is not as easy as you might think, though.  For non-PI futexes
> there is deliberately no protocol in place describing what "locked"
> means.  The locking operation has to be customizable.  This is what
> the FUTEX_OP_* stuff is about.
Events are simple. A event is either signaled or not. A futex value 0 means
not signaled, 1+ signaled.
> And you wrote that currently each futex needs its own file descriptor.
> So this would have to be changed, too.
If it's really worth, I have no problem with it.

--
Davi Arnaut
