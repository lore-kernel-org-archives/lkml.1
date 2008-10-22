Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbYJVMzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbYJVMzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 08:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbYJVMzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 08:55:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40816 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbYJVMzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 08:55:23 -0400
Date: Wed, 22 Oct 2008 14:55:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: call dmi-quirks for HP Laptops after early-quirks
	are executed
Message-ID: <20081022125504.GA2917@elte.hu>
References: <20081016105706.GC29183@alberich.amd.com> <20081022100253.GB29744@elte.hu> <20081022100924.GC13400@alberich.amd.com> <20081022112858.GE13400@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022112858.GE13400@alberich.amd.com>
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

> Problems with bogus IRQ0 override of those laptops should be fixed
> with commits
> 
> x86: SB600: skip IRQ0 override if it is not routed to INT2 of IOAPIC
> x86: SB450: skip IRQ0 override if it is not routed to INT2 of IOAPIC
> 
> that introduce early-quirks based on chipset configuration.
> 
> For further information, see
> http://bugzilla.kernel.org/show_bug.cgi?id=11516
> 
> Instead of removing the related dmi-quirks completely we'd like to
> keep them for (at least) one kernel version -- to double-check whether
> the early-quirks really took effect. But the dmi-quirks need to be
> called after early-quirks are executed. With this patch calling
> sequence for dmi-quirks is changed as follows:
> 
>  acpi_boot_table_init()   (dmi-quirks)
>  ...
>  early_quirks()           (detect bogus IRQ0 override)
>  ...
>  acpi_boot_init()         (late dmi-quirks and setup IO APIC)
> 
> Note: Plan is to remove the "late dmi-quirks" with next kernel version.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

applied to tip/x86/urgent, thanks Andreas!

	Ingo
