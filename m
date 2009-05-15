Return-Path: <linux-kernel-owner+w=401wt.eu-S1760528AbZEOI3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760528AbZEOI3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbZEOI3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:29:22 -0400
Received: from www.tglx.de ([62.245.132.106]:53046 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481AbZEOI3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:29:20 -0400
Date: Fri, 15 May 2009 10:27:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Len Brown <lenb@kernel.org>
cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Janne Kulmala <janne.t.kulmala@tut.fi>, Frans Pop <elendil@planet.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       johnstul@us.ibm.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI: Idle C-states disabled by max_cstate should not
 disable the TSC
In-Reply-To: <alpine.LFD.2.00.0905150138001.10065@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0905151027130.3561@localhost.localdomain>
References: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com> <200905110226.50115.elendil@planet.nl> <alpine.LFD.2.00.0905111614570.3561@localhost.localdomain> <4A0855A5.8040109@tut.fi> <alpine.LFD.2.00.0905141545280.24833@localhost.localdomain>
 <alpine.LFD.2.00.0905141608070.24833@localhost.localdomain> <alpine.LFD.2.00.0905142217340.3561@localhost.localdomain> <alpine.LFD.2.00.0905141750100.24833@localhost.localdomain> <alpine.LFD.2.00.0905150138001.10065@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009, Len Brown wrote:

> From: Len Brown <len.brown@intel.com>
> 
> Processor idle power states C2 and C3 stop the TSC on many machines.
> Linux recognizes this situation and marks the TSC as unstable:
> 
> Marking TSC unstable due to TSC halts in idle
> 
> But if those same machines are booted with "processor.max_cstate=1",
> then there is no need to validate C2 and C3, and no need to
> disable the TSC, which can be reliably used as a clocksource.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
>  drivers/acpi/processor_idle.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index e39a40a..e65476f 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -582,7 +582,7 @@ static int acpi_processor_power_verify(struct acpi_processor *pr)
>  
>  	pr->power.timer_broadcast_on_state = INT_MAX;
>  
> -	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER; i++) {
> +	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER && i <= max_cstate; i++) {
>  		struct acpi_processor_cx *cx = &pr->power.states[i];
>  
>  		switch (cx->type) {
> -- 
> 1.6.3.1.9.g95405b
> 
