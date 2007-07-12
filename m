Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbXGLSON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbXGLSON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 14:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbXGLSNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 14:13:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:9788 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbXGLSNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 14:13:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=WlC32bstQF8gG06cnNh/IVeFO6CNp2V9xxDKBrpga+OQG14FYu+Gi51orN+2bfoRGe07G9CGRtsq0Ooqgjj7wgUrwqcFyw518272mZ7P5PjGKmKaVFe6tNzQ6zO6tH7EXricRXcxmbJmbD9gNaT36XAhxP7DHq/orcwEFmge+6c=
Message-ID: <8c34a9060707121113u6094d3acj7e01a8b560623ae7@mail.gmail.com>
Date: Thu, 12 Jul 2007 13:13:45 -0500
From: "Brett Boren" <brett.boren@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: IRQ problem with IO-APIC and plx9056-based data capture board
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a plx9056-based data capture board that works with the winXP
drivers (based off of the win32 plx sdk) but does not work with the
linux driver provided to me. The board constitently gets 0xa (IRQ 10)
in the INTERRUPT_LINE register but the IO-APIC reports IRQ 49 to the
kernel. To add to the confusion when an interrupt is triggered it
arrives on IRQ 17 causing an irq disable. When run with `noapic` on
the kernel bootline a consistent irq 10 is observed and the driver
behaves correctly. When `irqpoll` is given the driver behaves
correctly(kernel complains about irq 10 being the registered irq
handler) though it causes other kernel problems. The following options
have been tried in isolation with no success: pci=nommconf; pci=conf2
(noboot); acpi=bigsmp; pci=routeirq (kernel output changes, but no
change in behavior); pci=noacpi acpi=noirq (seems identical to
pci=routeirq); acpi=irq_balance; apic=debug.

I'm running primarily in a Dell precision 370n workstation with 3
PCI-X slots. The irq reported in by the IO-APIC changes depending on
which slot I plug it in.

Slot       INTERRUPT_LINE     IO-APIC        Observed
1           10                            49                 17
2           10                            53                 17
3           9                              26                 18

The same general behavior has been observed in _every_ linux machine
I've been able to plug this card into that had an IO-APIC. These were
mostly Intel chipsets but I 've also had it in a Tyan 8-proc AMD board
with a Nvidia chipset with the same interrupt issues.

I see two problems: first, the INTERRUPT_LINE register on the card is
not consistent with either the APIC reported irq or the actual irq.
Second, that the IO_APIC, which is supposed to maintain a mapping of
its pins to a particular irq, is inconsistent in what IRQ is reported
for a particular pin (different slots result in different irqs
reported, but still actually use irq 17).

I'm not a LKML subscriber so please CC to brett.boren_at_gmail_dot_com.

Thanks,
Brett
