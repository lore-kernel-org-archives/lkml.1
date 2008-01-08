Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbYAHFvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbYAHFvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 00:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757062AbYAHFvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 00:51:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33595 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783AbYAHFvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 00:51:22 -0500
Message-ID: <47830DCF.3080306@zytor.com>
Date: Mon, 07 Jan 2008 21:44:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@stusta.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: free_pages_check
References: <86802c440801071843p583f390as53f8b600622b93b2@mail.gmail.com> <200801081434.14723.nickpiggin@yahoo.com.au>
In-Reply-To: <200801081434.14723.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tuesday 08 January 2008 13:43, Yinghai Lu wrote:
>> wonder why free_pages_check mm/page_alloc.c is using bit OR than logical OR
>>
>> @@ -450,9 +450,9 @@ static inline void __free_one_page(struc
>>
>>  static inline int free_pages_check(struct page *page)
>>  {
>> -       if (unlikely(page_mapcount(page) |
>> -               (page->mapping != NULL)  |
>> -               (page_count(page) != 0)  |
>> +       if (unlikely(page_mapcount(page) ||
>> +               (page->mapping != NULL)  ||
>> +               (page_count(page) != 0)  ||
>>                 (page->flags & (
>>                         1 << PG_lru     |
>>                         1 << PG_private |
> 
> Because the positive case is extremely rare, so there is no benefit (nor
> any correctness requirement) for short-circuit evaluation, and we don't
> want to have all the branches that it involves. I think it is 3 more
> conditional jumps.

Depends on how smart the compiler is.  If the page_() functions are 
inlines or macros, there is only one pointer reference involved and it 
should be able to do that transformation.  Whether or not gcc is that 
smart is another matter.

	-hpa

