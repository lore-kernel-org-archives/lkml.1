Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbZGILIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbZGILIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 07:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbZGILHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 07:07:55 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:65010 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbZGILHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 07:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AF5z3XEQzn7b1Cx6VD10Seg7I5VtTWGDm1yUjBNERMduZnBx3hRxQTKKknTJN1Na+2
         //zTOUweBC3/pLX+DJnCI4m8eKRsNDuRIZmnh2YjJ8DY3UjMXvEM4Gs5G7Onv2HAvhtT
         rEgA1sxxWHo2JpuMBRwdBFIEnTqQzdhcyu21M=
MIME-Version: 1.0
In-Reply-To: <20090709084222.GA10400@localhost>
References: <20090709024710.GA16783@localhost>
	 <20090709030731.GA17097@localhost>
	 <20090709121647.2395.A69D9226@jp.fujitsu.com>
	 <20090709084222.GA10400@localhost>
Date: Thu, 9 Jul 2009 20:07:53 +0900
Message-ID: <28c262360907090407i706aet3bff62f49f11f7a0@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] vmscan don't isolate too many pages in a zone
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Wu.

On Thu, Jul 9, 2009 at 5:42 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> On Thu, Jul 09, 2009 at 03:01:26PM +0800, KOSAKI Motohiro wrote:
>> Hi
>>
>> > I tried the semaphore based concurrent direct reclaim throttling, and
>> > get these numbers. The run time is normal 30s, but can sometimes go up
>> > by many folds. It seems that there are more hidden problems..
>>
>> Hmm....
>> I think I and you have different priority list. May I explain why Rik
>> and decide to use half of LRU pages?
>>
>> the system have 4GB (=1M pages) memory. my patch allow 1M/2/32=16384
>> threads. I agree this is very large and inefficient. However IOW
>> this is very conservative.
>> I believe it don't makes too strong restriction problem.
>
> Sorry if I made confusions. I agree on the NR_ISOLATED based throttling.
> It risks much less than to limit the concurrency of direct reclaim.
> Isolating half LRU pages normally costs nothing.
>
>> In the other hand, your patch's concurrent restriction is small constant
>> value (=32).
>> it can be more efficient and it also can makes regression. IOW it is more
>> aggressive approach.
>>
>> e.g.
>> if the system have >100 CPU, my patch can get enough much reclaimer but
>> your patch makes tons idle cpus.
>
> That's a quick (and clueless) hack to check if the (very unstable)
> reclaim behavior can be improved by limiting the concurrency. I didn't
> mean to push it further more :)
>
>> And, To recall original issue tearch us this is rarely and a bit insane
>> workload issue.
>> Then, I priotize to
>>
>> 1. prevent unnecessary OOM
>> 2. no regression to typical workload
>> 3. msgctl11 performance
>
> I totally agree on the above priorities.
>
>>
>> IOW, I don't think msgctl11 performance is so important.
>> May I ask why do you think msgctl11 performance is so important?
>
> Now that we have addressed (1)/(2) with your patch, naturally the
> msgctl11 performance problem catches my eyes. Strictly speaking
> I'm not particularly interested in the performance itself, but
> the obviously high _fluctuations_ of performance. Something bad

Me, too. I also have a looked into this problem.
But unfortunately, I can't devote my attention to the problem until
this weekend.
If you know the cause, let me know it :)

-- 
Kind regards,
Minchan Kim
