Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZDIG4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZDIG4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 02:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZDIGz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 02:55:56 -0400
Received: from complete.lackof.org ([198.49.126.79]:45270 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbZDIGzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 02:55:55 -0400
Date: Thu, 9 Apr 2009 00:55:53 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>
Subject: Re: tracking of PCI address space
Message-ID: <20090409065553.GA14780@lackof.org>
References: <E942C580-7C39-44AB-B207-C65CDE0B5292@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E942C580-7C39-44AB-B207-C65CDE0B5292@kernel.crashing.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 03:53:55PM -0500, Kumar Gala wrote:
> I was wondering if we have anything that tracks regions associated with 
> the "inbound" side of a pci_bus.
>
> What I mean is on embedded PPC we have window/mapping registers for both 
> inbound (accessing memory on the SoC) and outbound (access PCI device 
> MMIO, IO etc).  The combination of the inbound & outbound convey what 
> exists in the PCI address space vs CPU physical address space (and how to 
> map from one to the other).

Most PCI Host bus controllers will negatively decode the outbound ranges
for inbound traffic.

PARISC and IA64 have extra registers to play some games with that. But
routing between PCI bus controllers to make them look like a single PCI
segment was the main intent of that. I've not found any other uses
to subvert that.

>  Today in the PPC land we only attach 
> outbound windows to the pci_bus.  So technically the inbound side 
> information (like what subset of physical memory is visible on the PCI 
> bus) seems to be lost.

What did you need inbound "routing map" for?

thanks,
grant
