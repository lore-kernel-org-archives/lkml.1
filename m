Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbZJUS5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbZJUS5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 14:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZJUS5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 14:57:13 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:25350 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbZJUS5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 14:57:12 -0400
Date: Wed, 21 Oct 2009 12:57:15 -0600
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] pci: pciehp update the slot bridge res to get big
	range for pcie devices
Message-ID: <20091021185715.GJ23948@ldl.fc.hp.com>
References: <4ADEB601.8020200@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADEB601.8020200@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu <yinghai@kernel.org>:
> @@ -144,9 +182,6 @@ static void pci_setup_bridge(struct pci_
>  	u32 l, bu, lu, io_upper16;
>  	int pref_mem64;
>  
> -	if (pci_is_enabled(bridge))
> -		return;
> -
>  	dev_info(&bridge->dev, "PCI bridge, secondary bus %04x:%02x\n",
>  		 pci_domain_nr(bus), bus->number);

Have you tested this with the hotplug facilities I added a while
back?

Basically, what happens when you offline a bridge using

	/sys/bus/pci/devices/.../remove

And then re-add it using:

	/sys/bus/pci/rescan

Please try this both for bridges that are claimed by pciehp as
well as bridges that are not claimed.

Thanks.

/ac

