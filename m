Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbYDDXfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbYDDXfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 19:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYDDXfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 19:35:31 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60933 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbYDDXfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 19:35:30 -0400
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Alex Chiang <achiang@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linas@austin.ibm.com
In-Reply-To: <20080404224227.GA31436@ldl.fc.hp.com>
References: <1207331616.5916.15.camel@badari-desktop>
	 <20080404180518.GA12642@ldl.fc.hp.com>
	 <1207340371.5916.23.camel@badari-desktop>
	 <20080404224227.GA31436@ldl.fc.hp.com>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 16:35:28 -0700
Message-Id: <1207352128.5916.26.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-04 at 16:42 -0600, Alex Chiang wrote:
> * Badari Pulavarty <pbadari@us.ibm.com>:
> > 
> > On Fri, 2008-04-04 at 12:05 -0600, Alex Chiang wrote:
> > > Hi Badari,
> > > 
> > > * Badari Pulavarty <pbadari@us.ibm.com>:
> > > > Hi Andrew & Alex,
> > > > 
> > > > I get following panic in rpaphp_register_slot() on
> > > > 2.6.25-rc8-mm1. Known issue ?
> > > 
> > > I know about it now... :-/
> > > 
> > > Any chance you could turn debugging on for both rpaphp and
> > > pci_hotplug?
> > > 
> > 
> > I did set "debug" variables in rpaphp_core.c and pci_hotplug_core.c
> > to 1. But it didn't give any more information. How do I enable
> > the debug ?
> 
> If those modules are built into your kernel, then you'll need to
> modify the kernel command line to add:
> 
> 	rpaphp.debug=1 pci_hotplug.debug=1
> 
> If you're manually modprobing them:
> 
> 	$ modprobe pci_hotplug debug=1
> 	$ modprobe rpaphp debug=1
> 
> > I just changed dbg() to printk() in rpaphp_register_slot() to
> > print out more information.
> > 
> > Thanks,
> > Badari
> > 
> > 
> > pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> > rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
> > rpaphp_register_slot registering slot:path[/pci@800000020000003/pci@2,4] index[22010003], name[U787E.001.AAA3015-P2-C1] pdomain[22010003] type[16]
> > Unable to handle kernel paging request for data at address 0x00000070
> 
> Hrm, this is a little more information, but still not quite
> enough. I'm going to take a stab in the dark and say I'm probably
> doing something wrong on this line, maybe dereferencing a pointer
> incorrectly:
> 
>         retval = pci_hp_register(php_slot, slot->bus,
> 				 PCI_SLOT(PCI_DN(slot->dn->child)->devfn));
> 

Sorry. I thought you knew this already. Disassembly clearly showed
that slot->dn->child is NULL. 

I confirmed it by adding printk also.

Thanks,
Badari

