Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbZJMBWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbZJMBWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 21:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757079AbZJMBWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 21:22:16 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:49788 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755575AbZJMBWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 21:22:15 -0400
Subject: Re: [PATCH] x86: avoid modifying global flag tsc_unstable in
	unsychronized_tsc()
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "Hillier, Gernot" <gernot.hillier@siemens.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4AD33BB0.8080903@siemens.com>
References: <4AD33BB0.8080903@siemens.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 12 Oct 2009 18:21:39 -0700
Message-Id: <1255396899.31156.71.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-10-12 at 07:22 -0700, Hillier, Gernot wrote:
> From: Gernot Hillier <gernot.hillier@siemens.com>
> 
> The current behavior of unsynchronized_tsc() prevents the warning for
> unsychronized TSCs to be printed: tsc_init() calls unsynchronized_tsc()
> first to check for such problems; if found, mark_tsc_unstable() is
> called. However, the latter bails out immediately as unsynchronized_
> tsc() did already set the global flag tsc_unstable. Thus, the intended
> warning message "Marking TSC unstable due to TSCs unsynchronized" won't
> show up.
> 
> This patch changes the behavior for unsynchronized_tsc() to only *check*
> for the quirk condition, but not to modify any global flags. If I'm not
> mistaken, the only place to *set* the flag shall be mark_tsc_unstable().

Yes, you are right. The patch looks good to me.

Thanks,
Alok

> 
> Signed-off-by: Gernot Hillier <gernot.hillier@siemens.com>
> Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
> Reviewed-by: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index cd982f4..ffbb786 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -836,10 +836,10 @@ __cpuinit int unsynchronized_tsc(void)
>  	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
>  		/* assume multi socket systems are not synchronized: */
>  		if (num_possible_cpus() > 1)
> -			tsc_unstable = 1;
> +			return 1;
>  	}
> 
> -	return tsc_unstable;
> +	return 0;
>  }
> 
>  static void __init init_tsc_clocksource(void)
> 

