Return-Path: <linux-kernel-owner+w=401wt.eu-S933230AbZFQTD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbZFQTD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 15:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755733AbZFQTDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 15:03:21 -0400
Received: from bu3sch.de ([62.75.166.246]:53158 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbZFQTDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 15:03:20 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Add support for NetMos 9901 Multi-IO card
Date: Wed, 17 Jun 2009 21:02:53 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200906102247.19557.mb@bu3sch.de>
In-Reply-To: <200906102247.19557.mb@bu3sch.de>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906172102.53475.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did somebody pick this up? Who is responsible for parallel/serial stuff?

On Wednesday 10 June 2009 22:47:19 Michael Buesch wrote:
> This patch adds support for the PCI-Express NetMos 9901 Multi-IO card.
> 
> 0001:06:00.0 Serial controller [0700]: NetMos Technology Device [9710:9901] (prog-if 02 [16550])
>         Subsystem: Device [a000:1000]
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 65
>         Region 0: I/O ports at 0030 [size=8]
>         Region 1: Memory at 80105000 (32-bit, non-prefetchable) [size=4K]
>         Region 4: Memory at 80104000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: <access denied>
>         Kernel driver in use: serial
>         Kernel modules: 8250_pci
> 
> 0001:06:00.1 Serial controller [0700]: NetMos Technology Device [9710:9901] (prog-if 02 [16550])
>         Subsystem: Device [a000:1000]
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin B routed to IRQ 65
>         Region 0: I/O ports at 0020 [size=8]
>         Region 1: Memory at 80103000 (32-bit, non-prefetchable) [size=4K]
>         Region 4: Memory at 80102000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: <access denied>
>         Kernel driver in use: serial
>         Kernel modules: 8250_pci
> 
> 0001:06:00.2 Parallel controller [0701]: NetMos Technology Device [9710:9901] (prog-if 03 [IEEE1284])
>         Subsystem: Device [a000:2000]
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin C routed to IRQ 65
>         Region 0: I/O ports at 0010 [size=8]
>         Region 1: I/O ports at <unassigned>
>         Region 2: Memory at 80101000 (32-bit, non-prefetchable) [size=4K]
>         Region 4: Memory at 80100000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: <access denied>
>         Kernel driver in use: parport_pc
>         Kernel modules: parport_pc
> 
> 
> [   16.760181] PCI parallel port detected: 416c:0100, I/O at 0x812010(0x0), IRQ 65
> [   16.760225] parport0: PC-style at 0x812010, irq 65 [PCSPP,TRISTATE,EPP]
> [   16.851842] serial 0001:06:00.0: enabling device (0004 -> 0007)
> [   16.883776] 0001:06:00.0: ttyS0 at I/O 0x812030 (irq = 65) is a ST16650V2
> [   16.893832] serial 0001:06:00.1: enabling device (0004 -> 0007)
> [   16.926537] 0001:06:00.1: ttyS1 at I/O 0x812020 (irq = 65) is a ST16650V2
> 
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
>  drivers/parport/parport_pc.c |    4 ++++
>  drivers/serial/8250_pci.c    |    6 ++++++
>  include/linux/pci_ids.h      |    1 +
>  3 files changed, 11 insertions(+)
> 
> --- linux-2.6.30.orig/drivers/parport/parport_pc.c
> +++ linux-2.6.30/drivers/parport/parport_pc.c
> @@ -2800,6 +2800,7 @@ enum parport_pc_pci_cards {
>  	netmos_9755,
>  	netmos_9805,
>  	netmos_9815,
> +	netmos_9901,
>  	quatech_sppxp100,
>  };
>  
> @@ -2878,6 +2879,7 @@ static struct parport_pc_pci {
>          /* netmos_9755 */               { 2, { { 0, 1 }, { 2, 3 },} }, /* untested */
>  	/* netmos_9805 */               { 1, { { 0, -1 }, } }, /* untested */
>  	/* netmos_9815 */               { 2, { { 0, -1 }, { 2, -1 }, } }, /* untested */
> +	/* netmos_9901 */               { 1, { { 0, -1 }, } },
>  	/* quatech_sppxp100 */		{ 1, { { 0, 1 }, } },
>  };
>  
> @@ -2978,6 +2980,8 @@ static const struct pci_device_id parpor
>  	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9805 },
>  	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9815,
>  	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9815 },
> +	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9901,
> +	  0xA000, 0x2000, 0, 0, netmos_9901 },
>  	/* Quatech SPPXP-100 Parallel port PCI ExpressCard */
>  	{ PCI_VENDOR_ID_QUATECH, PCI_DEVICE_ID_QUATECH_SPPXP_100,
>  	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, quatech_sppxp100 },
> --- linux-2.6.30.orig/include/linux/pci_ids.h
> +++ linux-2.6.30/include/linux/pci_ids.h
> @@ -2659,6 +2659,7 @@
>  #define PCI_DEVICE_ID_NETMOS_9835	0x9835
>  #define PCI_DEVICE_ID_NETMOS_9845	0x9845
>  #define PCI_DEVICE_ID_NETMOS_9855	0x9855
> +#define PCI_DEVICE_ID_NETMOS_9901	0x9901
>  
>  #define PCI_VENDOR_ID_3COM_2		0xa727
>  
> --- linux-2.6.30.orig/drivers/serial/8250_pci.c
> +++ linux-2.6.30/drivers/serial/8250_pci.c
> @@ -761,6 +761,8 @@ static int pci_netmos_init(struct pci_de
>  	/* subdevice 0x00PS means <P> parallel, <S> serial */
>  	unsigned int num_serial = dev->subsystem_device & 0xf;
>  
> +	if (dev->device == PCI_DEVICE_ID_NETMOS_9901)
> +		return 0;
>  	if (dev->subsystem_vendor == PCI_VENDOR_ID_IBM &&
>  			dev->subsystem_device == 0x0299)
>  		return 0;
> @@ -3556,6 +3558,10 @@ static struct pci_device_id serial_pci_t
>  		PCI_VENDOR_ID_IBM, 0x0299,
>  		0, 0, pbn_b0_bt_2_115200 },
>  
> +	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9901,
> +		0xA000, 0x1000,
> +		0, 0, pbn_b0_1_115200 },
> +
>  	/*
>  	 * These entries match devices with class COMMUNICATION_SERIAL,
>  	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
> 



-- 
Greetings, Michael.
