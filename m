Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbYFNSm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbYFNSm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 14:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbYFNSmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 14:42:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYFNSmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 14:42:15 -0400
Message-ID: <485410E8.5050904@zytor.com>
Date: Sat, 14 Jun 2008 11:41:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanup reloated_initrd
References: <200806132005.45836.yhlu.kernel@gmail.com> <200806132007.03576.yhlu.kernel@gmail.com>
In-Reply-To: <200806132007.03576.yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 1. move that before zone_sizes_init ...
> 2. add free_early for one old one, otherwise it will be be reserved again when
>    init highmem.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> Index: linux-2.6/arch/x86/kernel/setup_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/setup_32.c
> +++ linux-2.6/arch/x86/kernel/setup_32.c
> @@ -585,6 +585,9 @@ static void __init relocate_initrd(void)
>  	printk(KERN_INFO "Copied RAMDISK from %016llx - %016llx to %08llx - %08llx\n",
>  		ramdisk_image, ramdisk_image + ramdisk_size - 1,
>  		ramdisk_here, ramdisk_here + ramdisk_size - 1);
> +
> +	/* need to free that, otherwise init highmem will reserve it again */
> +	free_early(ramdisk_image, ramdisk_image+ramdisk_size);
>  }
>  

I'm somewhat confused by this... you realize that the old location and 
the new location of the initrd will overlap, right?

	-hpa
