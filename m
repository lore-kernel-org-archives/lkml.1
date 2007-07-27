Return-Path: <linux-kernel-owner+w=401wt.eu-S935882AbXG0KQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935882AbXG0KQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 06:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbXG0KQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 06:16:27 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:42446 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbXG0KQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 06:16:26 -0400
X-IronPort-AV: i="4.16,588,1175486400"; 
   d="scan'208"; a="46664811:sNHT26462142"
Subject: Re: [PATCH 04/68] 0 -> NULL, for arch/blackfin
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Yoann Padioleau <padator@wanadoo.fr>
Cc: kernel-janitors@vger.kernel.org, aubrey.li@analog.com, bryan.wu@analog.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200707270944.LAA17116@ifs.emn.fr>
References: <200707270944.LAA17116@ifs.emn.fr>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 27 Jul 2007 18:23:44 +0800
Message-Id: <1185531824.11601.25.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 27 Jul 2007 10:16:25.0207 (UTC) FILETIME=[3018F870:01C7D037]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 11:44 +0200, Yoann Padioleau wrote:
> When comparing a pointer, it's clearer to compare it to NULL than to 0.
> 
> Here is an excerpt of the semantic patch: 
> 
> @@
> expression *E;
> @@
> 
>   E ==
> - 0
> + NULL
> 
> @@
> expression *E;
> @@
> 
>   E !=
> - 0
> + NULL
> 
> Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
> Cc: aubrey.li@analog.com
> Cc: bryan.wu@analog.com
> Cc: akpm@linux-foundation.org
> ---
> 
>  traps.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
> index 3909f5b..691c66d 100644
> --- a/arch/blackfin/kernel/traps.c
> +++ b/arch/blackfin/kernel/traps.c
> @@ -546,7 +546,7 @@ void dump_bfin_regs(struct pt_regs *fp, 
>  	}
>  
>  	printk(KERN_EMERG "return address: [0x%p]; contents of:", retaddr);
> -	if (retaddr != 0 && retaddr <= (void *)physical_mem_end
> +	if (retaddr != NULL && retaddr <= (void *)physical_mem_end
>  #if L1_CODE_LENGTH != 0
>  	    /* FIXME: Copy the code out of L1 Instruction SRAM through dma
>  	       memcpy.  */

Why not just use " if (!E)" instead of " if (E != NULL)"?
more readable?

Thanks
- Bryan Wu
