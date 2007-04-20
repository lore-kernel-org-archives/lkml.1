Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbXDTWAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbXDTWAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 18:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXDTWAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 18:00:23 -0400
Received: from sanctuary.goth.net ([64.27.17.130]:53934 "EHLO mail.goth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbXDTWAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 18:00:22 -0400
Message-ID: <462937E1.7040403@goth.net>
Date: Fri, 20 Apr 2007 18:00:01 -0400
From: "Preston A. Elder" <prez@goth.net>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, "Preston A. Elder" <prez@goth.net>,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: AGPGart / AMD K7
References: <46286775.5000507@goth.net> <20070420155537.GA20118@redhat.com> <4628F00B.3010304@goth.net> <20070420173337.GD20118@redhat.com> <462900BD.8020204@goth.net> <20070420182029.GF20118@redhat.com> <462906E5.8060609@goth.net> <20070420184956.GD13939@redhat.com> <462920EE.2020202@goth.net> <20070420203342.GA622@redhat.com>
In-Reply-To: <20070420203342.GA622@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Fri, Apr 20, 2007 at 04:22:06PM -0400, Preston A. Elder wrote:
>  > Dave, Greg,
>  > 
>  > Here is the trace with 2.6.20.6
>  > 
>  > I added back in my trace code, as you see.  As you can also see,
>  > agp_amdk7_probe is still not called.
>
> Try looking down in __driver_attach()
> The fact that we're not calling the ->probe function is quite bizarre.
>
> It could be this in __driver_attach
>
>         if (!dev->driver)
>                 driver_probe_device(drv, dev);
>
> Though that'd be odd.
>
> Putting a #define DEBUG 1 in drivers/base/dd.c may also yield some clues.
>
> 	Dave
>
>   
OK, I found it!

Here is more trace:
Linux agpgart interface v0.101 (c) Dave Jones
agp_amdk7_init: In function
agp_amdk7_init: Before pci_register_driver
__pci_register_driver: In Function (driver = agpgart-amdk7, multithread = 0)
__pci_register_driver: Before Spinlock
__pci_register_driver: Before Init List Head
__pci_register_driver: Before driver_register
bus_add_driver: In Function (c0492920)
bus_add_driver: Before kobject_set_name
bus_add_driver: error = 0
bus_add_driver: Before kobject_register
bus_add_driver: error = 0
bus_add_driver: Before driver_attach
__driver_attach (0000:00:00.0,1): Before Down (parent) (c21c8600)
__driver_attach (0000:00:00.0, 1): Before Down
__driver_attach (0000:00:00.0, 1): Before Probe Device (c049fe54)
__driver_attach (0000:00:00.0, 1): alreay registered with driver amd76x_edac
__driver_attach (0000:00:00.0, 1): Before Up
__driver_attach (0000:00:00.0, 1): Before Up (parent) (c21c8600)
__driver_attach (0000:00:00.0, 1): Returning 0
bus_add_driver: error = 0
bus_add_driver: Before klist_add_tail
bus_add_driver: Before module_add_driver
bus_add_driver: Before driver_add_attrs
bus_add_driver: error = 0
bus_add_driver: Before add_bind_files
bus_add_driver: error = 0
bus_add_driver: Returning 0
__pci_register_driver: error = 0
__pci_register_driver: Before pci_create_newid_file
__pci_register_driver: error = 0
__pci_register_driver: Returning 0

I snipped some since __driver_attach is called many times.

But the long and short is that 00:00:00 is already associated with the
'amd76x_edac' driver, and as such will not call the agp probe call. 
What is this edac, btw?

PreZ :)


