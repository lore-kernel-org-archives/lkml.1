Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZAKCrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZAKCrO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 21:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZAKCq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 21:46:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35851 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbZAKCq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 21:46:57 -0500
Date: Sun, 11 Jan 2009 03:46:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: x86: meaning of nolapic command line option
Message-ID: <20090111024642.GA7077@elte.hu>
References: <496790D1.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496790D1.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> Shouldn't that option imply that all APIC related activity, including 
> that relating to IO-APICs or PCI MSI, should be circumvented? I'm 
> finding that MSI must be disabled separately, and while most of the 
> IO-APIC stuff is indeed not happening, acpi_get_override_irq() only 
> checks skip_ioapic_setup, but that doesn't normally set without the 
> noapic command line option.
> 
> Is there any reason pci_no_msi() and disable_ioapic_setup() shouldn't be 
> called when !cpu_has_apic at the end of identify_cpu()?

Yes, both depend on a lapic and they might limp on with whatever the BIOS 
gave us, you are right that it should be disabled explicitly. Mind sending 
a patch?

	Ingo
