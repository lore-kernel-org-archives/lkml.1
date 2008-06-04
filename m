Return-Path: <linux-kernel-owner+w=401wt.eu-S1762265AbYFDU0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762265AbYFDU0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759727AbYFDU0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:26:33 -0400
Received: from saeurebad.de ([85.214.36.134]:45263 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758767AbYFDU0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:26:32 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 11/14] bootmem: respect goal more likely
References: <20080603225700.9780.E1E9C6FF@jp.fujitsu.com>
	<87zlq2h4sn.fsf@saeurebad.de>
	<20080604193712.97A9.E1E9C6FF@jp.fujitsu.com>
Date: Wed, 04 Jun 2008 22:25:46 +0200
In-Reply-To: <20080604193712.97A9.E1E9C6FF@jp.fujitsu.com> (Yasunori Goto's
	message of "Wed, 04 Jun 2008 19:55:29 +0900")
Message-ID: <87fxrtaqwl.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yasunori Goto <y-goto@jp.fujitsu.com> writes:

>> This check is backwards and probably made your boot fail.
>> 
>> >> +		if (limit && limit < bdata->node_boot_start)
>> >> +			continue;
>> 
>> Changed this to break, because we don't need to search any further if
>> the current node already starts at/above the limit (remember, we walk a
>> list sorted by ->node_boot_start here).
>> 
>> I also made the checks more intuitively understandable.
>> 
>> Could you try the following fix on top of this patch?
>
> I tried it. However, my box cannot boot yet.
>
>>>  	max -= PFN_DOWN(bdata->node_boot_start);
>>>  	start -= PFN_DOWN(bdata->node_boot_start);
>>> +	fallback -= PFN_DOWN(bdata->node_boot_start);
>
> I thought this fallback was wrong at first, 
> because fallback may point 0 at this time,
> it doesn't point start_pfn of this node.
>
> But even if here is commented out, kernel can't boot up yet.

Oh, that should go out, sorry.  It is a left-over from another way to do
it.  Should pay more attention :/

> I'd like to straggle more, but may be need more time,
> because, IA64 doesn't have early_printk, and console is not enable
> at here.....

Hm, just to make sure: this is the patch that breaks booting, right?  If
you apply all patches in the series before this one, the machine boots
fine?

Could you boot a working image with bootmem_debug in the command line?
Perhaps seeing the usual bootmem usage on this box gives a hint what is
broken.

> P.S.
> I was very confused by local variable namimng in alloc_bootmem_core. 
> I suppose start, max, and end, should be named like
> sidx, eidx, and midx. They are not pfn, but index of bitmap.

Okay, I will make them more clear.

> However, new_start and new_end should be named as new_start_offset and
> new_end_offset. They are not index, but offset from start address of
> the node.

Yes, that too.  I would also rename last_offset to last_eidx and
last_success to last_sidx.  What do you think?

	Hannes
