Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZHPUSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZHPUSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 16:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZHPUSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 16:18:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60566 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbZHPUSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 16:18:49 -0400
Message-ID: <4A8869A3.7020504@garzik.org>
Date: Sun, 16 Aug 2009 16:18:43 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "Subbrathnam, Swaminathan" <swami.iyer@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sata AHCI controller over non-PCI bus
References: <FCCFB4CDC6E5564B9182F639FC35608702F5989152@dbde02.ent.ti.com>	 <4A7FE245.8020002@ru.mvista.com>	 <FCCFB4CDC6E5564B9182F639FC35608702F59891CB@dbde02.ent.ti.com>	 <4A88014D.9060309@garzik.org> <1250436892.3856.87.camel@mulgrave.site>
In-Reply-To: <1250436892.3856.87.camel@mulgrave.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2009 11:34 AM, James Bottomley wrote:
> Can't you get the best of both worlds?  Do the separation but
> artificially glue them together again as a module at link time.  This
> solves the current distro problem and you can remove the linker hack as
> soon as the distros get their act together.
>
> James
>
> ---
>
> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> index 9f7b500..10101d7 100644
> --- a/drivers/ata/Makefile
> +++ b/drivers/ata/Makefile
> @@ -1,8 +1,10 @@
>
>   obj-$(CONFIG_ATA)		+= libata.o
>
> -obj-$(CONFIG_SATA_AHCI)		+= libahci.o ahci.o
> -obj-$(CONFIG_SATA_ACARD_AHCI)	+= libahci.o acard-ahci.o
> +obj-$(CONFIG_SATA_AHCI)		+= ahci_mod.o
> +obj-ahci_mod-y			+= libahci.o ahci.o
> +obj-ahci_mod-$(CONFIG_SATA_ACARD_AHCI)	+= acard-ahci.o
> +obj-ahci_mod-$(CONFIG_SATA_MV_AHCI)	+= mv-ahci.o


Yeah, that could definitely be an option...

	Jeff


