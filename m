Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbXEAQCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbXEAQCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbXEAQCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:02:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46411 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbXEAQCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:02:45 -0400
Message-ID: <46376474.8090505@redhat.com>
Date: Tue, 01 May 2007 12:01:56 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: regression on quad Xeon: no SCSI-disks
References: <20070501142431.GA11667@erig.dyndns.org>
In-Reply-To: <20070501142431.GA11667@erig.dyndns.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Erig wrote:
> Sorry
> for detecting this 2 year old regression so late.
> 
> 2.6.13 or later is bad.
> 2.6.12 is good,
> 
> "git bisect" worked fine and points to the attached patch.
> The patch is pretty small. The problem seemed to be dependant
> on the PCI-architecture of these particular systems.
> Tried this on two machines with the same behaviour.
> 
> Wolfgang
> 
> 
> $ git bisect bad 
> 299de0343c7d18448a69c635378342e9214b14af is first bad commit
> commit 299de0343c7d18448a69c635378342e9214b14af
> Author: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Date:   Wed Jun 15 18:59:27 2005 +0400
> 
>     [PATCH] PCI: pci_assign_unassigned_resources() on x86
>     
>     - Add sanity check for io[port,mem]_resource in setup-bus.c. These
>       resources look like "free" as they have no parents, but obviously
>       we must not touch them.
>     - In i386.c:pci_allocate_bus_resources(), if a bridge resource cannot be
>       allocated for some reason, then clear its flags. This prevents any child
>       allocations in this range, so the setup-bus code will work with a clean
>       resource sub-tree.
>     - i386.c:pcibios_enable_resources() doesn't enable bridges, as it checks
>       only resources 0-5, which looks like a clear bug to me. I suspect it
>       might break hotplug as well in some cases.
>     
>     From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> :040000 040000 ecab084beb95987f3e4ead8b61ce19cc052a5fa3 4c1364a6fd511b6dc6ddec06d787bcf105687835 M      arch
> :040000 040000 0956f28cde32bd7494d7a87e2814bcd726547a32 0d2e2b611b007085e5a0994a66fd9c0a873ac8f8 M      drivers
> 
> ====== on console =======
> sym0: <875> rev 0x26 at pci 0000:01:02.0 irq 30
> sym0: Symbios NVRAM, ID 7, Fast-20, SE, parity checking
> sym0: open drain IRQ line driver, using on-chip SRAM
> sym0: using LOAD/STORE-based firmware.
> sym0: SCSI BUS has been reset.
> scsi0 : sym-2.2.0
> scsi 0:0:0:0 ABORT operation started.
> scsi 0:0:0:0 ABORT operation timed-out.
> scsi 0:0:0:0 DEVICE RESET operation started.
> scsi 0:0:0:0 DEVICE RESET operation timed-out.
> scsi 0:0:0:0 BUS RESET operation started.
> scsi 0:0:0:0 BUS RESET operation timed-out.
>       ....

Output from kernel with CONFIG_PCI_DEBUG could be useful.

