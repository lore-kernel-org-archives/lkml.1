Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758961AbYLQHBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbYLQHBV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbYLQHBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:01:09 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:27069 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYLQHBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:01:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ftggy0hG2iWRiEywoNhxObxxEh6OK9dLsem9aG40dOmnv5n35cVCdl8Qh2DUQliVO1
         dbP/KHsp1pWvDoMNZcEV8tXHq7P5p0OvzgZJQd52T/uRX1sv/ECSVs+Tp8WS1v19njVp
         gQ8GXgYZsjRFyee8rJ6NpiHt0gs1ECRn5cWyU=
Message-ID: <28c262360812162301i58c9fe9l4a1ee89ca0a6a56@mail.gmail.com>
Date: Wed, 17 Dec 2008 16:01:06 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [rfc][patch] SLQB slab allocator
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux Memory Management List" <linux-mm@kvack.org>
In-Reply-To: <20081217064238.GA26179@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212002518.GH8294@wotan.suse.de>
	 <28c262360812151542g2ac032fay6c5b03d846d05a77@mail.gmail.com>
	 <20081217064238.GA26179@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 3:42 PM, Nick Piggin <npiggin@suse.de> wrote:
> On Tue, Dec 16, 2008 at 08:42:12AM +0900, MinChan Kim wrote:
>> Hi, Nick.
>> I am interested in SLQB.
>> So I tested slqb, slub, slab by kernel compile time.
>>
>> make all -j 8
>>
>> slqb and slub not DEBUG.
>> my test environment is as follows.
>>
>> cpu family    : 6
>> model         : 15
>> model name    : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
>> stepping      : 11
>> cpu MHz               : 1600.000
>> cache size    : 4096 KB
>>
>> Below is average for ten time test.
>>
>> slab :
>> user : 2376.484, system : 192.616 elapsed : 12:22.0
>> slub :
>> user : 2378.439, system : 194.989 elapsed : 12:22.4
>> slqb :
>> user : 2380.556, system : 194.801 elapsed : 12:23.0
>>
>> so, slqb is rather slow although it is a big difference.
>> Interestingly, slqb consumes less time than slub in system.
>
> Thanks, interesting test. kbuild is not very slab allocator intensive,

Let me know what is popular benchmark program in slab allocator.
I will try with it. :)

> so I hadn't thought of trying it. Possibly the object cacheline layout
> of longer lived allocations changes the behaviour (increased user time
> could indicate that).

What mean "object cacheline layout of loger lived allocations" ?

> I've been making a few changes to that, and hopefully slqb is slightly
> improved now (the margin is much closer, seems within the noise with
> SLUB on my NUMA opteron now, although that's a very different system).
>
> The biggest bug I fixed was that the NUMA path wasn't being taken in
> kmem_cache_free on NUMA systems (oops), but that wouldn't change your
> result. But I did make some other changes too, eg in prefetching.

OK. I will review and test your new patch in my machine.

-- 
Kinds regards,
MinChan Kim
