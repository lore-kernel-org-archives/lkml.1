Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbXLLIbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbXLLIbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 03:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbXLLIbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 03:31:45 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:56560 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbXLLIbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 03:31:44 -0500
Subject: Re: [PATCH] pcie AER: don't check _OSC when acpi is disabled
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200712112013.48346.yinghai.lu@sun.com>
References: <200712112013.48346.yinghai.lu@sun.com>
Content-Type: text/plain
Organization: IBM
Date: Wed, 12 Dec 2007 14:01:41 +0530
Message-Id: <1197448301.4710.33.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would you like to submit the Driver Test Cases to LTP ? Or, if you have
your Driver test cases written in C, we can port to LTP and have it
inside the LTP package.
You can also check out the following links for more info, and can always
ping me for anything:
http://ltp.cvs.sourceforge.net/ltp/ltp/testcases/kernel/device-drivers/,
http://ltp.sourceforge.net/documentation/how-to/ltp.php?

Regards--
Subrata
(LTP Maintainer)

On Tue, 2007-12-11 at 20:13 -0800, Yinghai Lu wrote:
> [PATCH] pcie AER: don't check _OSC when acpi is disabled
> 
> when acpi=off and pci=nomsi, don't check _OSC in aer_osc_setup
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 
> diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
> index 1a1eb45..dd38777 100644
> --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
> +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
> @@ -34,6 +34,9 @@ int aer_osc_setup(struct pcie_device *pciedev)
>  	acpi_handle handle = DEVICE_ACPI_HANDLE(&pdev->dev);
>  	struct pci_bus *parent;
> 
> +	if (acpi_pci_disabled)
> +		return -1;
> +
>  	while (!handle) {
>  		if (!pdev || !pdev->bus->parent)
>  			break;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

