Return-Path: <linux-kernel-owner+w=401wt.eu-S1757751AbXJ3VNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbXJ3VNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbXJ3VNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:13:44 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:58537 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbXJ3VNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:13:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=eikwn2K3giIxR5VO+W/TdNUe1LuogQ+WgCVtubaAtrg0zf3R1xhqgtdiCLgkiMLxsIzIVD+GVpAHNoIoUC1cVkO2MJk7/COqVONgCU7QcpKvfLjIASUvWBLLfpzPBHEKuHg6pnVU/3ZvYPQt2YN02fsukpcB6eFws7CkcQjXG40=
Message-ID: <c3d0340b0710301413r2607ee08x8b27c5bffa43f1c4@mail.gmail.com>
Date: Tue, 30 Oct 2007 13:13:41 -0800
From: "Shawn Jin" <shawnxjin@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Multiple MSI messages support
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If this is really off-topic here, I apologize first. But I cannot
think a better place to ask this particular question.

I understand that the current PCI subsystem or linux kernel (x86)
supports only one message when MSI is enabled even for devices having
multiple MSI messages. But why? Is this a limitation solely due to the
OS or due to the x86 APIC?

I know the current linux kernel (2.6.23) changed MSI message data
format a little bit to support other architectures. But some older
version (e.g. 2.6.18) defined a specific format for the MSI msg data
in a way that 8 bits contain the irq number and the other 8 bits have
the interrupt attributes, which is x86 specific. Why does the msg data
need to contain the irq number? Here is my hypothetic explanation. The
device writes the MSI msg data to the specified MSI msg address. And
APIC uses the irq number in the msg data to generate appropriate
interrupt, which of course results in an appropriate ISR invoked. A
device having multiple MSI messages typically appends some information
of which MSI message to the msg data field. For example, if the system
(or OS) configures the MSI msg data as 0x5000, a device having 4 MSI
messages could write 0x5000, 0x5001, 0x5002, 0x5003 to differentiate
the MSI messages. However this cannot work with the APIC due to the
way how APIC asserts interrupts as I described above (if my
understanding is correct).

Hence my answer to the question is this is due to the x86 APIC. For
other architectures such as powerpc this is probably not a problem
since the interrupt controller is different. Am I correct?

TIA.
-Shawn.
