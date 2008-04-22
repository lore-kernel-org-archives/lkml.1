Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbYDVFKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbYDVFKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 01:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYDVFKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 01:10:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:43682 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbYDVFKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 01:10:37 -0400
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alex Chiang <achiang@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, pbadari@us.ibm.com,
       linux-kernel@vger.kernel.org, matthew@wil.cx
In-Reply-To: <20080422040502.GB1788@ldl.fc.hp.com>
References: <20080404224227.GA31436@ldl.fc.hp.com>
	 <1207352128.5916.26.camel@badari-desktop>
	 <20080407234255.GA22514@ldl.fc.hp.com>
	 <20080416031712.GB3333@ldl.fc.hp.com> <1208331916.6958.270.camel@pasglop>
	 <20080416171127.GA18290@ldl.fc.hp.com>
	 <20080416130343.a82702f0.akpm@linux-foundation.org>
	 <1208384185.6958.304.camel@pasglop> <20080419063807.GB12987@ldl.fc.hp.com>
	 <1208588626.6958.446.camel@pasglop>  <20080422040502.GB1788@ldl.fc.hp.com>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 15:07:57 +1000
Message-Id: <1208840877.9640.78.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-21 at 22:05 -0600, Alex Chiang wrote:
> 
> Are you saying that it is not accurate to use this
> pci_bus->self->devfn to keep track of slots?

Well, if it's a PHB, there's no self.

> I suppose you could just pass in 0 as slot_nr/devfn. That is what
> my fixup patch did if it couldn't find a pci_bus->self. The
> result would be that for a given pci_bus, you would only see the
> first "slot" with this 0 slot_nr appear in sysfs, and it would
> have whatever name originally associated with your dn.

Yes but we can have a PHB with no self and suddenly the HV brings in
multiple devices behind it. Oh well, I need to dig more, if I manage to
get the bloody hotplug stuff working here at all..

In some case, we don't even have the PHB, so nothing will appear in
sysfs but that's probably mostly harmless. The main thing is that those
hotplug operations are never driven that way, they are driven by the
management console which talks to a daemon which talks to the HV etc...
and the kernel is the last one to know about hotplug :-)

> I think if I were to understand more about this issue, we could
> figure out a better solution...

Ben.


