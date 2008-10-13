Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbYJMVXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbYJMVXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272AbYJMVWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:22:55 -0400
Received: from h155.mvista.com ([63.81.120.158]:27715 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759945AbYJMVWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:22:54 -0400
Message-ID: <48F3BC2E.5030601@ct.jp.nec.com>
Date: Mon, 13 Oct 2008 14:22:54 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/io_apic_32: fix printk format warning
References: <20081011234130.GE25563@orion>
In-Reply-To: <20081011234130.GE25563@orion>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov wrote:
> arch/x86/kernel/io_apic_32.c: In function 'print_local_APIC':
> arch/x86/kernel/io_apic_32.c:1539: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
> arch/x86/kernel/io_apic_32.c:1540: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
> 
>  arch/x86/kernel/io_apic_32.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
> index e710289..f678d12 100644
> --- a/arch/x86/kernel/io_apic_32.c
> +++ b/arch/x86/kernel/io_apic_32.c
> @@ -1536,8 +1536,8 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
>  	}
>  
>  	icr = apic_icr_read();
> -	printk(KERN_DEBUG "... APIC ICR: %08x\n", icr);
> -	printk(KERN_DEBUG "... APIC ICR2: %08x\n", icr >> 32);
> +	printk(KERN_DEBUG "... APIC ICR: %08x\n", (unsigned int)icr);
> +	printk(KERN_DEBUG "... APIC ICR2: %08x\n", (unsigned int)(icr >> 32));

looks good, but I think casting to u32 is better, because u32 is used in io_apic_64.c.

thanks,
Hiroshi Shimamoto
