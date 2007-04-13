Return-Path: <linux-kernel-owner+w=401wt.eu-S1751068AbXDMBBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068AbXDMBBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 21:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbXDMBBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 21:01:50 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:44664 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751068AbXDMBBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 21:01:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=zctfg1C7phgul8ZiBIQe+tewHweO1RV8vYFlc+AbA/+ylKnw6HGXpQhNIbIl+hmB3FpdcWUdGWsM+u93qlHvi8RHymDrZ66+5js11ZRkTW+71DkMC+coUSdJ80A7udG7MrL7giGZgC6Fct6EjvGTIX1lslmkn1UQB7tRVMCtCHU=  ;
X-YMail-OSG: Srd8PGAVM1mUEJxbFZJRLAFQiW1m6RhbgnonHJUn2dAAdypPA7hl0B2zOGtSezl1juBvJBHKDA--
Message-ID: <461ED675.3060909@yahoo.com.au>
Date: Fri, 13 Apr 2007 11:01:41 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <1.486631555@selenic.com> <20070412231050.GN2986@holomorphy.com> <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070413002538.GJ11115@waste.org>
In-Reply-To: <20070413002538.GJ11115@waste.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Fri, Apr 13, 2007 at 10:15:24AM +1000, Nick Piggin wrote:
> 
>>Andrew Morton wrote:
>>
>>>On Thu, 12 Apr 2007 16:10:50 -0700
>>>William Lee Irwin III <wli@holomorphy.com> wrote:
>>
>>>>+       while (count > 0) {
>>>>+               chunk = min_t(size_t, count, PAGE_SIZE);
>>>>+               i = 0;
>>>>+
>>>>+               if (pfn == -1) {
>>>>+                       page[0] = 0;
>>>>+                       page[1] = 0;
>>>>+                       ((char *)page)[0] = (ntohl(1) != 1);
>>>
>>>
>>>OK.
>>>
>>>
>>>
>>>>+                       ((char *)page)[1] = PAGE_SHIFT;
>>>
>>>
>>>OK.
>>
>>Shouldn't we just expose page size and endianness by other means? (another 
>>file or
>>syscall).
> 
> 
> If I send you this file dumped from a random machine, you won't know
> what to make of it.

That's a good reason ;)

> I'm planning to write a trivial server to sit on, say, my embedded
> target and spew this over the wire to a client. 
> 
> 
>>>Not a good idea to expose raw flags in this manner - it changes at the drop
>>>of a hat.  We'd need to also expose the kernel's PG_foo-to-bitnumber
>>>mapping to make this viable.
>>
>>I don't think it is viable because that makes the flags part of the
>>userspace ABI. I wonder what they are needed for.
> 
> 
> Basically: to show what the hell's going on in the VM.

kprobes / systemtap isn't good enough?

-- 
SUSE Labs, Novell Inc.
