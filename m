Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbZEKIlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbZEKIlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbZEKIk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:40:58 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5778 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbZEKIk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:40:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=JhQ3Cn5kuyMCIzdt/lS2Srsv/+JlEDZsGXH2gsam0581JLzlH/n3SAC0NvNJfgzBH
	tnZ5QDm+nLzhPeMi7snDA==
Date: Mon, 11 May 2009 01:40:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mmotm] mm: invoke oom killer for __GFP_NOFAIL
In-Reply-To: <20090511162900.f372edd1.minchan.kim@barrios-desktop>
Message-ID: <alpine.DEB.2.00.0905110138160.24726@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com> <20090511162900.f372edd1.minchan.kim@barrios-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Minchan Kim wrote:

> Hmm.. if __alloc_pages_may_oom fail to allocate free page due to order > PAGE_ALLOC_COSTRY_ORDER,
> 
> It will go to nopage label in __alloc_pages_slowpath.
> Then it will show the page allocation failure warning and will return. 
> Retrying depends on caller. 
> 

Correct.

> So, I think it won't loop forever. 
> Do I miss something ?
> 

__GFP_NOFAIL allocations shouldn't fail, that's the point of the gfp flag.  
So failing without attempting to free some memory is the wrong thing to 
do.

> In addition, the OOM killer can help for getting the high order pages ?
>  

Sure, if it selects a task that will free a lot of memory, which is it's 
goal.
