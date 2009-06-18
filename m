Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbZFRUkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbZFRUkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 16:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbZFRUjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 16:39:55 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46124 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZFRUjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 16:39:55 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's no local APIC
References: <4A329CF8.4050502@goop.org>
	<alpine.LFD.2.00.0906181206190.4213@localhost.localdomain>
	<4A3A9220.4070807@goop.org> <m1zlc5jqac.fsf@fess.ebiederm.org>
	<4A3A99FB.7070807@goop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 18 Jun 2009 13:39:53 -0700
In-Reply-To: <4A3A99FB.7070807@goop.org> (Jeremy Fitzhardinge's message of "Thu\, 18 Jun 2009 12\:48\:11 -0700")
Message-ID: <m1vdmtgtt2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: jeremy@goop.org, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, lenb@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> On 06/18/09 12:27, Eric W. Biederman wrote:
>>> The only actual exception I know of is Xen's replacement of the physical
>>> local APIC with a paravirtualized interrupt interface.
>>>     
>>
>> No one ever has.  Xen doesn't have I/O APICs either.  Not in any real
>> sense.  Xen just has devices that looking like I/O apics if you don't
>> look close.
>>   
>
> Well, if acpi_pci_irq_lookup() and friends return the right things
> without having parsed the MADT and set up the secondary state, then we
> should be fine either way.
>
> acpi_irq_model gets tested in all sorts of random places, so I wonder if
> we'll need to set it to ACPI_IRQ_MODEL_IOAPIC (or something else?) to
> make things work properly.

And this is where things get interesting.  Xen strictly speaking has
already made that decision.  Unless you support non APIC mode it
should always be ACPI_IRQ_MODEL_IOAPIC.

But Xen runs the hardware so Xen knows, and Xen should be running
all of the acpi and what not to make it happen.

> Hm, and principle we just get the SCI gsi from the FADT, but there's all
> that other mucking about with it in the MADT processing... Wonder what
> needs to happen there...

Good question.  What does the domU case do?

Eric

