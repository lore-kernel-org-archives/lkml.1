Return-Path: <linux-kernel-owner+w=401wt.eu-S1751237AbZG0X63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237AbZG0X63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 19:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbZG0X63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 19:58:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58604 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZG0X62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 19:58:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=nfwtZ+mTQux+d8iPN17bpTzNwJNWsM+7o5ynwVWIhCVHArCeuGmDDu06BHw/DhMnl
	eFBsvvgSNf7teXaCDqKEg==
Date: Mon, 27 Jul 2009 16:58:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Moussa Ba <moussa.a.ba@gmail.com>
cc: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Matt Mackall <mpm@selenic.com>,
       Mel Gorman <mel@csn.ul.ie>, Ying Han <yinghan@google.com>,
       Nick Piggin <npiggin@suse.de>, jaredeh@gmail.com
Subject: Re: [PATCH 1/1] pagemap clear_refs: modify to specify anon or mapped
 vma clearing
In-Reply-To: <7928e7bd0907271638x5ddbfd2ckba2802338a33765a@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0907271657160.27881@chino.kir.corp.google.com>
References: <4A693122.6060503@gmail.com> <20090724083926.GA6372@cr0.nay.redhat.com> <4A6E0BD6.50102@gmail.com> <alpine.DEB.2.00.0907271339070.17425@chino.kir.corp.google.com> <7928e7bd0907271514y699d1de4j54f9c562b94ef0cc@mail.gmail.com>
 <alpine.DEB.2.00.0907271543420.23587@chino.kir.corp.google.com> <7928e7bd0907271638x5ddbfd2ckba2802338a33765a@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009, Moussa Ba wrote:

> The other alternative would be to just forgo the additional function
> clear_refs_walk_vma and rewrite the for loop as:
> 
>         for (vma = mm->mmap; vma; vma = vma->vm_next) {
> 			clear_refs_walk.private = vma;
> 			if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
> 				continue;
> 			if (is_vm_hugetlb_page(vma))
> 				continue;
> 			if (type == CLEAR_REFS_ANON && vma->vm_file)
> 				continue;
> 			if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
> 				continue;
> 			walk_page_range(vma->vm_start, vma->vm_end, this_walk);
>         }
> 

That looks good, with the exception of the check for
type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED being in the loop.
