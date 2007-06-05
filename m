Return-Path: <linux-kernel-owner+w=401wt.eu-S1761021AbXFESRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761021AbXFESRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbXFESRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:17:25 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59879 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050AbXFESRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:17:24 -0400
Subject: Re: [PATCH 2/3] [PATCH powerpc] during VM oom condition, kill all
	threads in process group
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: linux-kernel@vger.kernel.org
Cc: anton@samba.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20070605174838.21740.55720.stgit@farscape.rchland.ibm.com>
References: <20070605174831.21740.33119.stgit@farscape.rchland.ibm.com>
	 <20070605174838.21740.55720.stgit@farscape.rchland.ibm.com>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 13:17:14 -0500
Message-Id: <1181067435.18837.3.camel@farscape.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Whoops..  sorry about any reply bounces, I flubbed the cc to
linuxppc-dev@ozlabs.org . 

-Will

On Tue, 2007-05-06 at 12:48 -0500, Will Schmidt wrote:
> When we get into a state where VM has ran out of memory, and it's time to
> thwack a process, we should take out the entire process group, rather than
> just one thread.
> 
> Tested on POWER5.
> 
> Signed-off-by: Will Schmidt <will_schmidt@vnet.ibm.com>
> ---
> 
>  arch/powerpc/mm/fault.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
> index 03aeb3a..9afe871 100644
> --- a/arch/powerpc/mm/fault.c
> +++ b/arch/powerpc/mm/fault.c
> @@ -392,8 +392,10 @@ out_of_memory:
>  		goto survive;
>  	}
>  	printk("VM: killing process %s\n", current->comm);
> -	if (user_mode(regs))
> +	if (user_mode(regs)) {
> +		zap_other_threads(current);
>  		do_exit(SIGKILL);
> +	}
>  	return SIGKILL;
>  
>  do_sigbus:
> 
> 

