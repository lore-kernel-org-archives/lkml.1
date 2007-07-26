Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbXGZC02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbXGZC02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 22:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbXGZC0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 22:26:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:2483 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbXGZC0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 22:26:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,582,1175497200"; 
   d="scan'208";a="272805169"
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
	platform devices - broke my serial console
From: Shaohua Li <shaohua.li@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr
In-Reply-To: <86802c440707251737p3be3ae69qe3f91282bec8984a@mail.gmail.com>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	 <200707250716.44609.bjorn.helgaas@hp.com>
	 <20070725153253.4d7e7e37@frecb000686.frec.bull.fr>
	 <200707251641.23406.bjorn.helgaas@hp.com>
	 <86802c440707251737p3be3ae69qe3f91282bec8984a@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 26 Jul 2007 10:21:06 +0800
Message-Id: <1185416466.31345.1.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 17:37 -0700, Yinghai Lu wrote:
> On 7/25/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > On Wednesday 25 July 2007 07:32:53 am Sébastien Dugué wrote:
> > > On Wed, 25 Jul 2007 07:16:44 -0600 Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > >
> > > > The _DDN is a "DOS device name", and the _UID is a "logical device ID
> > > > that does not change across reboots."  Both are optional, and PNPACPI
> > > > ignores them.  But maybe we could change PNPACPI to sort by them if
> > > > they are present.  I'll think about this a bit.
> > >
> > >   That would be nice, but I wish you good luck with all those
> > > crappy BIOSes out there.
> >
> > Yeah, it's an ugly world we live in.  Would you be able to try the
> > attached patch just for testing?  It should sort devices with the
> > same _HID by their _UID.  It doesn't have any effect on my systems,
> > because my devices are already ordered by _UID by default.  But I
> > think it should switch your COM1/COM2 ports back to the order you
> > expect.
> >
> > Yinghai, you mentioned the same issue on boxes with multiple root
> > bridges.  Any chance you could try this out there as well?
> >
> it doesn't solve pci_root_bus reverse problem.
> 
> is that too late for PNP0A03?
> 
> I wonder if we need to modify acpi_device_register to sort them.
The pci root driver is an acpi driver not a pnp driver, so Bjorn's patch
will not work. Maybe the ACPI core (ACPICA) should do the sort?

Thanks,
Shaohua
