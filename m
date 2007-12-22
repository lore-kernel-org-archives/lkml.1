Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbXLVQWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbXLVQWu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 11:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbXLVQWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 11:22:39 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:28177 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbXLVQWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 11:22:38 -0500
Date: Sat, 22 Dec 2007 10:22:29 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
In-reply-to: <fa.pFsY/52FEkQYqrDPnPMxmcUOsRY@ifi.uio.no>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Message-id: <476D39C5.9080409@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.pFsY/52FEkQYqrDPnPMxmcUOsRY@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
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

I don't really like this approach. Whether MMCONFIG works or not has 
nothing to do with the device itself, it's an attribute of the machine, 
and possibly the bus it's been plugged into. This patch might prevent 
problems in some cases, but it's equally likely to just delay problems 
until somebody plugs in a device that tries to use extended config 
space. Neither do I really like the approach of limiting MMCONFIG 
accesses to ones beyond a certain address in the config space, for a 
similar reason.

The detection of whether MMCONFIG works or not has to work properly (and 
I think we're pretty close, or at least we know what we need to do to 
get there, like fixing the stupid MMCONFIG/PCI bar sizing overlap 
problem, and likely Tony Camuso's patch or something like it, to disable 
MMCONFIG accesses to devices behind certain broken host bridges). Once 
that works, then this patch really serves no purpose.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

