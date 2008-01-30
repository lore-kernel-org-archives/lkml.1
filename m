Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbYA3Q33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbYA3Q33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYA3Q3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 11:29:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:11066 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbYA3Q3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:29:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,278,1199692800"; 
   d="scan'208";a="294377255"
Message-ID: <47A0A5B0.8090605@intel.com>
Date: Wed, 30 Jan 2008 08:28:32 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>, Jeff Garzik <jeff@garzik.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       auke-jan.h.kok@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, john.ronciak@intel.com,
       e1000-devel@lists.sourceforge.net, venkatesh.pallipadi@intel.com
Subject: Re: [PATCH 1/1] Net: e100, fix iomap mem accesses
References: <479F9E14.1070700@intel.com> <1201643356-28221-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1201643356-28221-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jan 2008 16:29:19.0596 (UTC) FILETIME=[43850AC0:01C8635D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Patch against netdev-2.6 follows.
> --
> writeX functions are not permitted on iomap-ped space change to iowriteX,
> also pci_unmap pci_map-ped space on exit (instead of iounmap).
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/net/e100.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/e100.c b/drivers/net/e100.c
> index 51cf577..47548ef 100644
> --- a/drivers/net/e100.c
> +++ b/drivers/net/e100.c
> @@ -1904,7 +1904,7 @@ static void e100_rx_clean(struct nic *nic, unsigned int *work_done,
>  
>  	if(restart_required) {
>  		// ack the rnr?
> -		writeb(stat_ack_rnr, &nic->csr->scb.stat_ack);
> +		iowrite8(stat_ack_rnr, &nic->csr->scb.stat_ack);
>  		e100_start_receiver(nic, rx_to_start);
>  		if(work_done)
>  			(*work_done)++;
> @@ -2706,7 +2706,7 @@ static void __devexit e100_remove(struct pci_dev *pdev)
>  		struct nic *nic = netdev_priv(netdev);
>  		unregister_netdev(netdev);
>  		e100_free(nic);
> -		iounmap(nic->csr);
> +		pci_iounmap(pdev, nic->csr);
>  		free_netdev(netdev);
>  		pci_release_regions(pdev);
>  		pci_disable_device(pdev);


Acked-By: Auke Kok <auke-jan.h.kok@intel.com>

Jeff, feel free to merge in upstream-fixes.

Cheers,

Auke

