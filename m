Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbYFPHAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbYFPHAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYFPG7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:59:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:59839 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbYFPG7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:59:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,651,1204531200"; 
   d="scan'208";a="260944756"
Subject: Re: [PATCH 5/8] x86 boot: remap efi systab runtime from phys to
	virt
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Jack Steiner <steiner@sgi.com>,
       Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080616063006.14597.73386.sendpatchset@polaris-admin.engr.sgi.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	 <20080616063006.14597.73386.sendpatchset@polaris-admin.engr.sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 16 Jun 2008 15:02:39 +0800
Message-Id: <1213599759.11185.7.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 16 Jun 2008 06:59:42.0105 (UTC) FILETIME=[8D274890:01C8CF7E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-15 at 23:30 -0700, Paul Jackson wrote:
> From: Paul Jackson <pj@sgi.com>
> 
> One more efi entry needs its address converted from physical
> to virtual during boot: efi.systab->runtime.
> 
> Signed-off-by: Paul Jackson <pj@sgi.com>
> 
> ---
>  arch/x86/kernel/efi.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux.orig/arch/x86/kernel/efi.c	2008-06-13 00:53:10.053599898 -0700
> +++ linux/arch/x86/kernel/efi.c	2008-06-13 00:53:21.762309008 -0700
> @@ -486,6 +486,7 @@ void __init efi_enter_virtual_mode(void)
>  		if (md->phys_addr <= systab && systab < end) {
>  			systab += md->virt_addr - md->phys_addr;
>  			efi.systab = (efi_system_table_t *) (unsigned long) systab;
> +			efi.systab->runtime = __va(efi.systab->runtime);
>  		}
>  	}

Why do you need this? This should be done by firmware in
efi_set_virtual_address_map(). And this doesn't work on i386, because
runtime code/data area may be not in identity map area (that is > 768M).
even on x86_64, runtime code/data area can be non-identity mapped (For
example identity map is restricted by mem=xxx kernel parameter). Same
problem for

[PATCH 6/8] x86 boot: virtualize the efi runtime function callback
addresses

Best Regards,
Huang Ying

