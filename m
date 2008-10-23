Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbYJWUv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbYJWUv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 16:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYJWUvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 16:51:18 -0400
Received: from kroah.org ([198.145.64.141]:51410 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751122AbYJWUvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 16:51:17 -0400
Date: Thu, 23 Oct 2008 13:37:32 -0700
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yinghai@kernel.org>, stable@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [BUG][PATCH] cpqphp: fix kernel NULL pointer
	dereference
Message-ID: <20081023203732.GA17600@kroah.com>
References: <48F7DB17.9020302@jp.fujitsu.com> <20081017003334.GA28723@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017003334.GA28723@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 06:33:34PM -0600, Alex Chiang wrote:
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> > 
> > The root cause of this problem seems that cpqphp driver calls
> > pci_hp_register() wrongly. In current implementation, cpqphp driver
> > passes 'ctrl->pci_dev->subordinate' as a second parameter for
> > pci_hp_register(). But because hotplug slots and it's hotplug
> > controller (exists as a pci funcion) are on the same bus, it should be
> > 'ctrl->pci_dev->bus' instead.
> > 
> > Cc: <stable@kernel.org>
> 
> Acked-by: Alex Chiang <achiang@hp.com>

This patch doesn't seem to have made it upstream.

Jesse, is it queued up in any of your trees?

thanks,

greg k-h

> 
> > Tested-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> > 
> > ---
> >  drivers/pci/hotplug/cpqphp_core.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6-tip/drivers/pci/hotplug/cpqphp_core.c
> > ===================================================================
> > --- linux-2.6-tip.orig/drivers/pci/hotplug/cpqphp_core.c
> > +++ linux-2.6-tip/drivers/pci/hotplug/cpqphp_core.c
> > @@ -435,7 +435,7 @@ static int ctrl_slot_setup(struct contro
> >  				slot->number, ctrl->slot_device_offset,
> >  				slot_number);
> >  		result = pci_hp_register(hotplug_slot,
> > -					 ctrl->pci_dev->subordinate,
> > +					 ctrl->pci_dev->bus,
> >  					 slot->device);
> >  		if (result) {
> >  			err("pci_hp_register failed with error %d\n", result);
> > 
> 
> _______________________________________________
> stable mailing list
> stable@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable
