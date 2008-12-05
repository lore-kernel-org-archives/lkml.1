Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbYLEIo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbYLEIo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbYLEIoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:44:18 -0500
Received: from brick.kernel.dk ([93.163.65.50]:26701 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbYLEIoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:44:18 -0500
Date: Fri, 5 Dec 2008 09:44:11 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: next-2008-12-04: vm.bio_inline_vecs
Message-ID: <20081205084410.GZ18255@kernel.dk>
References: <20081204200745.eff0ac87.sfr@canb.auug.org.au> <20081205070642.GA31087@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205070642.GA31087@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05 2008, Alexey Dobriyan wrote:
> Please, merge into 4d539d965767b98582fa9b7b57f51dbc0ab54fc4
> aka "bio: add experimental support for inlining a number of bio_vecs inside the bio"
> 
> kernel/sysctl.c:1233: error: 'bio_inline_vecs' undeclared here (not in a function)

Thanks, Randy Dunlap also made me aware of this fact. I'll update the
original patch.

> 
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1227,6 +1227,7 @@ static struct ctl_table vm_table[] = {
>  		.extra2		= &one,
>  	},
>  #endif
> +#ifdef CONFIG_BLOCK
>  	{
>  		.ctl_name	= CTL_UNNUMBERED,
>  		.procname	= "bio_inline_vecs",
> @@ -1237,6 +1238,7 @@ static struct ctl_table vm_table[] = {
>  		.strategy	= &sysctl_intvec,
>  		.extra1		= &zero,
>  	},
> +#endif
>  /*
>   * NOTE: do not add new entries to this table unless you have read
>   * Documentation/sysctl/ctl_unnumbered.txt

-- 
Jens Axboe

