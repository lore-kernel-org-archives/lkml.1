Return-Path: <linux-kernel-owner+w=401wt.eu-S1763436AbXJRC2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763436AbXJRC2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 22:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757444AbXJRC2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 22:28:13 -0400
Received: from rtr.ca ([76.10.145.34]:2020 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756678AbXJRC2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 22:28:12 -0400
Message-ID: <4716C4B9.4070003@rtr.ca>
Date: Wed, 17 Oct 2007 22:28:09 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       pcihpd-discuss@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 4/4] Fix PCIe hotplug for non-ACPI ExpressCard slots (version
 2)
References: <4714C0A6.1030204@rtr.ca>	<4714D700.7060008@rtr.ca>	<20071016084634.8a0d695a.kristen.c.accardi@intel.com>	<47150565.5090102@rtr.ca>	<20071016114328.a96e8bcb.kristen.c.accardi@intel.com>	<47150982.6050102@rtr.ca>	<471509FE.7080505@rtr.ca>	<47151191.40406@rtr.ca>	<20071016130757.ed2f2ce4.kristen.c.accardi@intel.com>	<4715217D.2000803@rtr.ca>	<20071016214143.GC21815@kroah.com>	<471533AF.60100@rtr.ca>	<47156B14.2080608@rtr.ca>	<47156B40.4060006@rtr.ca>	<47156B62.3070807@rtr.ca>	<47156B7B.8010800@rtr.ca>	<47156B92.7070501@rtr.ca> <20071017170106.5d9e0a9f.kristen.c.accardi@intel.com>
In-Reply-To: <20071017170106.5d9e0a9f.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> On Tue, 16 Oct 2007 21:55:30 -0400
> Mark Lord <lkml@rtr.ca> wrote:
> 
>> Make use of the previously split out pcie_init_enable_events() function
>> to reinitialize the hotplug hardware on resume from suspend,
>> but only when pciehp_force==1.  Otherwise behaviour is unmodified.
> 
> OK - definitely in this case the right thing to do is not use this code
> unless you are forcing pciehp, thanks.

Yeah, that was Ted's suggestion, and it makes sense.

> I think I'd be careful when you rename this patch - non-ACPI
> ExpressCard slots is not what you want to say, as this fix is very
> specific for your machine.


No, from reading through the driver it seems that any machine
that lacks ACPI BIOS support for PCIe slots will suffer from
the exact same problems.

That's a large class of machines, not just my tiny little individual
one here (of which *millions* have been manufactured and sold).

But, whatever.
