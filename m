Return-Path: <linux-kernel-owner+w=401wt.eu-S1764440AbXK3TKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764440AbXK3TKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763444AbXK3TKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:10:34 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42141 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756974AbXK3TKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:10:32 -0500
Date: Fri, 30 Nov 2007 11:10:22 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Alex Chiang <achiang@hp.com>
Cc: Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de, lenb@kernel.org,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
Message-ID: <20071130191022.GA6189@us.ibm.com>
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071119233225.GA6931@us.ibm.com> <20071126222253.GA31708@ldl.fc.hp.com> <20071127030454.GC23277@us.ibm.com> <20071127111136.77cb61fc@appleyard> <20071128213147.GA6199@us.ibm.com> <20071130011941.GG24707@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130011941.GG24707@ldl.fc.hp.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 06:19:41PM -0700, Alex Chiang wrote:

  < snip >

> >  [<ffffffff802499bc>] kthread+0x47/0x73
> >  [<ffffffff8020cc98>] child_rip+0xa/0x12
> >  [<ffffffff80249975>] kthread+0x0/0x73
> >  [<ffffffff8020cc8e>] child_rip+0x0/0x12
> 
> Maybe we're trying to kick off a hotplug event on the wrong slot?
> I really have no idea...

One hotplug event related difference that I believe I 
noticed between the x3850 were I did not see the problem and
the x3950 is the hotplug event arrival location.  On the
x3850 the handler receives the handle for the transparent
p2p bridge above the slot.  On the x3950 I believe the handler
is receiving the handle for the root bridge (directly above
the transparent p2p bridge).  acpiphp installs a handler for
each of these possible arrival locations.  pci_slot installs
a handler for neither location which seems like it should be
okay.

I notice that acpi_pci_register_driver() was only being
used by acpiphp before pci_slot.  Perhaps your changes are
flushing out some sort of ACPI core coexistence issue not
seen previously because there was only a single user?

My silly idea is probably no better than your no idea. :)

> 
> > Code: ff ff ff ff 40 23 2c 88 ff ff ff ff 00 c8 c6 3b 10 81 ff ff 
> > RIP  [<ffffffff882c2344>] :pci_slot:__this_module+0x21c4/0xfffffffffffff204
> >  RSP <ffff81103fa43ea8>
> 
> Can you apply this debug patch on top of your tree, and send me
> the output?
> 
> I'd be curious to see the output for your failure case:
> 
>   # modprobe pci_slot debug=1
>   # modprobe acpiphp debug=1

Someone else is using the system right now so I may not
be able to do this until next week.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

