Return-Path: <linux-kernel-owner+w=401wt.eu-S1760279AbXKTHzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279AbXKTHzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 02:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759434AbXKTHzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 02:55:37 -0500
Received: from www.tglx.de ([62.245.132.106]:38923 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759332AbXKTHzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 02:55:36 -0500
Date: Tue, 20 Nov 2007 08:55:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Travis <travis@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 1/1] x86: convert-cpuinfo_x86-array-to-a-per_cpu-array
 fix
In-Reply-To: <473B423B.6030400@sgi.com>
Message-ID: <alpine.LFD.0.9999.0711200848160.7601@localhost.localdomain>
References: <20071012225433.928899000@sgi.com> <20071012225434.102879000@sgi.com> <473B423B.6030400@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007, Mike Travis wrote:

> Hi Andrew,
> 
> It appears that this patch is missing from the latest 2.6.24 git kernel?
> 
> (Suresh noticed that it is still a problem.)
> 
> Thanks,
> Mike
> 
> This fix corrects the problem that early_identify_cpu() sets
> cpu_index to '0' (needed when called by setup_arch) after
> smp_store_cpu_info() had set it to the correct value.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
>  arch/x86_64/kernel/smpboot.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux.orig/arch/x86_64/kernel/smpboot.c	2007-10-12 14:28:45.000000000 -0700
> +++ linux/arch/x86_64/kernel/smpboot.c	2007-10-12 14:53:42.753508152 -0700
> @@ -141,8 +141,8 @@ static void __cpuinit smp_store_cpu_info
>  	struct cpuinfo_x86 *c = &cpu_data(id);
>  
>  	*c = boot_cpu_data;
> -	c->cpu_index = id;
>  	identify_cpu(c);
> +	c->cpu_index = id;
>  	print_cpu_info(c);
>  }

The correct fix is already in mainline:

commit 699d934d5f958d7944d195c03c334f28cc0b3669

	tglx
