Return-Path: <linux-kernel-owner+w=401wt.eu-S937852AbXHHXgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937852AbXHHXgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765755AbXHHXgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:36:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764165AbXHHXgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:36:17 -0400
Message-ID: <46BA5353.9050802@redhat.com>
Date: Wed, 08 Aug 2007 19:35:47 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Lennert Buytenhek <buytenh@wantstofly.org>
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org
Subject: Re: [PATCH] make atomic_t volatile on all architectures
References: <20070808230733.GA17270@shell.boston.redhat.com> <20070808232521.GC8460@xi.wantstofly.org>
In-Reply-To: <20070808232521.GC8460@xi.wantstofly.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennert Buytenhek wrote:
> On Wed, Aug 08, 2007 at 07:07:33PM -0400, Chris Snook wrote:
> 
>> From: Chris Snook <csnook@redhat.com>
>>
>> Some architectures currently do not declare the contents of an atomic_t to be
>> volatile.  This causes confusion since atomic_read() might not actually read
>> anything if an optimizing compiler re-uses a value stored in a register, which
>> can break code that loops until something external changes the value of an
>> atomic_t.  Avoiding such bugs requires using barrier(), which causes re-loads
>> of all registers used in the loop, thus hurting performance instead of helping
>> it, particularly on architectures where it's unnecessary.  Since we generally
>> want to re-read the contents of an atomic variable on every access anyway,
>> let's standardize the behavior across all architectures and avoid the
>> performance and correctness problems of requiring the use of barrier() in
>> loops that expect atomic_t variables to change externally.  This is relevant
>> even on non-smp architectures, since drivers may use atomic operations in
>> interrupt handlers.
>>
>> Signed-off-by: Chris Snook <csnook@redhat.com>
> 
> Documentation/atomic_ops.txt would need updating:
> 
> 	[...]
> 
> 	One very important aspect of these two routines is that they DO NOT
> 	require any explicit memory barriers.  They need only perform the
> 	atomic_t counter update in an SMP safe manner.

Thanks, I was looking for that.  I'll re-send shortly with my comment 
moved there.  People are already using atomic_t in a manner that implies 
the use of memory barriers and interrupt-safety, which is what the patch 
enforces.

	-- Chris
