Return-Path: <linux-kernel-owner+w=401wt.eu-S933869AbXCFClH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933869AbXCFClH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933867AbXCFClH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:41:07 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37055 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933866AbXCFClF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:41:05 -0500
Message-ID: <45ECD4B6.8000607@sgi.com>
Date: Mon, 05 Mar 2007 18:40:54 -0800
From: Jay Lan <jlan@sgi.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060725)
MIME-Version: 1.0
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Fastboot] [PATCH 1/1] - platform_kernel_launch_event is noop
 on generic kernel
References: <20070228194517.25635.98535.sendpatchset@attica.americas.sgi.com> <20070301042227.GO6479@verge.net.au> <20070301125736.GA18853@strauss.suse.de> <20070301130336.GB18853@strauss.suse.de>
In-Reply-To: <20070301130336.GB18853@strauss.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle wrote:
> * Bernhard Walle <bwalle@suse.de> [2007-03-01 13:57]:
>> * Horms <horms@verge.net.au> [2007-03-01 05:22]:
>>> On Wed, Feb 28, 2007 at 01:45:17PM -0600, John Keller wrote:
>>>> Add a missing #define for the platform_kernel_launch_event.
>>>> Without this fix, a call to platform_kernel_launch_event()
>>>> becomes a noop on generic kernels. SN systems require this
>>>> fix to successfully kdump/kexec from certain hardware errors.
>>>>
>>>> Signed-off-by: John Keller <jpk@sgi.com>
>>> I made a similar change when porting to xen, but I hadn't thought
>>> to see if mainline linux needs it to.
>>>
>>> Acked-by: Simon Horman <horms@verge.net.au>
>> I think there's an additional change needed. Without that, it leads to
>> a NULL pointer dereference.

Yep, it is needed. The missing line was in Jack's original patch
but was lost somehow in 2.6.20.

Acked-by: Jay Lan <jlan@sgi.com>

> 
> Maybe I should also get my editor right ... ;):
> 
> ---
>  include/asm-ia64/machvec.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: b/include/asm-ia64/machvec.h
> ===================================================================
> --- a/include/asm-ia64/machvec.h
> +++ b/include/asm-ia64/machvec.h
> @@ -168,6 +168,7 @@ extern void machvec_tlb_migrate_finish (
>  #  define platform_setup_msi_irq	ia64_mv.setup_msi_irq
>  #  define platform_teardown_msi_irq	ia64_mv.teardown_msi_irq
>  #  define platform_pci_fixup_bus	ia64_mv.pci_fixup_bus
> +#  define platform_kernel_launch_event	ia64_mv.kernel_launch_event
>  # endif
>  
>  /* __attribute__((__aligned__(16))) is required to make size of the
> @@ -269,6 +270,7 @@ struct ia64_machine_vector {
>  	platform_setup_msi_irq,			\
>  	platform_teardown_msi_irq,		\
>  	platform_pci_fixup_bus,			\
> +	platform_kernel_launch_event            \
>  }
>  
>  extern struct ia64_machine_vector ia64_mv;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ia64" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

