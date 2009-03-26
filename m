Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbZCZNNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbZCZNNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756630AbZCZNNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:13:33 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:56767 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757517AbZCZNNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:13:31 -0400
X-BigFish: VPS-37(zz1432R62a3L98dR936eQ1805M936fKzz1202hzz5a6ciz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KH47D1-03-EOE-01
Date: Thu, 26 Mar 2009 14:12:36 +0100
From: Robert Richter <robert.richter@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -tip] x86: unification of cpu/bugs.c
Message-ID: <20090326131236.GE3226@erda.amd.com>
References: <1238068930.2507.1.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1238068930.2507.1.camel@ht.satnam>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 26 Mar 2009 13:12:37.0382 (UTC) FILETIME=[88C2DA60:01C9AE14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.03.09 17:32:09, Jaswinder Singh Rajput wrote:
> This patch is based on -tip x86/core:
> 
> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Thu, 26 Mar 2009 17:14:38 +0530
> Subject: [PATCH] x86: unification of cpu/bugs.c
> 
> Impact: Unification, cleanup
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/cpu/Makefile  |    5 +--
>  arch/x86/kernel/cpu/bugs.c    |   74 ++++++++++++++++++++++++++--------------
>  arch/x86/kernel/cpu/bugs_64.c |   33 ------------------
>  3 files changed, 50 insertions(+), 62 deletions(-)
>  delete mode 100644 arch/x86/kernel/cpu/bugs_64.c

Jaswinder,

please send separate patches for separate changes (e.g. make separate
whitespace changes).

[...]

> @@ -91,14 +98,14 @@ static void __init check_hlt(void)
>  
>  	printk(KERN_INFO "Checking 'hlt' instruction... ");
>  	if (!boot_cpu_data.hlt_works_ok) {
> -		printk("disabled\n");
> +		printk(KERN_INFO "disabled\n");

All this is continuing the printk above.

-Robert

>  		return;
>  	}
>  	halt();
>  	halt();
>  	halt();
>  	halt();
> -	printk("OK.\n");
> +	printk(KERN_INFO "OK.\n");
>  }
>  
>  /*
> @@ -122,9 +129,9 @@ static void __init check_popad(void)
>  	 * CPU hard. Too bad.
>  	 */
>  	if (res != 12345678)
> -		printk("Buggy.\n");
> +		printk(KERN_INFO "Buggy.\n");
>  	else
> -		printk("OK.\n");
> +		printk(KERN_INFO "OK.\n");
>  #endif
>  }
>  

[...]

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

