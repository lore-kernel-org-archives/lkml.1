Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbXEBMjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbXEBMjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbXEBMjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:39:35 -0400
Received: from haxent.com ([65.99.219.155]:1778 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116AbXEBMjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:39:35 -0400
Message-ID: <46388677.4050706@haxent.com.br>
Date: Wed, 02 May 2007 09:39:19 -0300
From: Davi Arnaut <davi@haxent.com.br>
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
References: <20070502052235.914764000@haxent.com.br>	 <20070502053427.123392000@haxent.com.br> <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>
In-Reply-To: <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On 5/1/07, Davi Arnaut <davi@haxent.com.br> wrote:
>> The pollable futex approach is far superior (send and receive events from
>> userspace or kernel) to eventfd and fixes (supercedes) FUTEX_FD at the same time.
>> [...]
> 

<snip>

> 
> - more complicated case: I have to wait for multiple futexes and lock
> them all at the same time or don't return at all.  This is possible with
> SysV semaphores and generally useful and needed.
> How can this be implemented with your scheme?

It's quite easy to implement this scheme by write()ing the futexes all
at once but that would break the one futex per fd association. For
atomicity: if one of the futexes can't be queued, we would rollback
(unqueue) the others.

Sounds sane?

--
Davi Arnaut
