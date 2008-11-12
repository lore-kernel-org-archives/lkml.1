Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbYKLIkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbYKLIkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 03:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYKLIkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 03:40:35 -0500
Received: from mail.donpac.ru ([80.254.111.2]:37281 "EHLO mail.donpac.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbYKLIke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 03:40:34 -0500
X-Greylist: delayed 4005 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Nov 2008 03:40:33 EST
Date: Wed, 12 Nov 2008 10:33:45 +0300
From: Andrey Panin <pazke@donpac.ru>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] 8250: Oxford Semiconductor Devices
Message-ID: <20081112073345.GB8105@donpac.ru>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20081017192309.9308.74370.stgit@localhost.localdomain> <20081017192830.9308.94462.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017192830.9308.94462.stgit@localhost.localdomain>
X-Uname: Linux 2.6.18-4-686 i686
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 291, 10 17, 2008 at 08:28:44PM +0100, Alan Cox wrote:
> From: Lee Howard <lee.howard@mainpine.com>
> 
> Add support for the OxSemi 'Tornado' devices.
> 
> Orginal from Lee Howard
> Reformatted and reworked a bit by Alan Cox
> 
> 
> Signed-off-by: Lee Howard <lee.howard@mainpine.com>
> Signed-off-by: Alan Cox <alan@redhat.com>
> ---
> 
>  drivers/parport/parport_pc.c |   20 ++++
>  drivers/serial/8250_pci.c    |  211 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci_ids.h      |    8 ++
>  3 files changed, 238 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
> index 8a846ad..96f3bdf 100644
> --- a/drivers/parport/parport_pc.c
> +++ b/drivers/parport/parport_pc.c
> @@ -2791,6 +2791,7 @@ enum parport_pc_pci_cards {
>  	oxsemi_952,
>  	oxsemi_954,
>  	oxsemi_840,
> +	oxsemi_pcie_pport,
>  	aks_0100,
>  	mobility_pp,
>  	netmos_9705,
> @@ -2868,6 +2869,7 @@ static struct parport_pc_pci {
>  	/* oxsemi_952 */		{ 1, { { 0, 1 }, } },
>  	/* oxsemi_954 */		{ 1, { { 0, -1 }, } },
>  	/* oxsemi_840 */		{ 1, { { 0, 1 }, } },
> +	/* oxsemi_pcie_pport */		{ 1, { { 0, 1 }, } },
>  	/* aks_0100 */                  { 1, { { 0, -1 }, } },
>  	/* mobility_pp */		{ 1, { { 0, 1 }, } },
>  	/* netmos_9705 */               { 1, { { 0, -1 }, } }, /* untested */
> @@ -2928,7 +2930,6 @@ static const struct pci_device_id parport_pc_pci_tbl[] = {
>  	{ 0x1409, 0x7268, 0x1409, 0x0103, 0, 0, timedia_4008a },
>  	{ 0x1409, 0x7268, 0x1409, 0x0104, 0, 0, timedia_4018 },
>  	{ 0x1409, 0x7268, 0x1409, 0x9018, 0, 0, timedia_9018a },
> -	{ 0x14f2, 0x0121, PCI_ANY_ID, PCI_ANY_ID, 0, 0, mobility_pp },
>  	{ PCI_VENDOR_ID_SYBA, PCI_DEVICE_ID_SYBA_2P_EPP,
>  	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, syba_2p_epp },
>  	{ PCI_VENDOR_ID_SYBA, PCI_DEVICE_ID_SYBA_1P_ECP,
> @@ -2946,8 +2947,25 @@ static const struct pci_device_id parport_pc_pci_tbl[] = {
>  	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_954 },
>  	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_12PCI840,
>  	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_840 },
> +	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe840,
> +	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
> +	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe840_G,
> +	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
> +	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_0,
> +	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
> +	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_0_G,
> +	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
> +	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_1,
> +	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
> +	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_1_G,
> +	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
> +	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_1_U,
> +	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
> +	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_1_GU,
> +	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
>  	{ PCI_VENDOR_ID_AKS, PCI_DEVICE_ID_AKS_ALADDINCARD,
>  	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, aks_0100 },
> +	{ 0x14f2, 0x0121, PCI_ANY_ID, PCI_ANY_ID, 0, 0, mobility_pp },
>  	/* NetMos communication controllers */
>  	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9705,
>  	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9705 },
> diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
> index c014ffb..43c990a 100644
> --- a/drivers/serial/8250_pci.c
> +++ b/drivers/serial/8250_pci.c
> @@ -1100,6 +1100,8 @@ enum pci_board_num_t {
>  	pbn_b0_4_1843200_200,
>  	pbn_b0_8_1843200_200,
>  
> +	pbn_b0_1_4000000,
> +
>  	pbn_b0_bt_1_115200,
>  	pbn_b0_bt_2_115200,
>  	pbn_b0_bt_8_115200,
> @@ -1167,6 +1169,10 @@ enum pci_board_num_t {
>  	pbn_exsys_4055,
>  	pbn_plx_romulus,
>  	pbn_oxsemi,
> +	pbn_oxsemi_1_4000000,
> +	pbn_oxsemi_2_4000000,
> +	pbn_oxsemi_4_4000000,
> +	pbn_oxsemi_8_4000000,
>  	pbn_intel_i960,
>  	pbn_sgi_ioc3,
>  	pbn_computone_4,
> @@ -1290,6 +1296,12 @@ static struct pciserial_board pci_boards[] __devinitdata = {
>  		.base_baud	= 1843200,
>  		.uart_offset	= 0x200,
>  	},
> +	[pbn_b0_1_4000000] = {
> +		.flags		= FL_BASE0,
> +		.num_ports	= 1,
> +		.base_baud	= 4000000,
> +		.uart_offset	= 8,
> +	},
>  
>  	[pbn_b0_bt_1_115200] = {
>  		.flags		= FL_BASE0|FL_BASE_BARS,
> @@ -1625,6 +1637,35 @@ static struct pciserial_board pci_boards[] __devinitdata = {
>  		.base_baud	= 115200,
>  		.uart_offset	= 8,
>  	},
> +	[pbn_oxsemi_1_4000000] = {
> +		.flags		= FL_BASE0,
> +		.num_ports	= 1,
> +		.base_baud	= 4000000,
> +		.uart_offset    = 0x200,
> +        .first_offset   = 0x1000,
> +	},
> +	[pbn_oxsemi_2_4000000] = {
> +		.flags		= FL_BASE0,
> +		.num_ports	= 2,
> +		.base_baud	= 4000000,
> +		.uart_offset    = 0x200,
> +        .first_offset   = 0x1000,
> +	},
> +	[pbn_oxsemi_4_4000000] = {
> +		.flags		= FL_BASE0,
> +		.num_ports	= 4,
> +		.base_baud	= 4000000,
> +		.uart_offset    = 0x200,
> +        .first_offset   = 0x1000,
> +	},
> +	[pbn_oxsemi_8_4000000] = {
> +		.flags		= FL_BASE0,
> +		.num_ports	= 8,
> +		.base_baud	= 4000000,
> +		.uart_offset    = 0x200,
> +        .first_offset   = 0x1000,
> +	},
> +
>  
>  	/*
>  	 * EKF addition for i960 Boards form EKF with serial port.
> @@ -1813,6 +1854,34 @@ serial_pci_matches(struct pciserial_board *board,
>  	    board->first_offset == guessed->first_offset;
>  }
>  
> +/*
> + * Oxford Semiconductor Inc.
> + * Check that device is part of the Tornado range of devices, then determine
> + * the number of ports available on the device.
> + */
> +static int pci_oxsemi_tornado_init(struct pci_dev *dev, struct pciserial_board *board)
> +{
> +	u8 __iomem *p;
> +	unsigned long deviceID;
> +	unsigned int  number_uarts;
> +
> +	p = pci_iomap(dev, 0, 5);
> +	if (p == NULL)
> +		return -ENOMEM;
> +    
> +	deviceID = ioread32(p);
> +	/* Tornado device */
> +	if (deviceID == 0x07000200) {
> +		number_uarts = ioread8(p + 4);
> +		board->num_ports = number_uarts;
> +		printk(KERN_DEBUG
> +			"%d ports detected on Oxford PCI Express device\n",
> +								number_uarts);
> +	}
> +	pci_iounmap(dev, p);
> +	return 0;
> +}
> +
>  struct serial_private *
>  pciserial_init_ports(struct pci_dev *dev, struct pciserial_board *board)
>  {
> @@ -1821,6 +1890,12 @@ pciserial_init_ports(struct pci_dev *dev, struct pciserial_board *board)
>  	struct pci_serial_quirk *quirk;
>  	int rc, nr_ports, i;
>  
> +	/*
> +	 * Find number of ports on board
> +	 */
> +	 if (dev->vendor == PCI_VENDOR_ID_OXSEMI)
> +	 	pci_oxsemi_tornado_init(dev, board);
> +    

WTF is this ? Why existing pci_serial_quirks[] infrastructure isn't used here ? 

>  	nr_ports = board->num_ports;
>  
>  	/*
> @@ -2300,6 +2375,142 @@ static struct pci_device_id serial_pci_tbl[] = {
>  		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
>  		pbn_b0_bt_2_921600 },
>  
> +    /*
> +     * Oxford Semiconductor Inc. Tornado PCI express device range.
> +     */
> + 	{	PCI_VENDOR_ID_OXSEMI, 0xc101,    /* OXPCIe952 1 Legacy UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_b0_1_4000000 },
> + 	{	PCI_VENDOR_ID_OXSEMI, 0xc105,    /* OXPCIe952 1 Legacy UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_b0_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc11b,    /* OXPCIe952 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc11f,    /* OXPCIe952 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> + 	{	PCI_VENDOR_ID_OXSEMI, 0xc120,    /* OXPCIe952 1 Legacy UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_b0_1_4000000 },
> + 	{	PCI_VENDOR_ID_OXSEMI, 0xc124,    /* OXPCIe952 1 Legacy UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_b0_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc138,    /* OXPCIe952 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc13d,    /* OXPCIe952 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc140,    /* OXPCIe952 1 Legacy UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_b0_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc141,    /* OXPCIe952 1 Legacy UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_b0_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc144,    /* OXPCIe952 1 Legacy UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_b0_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc145,    /* OXPCIe952 1 Legacy UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_b0_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc158,    /* OXPCIe952 2 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_2_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc15d,    /* OXPCIe952 2 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_2_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc208,    /* OXPCIe954 4 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_4_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc20d,    /* OXPCIe954 4 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_4_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc308,    /* OXPCIe958 8 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_8_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc30d,    /* OXPCIe958 8 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_8_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc40b,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc40f,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc41b,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc41f,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc42b,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc42f,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc43b,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc43f,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc44b,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc44f,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc45b,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc45f,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc46b,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc46f,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc47b,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc47f,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc48b,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc48f,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc49b,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc49f,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc4ab,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc4af,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc4bb,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc4bf,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc4cb,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +	{	PCI_VENDOR_ID_OXSEMI, 0xc4cf,    /* OXPCIe200 1 Native UART */
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_oxsemi_1_4000000 },
> +
>  	/*
>  	 * SBS Technologies, Inc. P-Octal and PMC-OCTPRO cards,
>  	 * from skokodyn@yahoo.com
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 8edddc2..df6e42b 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -1944,6 +1944,14 @@
>  
>  #define PCI_VENDOR_ID_OXSEMI		0x1415
>  #define PCI_DEVICE_ID_OXSEMI_12PCI840	0x8403
> +#define PCI_DEVICE_ID_OXSEMI_PCIe840		0xC000
> +#define PCI_DEVICE_ID_OXSEMI_PCIe840_G		0xC004
> +#define PCI_DEVICE_ID_OXSEMI_PCIe952_0		0xC100
> +#define PCI_DEVICE_ID_OXSEMI_PCIe952_0_G	0xC104
> +#define PCI_DEVICE_ID_OXSEMI_PCIe952_1		0xC110
> +#define PCI_DEVICE_ID_OXSEMI_PCIe952_1_G	0xC114
> +#define PCI_DEVICE_ID_OXSEMI_PCIe952_1_U	0xC118
> +#define PCI_DEVICE_ID_OXSEMI_PCIe952_1_GU	0xC11C
>  #define PCI_DEVICE_ID_OXSEMI_16PCI954	0x9501
>  #define PCI_DEVICE_ID_OXSEMI_16PCI95N	0x9511
>  #define PCI_DEVICE_ID_OXSEMI_16PCI954PP	0x9513
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
