Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZEKJNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZEKJNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbZEKJMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:12:48 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:47501 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbZEKJMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l/4ojsKUe6BfE0yppErCk+sPzMMfNVZBrSxrpJ/q7wknbEk3qqLMw2jXoT2uFaukFh
         /3d2Va8cDJzUc3yVGufNjMX+7ikseN3vLre2v76OjEjulollMcfMMrFVLKPnipzxZ9lM
         vHhADatx0baeLUKEQsKfeudMolSW0HeYQPMNs=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0905110138160.24726@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com>
	 <20090511162900.f372edd1.minchan.kim@barrios-desktop>
	 <alpine.DEB.2.00.0905110138160.24726@chino.kir.corp.google.com>
Date: Mon, 11 May 2009 18:12:46 +0900
Message-ID: <28c262360905110212j9867b79wd8d90b16f6f196be@mail.gmail.com>
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

On Mon, May 11, 2009 at 5:40 PM, David Rientjes <rientjes@google.com> wrote:
> On Mon, 11 May 2009, Minchan Kim wrote:
>
>> Hmm.. if __alloc_pages_may_oom fail to allocate free page due to order > PAGE_ALLOC_COSTRY_ORDER,
>>
>> It will go to nopage label in __alloc_pages_slowpath.
>> Then it will show the page allocation failure warning and will return.
>> Retrying depends on caller.
>>
>
> Correct.
>
>> So, I think it won't loop forever.
>> Do I miss something ?
>>
>
> __GFP_NOFAIL allocations shouldn't fail, that's the point of the gfp flag.
> So failing without attempting to free some memory is the wrong thing to
> do.

Thanks for quick reply.
I was confused by your description.
I thought you suggested we have to prevent loop forever.

>
>> In addition, the OOM killer can help for getting the high order pages ?
>>
>
> Sure, if it selects a task that will free a lot of memory, which is it's
> goal.
>

How do we know any task have a lot of memory ?
If we select wrong task and kill one ?

I have a concern about innocent task.

-- 
Kinds regards,
Minchan Kim
