Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbZEKLVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbZEKLVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbZEKLVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:21:22 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:34178 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbZEKLVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KjPzn6lPj/bInfGbo0gDQ2IxNRB+Z9Rw/7/HgNs/PfQ2fVwT5vUhHaKdfOgA9SBl5S
         ZCVav+aCcByVxVhoMxkcrNoElw4jr8eCe+b8BpVN0aaMEV+drnCNJvbxXDWzamurbK7Z
         T9amp3CgHkZ0Sn6640u/o6GvZicBigJwZO/Os=
MIME-Version: 1.0
In-Reply-To: <28c262360905110212j9867b79wd8d90b16f6f196be@mail.gmail.com>
References: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com>
	 <20090511162900.f372edd1.minchan.kim@barrios-desktop>
	 <alpine.DEB.2.00.0905110138160.24726@chino.kir.corp.google.com>
	 <28c262360905110212j9867b79wd8d90b16f6f196be@mail.gmail.com>
Date: Mon, 11 May 2009 20:21:21 +0900
Message-ID: <28c262360905110421g1b079f2cr798ca95adfb8ee45@mail.gmail.com>
Subject: Re: [patch -mmotm] mm: invoke oom killer for __GFP_NOFAIL
From: Minchan Kim <minchan.kim@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 6:12 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Mon, May 11, 2009 at 5:40 PM, David Rientjes <rientjes@google.com> wrote:
>> On Mon, 11 May 2009, Minchan Kim wrote:
>>
>>> Hmm.. if __alloc_pages_may_oom fail to allocate free page due to order > PAGE_ALLOC_COSTRY_ORDER,
>>>
>>> It will go to nopage label in __alloc_pages_slowpath.
>>> Then it will show the page allocation failure warning and will return.
>>> Retrying depends on caller.
>>>
>>
>> Correct.
>>
>>> So, I think it won't loop forever.
>>> Do I miss something ?
>>>
>>
>> __GFP_NOFAIL allocations shouldn't fail, that's the point of the gfp flag.
>> So failing without attempting to free some memory is the wrong thing to
>> do.
>
> Thanks for quick reply.
> I was confused by your description.
> I thought you suggested we have to prevent loop forever.
>
>>
>>> In addition, the OOM killer can help for getting the high order pages ?
>>>
>>
>> Sure, if it selects a task that will free a lot of memory, which is it's
>> goal.
>>
>
> How do we know any task have a lot of memory ?
> If we select wrong task and kill one ?
>
> I have a concern about innocent task.

Now, I look over __out_of_memory.
For selecting better tasks in case of PAGE_ALLOC_COSTRY_ORDER, How
about increasing score of task which have VM_HUGETLB vma in badness ?

> --
> Kinds regards,
> Minchan Kim
>



-- 
Kinds regards,
Minchan Kim
