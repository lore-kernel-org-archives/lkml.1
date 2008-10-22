Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbYJVKDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbYJVKDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbYJVKDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:03:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50559 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbYJVKDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:03:09 -0400
Date: Wed, 22 Oct 2008 12:02:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove superfluous dmi_ignore_irq0_timer_override
	quirks
Message-ID: <20081022100253.GB29744@elte.hu>
References: <20081016105706.GC29183@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016105706.GC29183@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> The problem should be solved with commits:
> 
> x86: SB600: skip IRQ0 override if it is not routed to INT2 of IOAPIC
> x86: SB450: skip IRQ0 override if it is not routed to INT2 of IOAPIC
> 
> IMHO it does not make sense to check within a dmi-quirk
> whether an early-quirk was applied. Boot sequence is as follows:
> 
> acpi_boot_table_init()   (it applies dmi-quirks)
> ...
> early_quirks()           (detect bogus IRQ0 override)
> ...
> acpi_boot_init()         (setup IO APIC)
> 
> Thus with current code we will always get following warnings for
> Laptops that have this dmi_ignore_irq0_timer_override dmi quirk:
> 
>   WARNING: at arch/x86/kernel/acpi/boot.c:1410
>   dmi_ignore_irq0_timer_override+0x30/0x60()
>   ati_ixp4x0 quirk not complete.
> 
> ... just because the early-quirk (ati_ixp4x0) was not yet executed.

could we move the DMI check to after the early quicks stage? It would be 
nice to have this double check, for at least one kernel cycle.

	Ingo
