Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbZHFCg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbZHFCg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 22:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZHFCg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 22:36:57 -0400
Received: from mail-yw0-f183.google.com ([209.85.211.183]:40717 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZHFCg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 22:36:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WqyIIUlPcNDA+BCyBW0/WFD175MjN7kNOV/4HvO3wZo/wMy1h0aq8AfIFFu/Fbkxll
         0qrLG2IrffdQ9EZXe+PmPB8lwx2DsUKtUPiccoru0nfPL6J6HJOFVxF3fVkbfrNeKOKZ
         RIvp0FIsD2g8qRYPS+a85goVJ+HcYrU7+bXeA=
MIME-Version: 1.0
In-Reply-To: <20090805185247.86766d80.akpm@linux-foundation.org>
References: <20090805102817.GE21950@csn.ul.ie>
	 <20090805185247.86766d80.akpm@linux-foundation.org>
Date: Thu, 6 Aug 2009 11:36:56 +0900
X-Google-Sender-Auth: 4a1cfe9b760c5143
Message-ID: <2f11576a0908051936j6be1c7afta9d2004787b2760b@mail.gmail.com>
Subject: Re: [PATCH] page-allocator: Remove dead function free_cold_page()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/6 Andrew Morton <akpm@linux-foundation.org>:
> On Wed, 5 Aug 2009 11:28:17 +0100 Mel Gorman <mel@csn.ul.ie> wrote:
>
>> The function free_cold_page() has no callers so delete it.
>>
>> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
>> ---
>>  include/linux/gfp.h |    1 -
>>  mm/page_alloc.c     |    5 -----
>>  2 files changed, 6 deletions(-)
>>
>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>> index 7c777a0..c32bfa8 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -326,7 +326,6 @@ void free_pages_exact(void *virt, size_t size);
>>  extern void __free_pages(struct page *page, unsigned int order);
>>  extern void free_pages(unsigned long addr, unsigned int order);
>>  extern void free_hot_page(struct page *page);
>> -extern void free_cold_page(struct page *page);
>>
>>  #define __free_page(page) __free_pages((page), 0)
>>  #define free_page(addr) free_pages((addr),0)
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index d052abb..36758db 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1065,11 +1065,6 @@ void free_hot_page(struct page *page)
>>       free_hot_cold_page(page, 0);
>>  }
>>
>> -void free_cold_page(struct page *page)
>> -{
>> -     free_hot_cold_page(page, 1);
>> -}
>> -
>>  /*
>>   * split_page takes a non-compound higher-order page, and splits it into
>>   * n (1<<order) sub-pages: page[0..n]
>
> Well I spose so.  But the function is valid and might need to be
> resurrected at any stage.  We could `#if 0' it to save a few bytes of
> text, perhaps.
>
> I wonder how many free_page() callers should really be calling
> free_cold_page().  c'mon, write a thingy to work it out ;) You can
> query a page's hotness by timing how long it takes to read all its
> cachelines.

if we decide to keep this function, I think we also need to consider
make it exporting.
Driver developers never user unexported function.

Or, Can we free_hot_page() and free_cold_page move to inlined function?
