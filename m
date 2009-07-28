Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbZG1DXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbZG1DXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 23:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZG1DXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 23:23:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:53151 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbZG1DXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 23:23:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O2Zr6YiR310BXAIs4DFhlpSjEiP66qeKJBNL9QbtMuLXGFVM8viMaev3AOsAIbRCgz
         QXoVIRQ7spVjQqG287/5xXH9rO8MXRkyO+Z34PcIYCVEpRQxlAHN4LmrbTqua3Q2Z4QF
         WRa5N18jcXPcFWFod8WSjVAgoSSzLkIlklibI=
Date: Tue, 28 Jul 2009 11:24:58 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Moussa Ba <moussa.a.ba@gmail.com>, linux-kernel@vger.kernel.org,
       xiyou.wangcong@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Matt Mackall <mpm@selenic.com>,
       Mel Gorman <mel@csn.ul.ie>, Ying Han <yinghan@google.com>,
       Nick Piggin <npiggin@suse.de>, jaredeh@gmail.com
Subject: Re: [PATCH 1/1] pagemap clear_refs: modify to specify anon or
	mapped vma clearing
Message-ID: <20090728032254.GA5889@cr0.nay.redhat.com>
References: <4A693122.6060503@gmail.com> <20090724083926.GA6372@cr0.nay.redhat.com> <4A6E0BD6.50102@gmail.com> <alpine.DEB.2.00.0907271339070.17425@chino.kir.corp.google.com> <7928e7bd0907271514y699d1de4j54f9c562b94ef0cc@mail.gmail.com> <alpine.DEB.2.00.0907271543420.23587@chino.kir.corp.google.com> <7928e7bd0907271638x5ddbfd2ckba2802338a33765a@mail.gmail.com> <alpine.DEB.2.00.0907271657160.27881@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0907271657160.27881@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 04:58:20PM -0700, David Rientjes wrote:
>On Mon, 27 Jul 2009, Moussa Ba wrote:
>
>> The other alternative would be to just forgo the additional function
>> clear_refs_walk_vma and rewrite the for loop as:
>> 
>>         for (vma = mm->mmap; vma; vma = vma->vm_next) {
>> 			clear_refs_walk.private = vma;
>> 			if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
>> 				continue;
>> 			if (is_vm_hugetlb_page(vma))
>> 				continue;
>> 			if (type == CLEAR_REFS_ANON && vma->vm_file)
>> 				continue;
>> 			if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
>> 				continue;
>> 			walk_page_range(vma->vm_start, vma->vm_end, this_walk);
>>         }
>> 
>
>That looks good, with the exception of the check for
>type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED being in the loop.

And also that it looks like is_vm_hugetlb_page() is already checked
outside, no need to check it again. :-)

Thanks.
