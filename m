Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbZAPUJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbZAPUJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 15:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbZAPUIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 15:08:49 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:55731 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbZAPUIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 15:08:48 -0500
Date: Fri, 16 Jan 2009 15:08:32 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: ACPI hotplug panic with current git head
In-reply-to: <4970242C.4010404@jp.fujitsu.com>
X-X-Sender: lenb@localhost.localdomain
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, "Barnes, Jesse" <jesse.barnes@intel.com>,
       shaohua.li@intel.com
Message-id: <alpine.LFD.2.00.0901161504140.5705@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1231604250.3642.33.camel@localhost.localdomain>
 <alpine.LFD.2.00.0901121604380.5859@localhost.localdomain>
 <1231807693.27151.21.camel@localhost.localdomain>
 <1232046108.5966.57.camel@localhost.localdomain>
 <alpine.LFD.2.00.0901151421110.4737@localhost.localdomain>
 <1232049269.5966.64.camel@localhost.localdomain>
 <1232050347.5966.66.camel@localhost.localdomain>
 <4970242C.4010404@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It looks like acpi_pci_get_bridge_handle() is returning NULL, so this is
> > the fix that works for me.
> > 
> 
> I'm sorry for troubling you, and thank you for your patience.
> 
> The patch seems to avoid the kernel panic, but I still don't know
> why acpi_pci_get_bridge_handle() returns NULL here. I assumed
> it should return non-NULL value here. So I'd like to investigate
> it more.
> 


Kenji,
I'd like to push jejb's 1-liner upstream now.
It make sense, and it prevents a boot panic regression
that I'd rather not have others experience in rc2.

I agree that it is important to hotplug for you to figure out
why this machine runs down that path in the first place,
and I'm sure that James will continue to work with you
on that after the 1-liner is in.

thanks
Len Brown, Intel Open Source Technology Center


> > 
> > diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> > index f09b101..803d9dd 100644
> > --- a/drivers/pci/hotplug/acpiphp_glue.c
> > +++ b/drivers/pci/hotplug/acpiphp_glue.c
> > @@ -266,6 +266,8 @@ static int detect_ejectable_slots(struct pci_bus *pbus)
> >  	int found = acpi_pci_detect_ejectable(pbus);
> >  	if (!found) {
> >  		acpi_handle bridge_handle = acpi_pci_get_bridge_handle(pbus);
> > +		if (!bridge_handle)
> > +			return 0;
> >  		acpi_walk_namespace(ACPI_TYPE_DEVICE, bridge_handle, (u32)1,
> >  				    is_pci_dock_device, (void *)&found, NULL);
> >  	}

