Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbZCPC7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbZCPC7t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 22:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZCPC7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 22:59:35 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:65244 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZCPC7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 22:59:34 -0400
Date: Sun, 15 Mar 2009 22:59:19 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>, Zhao Yakui <yakui.zhao@intel.com>
Subject: Re: [PATCH] ACPI: pass correct parameter to
 acpi_processor_ffh_cstate_probe_cpu()
In-reply-to: <20090312074524.GA15992@localhost>
Message-id: <alpine.LFD.2.00.0903152257260.30317@localhost.localdomain>
References: <20090312074524.GA15992@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009, Wu Fengguang wrote:

> This fixes a NULL pointer dereference bug introduced by 6e911954cac.

What tree is this patch on top of?

thanks,
-Len Brown
Intel Open Source Technology Center

> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
> diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
> index 6626e8c..b866b87 100644
> --- a/arch/x86/kernel/acpi/cstate.c
> +++ b/arch/x86/kernel/acpi/cstate.c
> @@ -137,7 +137,7 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
>  	/* Run acpi_processor_ffh_cstate_probe_cpu() on the target CPU */
>  
>  	retval = smp_call_function_single(cpu,
> -				acpi_processor_ffh_cstate_probe_cpu, cx, 1);
> +				acpi_processor_ffh_cstate_probe_cpu, &cxcc, 1);
>  	if (retval == 0) {
>  		retval = cxcc.retval;
>  		if (retval == 0) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
