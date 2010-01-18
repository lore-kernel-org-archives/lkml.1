Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211Ab0ARDKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab0ARDKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 22:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974Ab0ARDKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 22:10:34 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57990 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab0ARDKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 22:10:33 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH -mmotm-2010-01-15-15-34] Fix wrong offset for vma merge in mbind
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <1263658528.2162.6.camel@barrios-desktop>
References: <1263658528.2162.6.camel@barrios-desktop>
Message-Id: <20100118120957.AE42.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 18 Jan 2010 12:10:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> mm-fix-mbind-vma-merge-problem.patch added vma_merge in mbind
> to merge mergeable vmas.
> But it passed wrong offset of vm_file.
> 
> This patch fixes it.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Nice catch!
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> ---
>  mm/mempolicy.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 9751f3f..7e529d0 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -570,6 +570,7 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
>  	struct vm_area_struct *prev;
>  	struct vm_area_struct *vma;
>  	int err = 0;
> +	pgoff_t pgoff;
>  	unsigned long vmstart;
>  	unsigned long vmend;
>  
> @@ -582,9 +583,9 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
>  		vmstart = max(start, vma->vm_start);
>  		vmend   = min(end, vma->vm_end);
>  
> +		pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
>  		prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
> -				  vma->anon_vma, vma->vm_file, vma->vm_pgoff,
> -				  new_pol);
> +				  vma->anon_vma, vma->vm_file, pgoff, new_pol);
>  		if (prev) {
>  			vma = prev;
>  			next = vma->vm_next;
> -- 
> 1.6.3.3
> 
> 
> 
> -- 
> Kind regards,
> Minchan Kim
> 



