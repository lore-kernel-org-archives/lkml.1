Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZDIGVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZDIGVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 02:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbZDIGVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 02:21:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:54140 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbZDIGVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 02:21:41 -0400
Subject: Re: tracking of PCI address space
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>
In-Reply-To: <E942C580-7C39-44AB-B207-C65CDE0B5292@kernel.crashing.org>
References: <E942C580-7C39-44AB-B207-C65CDE0B5292@kernel.crashing.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 08:21:31 +0200
Message-Id: <1239258091.7279.22.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 15:53 -0500, Kumar Gala wrote:
> I was wondering if we have anything that tracks regions associated  
> with the "inbound" side of a pci_bus.
> 
> What I mean is on embedded PPC we have window/mapping registers for  
> both inbound (accessing memory on the SoC) and outbound (access PCI  
> device MMIO, IO etc).  The combination of the inbound & outbound  
> convey what exists in the PCI address space vs CPU physical address  
> space (and how to map from one to the other).  Today in the PPC land  
> we only attach outbound windows to the pci_bus.  So technically the  
> inbound side information (like what subset of physical memory is  
> visible on the PCI bus) seems to be lost.

On powerpc, we do keep track of the offset, but that's about it.

Tracking inbound ranges is very platform specific though. You can have
multiple inbound windows with different translations, in some cases some
via iommu and some not, or windows aliasing the same target memory but
with different attributes, etc...

I don't think there's that much interest in trying to create generic
code to keep track.

Ben.


