Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbXJXFzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbXJXFzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbXJXFyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:54:52 -0400
Received: from smile.2scale.net ([212.12.33.142]:52727 "EHLO smile.2scale.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634AbXJXFyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:54:50 -0400
Subject: 2.6.22.7 reboots if PCI-X eth card is used for capture
From: Michael Stiller <ms@2scale.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: 2scale GmbH
Date: Wed, 24 Oct 2007 07:54:43 +0200
Message-Id: <1193205283.3659.24.camel@blackberry>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i run a machine with 4 dual gigabit ethernet cards utilizing 2.6.22.7.
All cards are PCI-E, one card is PCI-X, all Gigabit Ethernet from Intel.
This is working fine and stable if only the PCI-E cards are used.

If i try to capture packets on the PCI-X card, the machine reboots after
some seconds. I think i can rule out a hardware defect, as i actually
run two of this machines with equal hard and software and the problem
occurs on both machines. This is perfectly reproducible but i am unable
to debug this, as no (oops) messages are ever written to the syslog. 
As the machine instantly reboots i guess there will be nothing valueable
shown on the display. 

The interrupt layout:

(cat /proc/interrupts)

 16:         36          6        430          0   IO-APIC-fasteoi   eth0
 18:         33          5        305        126   IO-APIC-fasteoi   uhci_hcd:us
b1, ehci_hcd:usb4, eth1
211:       2143       2210     127682        533   PCI-MSI-edge      eth9
212:       5332       5818      10298    3594001   PCI-MSI-edge      eth8
213:        129      46419    5525683          6   PCI-MSI-edge      eth7
214:      13528      14184      34425   11239040   PCI-MSI-edge      eth6
215:      50277        116    5821388         14   PCI-MSI-edge      eth5
216:        595        590     347154        857   PCI-MSI-edge      eth4
217:         48        153       5760       2653   PCI-MSI-edge      eth2

The card in question is eth0+eth1. I even tried the following boot kernel parameters
with NO success.
	
	nousb (don't need it, suspected the irq sharing as problem source)
	
	pci=nomsi (this recommended my hardware vendor)

I need some advice, howto debug or solve this.

As i usually don't read the list, i would like to be cc'd. 

Cheers

Michael

