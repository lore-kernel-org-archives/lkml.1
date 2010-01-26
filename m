Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734Ab0AZSRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab0AZSRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 13:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466Ab0AZSRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 13:17:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753936Ab0AZSRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 13:17:13 -0500
Date: Tue, 26 Jan 2010 10:16:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garrett <jeff@jgarrett.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Myron Stowe <myron.stowe@hp.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with
 pci=use_crs)
In-Reply-To: <201001261032.37053.bjorn.helgaas@hp.com>
Message-ID: <alpine.LFD.2.00.1001260955060.3574@localhost.localdomain>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <20100126071912.GA7543@jgarrett.org> <201001261348.59508.rjw@sisk.pl> <201001261032.37053.bjorn.helgaas@hp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Jan 2010, Bjorn Helgaas wrote:
> 
> which IS big enough, and we know the bridge is in fact forwarding the
> [mem 0xd0000000-0xdfffffff 64bit pref] region, because the Radeon works
> when Jeff boots with "pci=use_crs".

I bet it's a subtractive decode thing. Sure, it could be just another 
undocumented range register (does anybody have the datasheet for that 
thing?) but Intel tends to often have subtractive decode.

That system in question has three PCI express root ports, but two of them 
have IO and memory disabled according to the lspci info. So maybe it's as 
simple as that "I/O Hub PCI Express Root Port 7" just catching anything 
that nobody else does, and the single IOH host chip doing the same?

> I think we should remove intel_bus.c before .33.  It's breaking boxes
> and we don't know how to fix it.  Even if we do find out how to fix it,
> I think we should move toward using _CRS instead, because that's what
> Windows uses and it's an easy way for the firmware to tell us about
> platform quirks.

I suspect that for 33 it is indeed best to just revert. But somebody is 
bound to have information on how the actual hardware works. Yinghai?

		Linus
