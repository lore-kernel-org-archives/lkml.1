Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbXFMG0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbXFMG0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 02:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbXFMG0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 02:26:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:33335 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbXFMG0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 02:26:14 -0400
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <D016D9D4-7F9F-4CA7-A955-71D07E96C7BF@kernel.crashing.org>
Cc: Greg KH <gregkh@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: PCI-Express root complex quirk in virtual P2P bridge
Date: Wed, 13 Jun 2007 01:26:33 -0500
To: linux-pci@atrey.karlin.mff.cuni.cz
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was hoping to get some guidance on how to handle a quirk in how the  
virtual P2P bridge works on some embedded PowerPC PCI-Express root  
complex controllers.  In the controllers I'm dealing with when we  
change PCI_PRIMARY_BUS in pci_scan_bridge the ability to send config  
cycles to the controller itself becomes effected.  The controller  
only sends config cycles internally if the bus # in the config cycle  
matches the PCI_PRIMARY_BUS.  We end up going from being 0 to 3 in  
the particular setup and at the point we set PCI_PRIMARY_BUS to 3 we  
are no longer able to send internal config cycles.

What we need is that either a quirk or pcibios code needs to get call  
right after we set PCI_PRIMARY_BUS so we can fixup the bus number  
relationship.  I was wondering if anyone had suggestions on how best  
to handle this.

thanks

- k
