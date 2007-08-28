Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbXH1Xtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbXH1Xtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 19:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbXH1Xtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 19:49:35 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:46659 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752827AbXH1Xte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 19:49:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=CnklF0GKOJltftnlRdqpl+oXP7Jmwxf1u8CdJ2dUePT77x0NUA8ioFCOhAlJ5PVXah1W8opzLh3w5ddaWD8mdir5jyBJsrNKS2FUe60zmzZGuacexUjUCMODksI0/E3Yrvctf/ePbD8Ynh73e+Z5EiWsDJsojW41KusyVQq7SOw=  ;
X-YMail-OSG: zDOLVXkVM1mF7uUlzbtrGJ5nl4EvTj1I8atowHsHgO9JB8STfr_D2F.s.nLw3OkEXVqzJbp6bQ--
Message-ID: <46D4B484.2070005@yahoo.com.au>
Date: Wed, 29 Aug 2007 09:49:24 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: J??rn Engel <joern@logfs.org>, clameter@sgi.com,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [07/36] Use page_cache_xxx in mm/filemap_xip.c
References: <20070828190551.415127746@sgi.com> <20070828190729.308864359@sgi.com> <20070828194937.GA23020@lazybastard.org> <20070828195503.GA15903@lst.de>
In-Reply-To: <20070828195503.GA15903@lst.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Aug 28, 2007 at 09:49:38PM +0200, J??rn Engel wrote:
> 
>>On Tue, 28 August 2007 12:05:58 -0700, clameter@sgi.com wrote:
>>
>>> 
>>>-	index = *ppos >> PAGE_CACHE_SHIFT;
>>>-	offset = *ppos & ~PAGE_CACHE_MASK;
>>>+	index = page_cache_index(mapping, *ppos);
>>>+	offset = page_cache_offset(mapping, *ppos);
>>
>>Part of me feels inclined to marge this patch now because it makes the
>>code more readable, even if page_cache_index() is implemented as
>>#define page_cache_index(mapping, pos) ((pos) >> PAGE_CACHE_SHIFT)
>>
>>I know there is little use in yet another global search'n'replace
>>wankfest and Andrew might wash my mouth just for mentioning it.  Still,
>>hard to dislike this part of your patch.
> 
> 
> Yes, I I suggested that before.  Andrew seems to somehow hate this
> patchset, but even if we don;'t get it in the lowercase macros are much
> much better then the current PAGE_CACHE_* confusion.

I don't mind the change either. The open coded macros are very
recognisable, but it isn't hard to have a typo and get one
slightly wrong.

If it goes upstream now it wouldn't have the mapping argument
though, would it? Or the need to replace PAGE_CACHE_SIZE I guess.

-- 
SUSE Labs, Novell Inc.
