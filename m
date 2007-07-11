Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbXGKFy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbXGKFy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 01:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbXGKFyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 01:54:50 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:25532 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753145AbXGKFyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 01:54:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=q4XsBojOlkOgfNYSOzjAVmmYr+p1k5FkYnYj4XFkuVQUvfYoXjpd1Nyxe9PldiN7RAf7gW8OQU/0ZxcOXNXuV6UPlJ7zukVAbyieG0Hyfm9rkxQDjP1xRoPOacf/jeZP2RP3AWHpRhtxj2pcrumTnxvfXrnhCgpT2I3IA70FJRI=  ;
X-YMail-OSG: o11AVRAVM1kFNvVGmE4zHhIIRIcy4xeWiAB0D7xYUlgiC1e5z73LWreyAtGQ08UW2NkWrvfFDw--
Message-ID: <469470A3.5040606@yahoo.com.au>
Date: Wed, 11 Jul 2007 15:54:43 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Matthew Hawkins <darthmdh@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	 <200707102015.44004.kernel@kolivas.org>	 <b21f8390707101802o2d546477n2a18c1c3547c3d7a@mail.gmail.com>	 <20070710181419.6d1b2f7e.akpm@linux-foundation.org>	 <b21f8390707101954s3ae69db8vc30287277941cb1f@mail.gmail.com>	 <4694683B.3060705@yahoo.com.au> <2c0942db0707102247n3b6e5933i9803a2161d6c00b1@mail.gmail.com>
In-Reply-To: <2c0942db0707102247n3b6e5933i9803a2161d6c00b1@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On 7/10/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>> Matthew Hawkins wrote:
>> > On 7/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> > Anyhow with swap prefetch, applications that may have been sitting
>> > there idle for a while become responsive in the single-digit seconds
>> > rather than double-digit or worse.  The same goes for a morning wakeup
>> > (ie after nightly cron jobs throw things out)
>>
>> OK that's a good data point. It would be really good to be able to
>> do an analysis on your overnight IO patterns and the corresponding
>> memory reclaim behaviour and see why things are getting evicted.
> 
> 
> Eviction can happen for multiple reasons, as I'm sure you're painfully
> aware. It can happen because of poor balancing choices, or it can

s/balancing/reclaim, yes. And for the nightly cron job case, this is
could quite possibly be the cause. At least updatedb should be fairly
easy to apply use-once heuristics for, so if they're not working then
we should hopefully be able to improve it.

-- 
SUSE Labs, Novell Inc.
