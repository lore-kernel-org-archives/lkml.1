Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab0BVBhf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 20:37:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:32906 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab0BVBhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 20:37:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,514,1262592000"; 
   d="scan'208";a="246452545"
Subject: Re: [PATCH] drivers: acpi: fan.c move a dereference below the NULL
 test
From: Zhang Rui <rui.zhang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Darren Jenkins <darrenrjenkins@gmail.com>,
       Thomas Renninger <trenn@suse.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       Matthew Garrett <mjg@redhat.com>,
       linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1002190026070.17638@localhost.localdomain>
References: <1265882202.27789.0.camel@ICE-BOX>
	 <alpine.LFD.2.00.1002190026070.17638@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Feb 2010 09:37:03 +0800
Message-ID: <1266802623.2608.1471.camel@rzhang1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 13:27 +0800, Len Brown wrote:
> I think think this is a run-time check for a programming error,
> and the current fashion is to delete the check and take a fault
> if this happens so the caller can be fixed.
> 
I agree.

> There are a couple of checks like this in fan.c --
> perhaps Rui can clean them up when he comes back next week.
> 
I'll send the cleanup patch later.

thanks,
rui

> thanks,
> Len Brown, Intel Open Source Technology Center
> 
> On Thu, 11 Feb 2010, Darren Jenkins wrote:
> 
> > In acpi_fan_remove() device is being dereferenced before the NULL test.
> > This reorders the code to ensure it is checked for NULL first.
> > 
> > Coverity CID: 2758
> > 
> > Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
> > ---
> >  drivers/acpi/fan.c |    9 +++++++--
> >  1 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
> > index acf2ab2..dc39640 100644
> > --- a/drivers/acpi/fan.c
> > +++ b/drivers/acpi/fan.c
> > @@ -298,9 +298,14 @@ static int acpi_fan_add(struct acpi_device *device)
> >  
> >  static int acpi_fan_remove(struct acpi_device *device, int type)
> >  {
> > -	struct thermal_cooling_device *cdev = acpi_driver_data(device);
> > +	struct thermal_cooling_device *cdev;
> > +
> > +	if (!device)
> > +		return -EINVAL;
> > +
> > +	cdev = acpi_driver_data(device);
> >  
> > -	if (!device || !cdev)
> > +	if (!cdev)
> >  		return -EINVAL;
> >  
> >  	acpi_fan_remove_fs(device);
> > -- 
> > 1.6.3.3
> > 
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 


