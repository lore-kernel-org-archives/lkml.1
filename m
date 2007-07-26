Return-Path: <linux-kernel-owner+w=401wt.eu-S1761707AbXGZDek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761707AbXGZDek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 23:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757509AbXGZDed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 23:34:33 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:40811 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030AbXGZDeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 23:34:31 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Date: Wed, 25 Jul 2007 21:33:20 -0600
User-Agent: KMail/1.9.6
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       =?utf-8?q?S=C3=A9bastien_Dugu=C3=A9?= <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <86802c440707251737p3be3ae69qe3f91282bec8984a@mail.gmail.com> <1185416466.31345.1.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1185416466.31345.1.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707252133.20266.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007 08:21:06 pm Shaohua Li wrote:
> On Wed, 2007-07-25 at 17:37 -0700, Yinghai Lu wrote:
> > On 7/25/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > Yinghai, you mentioned the same issue on boxes with multiple root
> > > bridges.  Any chance you could try this out there as well?
> > >
> > it doesn't solve pci_root_bus reverse problem.
> > 
> > is that too late for PNP0A03?
> > 
> > I wonder if we need to modify acpi_device_register to sort them.
> The pci root driver is an acpi driver not a pnp driver, so Bjorn's patch
> will not work.

Right, I forgot that the PCI root driver is an ACPI driver.

This is a longer-term idea, but the way I'd like to solve this is
by converting ACPI drivers into PNP drivers.  Then the PNPACPI sort
would work for all of them.  PNP would provide a hook to retrieve
the ACPI handle corresponding to a PNP device.

> Maybe the ACPI core (ACPICA) should do the sort? 

I thought about that, but I didn't see a nice way to do it.  The
current namespace interfaces like acpi_get_devices() are walk-
oriented -- they call a callback function for every node that
meets some criteria.  Sorting requires some sort of buffer so
you can look at all the matching nodes before returning any of
them.

Bjorn
