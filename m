Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbYGCTdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbYGCTdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYGCTdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:33:31 -0400
Received: from outbound-mail-106.bluehost.com ([69.89.22.6]:53824 "HELO
	outbound-mail-106.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753409AbYGCTda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:33:30 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 02/04] PCI: handle pci_name() being const
Date: Thu, 3 Jul 2008 12:33:17 -0700
User-Agent: KMail/1.9.9
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       davem@davemloft.net
References: <20080702200902.909349505@mini.kroah.org> <20080702202449.GB14024@kroah.com>
In-Reply-To: <20080702202449.GB14024@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807031233.18759.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 02, 2008 1:24 pm Greg Kroah-Hartman wrote:
> This changes pci_setup_device to handle pci_name() now returning a
> constant string.
>
> Cc: Jesse Barns <jbarnes@virtuousgeek.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  drivers/pci/probe.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -711,8 +711,9 @@ static int pci_setup_device(struct pci_d
>  {
>  	u32 class;
>
> -	sprintf(pci_name(dev), "%04x:%02x:%02x.%d", pci_domain_nr(dev->bus),
> -		dev->bus->number, PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
> +	dev_set_name(&dev->dev, "%04x:%02x:%02x.%d", pci_domain_nr(dev->bus),
> +		     dev->bus->number, PCI_SLOT(dev->devfn),
> +		     PCI_FUNC(dev->devfn));
>
>  	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
>  	dev->revision = class & 0xff;

Just applied this to my linux-next branch (fortunately I already had the 
dev_set_name commit).  Doing a quick build & test before I push it out.

Thanks,
Jesse
