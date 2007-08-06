Return-Path: <linux-kernel-owner+w=401wt.eu-S1765702AbXHFRyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765702AbXHFRyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758562AbXHFRx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:53:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51647 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758215AbXHFRx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:53:58 -0400
Message-ID: <46B72C58.5030502@redhat.com>
Date: Mon, 06 Aug 2007 10:12:40 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jerry Jiang <wjiang@resilience.com>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain> <20070806123551.a6c3c154.wjiang@resilience.com>
In-Reply-To: <20070806123551.a6c3c154.wjiang@resilience.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jerry Jiang wrote:
> Is there some feedback on this point ?
> 
> Thank you
> ./Jerry
> 
> On Sun, 1 Jul 2007 08:49:37 -0400 (EDT)
> "Robert P. J. Day" <rpjday@mindspring.com> wrote:
> 
>>   prompted by the earlier post on "volatile"s, is there a reason that
>> most atomic_t typedefs use volatile int's, while the rest don't?
>>
>> $ grep "typedef.*struct"  $(find . -name atomic.h)
>> ./include/asm-v850/atomic.h:typedef struct { int counter; } atomic_t;
>> ./include/asm-mips/atomic.h:typedef struct { volatile int counter; } atomic_t;
>> ./include/asm-mips/atomic.h:typedef struct { volatile long counter; } atomic64_t;
>> ...
>>
>>   etc, etc.  just curious.

If your architecture doesn't support SMP, the volatile keyword doesn't do 
anything except add a useless memory fetch.  Also, some SMP architectures (i386, 
x86_64, s390) provide sufficiently strong guarantees about memory access 
ordering that it's not necessary as long as you're using the appropriate 
locked/atomic instructions in the atomic operations.

	-- Chris
