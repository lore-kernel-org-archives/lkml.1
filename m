Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbXFNRt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbXFNRt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbXFNRtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:49:21 -0400
Received: from mx28.mail.ru ([194.67.23.67]:29886 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbXFNRtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:49:20 -0400
Date: Thu, 14 Jun 2007 21:50:59 +0400
From: Evgeniy Dushistov <dushistov@mail.ru>
To: vignesh babu <vignesh.babu@wipro.com>, akpm@linux-foundation.org
Cc: daniel.pirkl@email.cz, linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>
Subject: Re: [PATCH]is_power_of_2-ufs/super.c
Message-ID: <20070614175059.GA11508@rain>
Mail-Followup-To: vignesh babu <vignesh.babu@wipro.com>,
	akpm@linux-foundation.org, daniel.pirkl@email.cz,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Kernel Janitors List <kernel-janitors@lists.osdl.org>
References: <1181808559.2474.9.camel@merlin.linuxcoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181808559.2474.9.camel@merlin.linuxcoe.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 01:39:18PM +0530, vignesh babu wrote:
> 
> 
> Replacing (n & (n-1)) in the context of power of 2 checks
> with is_power_of_2
> 
> Signed-off-by: vignesh babu <vignesh.babu@wipro.com>

Acked-by: Evgeniy Dushistov <dushistov@mail.ru>

> --- 
> diff --git a/fs/ufs/super.c b/fs/ufs/super.c
> index 22ff6ed..2b30116 100644
> --- a/fs/ufs/super.c
> +++ b/fs/ufs/super.c
> @@ -87,6 +87,7 @@
>  #include <linux/smp_lock.h>
>  #include <linux/buffer_head.h>
>  #include <linux/vfs.h>
> +#include <linux/log2.h>
>  
>  #include "swab.h"
>  #include "util.h"
> @@ -854,7 +855,7 @@ magic_found:
>  	uspi->s_fmask = fs32_to_cpu(sb, usb1->fs_fmask);
>  	uspi->s_fshift = fs32_to_cpu(sb, usb1->fs_fshift);
>  
> -	if (uspi->s_fsize & (uspi->s_fsize - 1)) {
> +	if (!is_power_of_2(uspi->s_fsize)) {
>  		printk(KERN_ERR "ufs_read_super: fragment size %u is not a power of 2\n",
>  			uspi->s_fsize);
>  			goto failed;
> @@ -869,7 +870,7 @@ magic_found:
>  			uspi->s_fsize);
>  		goto failed;
>  	}
> -	if (uspi->s_bsize & (uspi->s_bsize - 1)) {
> +	if (!is_power_of_2(uspi->s_bsize)) {
>  		printk(KERN_ERR "ufs_read_super: block size %u is not a power of 2\n",
>  			uspi->s_bsize);
>  		goto failed;
> 
> -- 
> Vignesh Babu BM 
> _____________________________________________________________ 
> "Why is it that every time I'm with you, makes me believe in magic?"
> 
> 
> 
> The information contained in this electronic message and any attachments to this message are intended for the exclusive use of the addressee(s) and may contain proprietary, confidential or privileged information. If you are not the intended recipient, you should not disseminate, distribute or copy this e-mail. Please notify the sender immediately and destroy all copies of this message and any attachments. 
> 
> WARNING: Computer viruses can be transmitted via email. The recipient should check this email and any attachments for the presence of viruses. The company accepts no liability for any damage caused by any virus transmitted by this email.
>  
> www.wipro.com

-- 
/Evgeniy

