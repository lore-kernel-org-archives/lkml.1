Return-Path: <linux-kernel-owner+w=401wt.eu-S1763731AbZFQBKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763731AbZFQBKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 21:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760142AbZFQBKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 21:10:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:32298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759805AbZFQBKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 21:10:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,233,1243839600"; 
   d="scan'208";a="700031643"
Subject: Re: [PATCH] x86: efi/e820 table merge fix
From: Huang Ying <ying.huang@intel.com>
To: Cliff Wickman <cpw@sgi.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "yinghai@kernel.org" <yinghai@kernel.org>
In-Reply-To: <E1MGgRQ-0002pu-6Z@eag09.americas.sgi.com>
References: <E1MGgRQ-0002pu-6Z@eag09.americas.sgi.com>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 09:10:05 +0800
Message-Id: <1245201005.11965.4.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 05:43 +0800, Cliff Wickman wrote:
> From: Cliff Wickman <cpw@sgi.com>
> --- linux.orig/arch/x86/kernel/efi.c
> +++ linux/arch/x86/kernel/efi.c
> @@ -240,10 +240,35 @@ static void __init do_add_efi_memmap(voi
>  		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
>  		int e820_type;
>  
> -		if (md->attribute & EFI_MEMORY_WB)
> -			e820_type = E820_RAM;
> -		else
> +		switch (md->type) {
> +		case EFI_LOADER_CODE:
> +		case EFI_LOADER_DATA:
> +		case EFI_BOOT_SERVICES_CODE:
> +		case EFI_BOOT_SERVICES_DATA:
> +		case EFI_CONVENTIONAL_MEMORY:
> +			if (md->attribute & EFI_MEMORY_WB)
> +				e820_type = E820_RAM;
> +			else
> +				e820_type = E820_RESERVED;
> +			break;

Why does BIOS mark memory region without EFI_MEMORY_WB as these types?
Any example?

Best Regards,
Huang Ying


