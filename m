Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbXDUARf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbXDUARf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 20:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXDUARf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 20:17:35 -0400
Received: from canuck.infradead.org ([209.217.80.40]:33259 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbXDUARe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 20:17:34 -0400
Date: Fri, 20 Apr 2007 17:15:10 -0700
From: Greg KH <greg@kroah.com>
To: "Preston A. Elder" <prez@goth.net>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: AGPGart / AMD K7
Message-ID: <20070421001510.GA13287@kroah.com>
References: <4628F00B.3010304@goth.net> <20070420173337.GD20118@redhat.com> <462900BD.8020204@goth.net> <20070420182029.GF20118@redhat.com> <462906E5.8060609@goth.net> <20070420184956.GD13939@redhat.com> <462920EE.2020202@goth.net> <20070420203342.GA622@redhat.com> <462937E1.7040403@goth.net> <46294FE9.8090300@goth.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46294FE9.8090300@goth.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 07:42:33PM -0400, Preston A. Elder wrote:
> Final followup,
> 
> If I compile EDAC out of the kernel completely, everything works now.
> 
> This should be resolved though.
> 1) dd.c should produce some kind of warning when it wants to assign a
> driver to a device, but it can't because a driver is already assigned to
> a device
> 
> ie. change:
>       if (!dev->driver)
>           driver_probe_device(drv, dev);
> to:
>       if (!dev->driver)
>           driver_probe_device(drv, dev);
>       else
>           printk(KERN_WARNING "__driver_attach (%s): alreay registered
> with driver %s\n",
>              dev->bus_id, dev->driver->name);
> 
> 2) Possibly a device should be able to have more than one driver
> associated with it - so the AGP driver and EDAC could both use the
> device in question here (though this would probably be a sizable change).

I'm working on this change for PCI devices right now, but it's slow
going due to some other external things (OLS paper that I am woefully
behind on, etc...)

thanks,

greg k-h
