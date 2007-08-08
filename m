Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbXHHHYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbXHHHYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbXHHHYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:24:10 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:17434 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbXHHHYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:24:08 -0400
Date: Wed, 8 Aug 2007 10:23:51 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: akpm@linux-foundation.org, ak@suse.de, apw@shadowen.org, clameter@sgi.com,
       greg@kroah.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] x86_64: get mp_bus_to_node as early v3
Message-ID: <20070808072351.GK3383@rhun.haifa.ibm.com>
References: <200708072245.l77MjVxU008742@imap1.linux-foundation.org> <200708071820.33720.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708071820.33720.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 06:20:33PM -0700, Yinghai Lu wrote:

> please check this one against pci_scan_bus_with_sysdata
> 
> [PATCH 1/5] x86_64: get mp_bus_to_node as early v3
> 
> current on amd k8 system with multi ht chain, the numa_node of pci
> devices under r/sys/devices/pci0000:80/* always 0, even that chain is
> on node 1 or 2 or 3.
> 
> workaround: pcibus_to_node(bus) is used when we want to get node
> that pci_device is on.
> 
> In struct device, we already have numa_node member. and we could use
> dev_to_node() /set_dev_node() to get and set numa_node in the
> device.  set_dev_node is called in pci_device_add() with
> pcibus_to_node(bus). and pcibus_to_node use bus->sysdata for nodeid.
> 
> the problem is when pci_add_device is called, bus->sysdata is not
> assigned correct nodeid yet. the result will be numa_node always is
> 0.
> 
> pcibios_scan_root and pci_scan_root could take sysdata. So we need
> to get mp_bus_to_node mapping before these two are called. and
> get_mp_bus_to_node could get correct node for sysdata in root bus.
> 
> in scanning of root bus, all child bus will take parent bus sysdata. So all
> pci_device->dev.numa_node will be assigned correctly automatically.
> 
> later we could use dev_to_node(&pci_dev->dev) to get numa_node, and
> we could also could make other bus specific device get the correct
> numa_node too.
> 
> this is one update version to pci_sysdata ...  also reverse
> pci_acpi_scan_root to use pcibios_scan_root again.

Can you explain why this patch (and your other patches in this area)
are needed? is this a performance issue? the patches seem complex, is
there a good argument for that complexity?

Cheers,
Muli


