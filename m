Return-Path: <linux-kernel-owner+w=401wt.eu-S1946597AbXEAF6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946597AbXEAF6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946598AbXEAF6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:58:31 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:30176 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1946597AbXEAF6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:58:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=kSZe1Y5DJRZyGodpv8XrGNet9vvMGxfDBzMo59GLxcBtcIKhiSm8lFspn/G1ZJiISBfG+9bsHUSiYcAFcPZxbsx6D8B1U0KJ1O/SlB4FjmjhQgpvm8LBIgCAdaOsOA64pKO2LKLwi+hXm1oHxlJmOcW8ElTu97MuiDXOplhUSvk=  ;
X-YMail-OSG: JI0GyTgVM1mGoENdX2kwcq0KNzFqScYacO_LbuCH27ZBOkOMx95RPWwInSoWoUsWWdXdE0NvJA--
Message-ID: <4636D6FF.9060707@yahoo.com.au>
Date: Tue, 01 May 2007 15:58:23 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Miguel Figueiredo <elmig@debianpt.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21 frozen for a few minutes, swapping to disk
References: <46347335.7080601@debianpt.org>	<20070430003031.2e89fbc1.akpm@linux-foundation.org>	<4636D346.2010507@yahoo.com.au> <20070430224911.ac989f40.akpm@linux-foundation.org>
In-Reply-To: <20070430224911.ac989f40.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 01 May 2007 15:42:30 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>>hm, a genuine oom on an all-ext3 data=ordered i386 system, just like a
>>>million other people.  How very weird.
>>>
>>>I assume all those pages on the LRU are pagecache pages which for some
>>>reason we're unable to reclaim.
>>
>>It looks like it used up all swap? I'd guess a memory leak in some
>>application, or maybe a page refcount leak somewhere.
> 
> 
> yes, I missed that.   The number of mapped pages is tiny so the thing has
> been trying to swap out like.

I didn't quite parse this :)

If the memory is leaking slowly, it could be eventually pushing
everything out to swap without having a large amount of mapped pages.

Or if something is slowly writing stuff to tmpfs, that may not show
up in mapped pages either.


> The question is: how much memory is free after the oom-killing storm?
> If it's "lots" then it's probably an application problem.  If it's
> "not much" then perhaps there's a kernel leak.

Yeah, or a tmpfs filesystem being filled up (what does `df` say?).

-- 
SUSE Labs, Novell Inc.
