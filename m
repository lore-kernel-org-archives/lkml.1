Return-Path: <linux-kernel-owner+w=401wt.eu-S1752398AbYFEEOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbYFEEOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 00:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYFEEOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 00:14:35 -0400
Received: from saeurebad.de ([85.214.36.134]:50148 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbYFEEOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 00:14:34 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 11/14] bootmem: respect goal more likely
References: <20080604193712.97A9.E1E9C6FF@jp.fujitsu.com>
	<87fxrtaqwl.fsf@saeurebad.de>
	<20080605115235.6453.E1E9C6FF@jp.fujitsu.com>
Date: Thu, 05 Jun 2008 06:13:47 +0200
In-Reply-To: <20080605115235.6453.E1E9C6FF@jp.fujitsu.com> (Yasunori Goto's
	message of "Thu, 05 Jun 2008 11:58:56 +0900")
Message-ID: <87abi0semc.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yasunori Goto <y-goto@jp.fujitsu.com> writes:

> Hi.
>
>> > I'd like to straggle more, but may be need more time,
>> > because, IA64 doesn't have early_printk, and console is not enable
>> > at here.....
>> 
>> Hm, just to make sure: this is the patch that breaks booting, right?  If
>> you apply all patches in the series before this one, the machine boots
>> fine?
>
> Yes.

Okay.

>> 
>> Could you boot a working image with bootmem_debug in the command line?
>> Perhaps seeing the usual bootmem usage on this box gives a hint what is
>> broken.
>
> Ok. I'll try it.

Thanks!

>> > However, new_start and new_end should be named as new_start_offset and
>> > new_end_offset. They are not index, but offset from start address of
>> > the node.
>> 
>> Yes, that too.  I would also rename last_offset to last_eidx and
>> last_success to last_sidx.  What do you think?
>
> Last_sidx is ok. But, last_offset seems to be used to manage some
> allocated smaller chunks than one page. I'm not sure last_eidx is ok.

Sorry, my fault.

How about last_offset -> last_end_off to reflect that it is the offset
of the last allocations end?

And last_succes -> hint_idx to reflect that it is an index we start
searching from but it is not strict and we fall back if we find nothing
starting from there.  Also free_bootmem* sets it as a hint from where we
could start searching.

I also would set last_success/hint_idx to the _end_ of the successful
allocation (instead of the beginning of it) in alloc_bootmem_core
because we do not want to search for a new free block from the beginning
of the last allocation but rather right after it.

What do you think?

	Hannes
