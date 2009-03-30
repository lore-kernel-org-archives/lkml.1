Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbZC3CPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbZC3CPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 22:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbZC3CO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 22:14:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49693 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbZC3CO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 22:14:57 -0400
Message-ID: <49D02B0F.5060409@jp.fujitsu.com>
Date: Mon, 30 Mar 2009 11:14:39 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] PCI: allow PCI core hotplug to remove PCI root bus
References: <20090329165352.29073.5159.stgit@bob.kio> <20090329165444.29073.36246.stgit@bob.kio>
In-Reply-To: <20090329165444.29073.36246.stgit@bob.kio>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> There is no reason to prevent root bus removal. We never actually
> remove the node from the pci_root_buses list, so a rescan will correctly
> rediscover the root bus.
> 

I'm a little confused about the description. I don't think the
patch is for allowing pci root bus removal. I think it is for
allowing removal of pci devices on pci root buses.

Thanks,
Kenji Kaneshige


> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
>  drivers/pci/pci-sysfs.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index e9a8706..7b2cb27 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -277,14 +277,10 @@ remove_store(struct device *dev, struct device_attribute *dummy,
>  {
>  	int ret = 0;
>  	unsigned long val;
> -	struct pci_dev *pdev = to_pci_dev(dev);
>  
>  	if (strict_strtoul(buf, 0, &val) < 0)
>  		return -EINVAL;
>  
> -	if (pci_is_root_bus(pdev->bus))
> -		return -EBUSY;
> -
>  	/* An attribute cannot be unregistered by one of its own methods,
>  	 * so we have to use this roundabout approach.
>  	 */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


