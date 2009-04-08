Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZDHWOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZDHWOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 18:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbZDHWOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 18:14:44 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:33003 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbZDHWOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 18:14:43 -0400
X-Greylist: delayed 1509 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Apr 2009 18:14:43 EDT
Date: Wed, 8 Apr 2009 14:49:32 -0700
From: Ira Snyder <iws@ovro.caltech.edu>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>
Subject: Re: tracking of PCI address space
Message-ID: <20090408214932.GA31970@ovro.caltech.edu>
References: <E942C580-7C39-44AB-B207-C65CDE0B5292@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E942C580-7C39-44AB-B207-C65CDE0B5292@kernel.crashing.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Wed, 08 Apr 2009 14:49:34 -0700 (PDT)
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
> map from one to the other).  Today in the PPC land we only attach 
> outbound windows to the pci_bus.  So technically the inbound side 
> information (like what subset of physical memory is visible on the PCI 
> bus) seems to be lost.
>

To the best of my knowledge there is no API to set inbound windows in
Linux. I've been implementing a virtio-over-PCI driver which needs the
inbound windows. I set them up myself during driver probe, using
get_immrbase() to get the IMMR registers. This board is a PCI Slave /
Agent, it doesn't even have PCI support compiled into the kernel.

Ira
