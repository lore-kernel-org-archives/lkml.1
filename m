Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYDYFI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYDYFI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 01:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYDYFIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 01:08:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39889 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbYDYFIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 01:08:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Garzik <jeff@garzik.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
References: <20080422221733.GA16260@havoc.gtf.org>
	<alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org>
	<480E6DE5.6010103@garzik.org>
	<alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org>
	<480E796E.4070001@garzik.org>
	<alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org>
	<20080423000529.GG28933@cs181133002.pp.htv.fi>
	<alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org>
	<480F3ECC.1090809@keyaccess.nl> <480FEC1B.6040102@garzik.org>
	<alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org>
	<m1od7zkd2s.fsf@frodo.ebiederm.org> <481066C1.1030805@garzik.org>
	<alpine.LFD.1.10.0804240806500.2779@woody.linux-foundation.org>
	<4810A9E6.1080201@garzik.org>
	<alpine.LFD.1.10.0804240847230.2779@woody.linux-foundation.org>
	<m1r6cvgpw2.fsf@frodo.ebiederm.org> <4810C3B5.3020605@garzik.org>
	<m11w4u8x1c.fsf@frodo.ebiederm.org> <481150EE.3040103@garzik.org>
Date: Thu, 24 Apr 2008 22:08:00 -0700
In-Reply-To: <481150EE.3040103@garzik.org> (Jeff Garzik's message of "Thu, 24
	Apr 2008 23:33:02 -0400")
Message-ID: <m1r6cu5xov.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_04 Obfuscated Sexy Noun-Thing
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: MSI, fun for the whole family
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> Eric W. Biederman wrote:
>> Jeff Garzik <jeff@garzik.org> writes:
>>
>>> Eric W. Biederman wrote:
>>>> And on x86 at least the hardware maps the MSI write into an interrupt.
>>>> So there is not an opportunity to get any metdata/OOB data from the
>>>> MSI message.  Instead we just potentially get a boatload more irq
>>>> sources.  Which is one of the things making a static NR_IRQS painful.
>>>>
>>>> To be safe we have to make NR_IRQS 10x+ or so bigger then people use
>>>> today.  Just in case they decide to plug in some really irq hungry
>>>> cards.
>>>
>>> Just to be clear, irq_chip/irq_desc and metadata/OOB data are two very
> different
>>> beasts.  irq_chip/irq_desc is more a system attribute as Linus notes.  Also,
> it
>>> doesn't change very often.
>>>
>>> metadata/OOB, on the other hand, is different -for each interrupt-, and is
>>> highly relevant to drivers.  Thus should be part of the driver API somehow.
>>
>> I'm not certain I follow so I will ask.
>>
>> Do you mean information that is different each time an interrupt is fires?
>>
>> Or do you mean information that differs for each different interrupt?
>> Something like the current dev_id?
>>
>> To my knowledge there is not any information that varies each time an
>> interrupt fires.
>
> Absolutely there is!  This is why MSI is so cool.
>
> You get a tiny chunk of data from the hardware, across the PCI bus in a single
> PCI transaction, sent [well, basically...] straight to the driver __for each MSI
> interrupt__.  Rather than having a separate interrupt line -- really an ugly OOB
> mechanism -- you get a bus transaction as God intended, a bus transaction just
> like all the others going across the PCI bus.

Correct.

You get a write of 16 bits of data to a 32bit address on x86.
Encoded in that write is a cpu number, an 8 bit vector number,
and various encoding modes.  That 8 bit vector is encoded in the
low 8 bits of the 16bit data word.

> Let's illustrate with a real world example, with hardware you probably already
> have in your hands today.
>
>
> Download AHCI 1.1 SATA controller specification from
> http://www.intel.com/technology/serialata/ahci.htm
>
> and check out Section 2.3 and MSI-related bits of Section 10.6.2 for the usage
> of those PCI MSI registers on the PCI device.
>
> An AHCI PCI device uses MSI messages to inform the driver which <mask> of 32
> SATA ports have asserted an activity indication.

Not a mask of 32 SATA ports.  The low 5 bits of the 16 bit data word vary.

> This MSI message varies _for each interrupt_, and replaces the standard driver
> idiom of reading a hardware Interrupt-Status register.
>
> Thus you can see increased performance with MSI messages because the hardware
> "pushes" useful information to the driver, using an in-band mechanism (PCI bus
> transaction) rather than an out-of-band mechanism ($N SATA ports sharing a
> single interrupt line).

The effect is the same but the principle of operation is slightly different.

In practice you have a limited set of messages that a card may generate.
A maximum of 32 different messages in the case of a plain MSI capability
and a maximum of 4096 different messages in the case of a MSI-X capability.

The hardware encoding on x86 ensures each of those different messages
maps to a different system interrupt.  The irq layer then maps each
of those interrupts into a different linux irq number.  And those
interrupts may never be shared.

The support code for all of that is already implemented.

Now I do have some bad news for you.  We do not support
using the multiple message capability of the AHCI.  The linux API
currently requires that we be able to migrate irqs individually to
different CPUS and that we be able mask individual irqs, and
the only the MSI-X capability allows us to implement that.

> This is the reverse of the standard model, where the driver receives the
> knowledge "your interrupt line asserted... maybe" and it must deduce activity
> from there by reading an Interrupt-Status register.

> That is one fundamental of MSI messages:  they carry data.  To illustrate with
> "kernel pseudocode", this equates to
>
> 	irqreturn_t irq_handler(int irq, void *dev_id,
> 				const void *metadata,
> 				size_t metadata_len)
>
> You have a fundamentally new model for interrupt handling with MSI...

Close.

> You are no longer managing an interrupt line that is asserted and cleared.  It
> is now an asynchronous flow of data blobs from hardware to various per-driver
> "mailboxes".

Pretty much.  Although a large chunk of that comes from simply having
edge triggered interrupts.

I can almost see handling the irqs for the msi capability that way.
As one interrupt with a data blob.  As that gets around the migration
and masking issues that are otherwise present.  The need to allocate
several vectors continuously is a pain and hard to do portably.  So
if those kinds of cards take off and there is a real win I won't
object.

For now I figure cards like that get one MSI interrupt, and if
they want more or to use the in-band data they may implement MSI-X
which provides for a completely separate address and data item
for each message.  Making the separate messages much more useful.

Eric
