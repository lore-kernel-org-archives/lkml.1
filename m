Return-Path: <linux-kernel-owner+w=401wt.eu-S1765302AbYAaFCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765302AbYAaFCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 00:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbYAaFCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 00:02:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:6092 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbYAaFC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 00:02:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,282,1199692800"; 
   d="scan'208";a="332588424"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Mostly revert "e1000/e1000e: Move PCI-Express device IDs over       to e1000e"
Date: Wed, 30 Jan 2008 20:59:40 -0800
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F52044F8B6A@orsmsx418.amr.corp.intel.com>
In-Reply-To: <E1JKOBl-0007ne-EE@faramir.fjphome.nl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Mostly revert "e1000/e1000e: Move PCI-Express device IDs over       to e1000e"
Thread-Index: AchjqL+DlX1CfEDQTlOguN3MO0aH0QAHL7aw
References: <200801292359.m0TNxb75011826@hera.kernel.org> <20080129212314.91b9bb5b.randy.dunlap@oracle.com> <alpine.LFD.1.00.0801301631400.3426@www.l.google.com> <20080130235836.GV29368@does.not.exist> <E1JKOBl-0007ne-EE@faramir.fjphome.nl>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Frans Pop" <elendil@planet.nl>, "Adrian Bunk" <bunk@kernel.org>
Cc: <akpm@linux-foundation.org>, "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       <davem@davemloft.net>, <jeff@garzik.org>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
       <randy.dunlap@oracle.com>, <torvalds@linux-foundation.org>
X-OriginalArrivalTime: 31 Jan 2008 04:59:43.0273 (UTC) FILETIME=[17B8F190:01C863C6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> There is one thing I don't understand, but that may well be just me...
> 
> From Linus' original patch:
>> +++ b/drivers/net/e1000/e1000_main.c
>> +     INTEL_E1000_ETHERNET_DEVICE(0x108C),
> 
> So, apparently support for 8086:108c was removed from the e1000
> driver. 

When it was enabled to be supported by e1000e.
 
> From my lspci:
> $ lspci -nn | grep Ether
> 01:00.0 Ethernet controller [0200]: Intel Corporation 82573E Gigabit
> Ethernet Controller (Copper) [8086:108c] (rev 03) 
> 
> But when I look at where that card is sitting:
> $ readlink pci/devices/0000\:01\:00.0/driver
> ../../../../bus/pci/drivers/e1000
> 
> So, it's on the PCI bus, not on the PCI-Express bus (which I also
> have, but 
> which has no devices on it).

82573E/L are PCIe devices only, don't let the use of "PCI configuration
space" confuse you.  All PCIe devices support PCI configuration space.
This allows systems with PCIe to work right (or mostly right) with all
the PCI supporting software like Linux.
 
> Or does the e1000e driver also support cards on the PCI bus?

E1000e is targeted at the PCIe devices only.
 
> If that's the case then the original changelog entry "Move PCI-Express
> device IDs over to e1000e" is misleading as it's not only PCI-Express
> devices...

Unfortunate bit of confusion over terminology.
 
> Hmmm. Or does which driver is loaded decide on which bus the device
> ends up? 

Hope this helped,
  Jesse
