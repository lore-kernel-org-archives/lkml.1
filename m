Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbXLEKk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbXLEKk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbXLEKkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:40:21 -0500
Received: from il.qumranet.com ([82.166.9.18]:58517 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbXLEKkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:40:20 -0500
Message-ID: <47568011.1080409@qumranet.com>
Date: Wed, 05 Dec 2007 12:40:17 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: npiggin@suse.de
CC: akpm@linux-foundation.org, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 05/18] kvm: nopage
References: <20071205071547.701344000@nick.local0.net> <20071205071627.251516000@nick.local0.net>
In-Reply-To: <20071205071627.251516000@nick.local0.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

npiggin@suse.de wrote:
> Convert KVM from nopage to fault.
>
>   

> @@ -3111,27 +3105,21 @@ out:
>  	return r;
>  }
>  
> -static struct page *kvm_vm_nopage(struct vm_area_struct *vma,
> -				  unsigned long address,
> -				  int *type)
> +static int kvm_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
>  	struct kvm *kvm = vma->vm_file->private_data;
> -	unsigned long pgoff;
>  	struct page *page;
>  
> -	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> -	page = gfn_to_page(kvm, pgoff);
> +	page = gfn_to_page(kvm, vmf->pgoff);
>  	if (!page)
> -		return NOPAGE_SIGBUS;
> +		return VM_FAULT_SIGBUS;
>  	get_page(page);
> -	if (type != NULL)
> -		*type = VM_FAULT_MINOR;
> -
> -	return page;
> +	vmf->page = page;
> +	return 0;
>  }
>  
>   

This part has changed in kvm.git, so this won't apply to -mm.  I ported 
it and applied to my tree, so it should arrive in -mm when Andrew 
re-fetches.

-- 
error compiling committee.c: too many arguments to function

