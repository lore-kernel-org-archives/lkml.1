Return-Path: <linux-kernel-owner+w=401wt.eu-S1760594AbYFDK4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbYFDK4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbYFDK4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:56:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33158 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbYFDK43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:56:29 -0400
Date: Wed, 04 Jun 2008 19:55:29 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH -mm 11/14] bootmem: respect goal more likely
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <87zlq2h4sn.fsf@saeurebad.de>
References: <20080603225700.9780.E1E9C6FF@jp.fujitsu.com> <87zlq2h4sn.fsf@saeurebad.de>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080604193712.97A9.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This check is backwards and probably made your boot fail.
> 
> >> +		if (limit && limit < bdata->node_boot_start)
> >> +			continue;
> 
> Changed this to break, because we don't need to search any further if
> the current node already starts at/above the limit (remember, we walk a
> list sorted by ->node_boot_start here).
> 
> I also made the checks more intuitively understandable.
> 
> Could you try the following fix on top of this patch?

I tried it. However, my box cannot boot yet.

>>  	max -= PFN_DOWN(bdata->node_boot_start);
>>  	start -= PFN_DOWN(bdata->node_boot_start);
>> +	fallback -= PFN_DOWN(bdata->node_boot_start);

I thought this fallback was wrong at first, 
because fallback may point 0 at this time,
it doesn't point start_pfn of this node.

But even if here is commented out, kernel can't boot up yet.

I'd like to straggle more, but may be need more time,
because, IA64 doesn't have early_printk, and console is not enable
at here.....


P.S.
I was very confused by local variable namimng in alloc_bootmem_core. 
I suppose start, max, and end, should be named like
sidx, eidx, and midx. They are not pfn, but index of bitmap.

However, new_start and new_end should be named as new_start_offset and
new_end_offset. They are not index, but offset from start address of
the node.

Probably, it will be easier to read, I think.

Bye.
-- 
Yasunori Goto 

