Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbZDNQf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbZDNQf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZDNQfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:35:47 -0400
Received: from gw.goop.org ([64.81.55.164]:37663 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbZDNQfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:35:47 -0400
Message-ID: <49E4BB61.1090008@goop.org>
Date: Tue, 14 Apr 2009 09:35:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 01/14] [VOYAGER] x86: add {safe,hard}_smp_processor_id
 to smp_ops
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
In-Reply-To: <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> Not having apics, Voyager can't use the default apic implementation of
> these, it has to read from a special port in the VIC to get the
> processor ID, so abstract these functions in smp_ops to allow voyager
> to live simultaneously with the apic code.
>   

I thnk we should just drop safe_smp_processor_id().  It doesn't seem to 
do anything useful.

> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 429834e..eb795bf 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -454,6 +454,11 @@ static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> +static int xen_hard_smp_processor_id(void)
> +{
> +	return read_apic_id();
> +}
>   

This should just be "return smp_processor_id()".  There are no 
meaningful APICs under Xen.

    J
