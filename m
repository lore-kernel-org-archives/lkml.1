Return-Path: <linux-kernel-owner+w=401wt.eu-S1760630AbZFPRNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630AbZFPRNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbZFPRNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:13:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:19304 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbZFPRNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:13:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,230,1243839600"; 
   d="scan'208";a="466915851"
Date: Tue, 16 Jun 2009 10:13:11 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 45/64] PCIE: remove driver_data direct access of struct
 device
Message-ID: <20090616101311.747a3f19@jbarnes-g45>
In-Reply-To: <1245131213-24168-45-git-send-email-gregkh@suse.de>
References: <20090616051351.GA23627@kroah.com>
	<1245131213-24168-45-git-send-email-gregkh@suse.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 22:46:34 -0700
Greg Kroah-Hartman <gregkh@suse.de> wrote:

> In the near future, the driver core is going to not allow direct
> access to the driver_data pointer in struct device.  Instead, the
> functions dev_get_drvdata() and dev_set_drvdata() should be used.
> These functions have been around since the beginning, so are
> backwards compatible with all older kernel versions.
> 
> 
> Cc: linux-pci@vger.kernel.org
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/pci/pcie/portdrv_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/pcie/portdrv_core.c
> b/drivers/pci/pcie/portdrv_core.c index e399825..13ffdc3 100644
> --- a/drivers/pci/pcie/portdrv_core.c
> +++ b/drivers/pci/pcie/portdrv_core.c
> @@ -275,7 +275,7 @@ static void pcie_device_init(struct pci_dev
> *parent, struct pcie_device *dev, memset(device, 0, sizeof(struct
> device)); device->bus = &pcie_port_bus_type;
>  	device->driver = NULL;
> -	device->driver_data = NULL;
> +	dev_set_drvdata(device, NULL);
>  	device->release = release_pcie_device;	/* callback to
> free pcie dev */ dev_set_name(device, "%s:pcie%02x",
>  		 pci_name(parent), get_descriptor_id(port_type,
> service_type));

Looks like I already have this one in my linux-next branch, but I think
Linus will handle any conflict that arises if this ends up coming from
both of us.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
