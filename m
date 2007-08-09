Return-Path: <linux-kernel-owner+w=401wt.eu-S1761005AbXHIT0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005AbXHIT0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXHITZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:25:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:59485 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbXHITZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:25:41 -0400
In-Reply-To: <46BB656D.6090408@redhat.com>
References: <20070809132442.GA13042@shell.boston.redhat.com> <20070809143255.GA8424@linux.vnet.ibm.com> <46BB2A5A.5090006@redhat.com> <20070809150445.GB8424@linux.vnet.ibm.com> <46BB31A6.4080507@redhat.com> <3bfabd7472d6f019aa1880b14013f7a1@kernel.crashing.org> <46BB3ECF.2070100@redhat.com> <1abc2c621d6b62b3ac9f489d4d18806a@kernel.crashing.org> <46BB656D.6090408@redhat.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <2d0e5a19da57d8c22e81a958ae984884@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: wjiang@resilience.com, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, ak@suse.de,
       cfriesen@nortel.com, netdev@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       horms@verge.net.au, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, jesper.juhl@gmail.com, davem@davemloft.net,
       torvalds@linux-foundation.org, zlynx@acm.org, rpjday@mindspring.com
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/24] make atomic_read() behave consistently on alpha
Date: Thu, 9 Aug 2007 21:19:20 +0200
To: Chris Snook <csnook@redhat.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> The only safe way to get atomic accesses is to write
>>>> assembler code.  Are there any downsides to that?  I don't
>>>> see any.
>>>
>>> The assumption that aligned word reads and writes are atomic, and 
>>> that words are aligned unless explicitly packed otherwise, is 
>>> endemic in the kernel.  No sane compiler violates this assumption.  
>>> It's true that we're not portable to insane compilers after this 
>>> patch, but we never were in the first place.
>> You didn't answer my question: are there any downsides to using
>> explicit coded-in-assembler accesses for atomic accesses?  You
>> can handwave all you want that it should "just work" with
>> volatile accesses, but volatility != atomicity, volatile in C
>> is really badly defined, GCC never officially gave stronger
>> guarantees, and we have a bugzilla full of PRs to show what a
>> minefield it is.
>> So, why not use the well-defined alternative?
>
> Because we don't need to,

You don't need to use volatile objects, or accesses through
valatile-cast pointers, either.

> and it hurts performance.

Please show how it does this -- one load is one load either way,
and one store is one store.


Segher

