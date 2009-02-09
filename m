Return-Path: <linux-kernel-owner+w=401wt.eu-S1752445AbZBIIOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbZBIIOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbZBIIOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:14:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52712 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZBIIOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:14:03 -0500
Date: Mon, 9 Feb 2009 09:13:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: find nr_irqs_gsi with mp_ioapic_routing
Message-ID: <20090209081350.GC24420@elte.hu>
References: <498CCEDB.8050708@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498CCEDB.8050708@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: find right nr_irqs_gsi on some systems.
> 
> one system has gap between gsi.
> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: IOAPIC (id[0x05] address[0xfeafd000] gsi_base[48])
> [    0.000000] IOAPIC[1]: apic_id 5, version 0, address 0xfeafd000, GSI 48-54
> [    0.000000] ACPI: IOAPIC (id[0x06] address[0xfeafc000] gsi_base[56])
> [    0.000000] IOAPIC[2]: apic_id 6, version 0, address 0xfeafc000, GSI 56-62
> ...
> [    0.000000] nr_irqs_gsi: 38
> 
> so nr_irqs_gsi is not right. some irq for MSI will overwrite with io_apic.
> 
> need to get that with acpi_probe_gsi when acpi io_apic is used
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/mpspec.h |    5 +++++
>  arch/x86/kernel/acpi/boot.c   |   23 +++++++++++++++++++++++
>  arch/x86/kernel/io_apic.c     |   20 +++++++++++++++-----
>  3 files changed, 43 insertions(+), 5 deletions(-)

Applied to tip/x86/apic, thanks Yinghai!

Could you please send one against linus/master too please? (there's conflicts)

	Ingo
