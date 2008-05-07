Return-Path: <linux-kernel-owner+w=401wt.eu-S1761918AbYEGEeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918AbYEGEeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761069AbYEGEdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 00:33:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61762 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760873AbYEGEdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 00:33:45 -0400
Message-ID: <482130D6.8020306@cn.fujitsu.com>
Date: Wed, 07 May 2008 12:32:22 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: clameter@sgi.com, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/page_alloc.c: fix a typo
References: <4820272C.4060009@cn.fujitsu.com>	<482027E4.6030300@cn.fujitsu.com>	<482029E7.6070308@cn.fujitsu.com> <20080506071943.46641c26.akpm@linux-foundation.org> <4821057F.8090706@cn.fujitsu.com>
In-Reply-To: <4821057F.8090706@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index bdd5c43..d0ba10d 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -303,7 +303,7 @@ static void destroy_compound_page(struct page *page, unsigned long order)
>>>  	for (i = 1; i < nr_pages; i++) {
>>>  		struct page *p = page + i;
>>>  
>>> -		if (unlikely(!PageTail(p) |
>>> +		if (unlikely(!PageTail(p) ||
>>>  				(p->first_page != page)))
>>>  			bad_page(page);
>>>  		__ClearPageTail(p);
>> I have a vague memory that the "|" was deliberate.  Most of the time,
>> "!PageTail" will be false so most of the time we won't take the first
> 
> !PageTail will be true if nothing bad happened, corrected me if I'm wrong:
> 

Silly, I was wrong...

Christoph Lameter wrote:
> I think the | there was some developers attempt to avoid gcc generating 
> too many branches. I am fine either way.
> 

Yes, I found out it's 224abf92b2f439a9030f21d2926ec8047d1ffcdb :

[PATCH] mm: bad_page optimisation
Nick Piggin [Fri, 6 Jan 2006 08:11:11 +0000 (00:11 -0800)]

Cut down size slightly by not passing bad_page the function name (it should be
able to be determined by dump_stack()).  And cut down the number of printks in
bad_page.

Also, cut down some branching in the destroy_compound_page path.

