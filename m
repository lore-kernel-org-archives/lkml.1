Return-Path: <linux-kernel-owner+w=401wt.eu-S1751502AbZKRLPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbZKRLPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 06:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZKRLPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 06:15:06 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:65030 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZKRLPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 06:15:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dg23+JXg3QZE6aaEejlhUcBTj8uxPT9I/OHAw0Ds3B1OcN9B/T5wWv14p6O9BOHZN5
         ozY5tv8iM3vQ3kClR2uIbha3ei8xZ7TKfsLy6wSXrQcGXzac025DoKSo986ZrVSKH98B
         ydVrqKXj4oGQsoLNmILqMi1cHSg8Lc/4P4DJk=
MIME-Version: 1.0
In-Reply-To: <1258541696.3918.237.camel@laptop>
References: <20091117161711.3DDA.A69D9226@jp.fujitsu.com>
	 <20091117102903.7cb45ff3@lxorguk.ukuu.org.uk>
	 <20091117200618.3DFF.A69D9226@jp.fujitsu.com>
	 <4B029C40.2020803@gmail.com> <1258490826.3918.29.camel@laptop>
	 <28c262360911171601u618ca555o1dd51ea19168575e@mail.gmail.com>
	 <1258538181.3918.138.camel@laptop>
	 <28c262360911180231o7fcd2128hc9c40f4fffa3f7d6@mail.gmail.com>
	 <1258541696.3918.237.camel@laptop>
Date: Wed, 18 Nov 2009 20:15:10 +0900
Message-ID: <28c262360911180315p6905c365we97f984c49c8fe18@mail.gmail.com>
Subject: Re: [PATCH 2/7] mmc: Don't use PF_MEMALLOC
From: Minchan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 7:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2009-11-18 at 19:31 +0900, Minchan Kim wrote:
>> >
>> > Sure some generic blocklevel infrastructure might work, _but_ you cannot
>> > take away the responsibility of determining the amount of memory needed,
>> > nor does any of this have any merit if you do not limit yourself to that
>> > amount.
>>
>> Yes. Some one have to take a responsibility.
>>
>> The intention was we could take away the responsibility from block driver.
>> Instead of driver, VM would take the responsibility.
>>
>> You mean althgouth VM could take the responsiblity, it is hard to
>> expect amout of pages needed by block drivers?
>
> Correct, its near impossible for the VM to accurately guess the amount
> of memory needed for a driver, or limit the usage of the driver.
>
> The driver could be very simple in that it'll just start a DMA on the
> page and get an interrupt when done, not consuming much (if any) memory
> beyond the generic BIO structure, but it could also be some iSCSI
> monstrosity which involves the full network stack and userspace.

Wow, Thanks for good example.
Until now, I don't know iSCSI is such memory hog driver.

> That is why I generally prefer the user of PF_MEMALLOC to take
> responsibility, because it knows its own consumption and can limit its
> own consumption.

Okay. I understand your point by good explanation.

> Now, I don't think (but I could be wring here) that you need to bother
> with PF_MEMALLOC unless you're swapping. File based pages should always
> be able to free some memory due to the dirty-limit, whcih basically
> guarantees that there are some clean file pages for every dirty file
> page.
>
> My swap-over-nfs series used to have a block-layer hook to expose the
> swap-over-block behaviour:
>
> http://programming.kicks-ass.net/kernel-patches/vm_deadlock/v12.99/blk_queue_swapdev.patch
>
> That gives block devices the power to refuse being swapped over, which
> could be an alternative to using PF_MEMALLOC.
>

Thanks for noticing me.
I will look at your patches.
Thanks again, Peter.





-- 
Kind regards,
Minchan Kim
