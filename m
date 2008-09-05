Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbYIESBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbYIESBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYIESBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:01:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:15578 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYIESBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EoMk1CF5SqRWo7Nax3Yh3PvFPsUV4uxcZQAc1gbVrNjPqjA1ReVx/3jLJRYPgEsxpq
         UkQzSHpugKKAr8hhkFqLsCXzEBatjd7syB8DTc4iLnxn7lMzTIQV0a8VawyXBWyFBSg6
         utixeQhDwV6rxQ3C5Wo9JXTKO3UihIVTSOwis=
Date: Fri, 5 Sep 2008 22:01:26 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       yhlu.kernel@gmail.com, macro@linux-mips.org
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for
	setup_IO_APIC_irqs
Message-ID: <20080905180126.GA19334@lenovo>
References: <20080904183748.950151853@gmail.com>> <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com> <20080905080447.GC12409@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905080447.GC12409@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Fri, Sep 05, 2008 at 10:04:47AM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > Use a nested level for 'for' cycle and break long lines.
| > For apic_print we should countinue using KERNEL_DEBUG if
| > we have started to.
| 
| > @@ -1521,32 +1521,35 @@ static void __init setup_IO_APIC_irqs(vo
| >  	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
| >  
| >  	for (apic = 0; apic < nr_ioapics; apic++) {
| > -	for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
| > +		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
| >  
| > +			idx = find_irq_entry(apic, pin, mp_INT);
| > +			if (idx == -1) {
| 
| hm, i dont really like the super-deep nesting we do here. Could you 
| please split out the iterator into a separate function? That makes the 
| code a lot easier to understand and saves two extra tabs as well for 
| those ugly-looking printk lines.
| 
| 	Ingo
| 

You know it seems we use such a 'cycle on every pin on io-apics'
in several places for now:

io_apic.c
---------
	clear_IO_APIC
	save_mask_IO_APIC_setup
	restore_IO_APIC_setup
	IO_APIC_irq_trigger
	setup_IO_APIC_irqs

I've made a one-line macro for this (like for_all_ioapics_pins)
_but_ it looks much more ugly then this two nested for(;;) :)

If you meant me to make a separate iterator over the pins I think
it will not help a lot - this function is simple enought so the only
problem is too-long-printk-form - maybe just print them on separated
lines instead of tracking apicids? Or it was made in a sake to not
scroll screen too much?

		- Cyrill -
