Return-Path: <linux-kernel-owner+w=401wt.eu-S1762382AbXEYUJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762382AbXEYUJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbXEYUJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:09:27 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2552 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbXEYUJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:09:26 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] msi: Invert the sense of the MSI enables.
Date: Fri, 25 May 2007 13:09:31 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCECJEBAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <m18xbcc2ai.fsf@ebiederm.dsl.xmission.com>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 25 May 2007 14:09:48 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 25 May 2007 14:09:48 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hmm...

> I find in section 6.1:
> > In addition to PCI INTx compatible interrupt emulation, PCI Express
> > requires support of MSI or MSI-X or both.

> Which suggests that INTx support is required.

Unfortunately, this can be equally well read to suggest that MSI/MSI-X is
not required, but that MSI/MSI-x is required in addition if you choose to
support PCI INTx. Section 6.1 is ambiguous and you have to look elsewhere to
figure out if PCI INTx is required or not.

I think the most natural reading of this is that if you choose to support
PCI INTx compatible interrupt emulation, PCI Express requires support of MSI
or MSI-X or both in addition.

However, other sections are not ambiguous:

"For legacy compatibility, PCI Express provides a PCI INTx emulation
mechanism to signal
interrupts to the system interrupt controller (typically part of the Root
Complex). This
mechanism is compatible with existing PCI software, and provides the same
level and type
service as corresponding PCI interrupt signaling mechanism and is
independent of system
interrupt controller specifics. This legacy compatibility mechanism allows
boot device
support without requiring complex BIOS-level interrupt configuration/control
service stacks.
It virtualizes PCI physical interrupt signals by using an in-band signaling
mechanism."

This seems to make it pretty clear that if a device requires MSI/MSI-X, it
is broken. Devices are supposed to work even with PCI drivers that are not
smart enough to support MSI/MSI-X.

DS


