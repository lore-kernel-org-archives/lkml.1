Return-Path: <linux-kernel-owner+w=401wt.eu-S965680AbXAYHve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965680AbXAYHve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 02:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965681AbXAYHve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 02:51:34 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:41704 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965680AbXAYHvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 02:51:33 -0500
Message-ID: <45B86120.1020201@linux.vnet.ibm.com>
Date: Thu, 25 Jan 2007 13:19:52 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: Aubrey Li <aubreylee@gmail.com>
CC: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com> <45B75208.90208@linux.vnet.ibm.com> <Pine.LNX.4.64.0701240655400.9696@schroedinger.engr.sgi.com> <45B82F41.9040705@linux.vnet.ibm.com> <6d6a94c50701242235m48013856kb5a947c489d9da37@mail.gmail.com>
In-Reply-To: <6d6a94c50701242235m48013856kb5a947c489d9da37@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Aubrey Li wrote:
> On 1/25/07, Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
>>
>> Christoph Lameter wrote:
>>> On Wed, 24 Jan 2007, Vaidyanathan Srinivasan wrote:
>>>
>>>> With your patch, MMAP of a file that will cross the pagecache limit hangs the
>>>> system.  As I mentioned in my previous mail, without subtracting the
>>>> NR_FILE_MAPPED, the reclaim will infinitely try and fail.
>>> Well mapped pages are still pagecache pages.
>>>
>> Yes, but they can be classified under a process RSS pages.  Whether it
>> is an anon page or shared mem or mmap of pagecache, it would show up
>> under RSS.  Those pages can be limited by RSS limiter similar to the
>> one we are discussing in pagecache limiter.  In my opinion, once a
>> file page is mapped by the process, then it should be treated at par
>> with anon pages.  Application programs generally do not mmap a file
>> page if the reuse for the content is very low.
>>
> 
> I agree, we shouldn't take mmapped page into account.
> But Vaidy - even with your patch, we are still using the existing
> reclaimer, that means we dont ensure that only page cache is
> reclaimed/limited. mapped pages will be hit also.
> I think we still need to add a new scancontrol field to lock mmaped
> pages and remove unmapped pagecache pages only.

I have tried to add scan control to Roy's patch at
http://lkml.org/lkml/2007/01/17/96

In that patch, we search and remove only pages that are not mapped.
We also remove referenced and hot pagecache pages which the normal
reclaimer is not expected to consider.

I will try to fit that logic in Christoph's patch and test.

--Vaidy

> -Aubrey
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
