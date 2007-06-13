Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320AbXFMGj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbXFMGj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 02:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbXFMGjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 02:39:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47592
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbXFMGju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 02:39:50 -0400
Date: Tue, 12 Jun 2007 23:40:07 -0700 (PDT)
Message-Id: <20070612.234007.104033894.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: PCI-Express root complex quirk in virtual P2P bridge
From: David Miller <davem@davemloft.net>
In-Reply-To: <D016D9D4-7F9F-4CA7-A955-71D07E96C7BF@kernel.crashing.org>
References: <D016D9D4-7F9F-4CA7-A955-71D07E96C7BF@kernel.crashing.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>
Date: Wed, 13 Jun 2007 01:26:33 -0500

> I was hoping to get some guidance on how to handle a quirk in how the  
> virtual P2P bridge works on some embedded PowerPC PCI-Express root  
> complex controllers.  In the controllers I'm dealing with when we  
> change PCI_PRIMARY_BUS in pci_scan_bridge the ability to send config  
> cycles to the controller itself becomes effected.  The controller  
> only sends config cycles internally if the bus # in the config cycle  
> matches the PCI_PRIMARY_BUS.  We end up going from being 0 to 3 in  
> the particular setup and at the point we set PCI_PRIMARY_BUS to 3 we  
> are no longer able to send internal config cycles.
> 
> What we need is that either a quirk or pcibios code needs to get call  
> right after we set PCI_PRIMARY_BUS so we can fixup the bus number  
> relationship.  I was wondering if anyone had suggestions on how best  
> to handle this.

I would suggest building the PCI device tree using the OF device tree.
64-bit PowerPC does this already, perhaps you can use some of the
existing code for your case too.

Sparc64 does as 64-bit PowerPC does.

I can't even program the PCI-E root controller in PCI config space on
sparc64 Niagara systems, so I just virtualize it.
