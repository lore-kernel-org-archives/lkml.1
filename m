Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbXEJNFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbXEJNFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760141AbXEJNF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:05:28 -0400
Received: from smtp5-g19.free.fr ([212.27.42.35]:39617 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760444AbXEJNF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:05:27 -0400
Message-ID: <1178802325.46431895e9469@imp.free.fr>
Date: Thu, 10 May 2007 15:05:25 +0200
From: Remi Colinet <remi.colinet@free.fr>
To: linux-kernel@vger.kernel.org
Subject: Regression in 2.6.21-mm1 (git-input) on Dell D610 laptop
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 81.255.27.251
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

My D610 ALPS Glide Point is unresponsive with 2.6.21-mm1 patch.
No problem noticed with 2.6.21.

The culprit seems to be git-input. I have applied 2.6.21-mm1 on top of 2.6.21
and then removed git-input patch. It is ok since then.

>From what i can see, no interrupt is raised from the GlidePoint with git-input
applied. IRQ count 12 does not increase. It is when using the touchpad.

           CPU0
  0:        160   IO-APIC-edge      timer
  1:        935   IO-APIC-edge      i8042
  7:          0   IO-APIC-edge      parport0
  8:          1   IO-APIC-edge      rtc
  9:          2   IO-APIC-fasteoi   acpi
=> 12:        114   IO-APIC-edge      i8042 <=
 14:       3223   IO-APIC-edge      libata
 15:          5   IO-APIC-edge      libata
 16:          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb5, Intel ICH6
 17:          1   IO-APIC-fasteoi   uhci_hcd:usb2, ipw2200, Intel ICH6 Modem
 18:          0   IO-APIC-fasteoi   uhci_hcd:usb3
 19:          1   IO-APIC-fasteoi   uhci_hcd:usb4, yenta
NMI:          0
LOC:       4051
ERR:          0
MIS:          0

I have also tried to disable the ALPS driver in the .config file. IRQ 12 are
then raised when using the Glide Point. X refuses to start.

Any idea?

Remi Colinet

