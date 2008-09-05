Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYIENtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYIENtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 09:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbYIENt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 09:49:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:60240 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbYIENt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 09:49:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FVQNdyp07N8i9q7SOEVCfuQI20Y3GnqFn6ascoj/F4RFSuuvavb5qGOLPEHzRJhRWP
         H+yp1WYeRuEQXPBAlox6DRtnfDE6I54UICcju5p7/MbLpeWSPKZGFX0fY6zBtGFBZZ93
         oQqcHO++NR0uj37KwOHfMb6VV/fAboom8b8tY=
Date: Fri, 5 Sep 2008 17:49:21 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       yhlu.kernel@gmail.com, macro@linux-mips.org
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for
	setup_IO_APIC_irqs
Message-ID: <20080905134921.GA7239@lenovo>
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

ok Ingo, will take a look, thanks

		- Cyrill -
