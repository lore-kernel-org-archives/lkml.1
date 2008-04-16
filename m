Return-Path: <linux-kernel-owner+w=401wt.eu-S1759925AbYDPWQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbYDPWQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYDPWQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:16:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:53134 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbYDPWQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:16:12 -0400
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alex Chiang <achiang@hp.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080416171127.GA18290@ldl.fc.hp.com>
References: <1207331616.5916.15.camel@badari-desktop>
	 <20080404180518.GA12642@ldl.fc.hp.com>
	 <1207340371.5916.23.camel@badari-desktop>
	 <20080404224227.GA31436@ldl.fc.hp.com>
	 <1207352128.5916.26.camel@badari-desktop>
	 <20080407234255.GA22514@ldl.fc.hp.com>
	 <20080416031712.GB3333@ldl.fc.hp.com> <1208331916.6958.270.camel@pasglop>
	 <20080416171127.GA18290@ldl.fc.hp.com>
Content-Type: text/plain
Date: Thu, 17 Apr 2008 08:15:53 +1000
Message-Id: <1208384153.6958.302.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The basic idea, which I keep botching on pSeries, is that when we
> make a call to pci_hp_register, we now need to pass it:
> 
> pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
> 
> I am having trouble figuring out the slot_nr argument. Basically,
> I want to get the devfn of the slot we're looking at.

I haven't looked in details yet, but I can already tell that things on
pSeries aren't that simple because we don't necessarily know in advance
about "slots"...

When you add a physical PCI device to a partition, things can range from:

 - A device gets added to an existing bridge (ie. slot)
 - A whole P2P brigde gets added with that device below it (that's a slot too)
 - A whole PCI host bridge gets added with that device below it (or with
   a P2P bridge below it and the device below that).

In the later case, it's hard to have any concept of slot since you don't
know anything about the host bridge before it gets added to your partition :-)

So I'm not sure how much we can use of your slot infrastructure, I'll have
to look, I suspect it can cover some cases but not all of them.

Cheers,
Ben.


