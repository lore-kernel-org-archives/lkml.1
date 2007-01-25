Return-Path: <linux-kernel-owner+w=401wt.eu-S965379AbXAYShr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379AbXAYShr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 13:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965562AbXAYShr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 13:37:47 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:40748 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965379AbXAYShq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 13:37:46 -0500
Message-ID: <45B8F8F3.7000405@linux.vnet.ibm.com>
Date: Fri, 26 Jan 2007 00:07:39 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
References: <200701250942.47321.a1426z@gawab.com> <45B86930.2090709@linux.vnet.ibm.com> <200701251457.27813.a1426z@gawab.com>
In-Reply-To: <200701251457.27813.a1426z@gawab.com>
Content-Type: text/plain; charset=windows-1256
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Al Boldi wrote:
> Vaidyanathan Srinivasan wrote:
>> Al Boldi wrote:
>>> Rik van Riel wrote:
>>>> Christoph Lameter wrote:
>>>>> This is a patch using some of Aubrey's work plugging it in what is
>>>>> IMHO the right way. Feel free to improve on it. I have gotten
>>>>> repeatedly requests to be able to limit the pagecache.
>>>> IMHO it's a bad hack.
>>>>
>>>> It would be better to identify the problem this "feature" is
>>>> trying to fix, and then fix the root cause.
>>> Ok, here is the problem:  kswapd.
>>>
>>> Limiting the page-cache memory inhibits invoking kswapd needlessly,
>>> aiding performance and easing OOM pressures.
>> Apart from kswapd, limiting pagecache helps performance of
>> applications by not eating away their ANON pages or other parts of its
>> resident data set.  When there is enough free memory, then there is no
>> performance issue.  However memory is always utilized to the max.
>> Hence every pagecache page that is allocated should come from some
>> application's RSS, or from cold pagecache page.  If that page was
>> stolen from some application, then that application pays the price for
>> swapping or reading the page back to memory.  This scenario is what we
>>  want to avoid.  All that we are trying to achieve is that pagecache
>> eats a (unmapped) pagecache page and not steal memory from other
>> important application's resident set.
> 
> Agreed 100%.  Thanks for expanding exactly what I meant.
> 
>> Certainly this should be a configurable option and kernel's behavior
>> should not be changed in general.
>>
>>> I tried the patch; it works.
>>>
>> :)
>> :
>>> But it needs a bit of debugging.  Setting pagecache_ratio = 1 either
>>> deadlocks or reduces thru-put to < 1mb/s.
>> Yes, going below 5% on my 1GB RAM machine causes severe performance
>> problems.  We need to hard wire a reasonable lower limit and not
>> provide a noose for the end user to tie around!
> 
> One reason to test full range settings, is to expose underlying system 
> problems, like scalability.  By limiting the range, you only hide a problem 
> that was exposed.

Agreed.  This is a good point.

> 
> Thanks!
> 
> --
> Al
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
