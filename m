Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbXKTFAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbXKTFAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbXKTFAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:00:10 -0500
Received: from ro-out-1112.google.com ([72.14.202.179]:9117 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbXKTFAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:00:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=cwEqIy5I+HeknMBjK8M+MRlr4uHmqx7t7KwR8R9RkmDX/zFF+mr9wS79WQ0Udv8EPxwwsrtJ1+xzCQfNrhCk0xCTbBxCMNEoWQ74vX/Pn5CHIGEfYltsEN8ankwVh6FbhU4hNwbRJBcGZc36gN25r3NHe4f6NqnWozS6MvXiqw0=
Date: Tue, 20 Nov 2007 12:57:37 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@osdl.org>, linux-mm@kvack.org
Subject: Re: [Patch] mm/sparse.c: Check the return value of
	sparse_index_alloc().
Message-ID: <20071120045737.GE2472@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071115135428.GE2489@hacking> <1195507022.27759.146.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195507022.27759.146.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 01:17:02PM -0800, Dave Hansen wrote:
>On Thu, 2007-11-15 at 21:54 +0800, WANG Cong wrote:
>> Since sparse_index_alloc() can return NULL on memory allocation failure,
>> we must deal with the failure condition when calling it.
>> 
>> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>> Cc: Christoph Lameter <clameter@sgi.com>
>> Cc: Rik van Riel <riel@redhat.com>
>> 
>> ---
>> 
>> diff --git a/Makefile b/Makefile
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index e06f514..d245e59 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -83,6 +83,8 @@ static int __meminit sparse_index_init(unsigned long section_nr, int nid)
>>  		return -EEXIST;
>> 
>>  	section = sparse_index_alloc(nid);
>> +	if (!section)
>> +		return -ENOMEM;
>>  	/*
>>  	 * This lock keeps two different sections from
>>  	 * reallocating for the same index
>
>Oddly enough, sparse_add_one_section() doesn't seem to like to check
>its allocations.  The usemap is checked, but not freed on error.  If you
>want to fix this up, I think it needs a little more love than just two
>lines.  

Er, right. I missed this point.

>
>Do you want to try to add some actual error handling to
>sparse_add_one_section()?

Yes, I will have a try. And memory_present() also doesn't check it.
More patches around this will come up soon. Since Andrew has included
the above patch, so I won't remake it with others together.

Andrew, is this OK for you?

Thanks.



