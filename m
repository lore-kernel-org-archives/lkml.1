Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbXLMNrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbXLMNrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 08:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbXLMNrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 08:47:46 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:58057 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbXLMNrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 08:47:45 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Thu, 13 Dec 2007 14:45:39 +0100
User-Agent: KMail/1.9.6
Cc: "Daniel Walker" <dwalker@mvista.com>, akpm@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, mbuesch@freenet.de
References: <20071213003028.676998182@mvista.com> <200712130148.22727.mb@bu3sch.de> <2c0942db0712121717x59af3922na33d274cf5a8c7db@mail.gmail.com>
In-Reply-To: <2c0942db0712121717x59af3922na33d274cf5a8c7db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712131445.39770.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 December 2007 02:17:16 Ray Lee wrote:
> On Dec 12, 2007 4:48 PM, Michael Buesch <mb@bu3sch.de> wrote:
> > This driver is scheduled for removal, so I'd not touch it anymore
> > to avoid the possibility to introduce a lastminute regression.
> > The new drivers (b43 and b43legacy) have this fixed (in a different
> > way by completely removing it).
> 
> Uhm, hijacking the thread a bit here, but which driver is supposed to
> be supporting my 4309? Neither b43 nor b43legacy found my wireless,
> and I'm not seeing its PCI ID anywhere either of those...
> 
> $ lspci -s 02:02 -v;  lspci -n -s 02:02 -v -x
> 02:02.0 Network controller: Broadcom Corporation BCM4309 802.11a/b/g (rev 03)
>         Subsystem: Hewlett-Packard Company Unknown device 12f9
>         Flags: bus master, fast devsel, latency 64, IRQ 22
>         Memory at d0010000 (32-bit, non-prefetchable) [size=8K]
> 
> 02:02.0 0280: 14e4:4324 (rev 03)

The device is supported by b43.
The PCI ID is in the SSB PCI bridge code

static const struct pci_device_id b43_pci_bridge_tbl[] = {
        { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4301) },
        { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4307) },
        { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4311) },
        { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4312) },
        { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4318) },
        { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4319) },
        { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4320) },
        { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4321) },
        { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4324) },
        { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4325) },
        { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4328) },
        { 0, },
};
MODULE_DEVICE_TABLE(pci, b43_pci_bridge_tbl);

-- 
Greetings Michael.
