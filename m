Return-Path: <linux-kernel-owner+w=401wt.eu-S940318AbXHIQ1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940318AbXHIQ1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932305AbXHIQ0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:26:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765477AbXHIQ0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:26:52 -0400
Message-ID: <46BB3ECF.2070100@redhat.com>
Date: Thu, 09 Aug 2007 12:20:31 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: wjiang@resilience.com, rpjday@mindspring.com, wensong@linux-vs.org,
       heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, ak@suse.de,
       netdev@vger.kernel.org, paulmck@linux.vnet.ibm.com, horms@verge.net.au,
       akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       jesper.juhl@gmail.com, torvalds@linux-foundation.org,
       schwidefsky@de.ibm.com, davem@davemloft.net, cfriesen@nortel.com,
       zlynx@acm.org
Subject: Re: [PATCH 1/24] make atomic_read() behave consistently on alpha
References: <20070809132442.GA13042@shell.boston.redhat.com> <20070809143255.GA8424@linux.vnet.ibm.com> <46BB2A5A.5090006@redhat.com> <20070809150445.GB8424@linux.vnet.ibm.com> <46BB31A6.4080507@redhat.com> <3bfabd7472d6f019aa1880b14013f7a1@kernel.crashing.org>
In-Reply-To: <3bfabd7472d6f019aa1880b14013f7a1@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
>> We can't have split stores because we don't use atomic64_t on 32-bit 
>> architectures.
> 
> That's not true; the compiler is free to split all stores
> (and reads) from memory however it wants.  It is debatable
> whether "volatile" would prevent this as well, certainly
> it is unsafe if you want to be portable.  GCC will do its
> best to not split volatile memory accesses, but bugs in
> this area do happen a lot (because the compiler code for
> volatile isn't as well exercised as most other compiler
> code, and because it is simply a hard subject; and there
> is no real formalised model for what GCC should do).
> 
> The only safe way to get atomic accesses is to write
> assembler code.  Are there any downsides to that?  I don't
> see any.

The assumption that aligned word reads and writes are atomic, and that words are 
aligned unless explicitly packed otherwise, is endemic in the kernel.  No sane 
compiler violates this assumption.  It's true that we're not portable to insane 
compilers after this patch, but we never were in the first place.

	-- Chris
