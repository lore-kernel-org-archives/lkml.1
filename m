Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYGGHRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYGGHRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 03:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYGGHR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 03:17:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44330 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbYGGHR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 03:17:28 -0400
Date: Mon, 7 Jul 2008 09:17:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP
	systems
Message-ID: <20080707071706.GA3326@elte.hu>
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl> <20080701202453.GD4896@elte.hu> <200807070102.38854.rjw@sisk.pl> <200807070319.29470.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807070319.29470.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Appended is a patch that actually works for me (it's missing the i386 
> part, but I can't test that anyway).
> 
> Please note two things:
> (1) The whole acpi_dmi_table[] thing originally depended on __i386__, so it
>     wouldn't work on x86-64 no matter what.  I removed that dependecy, but
>     I have no idea why it was there and so I'm not sure if that's correct. 

> (2) The clear_IO_APIC_pin(apic1, pin1) done if 
>     disable_irq0_through_ioapic is true is absolutely essential.  The 
>     symptoms are 100% reproducible without it.

thanks, applied to tip/x86, to give this some more testing.

the clear_IO_APIC_pin() is the most worrisome aspect of the change - but 
since we are already in limited quirk mode, does it hurt? Maciej, any 
preferences?

	Ingo
