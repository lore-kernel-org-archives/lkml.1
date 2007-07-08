Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbXGHAyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbXGHAyb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 20:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbXGHAyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 20:54:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:37265 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804AbXGHAyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 20:54:20 -0400
Subject: Re: [PATCH 1/2] [ide] mmio ide support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-ide@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070707210234.6aed88bb@the-village.bc.nu>
References: <20070707094852.9473.21013.stgit@localhost.localdomain>
	 <200707071419.52650.arnd@arndb.de>
	 <20070707210234.6aed88bb@the-village.bc.nu>
Content-Type: text/plain
Date: Sun, 08 Jul 2007 10:54:08 +1000
Message-Id: <1183856048.3388.246.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-07 at 21:02 +0100, Alan Cox wrote:
> > You could also make it an of_platform_driver at the same time
> > instead of adding more cruft to fsl_soc.c. Since we're already
> > about to add the electra_ide.c driver in 2.6.23, I guess there
> > should really be _one_ driver that is able to handle all
> > of_device based ATA hosts.
> 
> and do so using libata. Preferably ata_platform but it does look like
> ata_of would make sense as a companion.

I wouldn't push for it too much tho. It's perfectly fine to have
"helpers" generate xx_platform from the device-tree. Since I added the
generic dev_archdata to struct device, it's easy for the arch to keep
track of OF devices for anything, it doesn't have to be an of_platform
device or anything like that anymore.

One of the things I have in mind is to provide a way to register
"constructors" that are based on an OF match set. Those would then be
called by the arch code for every OF node that matches, and would then
"construct" the appropriate linux device. Could be some kind of platform
device, could even be PCI devs.

Ben.


