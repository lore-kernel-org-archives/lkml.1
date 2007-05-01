Return-Path: <linux-kernel-owner+w=401wt.eu-S1946085AbXEAX7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946085AbXEAX7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 19:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946090AbXEAX7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 19:59:24 -0400
Received: from rtr.ca ([64.26.128.89]:3291 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946085AbXEAX7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 19:59:24 -0400
Message-ID: <4637D459.2040502@rtr.ca>
Date: Tue, 01 May 2007 19:59:21 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: ak@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove unnecessary irq disabling
References: <20070501213050.GD6119@redhat.com>
In-Reply-To: <20070501213050.GD6119@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> RR asks us if it is really necessary to disable interrupts in
> setup_secondary_APIC_clock(). The answer is no, since setup_APIC_timer()
> starts by saving irq flags, which also disables them.
> 
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> 
> --- a/arch/x86_64/kernel/apic.c
> +++ b/arch/x86_64/kernel/apic.c
> @@ -875,9 +875,7 @@ void __init setup_boot_APIC_clock (void)
>  
>  void __cpuinit setup_secondary_APIC_clock(void)
>  {
> -	local_irq_disable(); /* FIXME: Do we need this? --RR */
>  	setup_APIC_timer(calibration_result);
> -	local_irq_enable();
>  }
>  
>  void disable_APIC_timer(void)

Okay, I'll bite:  before the patch, this code would exit
with interrupts *enabled*, always.   Now it does not.

What does that break, or was it already broken and this fixes it?

Cheers
