Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZKIM3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZKIM3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZKIM3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:29:13 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:39092 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbZKIM3M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:29:12 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zba6lz1432R98dNzz1202hzzz32i176h6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KSUDC9-03-CL1-02
X-M-MSG: 
Date: Mon, 9 Nov 2009 13:29:19 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Yong Wang <yong.y.wang@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] x86: under bios control, restore AP's APIC_LVTTHMR
 to the BSP value
Message-ID: <20091109122919.GA32321@aftab>
References: <20091109114752.GA3896@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20091109114752.GA3896@ywang-moblin2.bj.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 09 Nov 2009 12:28:56.0417 (UTC) FILETIME=[34BA5510:01CA6138]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 07:47:52PM +0800, Yong Wang wrote:

[..]

> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 0a64353..e6f0ef9 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -110,6 +110,7 @@
>  #ifdef CONFIG_X86_64
>  #include <asm/numa_64.h>
>  #endif
> +#include <asm/mce.h>
>  
>  /*
>   * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
> @@ -1040,6 +1041,8 @@ void __init setup_arch(char **cmdline_p)
>  #endif
>  #endif
>  	x86_init.oem.banner();
> +
> +	mcheck_init();

I think you need

#ifdef CONFIG_X86_MCE
...
#endif

here for cases where mcheck is config-disabled, no?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

