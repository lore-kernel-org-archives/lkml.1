Return-Path: <linux-kernel-owner+w=401wt.eu-S932149AbZKMUHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbZKMUHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 15:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932207AbZKMUH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 15:07:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48475 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbZKMUH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 15:07:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Breno Leitao <leitao@linux.vnet.ibm.com>
Subject: Re: PCI: pci_restore_state() is returning 0 when it fails
Date: Fri, 13 Nov 2009 21:08:56 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc6-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <4AFD91DD.7000104@linux.vnet.ibm.com>
In-Reply-To: <4AFD91DD.7000104@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911132108.56691.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 November 2009, Breno Leitao wrote:
> Actually pci_restore_state() is returning 0 if the restore process
> fails, instead of a error value.
> 
> If it fails, I believe that it should return -EPERM, once that
> it is an invalid operation and probably pci_save_state() wasn't
> called.

I believe this patch will break a number of things.

Does it actually fix any problem you have observed?

Rafael


> Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
> ---
>  drivers/pci/pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 4e4c295..b677ca3 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -857,7 +857,7 @@ pci_restore_state(struct pci_dev *dev)
>  	u32 val;
>  
>  	if (!dev->state_saved)
> -		return 0;
> +		return -EPERM;
>  
>  	/* PCI Express register must be restored first */
>  	pci_restore_pcie_state(dev);
> 

