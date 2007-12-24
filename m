Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbXLXHJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbXLXHJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 02:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbXLXHJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 02:09:14 -0500
Received: from colo.lackof.org ([198.49.126.79]:54062 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbXLXHJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 02:09:13 -0500
Date: Mon, 24 Dec 2007 00:08:51 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Alan Cox <alan@redhat.com>,
       Greg Kroah-Hartman <greg@kroah.com>, jgarzik@pobox.com,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, wingel@nano-system.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, james.smart@emulex.com,
       linux-driver@qlogic.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 3/4] pci: Remove pci_enable_device_bars()
Message-ID: <20071224070850.GB3758@colo.lackof.org>
References: <1197932473.576079.142524077033.qpush@grosgo> <20071217230126.B2D71DDE36@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217230126.B2D71DDE36@ozlabs.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 10:01:14AM +1100, Benjamin Herrenschmidt wrote:
> Now that all in-tree users are gone, this removes pci_enable_device_bars()
> completely.

Almost completely.
Patch below removes pci_enable_device_bars() from Documentation/pci.txt .

(And I'd be happy to review patches to pci.txt that add
  pci_enable_device_io() and _mmio() as well. )

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>


diff --git a/Documentation/pci.txt b/Documentation/pci.txt
index 7754f5a..72b20c6 100644
--- a/Documentation/pci.txt
+++ b/Documentation/pci.txt
@@ -274,8 +274,6 @@ the PCI device by calling pci_enable_device(). This will:
 	o allocate an IRQ (if BIOS did not).
 
 NOTE: pci_enable_device() can fail! Check the return value.
-NOTE2: Also see pci_enable_device_bars() below. Drivers can
-    attempt to enable only a subset of BARs they need.
 
 [ OS BUG: we don't check resource allocations before enabling those
   resources. The sequence would make more sense if we called
@@ -605,40 +603,7 @@ device lists. This is still possible but discouraged.
 
 
 
-10. pci_enable_device_bars() and Legacy I/O Port space
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-
-Large servers may not be able to provide I/O port resources to all PCI
-devices. I/O Port space is only 64KB on Intel Architecture[1] and is
-likely also fragmented since the I/O base register of PCI-to-PCI
-bridge will usually be aligned to a 4KB boundary[2]. On such systems,
-pci_enable_device() and pci_request_region() will fail when
-attempting to enable I/O Port regions that don't have I/O Port
-resources assigned.
-
-Fortunately, many PCI devices which request I/O Port resources also
-provide access to the same registers via MMIO BARs. These devices can
-be handled without using I/O port space and the drivers typically
-offer a CONFIG_ option to only use MMIO regions
-(e.g. CONFIG_TULIP_MMIO). PCI devices typically provide I/O port
-interface for legacy OSes and will work when I/O port resources are not
-assigned. The "PCI Local Bus Specification Revision 3.0" discusses
-this on p.44, "IMPLEMENTATION NOTE".
-
-If your PCI device driver doesn't need I/O port resources assigned to
-I/O Port BARs, you should use pci_enable_device_bars() instead of
-pci_enable_device() in order not to enable I/O port regions for the
-corresponding devices. In addition, you should use
-pci_request_selected_regions() and pci_release_selected_regions()
-instead of pci_request_regions()/pci_release_regions() in order not to
-request/release I/O port regions for the corresponding devices.
-
-[1] Some systems support 64KB I/O port space per PCI segment.
-[2] Some PCI-to-PCI bridges support optional 1KB aligned I/O base.
-
-
-
-11. MMIO Space and "Write Posting"
+10. MMIO Space and "Write Posting"
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Converting a driver from using I/O Port space to using MMIO space
