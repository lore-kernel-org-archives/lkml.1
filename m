Return-Path: <linux-kernel-owner+w=401wt.eu-S935152AbYD1TBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935152AbYD1TBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966174AbYD1TAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:00:43 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43092 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935089AbYD1TAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:00:41 -0400
Message-ID: <48161ED2.8030306@linux.vnet.ibm.com>
Date: Mon, 28 Apr 2008 14:00:34 -0500
From: "V. Ananda Krishnan" <mansarov@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Kilau, Scott" <Scott.Kilau@digi.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Add new supported board to jsm serial driver.
References: <335DD0B75189FB428E5C32680089FB9F01DF1A49@mtk-sms-mail01.digi.com>
In-Reply-To: <335DD0B75189FB428E5C32680089FB9F01DF1A49@mtk-sms-mail01.digi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Ananda V <avenkat@us.ibm.com>

Kilau, Scott wrote:
> From: Scott Kilau <scottk@digi.com>
>
> [PATCH] Add new supported board to jsm serial driver.
> Add new PCI Express Neo/JSM board to the supported list of drivers in
> the JSM driver.
>
> Signed-off-by: Scott Kilau <scottk@digi.com>
>
>
> diff -uprN -X /usr/src/kernels/linux-2.6.25.orig/Documentation/dontdiff
> /usr/src/kernels/linux-2.6.25.orig/drivers/serial/jsm/jsm_driver.c
> /usr/src/kernels/linux-2.6.25/drivers/serial/jsm/jsm_driver.c
> --- /usr/src/kernels/linux-2.6.25.orig/drivers/serial/jsm/jsm_driver.c
> 2008-04-16 21:49:44.000000000 -0500
> +++ /usr/src/kernels/linux-2.6.25/drivers/serial/jsm/jsm_driver.c
> 2008-04-25 11:35:31.000000000 -0500
> @@ -82,7 +82,10 @@ static int jsm_probe_one(struct pci_dev 
>  	/* store the info for the board we've found */
>  	brd->boardnum = adapter_count++;
>  	brd->pci_dev = pdev;
> -	brd->maxports = 2;
> +	if (pdev->device == PCIE_DEVICE_ID_NEO_4_IBM)
> +		brd->maxports = 4;
> +	else
> +		brd->maxports = 2;
>
>  	spin_lock_init(&brd->bd_lock);
>  	spin_lock_init(&brd->bd_intr_lock);
> @@ -208,6 +211,7 @@ static struct pci_device_id jsm_pci_tbl[
>  	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2DB9PRI), 0,
> 0, 1 },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2RJ45), 0, 0,
> 2 },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2RJ45PRI), 0,
> 0, 3 },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_4_IBM), 0,
> 0, 4 },
>  	{ 0, }
>  };
>  MODULE_DEVICE_TABLE(pci, jsm_pci_tbl);
> diff -uprN -X /usr/src/kernels/linux-2.6.25.orig/Documentation/dontdiff
> /usr/src/kernels/linux-2.6.25.orig/drivers/serial/jsm/jsm.h
> /usr/src/kernels/linux-2.6.25/drivers/serial/jsm/jsm.h
> --- /usr/src/kernels/linux-2.6.25.orig/drivers/serial/jsm/jsm.h
> 2008-04-16 21:49:44.000000000 -0500
> +++ /usr/src/kernels/linux-2.6.25/drivers/serial/jsm/jsm.h
> 2008-04-25 10:08:04.000000000 -0500
> @@ -373,6 +373,7 @@ struct neo_uart_struct {
>  #define PCI_DEVICE_NEO_2DB9PRI_PCI_NAME		"Neo 2 - DB9
> Universal PCI - Powered Ring Indicator"
>  #define PCI_DEVICE_NEO_2RJ45_PCI_NAME		"Neo 2 - RJ45 Universal
> PCI"
>  #define PCI_DEVICE_NEO_2RJ45PRI_PCI_NAME	"Neo 2 - RJ45 Universal
> PCI - Powered Ring Indicator"
> +#define PCIE_DEVICE_NEO_IBM_PCI_NAME		"Neo 4 - PCI Express -
> IBM"
>
>  /*
>   * Our Global Variables.
> diff -uprN -X /usr/src/kernels/linux-2.6.25.orig/Documentation/dontdiff
> /usr/src/kernels/linux-2.6.25.orig/include/linux/pci_ids.h
> /usr/src/kernels/linux-2.6.25/include/linux/pci_ids.h
> --- /usr/src/kernels/linux-2.6.25.orig/include/linux/pci_ids.h
> 2008-04-16 21:49:44.000000000 -0500
> +++ /usr/src/kernels/linux-2.6.25/include/linux/pci_ids.h
> 2008-04-25 10:10:32.000000000 -0500
> @@ -1429,6 +1429,7 @@
>  #define PCI_DEVICE_ID_NEO_2DB9PRI       0x00C9
>  #define PCI_DEVICE_ID_NEO_2RJ45         0x00CA
>  #define PCI_DEVICE_ID_NEO_2RJ45PRI      0x00CB
> +#define PCIE_DEVICE_ID_NEO_4_IBM        0x00F4
>
>  #define PCI_VENDOR_ID_XIRCOM		0x115d
>  #define PCI_DEVICE_ID_XIRCOM_RBM56G	0x0101
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   

