Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbYKHLKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbYKHLKb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 06:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYKHLKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 06:10:23 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:27672 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYKHLKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 06:10:22 -0500
Date: Sat, 8 Nov 2008 12:09:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/5] i5k_amb: Load automatically on all 5000/5400
 chipsets
Message-ID: <20081108120950.397a3165@hyperion.delvare>
In-Reply-To: <20081107185631.13022.59600.stgit@elm3a70.beaverton.ibm.com>
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
	<20081107185631.13022.59600.stgit@elm3a70.beaverton.ibm.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Fri, 07 Nov 2008 10:56:31 -0800, Darrick J. Wong wrote:
> It turns out that we cannot create a pci_driver in this driver because PCI will
> not call this module's probe function if the i5000-edac driver is already
> loaded.

I seem to recall work in progress to let multiple drivers bind to the
same PCI device. Greg, Kay, what's the status?

> That said, we only want one value (AMBASE) from the PCI config space.
> Neither driver alters this value, so it's safe to read it.  However, we still
> want the module aliases, so provide that.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/hwmon/i5k_amb.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/i5k_amb.c b/drivers/hwmon/i5k_amb.c
> index 2ede938..a3fa639 100644
> --- a/drivers/hwmon/i5k_amb.c
> +++ b/drivers/hwmon/i5k_amb.c
> @@ -490,6 +490,14 @@ static unsigned long chipset_ids[] = {
>  	0
>  };
>  
> +static struct pci_device_id i5k_amb_ids[] __devinitdata = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5000_ERR) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5400_ERR) },
> +	{ 0, },
> +};
> +
> +MODULE_DEVICE_TABLE(pci, i5k_amb_ids);
> +
>  static int __devinit i5k_amb_probe(struct platform_device *pdev)
>  {
>  	struct i5k_amb_data *data;
> 

Looks good to me, we can apply this for now.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
