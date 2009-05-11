Return-Path: <linux-kernel-owner+w=401wt.eu-S1759282AbZEKUJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbZEKUJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZEKUJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:09:28 -0400
Received: from av-gw2.cc.tut.fi ([130.230.130.111]:39676 "EHLO
	av-gw2.cc.tut.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697AbZEKUJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:09:27 -0400
X-Greylist: delayed 12369 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 May 2009 16:09:27 EDT
X-AuditID: 82e6826f-a8d93bb0000003e2-df-4a087fd61504 
Message-ID: <4A0855A5.8040109@tut.fi>
Date: Mon, 11 May 2009 19:43:17 +0300
From: Janne Kulmala <janne.t.kulmala@tut.fi>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, len.brown@intel.com,
       mingo@elte.hu, johnstul@us.ibm.com
Subject: Re: [PATCH] ACPI: do not mark TSC unstable for invalid C-states
References: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com> <200905110226.50115.elendil@planet.nl> <alpine.LFD.2.00.0905111614570.3561@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905111614570.3561@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
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

Small suggestion: can we fix the double ';' here at the same time?

>  #endif
>  		switch (cx->type) {
> 
> 

Janne
