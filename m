Return-Path: <linux-kernel-owner+w=401wt.eu-S936759AbXHIQc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936759AbXHIQc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbXHIQcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:32:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763764AbXHIQcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:32:11 -0400
Message-ID: <46BB403D.10202@redhat.com>
Date: Thu, 09 Aug 2007 12:26:37 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: wjiang@resilience.com, wensong@linux-vs.org, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org, ak@suse.de, cfriesen@nortel.com,
       netdev@vger.kernel.org, horms@verge.net.au, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       schwidefsky@de.ibm.com, davem@davemloft.net, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com
Subject: Re: [PATCH 24/24] document volatile atomic_read() behavior
References: <20070809142430.GA19817@shell.boston.redhat.com> <8f6bb8a9e4f2819a161d732bdb6c70c0@kernel.crashing.org>
In-Reply-To: <8f6bb8a9e4f2819a161d732bdb6c70c0@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
>> Historically this has been
>> +accomplished by declaring the counter itself to be volatile, but the
>> +ambiguity of the C standard on the semantics of volatile make this 
>> practice
>> +vulnerable to overly creative interpretation by compilers.
> 
> It's even worse when accessing through a volatile casted pointer;
> see for example the recent(*) GCC bugs in that area.
> 
> (*) Well, not _all_ that recent.  No one should be using the 3.x
> series anymore, right?
> 
>> Explicit
>> +casting in atomic_read() ensures consistent behavior across 
>> architectures
>> +and compilers.
> 
> Even modulo compiler bugs, what makes you believe that?

When you declare a variable volatile, you don't actually tell the compiler where 
you want to override its default optimization behavior, giving it some freedom 
to guess your intentions incorrectly.  When you put the cast on the data access 
itself, there is no question about precisely where in the code you want to 
override the compiler's default optimization behavior.  If the compiler doesn't 
do what you want with a volatile declaration, it might have a plausible excuse 
in the ambiguity of the C standard.  If the compiler doesn't do what you want in 
a cast specific to a single dereference, it's just plain broken.  We try to be 
compatible with plausibly correct compilers, but if they're completely broken, 
we're screwed no matter what.

	-- Chris
