Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbZI2Ti2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbZI2Ti2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 15:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZI2Ti1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 15:38:27 -0400
Received: from mastodon.hardc0re.org.uk ([77.240.12.146]:52240 "EHLO
	mastodon.hardc0re.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZI2Ti1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 15:38:27 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2009 15:38:27 EDT
Message-ID: <4AC2604C.2060803@hardc0re.org.uk>
Date: Tue, 29 Sep 2009 20:30:20 +0100
From: Chris M <chrisfu@hardc0re.org.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: VIA VT6330 PCI-E Combo Controller not fully supported
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone!  I'll quickly introduce myself before I get to the crux of 
my reason for posting to the mailing list.  My name is Chris Merrett and 
although I'm not a subscriber to the list (my mail server would likely 
cry), I check a well-known archive quite regularly just to try and keep 
on top of developments in the community.

The reason I'm mailing is due to a partially-supported VIA chip present 
on a small handful of motherboards currently on sale.  I mailed the 
maintainer (Jeff Garzik) to bring this to his attention quite some time 
ago, but I'd imagine he's not found the time to reply to me yet which is 
understandable.  I figured that it'd be a good idea to make a post here 
with the info I've gathered, so that people affected by this same issue 
are aware that this particular chip isn't yet fully supported in the kernel.

The VT6330 is a combo controller chip that handles both Firewire and 
PATA, and is present on my Asrock N7AD-SLI.  I'm also aware of it being 
present on other Asrock boards, and presumably other boards from 
different manufacturers.  The Firewire functionality is supported 
perfectly and without issue, but unfortunately the PATA support is 
lacking at the moment.  VIA have some information on this at the 
following URL: http://www.via.com.tw/en/products/peripherals/1394/vt6330/

 From the info on the URL above, it appears that the PATA functionality 
is identical to that of the VT6415 PATA controller, support for which 
was added in 2.6.28.  The mailing list post made regarding the patch 
that was submitted can be found here: 
http://lkml.indiana.edu/hypermail/linux/kernel/0902.2/01428.html

Finally, some relevant output from lshw:

           *-firewire
                description: FireWire (IEEE 1394)
                product: VIA Technologies, Inc.
                vendor: VIA Technologies, Inc.
                physical id: 0
                bus info: pci@0000:01:00.0
                version: 00
                width: 64 bits
                clock: 33MHz
                capabilities: pm msi pciexpress bus_master cap_list
                configuration: driver=ohci1394 latency=0 module=ohci1394
           *-ide UNCLAIMED
                description: IDE interface
                product: PATA IDE Host Controller
                vendor: VIA Technologies, Inc.
                physical id: 0.1
                bus info: pci@0000:01:00.1
                version: a0
                width: 32 bits
                clock: 33MHz
                capabilities: ide pm msi pciexpress cap_list
                configuration: latency=0

I'm going to get my hands dirty and have a try at fixing it myself one 
evening this week, so if I have any luck (which I'll no doubt need) I'll 
be sure to reply soon.

Warmest regards to everyone,

Chris Merrett

****
