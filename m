Return-Path: <linux-kernel-owner+w=401wt.eu-S1750928AbXBTAGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750928AbXBTAGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbXBTAGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:06:00 -0500
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:43051 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717AbXBTAF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:05:58 -0500
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200702200005.l1K05tJi016929@turbo.physics.adelaide.edu.au>
Subject: PCI: Bus is behind transparent bridge
To: jwoithe@physics.adelaide.edu.au (Jonathan Woithe)
Date: Tue, 20 Feb 2007 10:35:55 +1030 (CST)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200702140006.l1E06awJ013179@turbo.physics.adelaide.edu.au> from "Jonathan Woithe" at Feb 14, 2007 10:36:36 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Further to my previous email:

> When booting my laptop I notice the following message:
> 
>   PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
>   PCI quirk: region 1180-11bf claimed by ICH6 GPIO
>   PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
>   PCI: Transparent bridge - 0000:00:1e.0
>   PCI: Bus #07 (-#0a) is hidden behind transparent bridge #06 (-#07) (try
>   'pci=assign-busses')
>   Please report the result to linux-kernel to fix this permanently
:
> The machine is a 2.0 GHz Dothan Centrino.  I'm happy to test things and/or
> provide more info if it will help.

A closer inspection under 2.6.20 showed that "pci=assign-busses" did have
some effect.  Without it I see:

> ACPI: Core revision 20060707
> ENABLING IO-APIC IRQs
> .TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: Using MMCONFIG
> Setting up standard PCI resources
> ACPI: Interpreter enabled
> ACPI: Using IOAPIC for interrupt routing
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> PCI: Probing PCI hardware (bus 00)
> Boot video device is 0000:00:02.0
> PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
> PCI quirk: region 1180-11bf claimed by ICH6 GPIO
> PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
> PCI: Transparent bridge - 0000:00:1e.0
> PCI: Bus #07 (-#0a) is hidden behind transparent bridge #06 (-#07) (try 'pci=assign-busses')
> Please report the result to linux-kernel to fix this permanently
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
> ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
> ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
> ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
> ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
> ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]

Using "assign-busses" I get

  :
  PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
  PCI quirk: region 1180-11bf claimed by ICH6 GPIO
  PCI: Transparent bridge - 0000:00:1e.0
  ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
  ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
  :

Is there any more information required for this to be "fixed permanently"?

Regards
  jonathan
