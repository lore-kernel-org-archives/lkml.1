Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbYJQAer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbYJQAer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYJQAeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 20:34:24 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:44665 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbYJQAeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 20:34:23 -0400
Date: Thu, 16 Oct 2008 18:33:34 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yinghai@kernel.org>, stable@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG][PATCH] cpqphp: fix kernel NULL pointer dereference
Message-ID: <20081017003334.GA28723@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Yinghai Lu <yinghai@kernel.org>, stable@kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <48F7DB17.9020302@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F7DB17.9020302@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> 
> The root cause of this problem seems that cpqphp driver calls
> pci_hp_register() wrongly. In current implementation, cpqphp driver
> passes 'ctrl->pci_dev->subordinate' as a second parameter for
> pci_hp_register(). But because hotplug slots and it's hotplug
> controller (exists as a pci funcion) are on the same bus, it should be
> 'ctrl->pci_dev->bus' instead.
> 
> Cc: <stable@kernel.org>

Acked-by: Alex Chiang <achiang@hp.com>

> Tested-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> ---
>  drivers/pci/hotplug/cpqphp_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-tip/drivers/pci/hotplug/cpqphp_core.c
> ===================================================================
> --- linux-2.6-tip.orig/drivers/pci/hotplug/cpqphp_core.c
> +++ linux-2.6-tip/drivers/pci/hotplug/cpqphp_core.c
> @@ -435,7 +435,7 @@ static int ctrl_slot_setup(struct contro
>  				slot->number, ctrl->slot_device_offset,
>  				slot_number);
>  		result = pci_hp_register(hotplug_slot,
> -					 ctrl->pci_dev->subordinate,
> +					 ctrl->pci_dev->bus,
>  					 slot->device);
>  		if (result) {
>  			err("pci_hp_register failed with error %d\n", result);
> 
