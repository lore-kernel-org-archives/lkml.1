Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbZDHVy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbZDHVy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 17:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbZDHVyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 17:54:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:53810 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224AbZDHVyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 17:54:07 -0400
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>
Message-Id: <D1CAC02C-BC2F-4B2E-A1AD-B6AE1532D4F0@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Ira Snyder <iws@ovro.caltech.edu>
In-Reply-To: <20090408214932.GA31970@ovro.caltech.edu>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: tracking of PCI address space
Date: Wed, 8 Apr 2009 16:53:52 -0500
References: <E942C580-7C39-44AB-B207-C65CDE0B5292@kernel.crashing.org> <20090408214932.GA31970@ovro.caltech.edu>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 8, 2009, at 4:49 PM, Ira Snyder wrote:

> On Wed, Apr 08, 2009 at 03:53:55PM -0500, Kumar Gala wrote:
>> I was wondering if we have anything that tracks regions associated  
>> with
>> the "inbound" side of a pci_bus.
>>
>> What I mean is on embedded PPC we have window/mapping registers for  
>> both
>> inbound (accessing memory on the SoC) and outbound (access PCI device
>> MMIO, IO etc).  The combination of the inbound & outbound convey what
>> exists in the PCI address space vs CPU physical address space (and  
>> how to
>> map from one to the other).  Today in the PPC land we only attach
>> outbound windows to the pci_bus.  So technically the inbound side
>> information (like what subset of physical memory is visible on the  
>> PCI
>> bus) seems to be lost.
>>
>
> To the best of my knowledge there is no API to set inbound windows in
> Linux. I've been implementing a virtio-over-PCI driver which needs the
> inbound windows. I set them up myself during driver probe, using
> get_immrbase() to get the IMMR registers. This board is a PCI Slave /
> Agent, it doesn't even have PCI support compiled into the kernel.

I'm not concerned explicitly about setting up inbound windows, its  
more about have a consistent view of the PCI address space which may  
be different from the CPU physical address space.

I'm working on code to actually setup the inbound windows on 85xx/86xx  
class devices (based on dma-ranges property in the device tree).  As I  
was thinking about this I realized that the send of ranges/dma-ranges  
in the .dts and what we map to outbound vs inbound changes if we an  
agent or host.

- k
