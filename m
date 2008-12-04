Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbYLDM2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbYLDM2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYLDM2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:28:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:9730 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbYLDM2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:28:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,715,1220252400"; 
   d="scan'208";a="86415998"
Date: Thu, 4 Dec 2008 20:28:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: 2.6.28-rc6: early panic with boot option "nosmp"
Message-ID: <20081204122817.GA14840@localhost>
References: <20081204022806.GA29293@localhost> <20081204101343.GO6703@one.firstfloor.org> <20081204120214.GA30833@localhost> <20081204123335.GP6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204123335.GP6703@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 02:33:35PM +0200, Andi Kleen wrote:
> > The exception raised on dereferencing mpf or mpf_found.
> 
> This obvious patch should fix it then. Does it?

Yes, it boots OK now with your patch.

Thanks,
Fengguang

> --
> 
> Fix early exception in __get_smp_config with nosmp
> 
> Bail out early when there is no MP table.
> 
> Reported by Wu Fengguang
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  arch/x86/kernel/mpparse.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6.28-rc4-test/arch/x86/kernel/mpparse.c
> ===================================================================
> --- linux-2.6.28-rc4-test.orig/arch/x86/kernel/mpparse.c	2008-10-24 13:34:40.000000000 +0200
> +++ linux-2.6.28-rc4-test/arch/x86/kernel/mpparse.c	2008-12-04 13:20:34.000000000 +0100
> @@ -604,6 +604,9 @@
>  		printk(KERN_INFO "Using ACPI for processor (LAPIC) "
>  		       "configuration information\n");
>  
> +	if (!mpf)
> +		return;
> +
>  	printk(KERN_INFO "Intel MultiProcessor Specification v1.%d\n",
>  	       mpf->mpf_specification);
>  #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
