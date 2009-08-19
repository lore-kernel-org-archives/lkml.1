Return-Path: <linux-kernel-owner+w=401wt.eu-S1751032AbZHSEwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751032AbZHSEwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 00:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbZHSEwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 00:52:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:2559 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZHSEwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 00:52:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=cCh4//hQFOi90R8K2e1HCF1GzVDPc3ky6nxXu3Nr7Hh97mckaGzqLNgCAB9FctHgXa
         8Xwib7YfEKcBu2Ayq1oUPgYs48d9AzqlU7KRke0XWghvI09Z5oRBLUe4lhTLiCjYoMWa
         5Esj/wCebAgmIQqpy1VIihFpTwYekqEVBNA6Q=
Date: Wed, 19 Aug 2009 13:51:05 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: ngupta@vflare.org
Cc: Minchan Kim <minchan.kim@gmail.com>,
       =?UTF-8?B?7Jqw7Lap6riw?= <chungki.woo@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, riel@redhat.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>
Subject: Re: abnormal OOM killer message
Message-Id: <20090819135105.e6b69a8d.minchan.kim@barrios-desktop>
In-Reply-To: <4A8B7508.4040001@vflare.org>
References: <18eba5a10908181841t145e4db1wc2daf90f7337aa6e@mail.gmail.com>
	<20090819114408.ab9c8a78.minchan.kim@barrios-desktop>
	<4A8B7508.4040001@vflare.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 19 Aug 2009 09:14:08 +0530
Nitin Gupta <ngupta@vflare.org> wrote:

> On 08/19/2009 08:14 AM, Minchan Kim wrote:
> > On Wed, 19 Aug 2009 10:41:51 +0900
> > 우충기<chungki.woo@gmail.com>  wrote:
> >
> >> Hi all~
> >> I have got a log message with OOM below. I don't know why this
> >> phenomenon was happened.
> >> When direct reclaim routine(try_to_free_pages) in __alloc_pages which
> >> allocates kernel memory was failed,
> >> one last chance is given to allocate memory before OOM routine is executed.
> >> And that time, allocator uses ALLOC_WMARK_HIGH to limit watermark.
> >> Then, zone_watermark_ok function test this value with current memory
> >> state and decide 'can allocate' or 'cannot allocate'.
> >>
> >> Here is some kernel source code in __alloc_pages function to understand easily.
> >> Kernel version is 2.6.18 for arm11. Memory size is 32Mbyte. And I use
> >> compcache(0.5.2).
> 
> <snip>
> 
> >>
> >> In my case, you can see free pages(6804KB) is much more higher than
> >> high watermark value(1084KB) in OOM message.
> >> And order of allocating is also zero.(order=0)
> >> In buddy system, the number of 4kbyte page is 867.
> >> So, I think OOM can't be happend.
> >>
> >
> > Yes. I think so.
> >
> > In that case, even we can also avoid zone defensive algorithm.
> >
> >> How do you think about this?
> >> Is this side effect of compcache?
> >
> 
> compcache can be storing lot of stale data and this memory space cannot be
> reclaimed (unless overwritten by some other swap data). This is because

stale data. It seems related ARMv6. 
I think Chungki's CPU is ARMv6. 

> compcache does not know when a swap slot has been freed and hence does not know 
> when its safe to free corresponding memory. You can check current memory usage 
> with /proc/ramzswap (see MemUsedTotal).
> 

Let me have a question. 
Now the system has 79M as total swap. 
It's bigger than system memory size. 
Is it possible in compcache?
Can we believe the number?

> BTW, with compcache-0.6 there is an experimental kernel patch that gets rid of 
> all this stale data:
> http://patchwork.kernel.org/patch/41083/
> 
> However, this compcache version needs at least kernel 2.6.28. This version also 
> fixes all known problems on ARM. compcache-0.5.3 or earlier is known to crash on 
> ARM (see: http://code.google.com/p/compcache/issues/detail?id=33).
>

Chungki. Is it reproducible easily ?
Could you try it with compcache-0.6. 
As Nitin said, it seems to solve cache aliasing problem. 

> Thanks,
> Nitin


-- 
Kind regards,
Minchan Kim
