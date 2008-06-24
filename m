Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYFXWCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYFXWCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 18:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYFXWCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 18:02:46 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:28061 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbYFXWCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 18:02:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wLLSASwHilkP6h2o/G3hg+9wBYtA2uGZPOoqBxf0GvsM8sEk1xm5NQLex97W+lZuHj
         2pxcnygviAv4GY3EbtYXm9OOvI1UImpZ1zwIByBgo3myxN4MtjBKTvqAJ/beSVs/E124
         dt9vDPADKN12ngf8xLPzRZ4tIq6EIw3zszHCI=
Message-ID: <86802c440806241502k342c0a5w8417c935d1ac835d@mail.gmail.com>
Date: Tue, 24 Jun 2008 15:02:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: introduce init_memory_mapping for 32bit
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440806241222h574c2a1cidf4191f7f6f3f372@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806231951.10898.yhlu.kernel@gmail.com>
	 <200806240410.47856.yhlu.kernel@gmail.com>
	 <20080624113049.GA7731@elte.hu>
	 <86802c440806241222h574c2a1cidf4191f7f6f3f372@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 12:22 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Tue, Jun 24, 2008 at 4:30 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>>> so could use mem below max_low_pfn as early. could move several
>>> function more early instead of waiting after paging_init including
>>> moving relocate_initrd early, and kva related early done in
>>> initmem_init
>>
>> applied to tip/x86/setup-memory - thanks Yinghai.
>>
>> a sidenote:
>>
>>>  6 files changed, 128 insertions(+), 74 deletions(-)
>>
>> this patch is too large - if it causes any problems it will not be very
>> easy to figure out which exact change caused the problems.
>>
>> Lets hope it goes all fine - but in the future lets try doing
>> more+smaller patches, especially if they change some known-dangerous
>> area of the kernel.
>>
>> For example here a better splitup would have been to do 5 or more
>> patches:
>>
>>  1) first introduce init_memory_mapping() [but dont use it anywhere]
>>  2) add the init_memory_mapping() call to setup_arch()
>>  3) move remap_numa_kva()
>>  4) move relocate_initrd()
>>  5) remove the now unnecessary setup from paging_init()
>>
>> ... or something like that. The point is to manage risk: if there's
>> multiple problem areas that a change is touching, try to isolate them
>> from each other and introduce the change gradually.
>>
>> The end result is still exactly the same, but much more
>> reviewable/debuggable/bisectable.
>
> split into 3 patches, please use them to replace the old one if you like.
>
and
[PATCH] x86: fix e820_update_range size when overlapping
[PATCH] x86: get max_pfn_mapped in init_memory_mapping
[PATCH] x86: add table_top check for alloc_low_page in 64 bit
[PATCH] x86: change size if e820_update/remove_range

YH
