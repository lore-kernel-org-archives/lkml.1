Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbZAMITd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbZAMITd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 03:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbZAMITY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 03:19:24 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:45180 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbZAMITX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 03:19:23 -0500
Message-Id: <496C5CBB.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 13 Jan 2009 08:19:55 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: x86: meaning of nolapic command line option
References: <496790D1.76E4.0078.0@novell.com>
 <20090111024642.GA7077@elte.hu>
In-Reply-To: <20090111024642.GA7077@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 11.01.09 03:46 >>>
>
>* Jan Beulich <jbeulich@novell.com> wrote:
>
>> Shouldn't that option imply that all APIC related activity, including 
>> that relating to IO-APICs or PCI MSI, should be circumvented? I'm 
>> finding that MSI must be disabled separately, and while most of the 
>> IO-APIC stuff is indeed not happening, acpi_get_override_irq() only 
>> checks skip_ioapic_setup, but that doesn't normally set without the 
>> noapic command line option.
>> 
>> Is there any reason pci_no_msi() and disable_ioapic_setup() shouldn't be 
>> called when !cpu_has_apic at the end of identify_cpu()?
>
>Yes, both depend on a lapic and they might limp on with whatever the BIOS 
>gave us, you are right that it should be disabled explicitly. Mind sending 
>a patch?

I will - just wanted to see whether there's some hidden reason behind the
current way this is coded. Actually, I meanwhile realized that doing this
somply based on !cpu_has_apic wouldn't be right, it should (at least for
32-bits) also depend on APIC_INTEGRATED() - just like e.g. done in
APIC_init_uniprocessor().

Jan

