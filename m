Return-Path: <linux-kernel-owner+w=401wt.eu-S1766783AbXEBQ7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766783AbXEBQ7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766774AbXEBQ7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:59:50 -0400
Received: from haxent.com ([65.99.219.155]:3693 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766785AbXEBQ7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:59:46 -0400
Message-ID: <4638C37D.7050503@haxent.com.br>
Date: Wed, 02 May 2007 13:59:41 -0300
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
References: <20070502052235.914764000@haxent.com.br>	 <20070502053427.123392000@haxent.com.br>	 <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>	 <20070502095503.a06f5472.dada1@cosmosbay.com>	 <a36005b50705020108o6fb7495ak2383ae64e49c48a0@mail.gmail.com>	 <20070502104936.674a4b54.dada1@cosmosbay.com> <a36005b50705020939j491ced9ekf3f4203fc8b865a3@mail.gmail.com>
In-Reply-To: <a36005b50705020939j491ced9ekf3f4203fc8b865a3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On 5/2/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
>> I understand your concerns, but *this* patch bundle extends 
>> poll()/select()/epoll, and is not an alternative to kevent or other 
>> work in progress, (and linux centered)
>
> It is adding huge amounts of complexity and at the same time is not
> future-safe.  I consider this enough reason to reject this approach.
Huge amounts of complexity? It just _moves_ some futex code around!
The intended use is not for locking, but for event signaling. Why can't
it be future-safe? It just needs a address and a value! Pseudocode:

thread A:
    int fd = plfutex(addr, 0);
    do
        poll(fdset+fd);
        process network events
        queue obj to thread B
        if fd:
            job processed

thread B:
    wait_job();
    process_job();
    raise_event(addr);
> You never can get rid of the interface.  It's much cleaner and safer
> to do it right instead of piling on more and more workarounds for
> special situations.
It simple as is, there is no need to overdesign.

--
Davi Arnaut
