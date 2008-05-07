Return-Path: <linux-kernel-owner+w=401wt.eu-S1759767AbYEGB2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767AbYEGB2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYEGB2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:28:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51988 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbYEGB2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:28:40 -0400
Message-ID: <4821057F.8090706@cn.fujitsu.com>
Date: Wed, 07 May 2008 09:27:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: clameter@sgi.com, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/page_alloc.c: fix a typo
References: <4820272C.4060009@cn.fujitsu.com>	<482027E4.6030300@cn.fujitsu.com>	<482029E7.6070308@cn.fujitsu.com> <20080506071943.46641c26.akpm@linux-foundation.org>
In-Reply-To: <20080506071943.46641c26.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 06 May 2008 17:50:31 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> Li Zefan wrote:
>>> ---
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>
>> Sorry for the noise, but the signed-off was eaten. :(
>> Maybe I should leave a blank line before the signed-off.
>>
>> ---
>>
>>  mm/page_alloc.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index bdd5c43..d0ba10d 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -303,7 +303,7 @@ static void destroy_compound_page(struct page *page, unsigned long order)
>>  	for (i = 1; i < nr_pages; i++) {
>>  		struct page *p = page + i;
>>  
>> -		if (unlikely(!PageTail(p) |
>> +		if (unlikely(!PageTail(p) ||
>>  				(p->first_page != page)))
>>  			bad_page(page);
>>  		__ClearPageTail(p);
> 
> I have a vague memory that the "|" was deliberate.  Most of the time,
> "!PageTail" will be false so most of the time we won't take the first

!PageTail will be true if nothing bad happened, corrected me if I'm wrong:

static void prep_compound_page(struct page *page, unsigned long order)
{
	...
	for (i = 1; i < nr_pages; i++) {
		struct page *p = page + i;

		__SetPageTail(p);
		p->first_page = page;
	}
}

> branch so it's probably worth omitting it and always doing the pointer
> comparison.
> 
> It's a somewhat dopey trick and shouldn't have been done without a comment.
> 
> otoh maybe it was a typo.
> 
> 
