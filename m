Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbZFRTsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbZFRTsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZFRTsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:48:10 -0400
Received: from claw.goop.org ([74.207.240.146]:39551 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbZFRTsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:48:09 -0400
Message-ID: <4A3A99FB.7070807@goop.org>
Date: Thu, 18 Jun 2009 12:48:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's
 no local APIC
References: <4A329CF8.4050502@goop.org>	<alpine.LFD.2.00.0906181206190.4213@localhost.localdomain>	<4A3A9220.4070807@goop.org> <m1zlc5jqac.fsf@fess.ebiederm.org>
In-Reply-To: <m1zlc5jqac.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/09 12:27, Eric W. Biederman wrote:
>> The only actual exception I know of is Xen's replacement of the physical
>> local APIC with a paravirtualized interrupt interface.
>>     
>
> No one ever has.  Xen doesn't have I/O APICs either.  Not in any real
> sense.  Xen just has devices that looking like I/O apics if you don't
> look close.
>   

Well, if acpi_pci_irq_lookup() and friends return the right things
without having parsed the MADT and set up the secondary state, then we
should be fine either way.

acpi_irq_model gets tested in all sorts of random places, so I wonder if
we'll need to set it to ACPI_IRQ_MODEL_IOAPIC (or something else?) to
make things work properly.

Hm, and principle we just get the SCI gsi from the FADT, but there's all
that other mucking about with it in the MADT processing... Wonder what
needs to happen there...

    J
