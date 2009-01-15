Return-Path: <linux-kernel-owner+w=401wt.eu-S933023AbZAOVIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbZAOVIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933817AbZAOU5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:57:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:65197 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934121AbZAOU5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:57:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       shemminger@vyatta.com, netdev@vger.kernel.org
Subject: Re: [PATCH RFC v5] net: add PCINet driver
Date: Thu, 15 Jan 2009 21:57:41 +0100
User-Agent: KMail/1.9.9
References: <20090107195052.GA24981@ovro.caltech.edu> <200901151853.52202.arnd@arndb.de> <20090115182034.GA9091@ovro.caltech.edu>
In-Reply-To: <20090115182034.GA9091@ovro.caltech.edu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901152157.42500.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+FttmXsP22sPI9d8oHH4Y9qV9AXqh0syb+ed/
 Rns7GFv1R3wiJqn5Sjbsx8qRKzeQZ3A25v+ag4+b1UpntA0gXK
 d1EmzecddLuWxctAii4ow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009, Ira Snyder wrote:
> Some sort of Broadcom chipset, I think. Full dmesg and lspci output are
> appended.
> 
> The PCI bridge does mention MSI, so maybe it does support it. Would
> using the DMA from the host mean that the guest system couldn't use the
> DMA controller at all? All of the channels share the same interrupt line
> on the guest. I need one channel on the DMA controller on the guest to
> do realtime transfers from some data processing FPGAs on the board.

The PCI-CompactPCI bridge supports MSI, but that does not imply that
the host does. My limited understanding of x86 tells me that you need
to enable the I/O-APIC in order to use MSI. Your log shows two relavant
lines:

[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
and
[    2.146845] IO APIC resources could be not be allocated.

I think you first need to enable the local APIC, then find out what the
problem with the IO APIC is. If possible, try enabling ACPI (sic) in the
BIOS in order to get the APIC support.

If you get that to work, you can use the interrupt line of the DMA controller
to signal interrupts to the FSL machine, while using DMA transfers to the
MSI address for sending interrupts to the host machine.

	Arnd <><
