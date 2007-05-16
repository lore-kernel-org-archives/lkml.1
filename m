Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbXEPA2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbXEPA2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758999AbXEPA2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:28:18 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:36404 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758793AbXEPA2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:28:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=oSeNHud+25jQbSTAHZsL5WD0kVmOx3JhFaIu7jlwhKl9pITw+s/dBrl3N1JhiJ/HjuZbDavZ5mtoTOTmB8D7fqmjkX5/BA80Fn5Ea3brT1v1V6BwAHnE0dnzdJIyasYcOpoHWpTkhWMYWHP5mWDryV8LO8LQnScb7NCinUxPG7s=  ;
X-YMail-OSG: XRQ.afoVM1mIjMlJFMRi6ozZukhsIymADCVlmF3cxpaCCVZMP426AscqPxJZ1o0i7W0fAKw8Rw--
Message-ID: <464A501A.3080209@yahoo.com.au>
Date: Wed, 16 May 2007 10:28:10 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Fengguang Wu <fengguang.wu@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] resolve duplicate flag no for PG_lazyfree
References: <379110250.28666@ustc.edu.cn>	<20070513224630.3cd0cb54.akpm@linux-foundation.org>	<20070514180618.GB9399@thunk.org> <20070514134606.695f087a.akpm@linux-foundation.org>
In-Reply-To: <20070514134606.695f087a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 14 May 2007 14:06:19 -0400
> Theodore Tso <tytso@mit.edu> wrote:
> 
> 
>>On Sun, May 13, 2007 at 10:46:30PM -0700, Andrew Morton wrote:
>>
>>>otoh, the intersection between pages which are PageBooked() and pages which
>>>are PageLazyFree() should be zreo, so it'd be good to actually formalise
>>>this reuse within the ext4 patches.
>>>
>>>otoh2, PageLazyFree() could have reused PG_owner_priv_1.
>>>
>>>Rik, Ted: any thoughts?  We do need to scrimp on page flags: when we
>>>finally run out, we're screwed.
>>
>>It makes sense to me.  PG_lazyfree is currently only in -mm, right?
> 
> 
> Ah, yes, I got confused, sorry.
> 
> 
>> I
>>don't see it in my git tree.  It would probably would be a good idea
>>to make sure that we check to add some sanity checking code if it
>>isn't there already that PG_lazyfree isn't already set when try to set
>>PG_lazyfree (just in case there is a bug in the future which causes
>>the should-never-happen case of trying lazy free a PageBooked page).
>>
> 
> 
> Actually, I think the current status of
> lazy-freeing-of-memory-through-madv_free.patch is "might not be needed".  I
> _think_ we've determined that 0a27a14a62921b438bb6f33772690d345a089be6
> sufficiently fixed the perfomance problems we had in there?

I think so far we've found that it fixes the MySQL scalability problem,
yes. I couldn't see any statistically significant difference with MySQL
in my tests with MADV_FREE (versus MADV_DONTNEED).

ebizzy is improved a bit at low concurrency but drops off slightly at
higher concurrency.

But basically, I don't think we've found a good reason to use a page
flag and introduce the potential performance regressions that the
MADV_FREE patch has.

-- 
SUSE Labs, Novell Inc.
