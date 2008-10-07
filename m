Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbYJGE3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbYJGE3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 00:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbYJGE3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 00:29:13 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:44424 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbYJGE3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 00:29:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gNxi0rslMu5AafLjrF4heOjYyNN7vCtcfwsa/u/4crQDDBnj9WVPP8e9OQcsCswywh
         HQ2fXegmDOlBHt+qcOYqBAM1hntOkd3Ehgi33qHbIe8G/41qy4yaAHvplC+oedAHMjIS
         z5tK9p5G/5T/sQ9WOTymaTltMvfFXw4S1iAVc=
Message-ID: <28c262360810062129h184f15cv5a31e1d598d28a@mail.gmail.com>
Date: Tue, 7 Oct 2008 13:29:10 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 0/4] Reclaim page capture v4
Cc: "Andy Whitcroft" <apw@shadowen.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, "Peter Zijlstra" <peterz@infradead.org>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>, "Mel Gorman" <mel@csn.ul.ie>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081003154616.EF74.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222864261-22570-1-git-send-email-apw@shadowen.org>
	 <28c262360810011946p443350d3hcb271720892e7b85@mail.gmail.com>
	 <20081003154616.EF74.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2008 at 3:48 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> Hi, Andy.
>>
>> I tested your patch in my desktop.
>> The test is just kernel compile with single thread.
>> My system environment is as follows.
>>
>> model name    : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
>> MemTotal:        2065856 kB
>>
>> When I tested vanilla, compile time is as follows.
>>
>> 2433.53user 187.96system 42:05.99elapsed 103%CPU (0avgtext+0avgdata
>> 0maxresident)k
>> 588752inputs+4503408outputs (127major+55456246minor)pagefaults 0swaps
>>
>> When I tested your patch, as follows.
>>
>> 2489.63user 202.41system 44:47.71elapsed 100%CPU (0avgtext+0avgdata
>> 0maxresident)k
>> 538608inputs+4503928outputs (130major+55531561minor)pagefaults 0swaps
>>
>> Regresstion almost is above 2 minutes.
>> Do you think It is a trivial?
>
> Ooops.
> this is definitly significant regression.
>
>
>> I know your patch is good to allocate hugepage.
>> But, I think many users don't need it, including embedded system and
>> desktop users yet.
>>
>> So I suggest you made it enable optionally.
>
> No.
> if the patch has this significant regression,
> nobody turn on its option.
>
> We should fix that.

I have been tested it.
But I can't reproduce such as regression.
I don't know why such regression happed at that time.

Sorry for confusing.
Please ignore my test result at that time.

This is new test result.

before

2346.24user 191.44system 42:07.28elapsed 100%CPU (0avgtext+0avgdata
0maxresident)k
458624inputs+4262728outputs (183major+52299730minor)pagefaults 0swaps


after

2349.75user 195.72system 42:16.36elapsed 100%CPU (0avgtext+0avgdata
0maxresident)k
475632inputs+4265208outputs (183major+52308969minor)pagefaults 0swaps

I think we can ignore some time gap.
Sometime, after is faster than before.

I could conclude it doesn't have any regressions in my desktop machine.

Tested-by: MinChan Kim <minchan.kim@gmail.com>

-- 
Kinds regards,
MinChan Kim
