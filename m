Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbXDEBca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbXDEBca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 21:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbXDEBca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 21:32:30 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:24295 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752987AbXDEBc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 21:32:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=J7BRG2cMz/I2/nnCtAVppw7Ywpur5tBPNj6tU6bAPwJp3wUwZmt4BecrIfS18uUUgP0TSswWDYIlwa0L8yj4Nzndxg9cxe2wIDs2N5OgT9IePoL25yXTcp67J51kx+/Hj3SxfmXUB1yhmoFXr2sZ9lIp1iZLQOGgZgpcdvTstH0=  ;
X-YMail-OSG: ZRY_D7kVM1mYyCf71Mb3TSod.8czZP4x4wqJfLF5mcrupMkZ
Message-ID: <461451A2.8020708@yahoo.com.au>
Date: Thu, 05 Apr 2007 11:32:18 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/13] maps: Move the page walker code to lib/
References: <7.486631555@selenic.com> <461320C9.5030601@yahoo.com.au> <20070404050857.GU4892@waste.org> <46133CC0.505@yahoo.com.au> <20070404214828.GA4892@waste.org>
In-Reply-To: <20070404214828.GA4892@waste.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Wed, Apr 04, 2007 at 03:50:56PM +1000, Nick Piggin wrote:
> 
>>Matt Mackall wrote:
>>
>>>On Wed, Apr 04, 2007 at 01:51:37PM +1000, Nick Piggin wrote:
>>>
>>>
>>>>Matt Mackall wrote:
>>>>
>>>>
>>>>>Move the page walker code to lib/
>>>>>
>>>>>This lets it get shared outside of proc/ and linked in only when
>>>>>needed.
>>>>
>>>>I think it would be better in mm/.
>>>
>>>
>>>I originally was looking at putting it in mm/memory.c and possibly
>>
>>Just put it in its own file in mm/ rather than its own file in lib.
>>lib should be for almost-standalone stuff, IMO (ie. only using basic
>>kernel functionality).
> 
> 
> Arguably that's what lib/ should be for, but it's currently largely

I disagree. There is code everywhere that exists to provide some
functionality via an API to other parts of the kernel. You don't
think mm/page_alloc.c should go in lib/?

> used to avoid linking in unused code without adding more hair to
> Kconfig. Which is what I'm trying to do here.

Well if you're doing a nice big reorganisation and jumble, then
why would you worry about a few lines in Kconfig?

>>Apart from these users outside mm/, I don't see much point in converting
>>things over. The page table walking API we have now is neat and simple.
>>It takes a few lines of code, but is it a big problem?
> 
> 
> I don't think it really qualifies as either neat or simple. It may be
> about as neat as walking a heterogenous tree with an inconsistent
> naming scheme can be, but it's still a headache. A maze of twisty
> little passages, all slightly different.

All page table range walking code should be the same.
It is a simple template to use to walk a range of ptes. It is
a headache outside mm/, sure, but not because of its incredible
complexity.

-- 
SUSE Labs, Novell Inc.
