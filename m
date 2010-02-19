Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab0BSA6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:58:51 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:53151 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab0BSA6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:58:48 -0500
Date: Thu, 18 Feb 2010 16:58:36 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
       Peter Haight <peterh@sapros.com>, Gary Hade <garyhade@us.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-am33-list@redhat.com, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v4 0/5] PCI: try "pci=use_crs" again
Message-ID: <20100219005836.GA26564@us.ibm.com>
References: <20100217201654.4013.70201.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100217201654.4013.70201.stgit@bob.kio>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 01:19:47PM -0700, Bjorn Helgaas wrote:
> Historically, Linux has assumed a single PCI host bridge, with that bridge
> claiming all the address space left after RAM and legacy devices are taken out.
> 
> If the system contains multiple host bridges, we can no longer operate under
> that assumption.  We have to know what parts of the address space are claimed
> by each bridge so that when we assign resources to a PCI device, we take them
> from a range claimed by the upstream host bridge.
> 
> On x86 and ia64, we use ACPI to enumerate all the PCI host bridges in the
> system, and part of the host bridge description is the "_CRS" (current resource
> settings" property, which lists the address space used by the bridge.  On x86,
> we currently ignore most of the _CRS information.  This patch series changes
> this, so we will use _CRS to learn about the host bridge windows.
> 
> Since most x86 machines with multiple host bridges are relatively new, this
> series only turns this on for machines with BIOS dates of 2008 or newer.

I just tried your changes on an IBM x3850 with a 12/01/2008 BIOS
date.  After booting without pci=use_crs I observed the expected
  PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
message.  I then loaded 'acpiphp' and was able to successfully 
hot-remove and hot-add PCI-X and PCIe cards.  Without pci=use_crs
a hot-add operation would have previously caused a machine check.

   Tested-by: Gary Hade <garyhade@us.ibm.com>

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

