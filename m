Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbXEYA1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbXEYA1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 20:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbXEYA1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 20:27:18 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:20503 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbXEYA1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 20:27:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=k4iZCikONZHjGfrdsXR7ueJrGCN+pmv66Hx2QIk21e88RJ8Rdvv0sMtib5cKMI+ZSuwNLyPH4SPeZpnRyei4ku9TBasZdx3uniu85WPTxjLSOWhlbjYWuJTlULmGYP8EGKACk27PRr+DTQamBILrRE9zVTNXt/KeipiB5GgcYfI=
Message-ID: <46562D61.3000107@gmail.com>
Date: Thu, 24 May 2007 17:27:13 -0700
From: Wayne Sherman <wsherman@gmail.com>
Organization: System Design Works
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: PCI device problem - MMCONFIG, cannot allocate resource region,
 resource collisions
References: <46524A6D.5050601@gmail.com> <4654DA5E.2050003@gmail.com> <200705232008.23540.jbarnes@virtuousgeek.org> <200705232010.54184.jbarnes@virtuousgeek.org> <20070524140941.A21491@jurassic.park.msu.ru>
In-Reply-To: <20070524140941.A21491@jurassic.park.msu.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> Actually, it should be something like this (also untested).
> 
> Ivan.
> 
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -1690,6 +1690,14 @@ static void __devinit quirk_p64h2_1k_io(struct pci_dev 
> *dev)
>  }
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	0x1460,		quirk_p64h2_1k_io);
>  
> +/* Give unknown D-Link network adapters a proper class */
> +static void __devinit quirk_dlink_unknown(struct pci_dev *dev)
> +{
> +	if ((dev->class >> 8) == PCI_CLASS_NOT_DEFINED)
> +		dev->class = PCI_CLASS_NETWORK_ETHERNET << 8;
> +}
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_DLINK, 0x4901, quirk_dlink_unknown);

Ivan,

   I tried a couple variations of the patch above.  It got me further, 
but I still wasn't getting the base address assigned properly.  I 
suspected a bad card, so I tried another one I have here.  It is likely 
that I have been fighting with bad hardware all this time.  The other 
card has a known device ID, a proper class code, and does not give 
resource allocation errors.  I have an e-mail into D-Link to inquire 
about the buggy card.

   I appreciate both yours and Jesse's help to troubleshoot this problem.

Best Regards,

Wayne Sherman

