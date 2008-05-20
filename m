Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbYETCQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbYETCQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 22:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbYETCQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 22:16:27 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:41411 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622AbYETCQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 22:16:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ESga107iU6WhqfKlyCF5yT0uB1K1TcYAy/nfz6X9+VPAEyH6Rz9KxQe144s2I/iex4wxJCb25LrYQSgEv8sod0iwMeiRK1CIYUXvHejwNya6ggGwNn+v09THdLr5U3fRKcnm/y/AUWLdrhLxHn507OBXPJuchm+7cuEUQalfmFo=
Message-ID: <a8e1da0805191916o4b040e26p7c71a5302422256c@mail.gmail.com>
Date: Tue, 20 May 2008 10:16:23 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: ext4-mm-delalloc-ext4-lock-reverse-fix
Cc: "Jiri Slaby" <jirislaby@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Mingming Cao" <cmm@us.ibm.com>
In-Reply-To: <20080519203752.GA4967@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080519002919.1f8f21f6.akpm@linux-foundation.org>
	 <1211210687-4212-1-git-send-email-jirislaby@gmail.com>
	 <20080519203752.GA4967@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 4:37 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Mon, May 19, 2008 at 05:24:47PM +0200, Jiri Slaby wrote:
>> Andrew Morton <akpm@linux-foundation.org> wrote:
>> > On Mon, 19 May 2008 15:15:09 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
>> >
>> > > With 2.6.26-rc2-mm1 I need to sync frequently. It's not normal as my
>> > > understanding.
>> > >
>> > > 1. scp a big file from a lan server. Firstly the speed is about 8M/s,
>> > > but the speed will slow down to 100K/s at last. After I exec "sync",
>> > > the speed will restore.
>> > >
>> > > Is this a known issue?
>> > >
>> >
>> > Yes, probably related to the "mkfs takes forever" problem.  I haven't
>> > looked into it yet.  Nor has anyone else afaik.
>>
>> Absolutely not sure what this breaks in ext4, but fixes the problem for me:

Jiri, it fixes my scp-slow-down problem as well. Thanks.

>
> This helps, thank you!
>
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -881,7 +881,7 @@ int write_cache_pages(struct address_space *mapping,
>>       pagevec_init(&pvec, 0);
>>       if (wbc->range_cyclic) {
>>               index = mapping->writeback_index; /* Start from prev offset */
>> -             end = wbc->range_end >> PAGE_CACHE_SHIFT;
>> +             end = -1;
>>       } else {
>>               index = wbc->range_start >> PAGE_CACHE_SHIFT;
>>               end = wbc->range_end >> PAGE_CACHE_SHIFT;
>
>
