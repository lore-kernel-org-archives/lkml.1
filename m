Return-Path: <linux-kernel-owner+w=401wt.eu-S1423089AbXEDXuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423089AbXEDXuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423001AbXEDXtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:49:51 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:27238 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161582AbXEDXtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:49:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=YnWE5LGmj6S8iKp5pJTpLqyGCx+mryLhRZ3LfqCrxTn7J+hw6ddp+3Tie+vPvltLUDfwYmhdna1GH/fEu1oPxmUyEScM3XQAO5pugCUDCzgu7Oiyrkgrr/6n40InwTB+l0NP+3ic7J34xFNRe0u9k+iK7qTBheRlrP3YqD/SMiM=  ;
X-YMail-OSG: zf8QrFgVM1kCKgcJpHL4Na06rOCoOXkRJ109aQ3nG4PxlaBAZ0aTw63kMwXoNyIcCuhkevv_Ig--
Message-ID: <463BC686.70901@yahoo.com.au>
Date: Sat, 05 May 2007 09:49:26 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] MM: implement MADV_FREE lazy freeing of anonymous memory
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au> <463B1FF6.1030904@redhat.com>
In-Reply-To: <463B1FF6.1030904@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Nick Piggin wrote:
> 
>> Rik van Riel wrote:
>>
>>> With lazy freeing of anonymous pages through MADV_FREE, performance of
>>> the MySQL sysbench workload more than doubles on my quad-core system.
>>
>>
>> OK, I've run some tests on a 16 core Opteron system, both sysbench with
>> MySQL 5.33 (set up as described in the freebsd vs linux page), and with
>> ebizzy.
>>
>> What I found is that, on this system, MADV_FREE performance improvement
>> was in the noise when you look at it on top of the MADV_DONTNEED glibc
>> and down_read(mmap_sem) patch in sysbench.
> 
> 
> Interesting, very different results from my system.
> 
> First, did you run with the properly TLB batched version of
> the MADV_FREE patch?  And did you make sure that MADV_FREE
> takes the mmap_sem for reading?   Without that, I did see
> a similar thing to what you saw...

Yes and yes (I initially forgot to add MADV_FREE to the down_read
case and saw horrible performance!)


> Secondly, I'll have to try some test runs one of the larger
> systems in the lab.
> 
> Maybe the results from my quad core Intel system are not
> typical; maybe the results from your 16 core Opteron are
> not typical.  Either way, I want to find out :)

Yep. We might have something like that here, and I'll try with
some other architectures as well next week, if I can get glibc
built.

-- 
SUSE Labs, Novell Inc.
