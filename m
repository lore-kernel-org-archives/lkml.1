Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbXKEFga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbXKEFga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 00:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbXKEFgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 00:36:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:37382 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbXKEFgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 00:36:23 -0500
Subject: Re: [PATCH 3/6]] POWERPC: fix memset size error
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <472E7E44.6000807@cn.fujitsu.com>
References: <472E7E44.6000807@cn.fujitsu.com>
Content-Type: text/plain
Date: Mon, 05 Nov 2007 16:35:57 +1100
Message-Id: <1194240957.6511.44.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-11-05 at 10:21 +0800, Li Zefan wrote:
> The size passing to memset is wrong.
> 
> Signed-off-by Li Zefan <lizf@cn.fujitsu.com>

Good catch, looks like a remain of when path was an array on the stack.

Thanks !

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> 
> ---
>  arch/powerpc/kernel/prom_init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
> index 1db10f7..1add6ef 100644
> --- a/arch/powerpc/kernel/prom_init.c
> +++ b/arch/powerpc/kernel/prom_init.c
> @@ -1244,7 +1244,7 @@ static void __init prom_initialize_tce_table(void)
>  			local_alloc_bottom = base;
>  
>  		/* It seems OF doesn't null-terminate the path :-( */
> -		memset(path, 0, sizeof(path));
> +		memset(path, 0, PROM_SCRATCH_SIZE);
>  		/* Call OF to setup the TCE hardware */
>  		if (call_prom("package-to-path", 3, 1, node,
>  			      path, PROM_SCRATCH_SIZE-1) == PROM_ERROR) {

