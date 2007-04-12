Return-Path: <linux-kernel-owner+w=401wt.eu-S1945899AbXDLGIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945899AbXDLGIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 02:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945900AbXDLGIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 02:08:50 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:38826 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1945899AbXDLGIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 02:08:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=4KJXItEIXfNjwKawDBR5qe1aSbyjjCgegJO9akyjvPjyNYWpCejwr9IOvmGwQjuanezjLVUrbAFbhNtTAB8YSXX2XtxvMgCt2OXVQXsAU7B5qpPJzAI7WG9f2G0zV7YtsndKvAgw7PHwrR1XE7xDsjV09fKGV3AgwSerLSKfUTw=  ;
X-YMail-OSG: 6irpslAVM1kcfanRJWYKzEImJ1Zt623PW7eA0jHsz83IPRp1yTrwkgtqdHTofgP5TZ0pkQBxKA--
Message-ID: <461DCCEB.70004@yahoo.com.au>
Date: Thu, 12 Apr 2007 16:08:43 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Rik van Riel <riel@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] make MADV_FREE lazily free memory
References: <461C6452.1000706@redhat.com> <461D6413.6050605@cosmosbay.com> <461D67A9.5020509@redhat.com> <461DC75B.8040200@cosmosbay.com>
In-Reply-To: <461DC75B.8040200@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Rik van Riel a écrit :
> 
>> Eric Dumazet wrote:
>>
>>> Rik van Riel a écrit :
>>>
>>>> Make it possible for applications to have the kernel free memory
>>>> lazily.  This reduces a repeated free/malloc cycle from freeing
>>>> pages and allocating them, to just marking them freeable.  If the
>>>> application wants to reuse them before the kernel needs the memory,
>>>> not even a page fault will happen.
>>
>>
>>> I dont understand this last sentence. If not even a page fault 
>>> happens, how the kernel knows that the page was eventually reused by 
>>> the application, and should not be freed in case of memory pressure ?
>>
>>
>> Before maybe freeing the page, the kernel checks the referenced
>> and dirty bits of the page table entries mapping that page.
>>
>>> ptr = mmap(some space);
>>> madvise(ptr, length, MADV_FREE);
>>> /* kernel may free the pages */
>>
>>
>> All this call does is:
>> - clear the accessed and dirty bits
>> - move the page to the far end of the inactive list,
>>   where it will be the first to be reclaimed
>>
>>> sleep(10);
>>>
>>> /* what the application must do know before reusing space ? */
>>> memset(ptr, data, 10000);
>>> /* kernel should not free ptr[0..10000] now */
>>
>>
>> Two things can happen here.
>>
>> If this program used the pages before the kernel needed
>> them, the program will be reusing its old pages.
> 
> 
> ah ok, this is because accessed/dirty bits are set by hardware and not a 
> page fault.

No it isn't.

> Is it true for all architectures ?

No.

-- 
SUSE Labs, Novell Inc.
