Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYIEIFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYIEIFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 04:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYIEIFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 04:05:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41435 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbYIEIFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 04:05:02 -0400
Date: Fri, 5 Sep 2008 10:04:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       yhlu.kernel@gmail.com, macro@linux-mips.org
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for
	setup_IO_APIC_irqs
Message-ID: <20080905080447.GC12409@elte.hu>
References: <20080904183748.950151853@gmail.com>> <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Use a nested level for 'for' cycle and break long lines.
> For apic_print we should countinue using KERNEL_DEBUG if
> we have started to.

> @@ -1521,32 +1521,35 @@ static void __init setup_IO_APIC_irqs(vo
>  	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
>  
>  	for (apic = 0; apic < nr_ioapics; apic++) {
> -	for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
> +		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
>  
> +			idx = find_irq_entry(apic, pin, mp_INT);
> +			if (idx == -1) {

hm, i dont really like the super-deep nesting we do here. Could you 
please split out the iterator into a separate function? That makes the 
code a lot easier to understand and saves two extra tabs as well for 
those ugly-looking printk lines.

	Ingo
