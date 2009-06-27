Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZF0Jmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZF0Jmc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 05:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbZF0JmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 05:42:25 -0400
Received: from aun.it.uu.se ([130.238.12.36]:63710 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZF0JmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 05:42:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19013.59767.139956.971375@pilspetsen.it.uu.se>
Date: Sat, 27 Jun 2009 11:42:15 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, hpa@zytor.com
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
	x86
In-Reply-To: <20090627042556.GA31085@lackof.org>
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>
	<19013.29264.623540.275538@pilspetsen.it.uu.se>
	<20090627042556.GA31085@lackof.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler writes:
 > On Sat, Jun 27, 2009 at 03:13:52AM +0200, Mikael Pettersson wrote:
 > > Mikael Pettersson writes:
 > ...
 > >  > CPU: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
 > >  > Checking 'hlt' instruction... OK.
 > >  > PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=2
 > ...
 > >  > pci 0000:00:1e.0: transparent bridge
 > >  > pci 0000:00:1f.0: PIIX/ICH IRQ router [8086:2810]
 > >  > 
 > >  > At this point the kernel hangs hard until rebooted.
 > 
 > ...
 > > I've now identified commit 95ee14e4379c5e19c0897c872350570402014742
 > > "x86: cap iomem_resource to addressable physical memory" by hpa (cc:d)
 > > as the culprit. Reverting it fixes my boot hang.
 > 
 > Mikael,
 > thanks for tracking this down...can you dump the value of c->x86_phys_bits
 > please?

Sure. This is from 2.6.31-rc1 with the commit commented out and
replaced by a debug printk:

identify_cpu: ->x86_phys_bits == 36, would change iomem_resource.end from 0xffffffffffffffff to 0x0000000fffffffff

which looks correct for HIGHMEM64G.
