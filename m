Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbZEKVjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbZEKVjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbZEKVjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:39:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49509 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbZEKVjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:39:05 -0400
Date: Mon, 11 May 2009 23:37:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 5/7] x86/pci: add 4 more return param in
	IO_APIC_get_PCI_irq_vector
Message-ID: <20090511213755.GB21232@elte.hu>
References: <4A01C35C.7060207@kernel.org> <4A01C406.2040303@kernel.org> <20090511082834.GD5636@elte.hu> <4A087F35.2000903@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A087F35.2000903@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> @@ -1198,6 +1198,7 @@ int mp_register_gsi(struct device *dev,
>  {
>  	int ioapic;
>  	int ioapic_pin;
> +	struct io_apic_irq_attr io_apic_irq;

please call the variable name 'irq_attr' or so.

> +	io_apic_irq.ioapic = ioapic;
> +	io_apic_irq.ioapic_pin = ioapic_pin;
> +	io_apic_irq.trigger = (triggering == ACPI_EDGE_SENSITIVE ? 0 : 1);
> +	io_apic_irq.polarity = (polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
> +	io_apic_set_pci_routing(dev, gsi, &io_apic_irq);

I think we've been through this before :-/ Doesnt this:

	io_apic_irq.ioapic	= ioapic;
	io_apic_irq.ioapic_pin	= ioapic_pin;
	io_apic_irq.trigger	= (triggering == ACPI_EDGE_SENSITIVE ? 0 : 1);
	io_apic_irq.polarity	= (polarity == ACPI_ACTIVE_HIGH ? 0 : 1);

Look nicer?

Also, please do s/triggering/trigger

Thanks,

	Ingo
