Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbXLVTXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbXLVTXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 14:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbXLVTXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 14:23:04 -0500
Received: from ns2.suse.de ([195.135.220.15]:33603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbXLVTXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 14:23:03 -0500
Date: Sat, 22 Dec 2007 11:25:32 -0800
From: Greg KH <gregkh@suse.de>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a
	driver opt-in issue
Message-ID: <20071222192532.GA5282@suse.de>
References: <fa.pFsY/52FEkQYqrDPnPMxmcUOsRY@ifi.uio.no> <476D39C5.9080409@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476D39C5.9080409@shaw.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2007 at 10:22:29AM -0600, Robert Hancock wrote:
> Arjan van de Ven wrote:
>> Hi,
>> Linus really wants the extended (4Kb) PCI configuration space (using MCFG 
>> acpi table etc) to be opt-in, since there's many issues with it and most 
>> drivers don't even use/need it. The idea behind opt-in is that if you 
>> don't use it, you don't get to suffer the bugs...
>> Booted on my 64 bit test machine; sadly it has a defunct BIOS that doesn't 
>> have a working MCFG.
>> From: Arjan van de Ven <arjan@linux.intel.com>
>> Subject: Make MMCONFIG space a driver opt-in
>> There are many issues with using the extended PCI configuration space 
>> (CPU, Chipset and most of all BIOS bugs). This while the vast majority of 
>> drivers
>> and devices don't even use/need to use the memory mapped access methods 
>> since they
>> don't use the config space beyond the traditional 256 bytes.
>> This patch makes accessing the extended config space a driver choice, via 
>> the
>> pci_enable_ext_config(pdev)
>> API function; drivers that want/need the extended configuration space 
>> should call this.
>> (a separate patch will be posted to add this function call to the driver 
>> that uses this)
>
> I don't really like this approach. Whether MMCONFIG works or not has 
> nothing to do with the device itself, it's an attribute of the machine, and 
> possibly the bus it's been plugged into. This patch might prevent problems 
> in some cases, but it's equally likely to just delay problems until 
> somebody plugs in a device that tries to use extended config space.

But it is that device, and the driver that controls this device that
cares about the extended config space.  So it's fair to push this onto
the driver if needed, instead of forcing the pci core to just blindly
guess for all devices, and getting it wrong...

thanks,

greg k-h
