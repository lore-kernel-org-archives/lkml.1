Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYIMUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYIMUQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 16:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYIMUQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 16:16:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34873 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbYIMUQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 16:16:07 -0400
Message-ID: <48CC1F7C.7050908@garzik.org>
Date: Sat, 13 Sep 2008 16:15:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alessandro Guido <alessandro.guido@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] e100: Use pci_pme_active to clear PME_Status and disable
 PME#
References: <200808051730.27599.alessandro.guido@gmail.com> <200808080000.07156.rjw@sisk.pl> <200808080014.25493.rjw@sisk.pl> <200808080018.05887.rjw@sisk.pl>
In-Reply-To: <200808080018.05887.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> e100: Use pci_pme_active to clear PME_Status and disable PME#
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> ---
>  drivers/net/e100.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> Index: linux-2.6/drivers/net/e100.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/e100.c
> +++ linux-2.6/drivers/net/e100.c
> @@ -2738,9 +2738,7 @@ static int __devinit e100_probe(struct p
>  		nic->flags |= wol_magic;
>  
>  	/* ack any pending wake events, disable PME */
> -	err = pci_enable_wake(pdev, 0, 0);
> -	if (err)
> -		DPRINTK(PROBE, ERR, "Error clearing wake event\n");
> +	pci_pme_active(pdev, false);

Since I am rusty on my PCI...  why is this needed?


