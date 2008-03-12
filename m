Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbYCLXMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbYCLXMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYCLXLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:11:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbYCLXLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:11:54 -0400
Date: Wed, 12 Mar 2008 16:09:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: pcibios_scanned needs to be set in ACPI?  (was Re: 2.6.25-rc5:
 Reported regressions from 2.6.24)
In-Reply-To: <20080312225421.GA24449@kroah.com>
Message-ID: <alpine.LFD.1.00.0803121604580.3557@woody.linux-foundation.org>
References: <200803110014.52985.rjw@sisk.pl> <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org> <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl> <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org> <20080312203205.GB17187@kroah.com>
 <20080312212704.GA16836@kroah.com> <20080312213826.GA17101@kroah.com> <alpine.LFD.1.00.0803121521550.3557@woody.linux-foundation.org> <20080312225421.GA24449@kroah.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Mar 2008, Greg KH wrote:
> 
> I can't get a box here to produce both of those PCI: messages myself,
> and neither can Len, so something is really odd here.

You can't?

I can trivially reproduce the warnings on my laptop by just adding 
"acpi=noirq" to the command line in grub.

	PCI: Probing PCI hardware
	kobject (ffff81007e08d9c8): tried to init an initialized object, something is seriously wrong.
	Pid: 1, comm: swapper Not tainted 2.6.25-rc3-00081-g7704a8b #29
	
	Call Trace:
	 [<ffffffff8054f921>] __down_read+0x12/0x93
	 [<ffffffff80313d60>] kobject_init+0x39/0x82
	 [<ffffffff803956d6>] device_initialize+0x25/0xa4
	 [<ffffffff80395f83>] device_register+0x9/0x12
	 [<ffffffff80322cdc>] pci_bus_add_devices+0xe2/0x13e
	 [<ffffffff807491be>] pci_legacy_init+0x66/0xf9
	 [<ffffffff8039763e>] bus_register+0x15b/0x221
	 [<ffffffff8072a6ba>] kernel_init+0x14a/0x2b4
	 [<ffffffff8020be38>] child_rip+0xa/0x12
	 [<ffffffff8072a570>] kernel_init+0x0/0x2b4
	 [<ffffffff8020be2e>] child_rip+0x0/0x12

did you try just adding that simple command line thing?

			Linus
