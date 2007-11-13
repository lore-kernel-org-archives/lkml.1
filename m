Return-Path: <linux-kernel-owner+w=401wt.eu-S1763283AbXKMVl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763283AbXKMVl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759828AbXKMVlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:41:49 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:47344 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109AbXKMVls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:41:48 -0500
Date: Tue, 13 Nov 2007 15:41:21 -0600
To: Alex Chiang <achiang@hp.com>, Greg KH <greg@kroah.com>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, matthew@wil.cx,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113214121.GC8509@austin.ibm.com>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113202424.GE8421@austin.ibm.com> <20071113205939.GC22812@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113205939.GC22812@ldl.fc.hp.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 01:59:39PM -0700, Alex Chiang wrote:
> 
> > On pseries systems, I deal with something called the
> > "partitionable endpoint", which I think probably usually
> > corresponds to physical slots, but I don't really know.  
> >
> > So, naively, the physical slot concept doesn't really map to
> > what I have to work with; it just adds one more appendix to it
> > all, one more thing to get confused about.
> 
> Sorry, I'm a bit ignorant about pseries -- what kind of name does
> your PCI hotplug driver give to those slots? What shows up in
> /sys/bus/pci/slots/?

~ # find /sys/bus/pci/slots -print
/sys/bus/pci/slots
/sys/bus/pci/slots/control
/sys/bus/pci/slots/control/remove_slot
/sys/bus/pci/slots/control/add_slot
/sys/bus/pci/slots/0001:00:02.0
/sys/bus/pci/slots/0001:00:02.0/phy_location
/sys/bus/pci/slots/0001:00:02.0/max_bus_speed
/sys/bus/pci/slots/0001:00:02.0/adapter
/sys/bus/pci/slots/0001:00:02.0/attention
/sys/bus/pci/slots/0001:00:02.0/power
/sys/bus/pci/slots/0001:00:02.6
etc.

~ # cat /sys/bus/pci/slots/0000:00:02.2/phy_location
U787A.001.DNZ00Z5-P1-C2

phy_location corresponds to the printed labels on the box,
and is also shared with the various management consoles
and serivce processors and what not that get involved 
with stuff like that.

Although, please note: on these sysmes, 99% of the "useful"
info about hardware is in /proc/device-tree, and not in /sys
I doubt anyone looks at /sys/bus/pci/slots, I think they mostly
look at the open firmware device tree.

--linas

