Return-Path: <linux-kernel-owner+w=401wt.eu-S1764764AbXEYRxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764764AbXEYRxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763027AbXEYRxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:53:45 -0400
Received: from waste.org ([66.93.16.53]:35663 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbXEYRxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:53:44 -0400
Date: Fri, 25 May 2007 12:53:20 -0500
From: Matt Mackall <mpm@selenic.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, yi.zhu@intel.com
Subject: Re: 2.6.22-rc2-mm1: NetworkManager fails to find ipw2200 again
Message-ID: <20070525175319.GK11115@waste.org>
References: <20070525163621.GE11166@waste.org> <20070525164842.GA6220@suse.de> <3ae72650705251037p6b1632a5m45cdd999a294fcbd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ae72650705251037p6b1632a5m45cdd999a294fcbd@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 07:37:46PM +0200, Kay Sievers wrote:
> On 5/25/07, Greg KH <gregkh@suse.de> wrote:
> >On Fri, May 25, 2007 at 11:36:22AM -0500, Matt Mackall wrote:
> >> 2.6.22-rc2 works. CONFIG_SYSFS_DEPRECATED = y, though that shouldn't
> >> matter. Bringing up the interface manually still works, so I suspect
> >> this is sysfs or HAL related again. Again, Debian unstable so
> >> userspace is quite up-to-date.
> >
> >I don't have any driver model changes that affect network devices in my
> >tree.  Could you go through and bisect the -mm tree to see if you can
> >find the patch that causes this?
> 
> Does it work, when you unload and load the kernel module?

rmmod followed by insmod had no effect.

> Does it work when you restart HAL and then NetworkManager?

I restarted dbus, which stopped and restarted HAL and NM. No effect.

> Can you compare the sections for the wireless card in the output of "lshal"?

The unhappy one looks like this:

udi = '/org/freedesktop/Hal/devices/pci_8086_4220'
  info.udi = '/org/freedesktop/Hal/devices/pci_8086_4220'  (string)
  linux.subsystem = 'pci'  (string)
  linux.hotplug_type = 1  (0x1)  (int)
  pci.subsys_product = 'Unknown (0x2711)'  (string)
  pci.subsys_vendor = 'Intel Corporation'  (string)
  info.product = 'PRO/Wireless 2200BG Network Connection'  (string)
  pci.product = 'PRO/Wireless 2200BG Network Connection'  (string)
  info.vendor = 'Intel Corporation'  (string)
  pci.vendor = 'Intel Corporation'  (string)
  pci.device_protocol = 0  (0x0)  (int)
  pci.device_subclass = 128  (0x80)  (int)
  pci.device_class = 2  (0x2)  (int)
  pci.subsys_vendor_id = 32902  (0x8086)  (int)
  pci.subsys_product_id = 10001  (0x2711)  (int)
  pci.vendor_id = 32902  (0x8086)  (int)
  pci.product_id = 16928  (0x4220)  (int)
  info.linux.driver = 'ipw2200'  (string)
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:02.0'  (string)
  info.parent = '/org/freedesktop/Hal/devices/pci_8086_2448'  (string)
  info.bus = 'pci'  (string)
  linux.sysfs_path_device = '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:02.0'  (string)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:02.0'  (string)

Will let you know when my bisecting finds a happy one. 

-- 
Mathematics is the supreme nostalgia of our time.
