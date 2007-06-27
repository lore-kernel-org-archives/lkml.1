Return-Path: <linux-kernel-owner+w=401wt.eu-S1762046AbXF0QmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762046AbXF0QmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbXF0QmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:42:06 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33137 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbXF0QmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:42:05 -0400
Message-ID: <46829345.1000607@zytor.com>
Date: Wed, 27 Jun 2007 12:41:41 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Matthew Wilcox <matthew@wil.cx>, Matt Domsch <Matt_Domsch@dell.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: pci.h stubs
References: <20070626132622.3226261a.randy.dunlap@oracle.com>	<20070627024505.GA30197@humbolt.us.dell.com>	<20070627113048.GU22063@parisc-linux.org> <20070627145500.2e66fd49@the-village.bc.nu>
In-Reply-To: <20070627145500.2e66fd49@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Wed, 27 Jun 2007 05:30:48 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
>> On Tue, Jun 26, 2007 at 09:45:05PM -0500, Matt Domsch wrote:
>>> On Tue, Jun 26, 2007 at 01:26:22PM -0700, Randy Dunlap wrote:
>>>> ERROR: "pci_get_bus_and_slot" [drivers/firmware/edd.ko] undefined!
>>> It should be stubbed, in include/linux/pci.h where all the other PCI
>>> functions are stubbed for the !CONFIG_PCI case.
>> pci_get_bus_and_slot() shouldn't be used because it fails to work on
>> systems with multiple domains.  pci_get_slot() avoids this problem (and
>> is much faster too).
> 
> But requires you have a bus pointer to hand which is often not the
> case. Do we need pci_get_domain_bus_and_slot() ?
> 

Note that EDD has no way of referencing anything but the zero domain 
(which is presumably the one which is addressed by I/O ports CF8/CFC on 
the BSP.)  So in this particular case I would say pci_get_bus_and_slot() 
is fine.

	-hpa

