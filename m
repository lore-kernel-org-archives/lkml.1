Return-Path: <linux-kernel-owner+w=401wt.eu-S1751696AbXBQUWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbXBQUWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 15:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbXBQUWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 15:22:34 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47691 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbXBQUWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 15:22:33 -0500
Message-ID: <45D76406.1060002@garzik.org>
Date: Sat, 17 Feb 2007 15:22:30 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Tim Hockin <thockin@hockin.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] natsemi: Support Aculab E1/T1 PMXc cPCI carrier cards
References: <20070214100203.413293000@sirena.org.uk> <20070214100227.222896000@sirena.org.uk>
In-Reply-To: <20070214100227.222896000@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> Aculab E1/T1 PMXc cPCI carrier card cards present a natsemi on the cPCI
> bus with an oversized EEPROM using a direct MII<->MII connection with no
> PHY.  This patch adds a new device table entry supporting these cards.
> 
> Signed-Off-By: Mark Brown <broonie@sirena.org.uk>

> @@ -811,7 +816,11 @@
>  	np->hands_off = 0;
>  	np->intr_status = 0;
>  	np->eeprom_size = natsemi_pci_info[chip_idx].eeprom_size;
> -	np->ignore_phy = 0;
> +	if (natsemi_pci_info[chip_idx].flags & NATSEMI_FLAG_IGNORE_PHY) {
> +		np->ignore_phy = 1;
> +	} else {
> +		np->ignore_phy = 0;
> +	}


I ACK the patch itself, but since you have to resend anyway, please kill 
the braces surrounding the above single-C-stmt lines.

