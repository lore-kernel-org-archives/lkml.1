Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbXFMNK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbXFMNK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbXFMNKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:10:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:37056 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbXFMNKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:10:49 -0400
In-Reply-To: <20070612.234007.104033894.davem@davemloft.net>
References: <D016D9D4-7F9F-4CA7-A955-71D07E96C7BF@kernel.crashing.org> <20070612.234007.104033894.davem@davemloft.net>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <1D49C522-F1EC-4708-800E-523C126C69D2@kernel.crashing.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: PCI-Express root complex quirk in virtual P2P bridge
Date: Wed, 13 Jun 2007 08:11:07 -0500
To: David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 13, 2007, at 1:40 AM, David Miller wrote:

> From: Kumar Gala <galak@kernel.crashing.org>
> Date: Wed, 13 Jun 2007 01:26:33 -0500
>
>> I was hoping to get some guidance on how to handle a quirk in how the
>> virtual P2P bridge works on some embedded PowerPC PCI-Express root
>> complex controllers.  In the controllers I'm dealing with when we
>> change PCI_PRIMARY_BUS in pci_scan_bridge the ability to send config
>> cycles to the controller itself becomes effected.  The controller
>> only sends config cycles internally if the bus # in the config cycle
>> matches the PCI_PRIMARY_BUS.  We end up going from being 0 to 3 in
>> the particular setup and at the point we set PCI_PRIMARY_BUS to 3 we
>> are no longer able to send internal config cycles.
>>
>> What we need is that either a quirk or pcibios code needs to get call
>> right after we set PCI_PRIMARY_BUS so we can fixup the bus number
>> relationship.  I was wondering if anyone had suggestions on how best
>> to handle this.
>
> I would suggest building the PCI device tree using the OF device tree.
> 64-bit PowerPC does this already, perhaps you can use some of the
> existing code for your case too.

Unfortunately that isn't really an option, since on the embedded side  
we allow the device tree to be much simpler.  For example, we dont  
require the firmware to produce a full PCI device tree and populate  
the device tree with it.  A lot of embedded PPCs use linux as the pci  
bios.

> Sparc64 does as 64-bit PowerPC does.

Both of these platforms do it because their OF implementations are  
more complete than anything we'd see on the embedded side.

> I can't even program the PCI-E root controller in PCI config space on
> sparc64 Niagara systems, so I just virtualize it.

- k
