Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbYFXKrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbYFXKrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYFXKrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:47:25 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:40464 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbYFXKrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:47:24 -0400
Message-ID: <4860D09D.4060801@csr.com>
Date: Tue, 24 Jun 2008 11:46:53 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org
Subject: PCI: MSI interrupts masked using prohibited method
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jun 2008 10:46:53.0995 (UTC) FILETIME=[9DB29FB0:01C8D5E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI MSI interrupts are masked and unmasked using a method (by writing
the MSI Enable capability bit) that is prohibited by the PCI specification.

See PCI Local Bus Specification Revision 3.0, section 6.8.1.3. Message
Control for MSI on page 236.

    "MSI Enable:  If 1 and the MSI-X Enable bit in the MSI-X Message
     Control register (see Section 6.8.2.3) is 0, the
     function is permitted to use MSI to request service
     and is prohibited from using its INTx# pin (if
     implemented; see Section 6.2.4 Interrupt pin register).
     System configuration software sets this bit to enable
     MSI. A device driver is prohibited from writing this bit
     to mask a function’s service request."

This behaviour can cause missed interrupts with some devices if the
interrupt is asserted by the hardware while MSI is disabled.

I believe the interrupt should be masked/unmasked on the interrupt
controller (the APIC on x86, for example).   I'm going to test this now
and see if it works.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
