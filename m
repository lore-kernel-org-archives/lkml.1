Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbZFKS2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbZFKS2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbZFKS2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:28:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:28678 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214AbZFKS2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:28:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,203,1243839600"; 
   d="scan'208";a="465547411"
Date: Thu, 11 Jun 2009 11:27:48 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: eliminate redundant pci_stop_dev() call from
 pci_destroy_dev()
Message-ID: <20090611112748.0601e347@jbarnes-g45>
In-Reply-To: <20090519010222.12679.74898.stgit@bob.kio>
References: <20090519010222.12679.74898.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 19:02:38 -0600
Alex Chiang <achiang@hp.com> wrote:

> We always call pci_stop_bus_device before calling pci_destroy_dev.
> 
> Since pci_stop_bus_device calls pci_stop_dev, there is no need
> for pci_destroy_dev to repeat the call.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
>  drivers/pci/remove.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index 86503c1..176615e 100644
> --- a/drivers/pci/remove.c
> +++ b/drivers/pci/remove.c
> @@ -32,8 +32,6 @@ static void pci_stop_dev(struct pci_dev *dev)
>  
>  static void pci_destroy_dev(struct pci_dev *dev)
>  {
> -	pci_stop_dev(dev);
> -
>  	/* Remove the device from the device lists, and prevent any
> further
>  	 * list accesses from this device */
>  	down_write(&pci_bus_sem);

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
