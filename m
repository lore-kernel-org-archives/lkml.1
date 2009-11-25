Return-Path: <linux-kernel-owner+w=401wt.eu-S1751716AbZKYG0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbZKYG0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 01:26:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbZKYG0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 01:26:01 -0500
Received: from dalsmrelay2.nai.com ([205.227.136.216]:57579 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751194AbZKYG0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 01:26:01 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2009 01:26:00 EST
Date: Wed, 25 Nov 2009 16:19:19 +1000
From: David McCullough <David_Mccullough@securecomputing.com>
To: uClinux development list <uclinux-dev@uclinux.org>
CC: David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Jie Zhang <jie.zhang@analog.com>
Subject: Re: [uClinux-dev] [PATCH] NOMMU: use copy_*_user_page() in
 access_process_vm()
Message-ID: <20091125061919.GA23663@mcafee.com>
References: <1259128503-28276-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1259128503-28276-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 25 Nov 2009 06:20:18.0999 (UTC) FILETIME=[5C542C70:01CA6D97]
X-NAI-Spam-Flag: NO
X-NAI-Spam-Threshold: 5
X-NAI-Spam-Score: 0
X-NAI-Spam-Version: 2.2.0.9149 : core <3413> : streams <317463> : uri <47796
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jivin Mike Frysinger lays it down ...
> From: Jie Zhang <jie.zhang@analog.com>
> 
> The mmu code uses the copy_*_user_page() variants in access_process_vm()
> rather than copy_*_user() as the former includes an icache flush.  This is
> important when doing things like setting software breakpoints with gdb.
> So switch the nommu code over to do the same.
> 
> Signed-off-by: Jie Zhang <jie.zhang@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: David McCullough <david_mccullough@mcafee.com>

Cheers,
Davidm

> ---
>  mm/nommu.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 9876fa0..51ae9be 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1889,9 +1889,11 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
>  
>  		/* only read or write mappings where it is permitted */
>  		if (write && vma->vm_flags & VM_MAYWRITE)
> -			len -= copy_to_user((void *) addr, buf, len);
> +			copy_to_user_page(vma, NULL, NULL,
> +					  (void *) addr, buf, len);
>  		else if (!write && vma->vm_flags & VM_MAYREAD)
> -			len -= copy_from_user(buf, (void *) addr, len);
> +			copy_from_user_page(vma, NULL, NULL,
> +					    buf, (void *) addr, len);
>  		else
>  			len = 0;
>  	} else {
> -- 
> 1.6.5.3
> 
> _______________________________________________
> uClinux-dev mailing list
> uClinux-dev@uclinux.org
> http://mailman.uclinux.org/mailman/listinfo/uclinux-dev
> This message was resent by uclinux-dev@uclinux.org
> To unsubscribe see:
> http://mailman.uclinux.org/mailman/options/uclinux-dev
> 
> 

-- 
David McCullough,  david_mccullough@securecomputing.com,  Ph:+61 734352815
McAfee - SnapGear  http://www.snapgear.com                http://www.uCdot.org
