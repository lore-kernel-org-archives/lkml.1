Return-Path: <linux-kernel-owner+w=401wt.eu-S1751125AbXBZGFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbXBZGFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 01:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbXBZGFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 01:05:07 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:23710 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbXBZGFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 01:05:06 -0500
Date: Sun, 25 Feb 2007 22:01:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dmitriy Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [PATCH] libata: handle ata_pci_device_do_resume() failure while
 resuming
Message-Id: <20070225220114.c449ef95.randy.dunlap@oracle.com>
In-Reply-To: <87abz4ble1.fsf@sw.ru>
References: <87abz4ble1.fsf@sw.ru>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Feb 2007 00:43:18 +0300 Dmitriy Monakhov wrote:

> Since commit:553c4aa630af7bc885e056d0436e4eb7f238579b
> ata_pci_device_do_resume() can return error code, all callers was updated
> except this one.
> 
> Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
> ---
>  drivers/ata/sata_inic162x.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
> index 31b636f..7933043 100644
> --- a/drivers/ata/sata_inic162x.c
> +++ b/drivers/ata/sata_inic162x.c
> @@ -639,7 +639,10 @@ static int inic_pci_device_resume(struct pci_dev *pdev)
>  	void __iomem *mmio_base = host->iomap[MMIO_BAR];
>  	int rc;
>  
> -	ata_pci_device_do_resume(pdev);
> +	rc = ata_pci_device_do_resume(pdev);
> +	if (rc) {
> +		return rc;

Either (a) don't use the braces when they are not needed, or
(b) is it possible to add a meaningful message there, or is that
done elsewhere?

> +	}
>  
>  	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
>  		printk("XXX\n");
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
