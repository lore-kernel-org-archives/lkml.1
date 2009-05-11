Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbZEKPBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbZEKPBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbZEKPAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:00:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40544 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbZEKPAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:00:20 -0400
Date: Mon, 11 May 2009 11:00:19 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       len.brown@intel.com, mingo@elte.hu, johnstul@us.ibm.com
Subject: Re: [PATCH] ACPI: do not mark TSC unstable for invalid C-states
In-Reply-To: <alpine.LFD.2.00.0905111614570.3561@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0905111100060.2492@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com> <200905110226.50115.elendil@planet.nl> <alpine.LFD.2.00.0905111614570.3561@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 11 May 2009, Thomas Gleixner wrote:

> commit a71e4917dc0ebbcb5a0ecb7ca3486643c1c9a6e2 (ACPI: idle:
> mark_tsc_unstable() at init-time, not run-time) marks TSC unstable
> even on non affected systems.
> 
> The reason is that the state enumeration does not check the cx->valid
> flag before calling tsc_halts_in_c(), so it marks TSC unstable for any
> enumerated albeit invalid C state which is known to turn off TSC.
> 
> Check cx->valid before checking whether the TSC might become unstable.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Tested-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  drivers/acpi/processor_idle.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/acpi/processor_idle.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/processor_idle.c
> +++ linux-2.6/drivers/acpi/processor_idle.c
> @@ -583,7 +583,7 @@ static int acpi_processor_power_verify(s
>  
>  #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
>  		/* TSC could halt in idle, so notify users */
> -		if (tsc_halts_in_c(cx->type))
> +		if (cx->valid && tsc_halts_in_c(cx->type))
>  			mark_tsc_unstable("TSC halts in idle");;
>  #endif
>  		switch (cx->type) {
> 
> 
> 
