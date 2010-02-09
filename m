Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab0BITzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:55:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451Ab0BITzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:55:20 -0500
Date: Tue, 9 Feb 2010 11:54:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 04/35] x86/pci: amd one chain system to use pci read out
 res
Message-Id: <20100209115411.95cee659.akpm@linux-foundation.org>
In-Reply-To: <1265743966-17065-5-git-send-email-yinghai@kernel.org>
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
	<1265743966-17065-5-git-send-email-yinghai@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Feb 2010 11:32:15 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> --- a/arch/x86/pci/amd_bus.c
> +++ b/arch/x86/pci/amd_bus.c
> @@ -87,11 +87,12 @@ static int __init early_fill_mp_bus_info(void)
>  	struct range range[RANGE_NUM];
>  	u64 val;
>  	u32 address;
> +	int found;

It'd be clearer to give this the `bool' type.  After all, it's a bool.

>  
>  	if (!early_pci_allowed())
>  		return -1;
>  
> -	found_all_numa_early = 0;
> +	found = 0;
>  	for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
>  		u32 id;
>  		u16 device;
> @@ -105,12 +106,12 @@ static int __init early_fill_mp_bus_info(void)
>  		device = (id>>16) & 0xffff;
>  		if (pci_probes[i].vendor == vendor &&
>  		    pci_probes[i].device == device) {
> -			found_all_numa_early = 1;
> +			found = 1;
>  			break;
>  		}
>  	}
>  
> -	if (!found_all_numa_early)
> +	if (!found)
>  		return 0;
>  
>  	pci_root_num = 0;
