Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbXLVUoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbXLVUoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 15:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbXLVUoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 15:44:15 -0500
Received: from gate.crashing.org ([63.228.1.57]:34457 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbXLVUoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 15:44:15 -0500
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a
	driver opt-in issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <20071222043139.0cd59804@laptopd505.fenrus.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Sun, 23 Dec 2007 07:43:37 +1100
Message-Id: <1198356217.6686.1.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-22 at 04:31 -0800, Arjan van de Ven wrote:
> Hi,
> 
> Linus really wants the extended (4Kb) PCI configuration space (using MCFG acpi table etc) to be opt-in, since there's many issues with it and most drivers don't even use/need it. The idea behind opt-in is that if you don't use it, you don't get to suffer the bugs...
> 
> Booted on my 64 bit test machine; sadly it has a defunct BIOS that doesn't have a working MCFG.
> 
> 
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: Make MMCONFIG space a driver opt-in
> 
> There are many issues with using the extended PCI configuration space 
> (CPU, Chipset and most of all BIOS bugs). This while the vast majority of drivers
> and devices don't even use/need to use the memory mapped access methods since they
> don't use the config space beyond the traditional 256 bytes.
> 
> This patch makes accessing the extended config space a driver choice, via the
> 
> pci_enable_ext_config(pdev)
> 
> API function; drivers that want/need the extended configuration space should call this.
> (a separate patch will be posted to add this function call to the driver that uses this)

That doesn't look like the right approach to me.

The extended config space is generally used by PCI capabilities. So you
end up in a situation where part of the capabilities will be invisible
until somebody calls your new API, which might affect generic code in
some cases beyond simply what a driver is supposed to do.

I think best is to have your low level config ops switch between
indirect and MM depending on the requested register offset.

Ben.


