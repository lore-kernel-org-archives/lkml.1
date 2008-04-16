Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYDPTkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYDPTkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYDPTkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:40:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:45259 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbYDPTkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:40:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WLp8gMTRHhY2RUld/XToVJfOZt84n7OFrWfp85w4iTSrM2T4hZEFt6hjg0KTMK9z7gxrHj3Xf58VqYsPoJUZDabuUg8gq25kcJggayby7ZT341cKk/CDt3UH6D0GzB3rhFSHPSMDp9fTgVqD99Y8OiCz9D8tnkVUfmltjGLB5gk=
Date: Wed, 16 Apr 2008 21:39:44 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] MIPS: irixelf: fix test unsigned var < 0
Message-ID: <20080416193941.GB6264@joi>
References: <480558CA.7090800@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480558CA.7090800@tiscali.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 03:39:22AM +0200, Roel Kluin wrote:
> v is unsigned, cast to signed to evaluate the do_brk() return value,
>     
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/arch/mips/kernel/irixelf.c b/arch/mips/kernel/irixelf.c
> index 290d8e3..fad2a2a 100644
> --- a/arch/mips/kernel/irixelf.c
> +++ b/arch/mips/kernel/irixelf.c
> @@ -583,15 +583,15 @@ static void irix_map_prda_page(void)
>  	unsigned long v;
>  	struct prda *pp;
>  
>  	down_write(&current->mm->mmap_sem);
>  	v =  do_brk(PRDA_ADDRESS, PAGE_SIZE);
>  	up_write(&current->mm->mmap_sem);
>  
> -	if (v < 0)
> +	if ((long) v < 0)
maybe cast it earlier (to struct prda *) and check error with IS_ERR?

>  		return;
>  
>  	pp = (struct prda *) v;
>  	pp->prda_sys.t_pid  = task_pid_vnr(current);
>  	pp->prda_sys.t_prid = read_c0_prid();
>  	pp->prda_sys.t_rpid = task_pid_vnr(current);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
