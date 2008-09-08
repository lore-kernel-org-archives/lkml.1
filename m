Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbYIHDui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbYIHDui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 23:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYIHDub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 23:50:31 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:32684 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYIHDua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 23:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uQ0CKCn5d+WQvNtPKhLRBuPTBHZiTbVsXpVuB8sU4c+sZzVLt+i+METb3UXAEhDjWn
         1/UI4GxgyfpjdbozkMBGKYm4/qy2ErnwKnqi1+EmOKFQPZE3Uw/qIBgzNXMifrMbmDvF
         c0seREUeqbg5rouRAgReIW2JNyMGhQ1Ag1nEA=
Message-ID: <48C4A0FF.8070705@gmail.com>
Date: Mon, 08 Sep 2008 11:50:23 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: hamid.jahanjou@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
References: <48BFCECE.90103@gmail.com>
In-Reply-To: <48BFCECE.90103@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hamid R. Jahanjou 写道:
> From: Hamid R. Jahanjou
>
> Implements the idea of swap-out page clustering from *BSD for
> Linux. Each time a candidate page is to be swapped out,
> virtually-nearby pages are scanned to find eligible pages to be
> swapped out too as a cluster. This technique increases the likelihood of
> bringing in related data on a page fault and decreases swap space
> fragmentation in the long run. Currently, Linux searches only
> physically-nearby pages which is not optimal since, over time, physically-
> adjacent pages may become unrelated.
>
> The code can be statically tuned. No benchmarks. I'm not sure whether
> the added complexity is acceptable.
>
> Signed-off-by: Hamid R. Jahanjou <hamid.jahanjou@gmail.com>
> [snip a lot of code here]
> +
> +	for(vm_address = cursor_vma->vm_start; 
> +	    vm_address < cursor_vma->vm_end && ci->nr_collected < ci->cluster_size; 
> +	    vm_address += PAGE_SIZE)
> +	{
> +	    cursor_page = virt_to_page(vm_address);
>   

I do not think that the virt_to_page() can work well on userland virtual 
address space.
And the linear searching for whole address space of a vma is not good 
idea too, really.

> +	    if (!page_allowed_in_cluster(cursor_page, ci))
> +		continue;
>
>   

