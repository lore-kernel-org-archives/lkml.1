Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbZENW2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbZENW2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbZENW2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:28:34 -0400
Received: from www.tglx.de ([62.245.132.106]:49597 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZENW2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:28:33 -0400
Date: Fri, 15 May 2009 00:27:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Len Brown <lenb@kernel.org>
cc: Janne Kulmala <janne.t.kulmala@tut.fi>, Frans Pop <elendil@planet.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       johnstul@us.ibm.com
Subject: Re: [PATCH] ACPI: idle: fix init-time TSC check regression
In-Reply-To: <alpine.LFD.2.00.0905141750100.24833@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0905150025030.3561@localhost.localdomain>
References: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com> <200905110226.50115.elendil@planet.nl> <alpine.LFD.2.00.0905111614570.3561@localhost.localdomain> <4A0855A5.8040109@tut.fi> <alpine.LFD.2.00.0905141545280.24833@localhost.localdomain>
 <alpine.LFD.2.00.0905141608070.24833@localhost.localdomain> <alpine.LFD.2.00.0905142217340.3561@localhost.localdomain> <alpine.LFD.2.00.0905141750100.24833@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> A previous 2.6.30 patch, a71e4917dc0ebbcb5a0ecb7ca3486643c1c9a6e2,
> (ACPI: idle: mark_tsc_unstable() at init-time, not run-time)
> erroneously disabled the TSC on systems that did not actually
> have valid deep C-states.
> 
> Move the check after the deep-C-states are validated,
> via new helper, tsc_check_state(), hich replaces tsc_halts_in_c().
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> ---
> Thomas,
> I decided to use a tsc-specific helper
> rather than piggyback on acpi_timer_check_state(),
> since that is not general, but rather LAPIC timer specific.
> (and I'll re-name that to reflect its specific function
>  in a cosmetic follow-up patch)

I have no strong opinion on that :)

> +		if (cx->valid)
> +			tsc_check_state(cx->type);
>  
>  		if (cx->valid)
>  			working++;

Could do with

      	 if (cx->valid) {
            	tsc_check_state(cx->type);
                working++;
      	 }

Otherwise Acked-by: Thomas Gleixner <tglx@linutronix.de>
