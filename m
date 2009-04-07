Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbZDGUDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbZDGUDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbZDGUDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:03:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5826 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbZDGUDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:03:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=cZzX5QZocl2nKTX6NdSnjiltB/f47PTqthvKRJ4d89PBgIeXd7DZYZfaxoSsLYoKv
	BuFTjmIb3/y5G4l6Nym4A==
MIME-Version: 1.0
In-Reply-To: <20090407072133.053995305@intel.com>
References: <20090407071729.233579162@intel.com>
	 <20090407072133.053995305@intel.com>
Date: Tue, 7 Apr 2009 13:03:36 -0700
Message-ID: <604427e00904071303g1d092eabp59fca0713ddacf82@mail.gmail.com>
Subject: Re: [PATCH 03/14] mm: remove FAULT_FLAG_RETRY dead code
From: Ying Han <yinghan@google.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 7, 2009 at 12:17 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> Cc: Ying Han <yinghan@google.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/memory.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> --- mm.orig/mm/memory.c
> +++ mm/mm/memory.c
> @@ -2766,10 +2766,8 @@ static int do_linear_fault(struct mm_str
>  {
>        pgoff_t pgoff = (((address & PAGE_MASK)
>                        - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> -       int write = write_access & ~FAULT_FLAG_RETRY;
> -       unsigned int flags = (write ? FAULT_FLAG_WRITE : 0);
> +       unsigned int flags = (write_access ? FAULT_FLAG_WRITE : 0);
>
> -       flags |= (write_access & FAULT_FLAG_RETRY);
>        pte_unmap(page_table);
>        return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
>  }
So, we got rid of FAULT_FLAG_RETRY flag?
> --
>
>
