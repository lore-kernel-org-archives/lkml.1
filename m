Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbZFITPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbZFITPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 15:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757011AbZFITO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 15:14:56 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:18552 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918AbZFITOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 15:14:55 -0400
Date: Tue, 9 Jun 2009 13:14:57 -0600
From: Alex Chiang <achiang@hp.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 07/11] ACPI: acpi_pci_unbind should clean up
	properly after acpi_pci_bind
Message-ID: <20090609191457.GF23647@ldl.fc.hp.com>
References: <20090604054504.18802.21690.stgit@bob.kio> <4A2788FA.2050606@jp.fujitsu.com> <20090604233521.GA12900@ethanol> <200906050949.02097.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906050949.02097.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bjorn Helgaas <bjorn.helgaas@hp.com>:
> On Thursday 04 June 2009 05:35:21 pm Alex Chiang wrote:
> > * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> > >
> > > I have a concern about this change.
> > >
> > > The acpi_pci_irq_del_prt() against dev->bus removes not only
> > > the _PRT entries for PCI function corresponding to specified
> > > acpi_device, but also other _PRT entries for working PCI
> > > devices/functions on the same bus. As a result, interrupt
> > > initialization for those PCI functions would no longer work
> > > properly after that.
> > >
> > > So I think we should not call acpi_pci_irq_del_prt() against
> > > dev->bus.
> > 
> > Thanks for the review. I agree with you.
> 
> I agree that this respun version makes things more the way they were,
> so in that sense, it should do no harm.  But I still have the niggling
> concern that .bind() adds _PRT info for non-bridges, and there's no
> corresponding removal.  There should be some path that makes this
> more symmetric.

Hm, in another forum, you suggested that dynamic PRT lookups
might be a solution, which I kinda like.

So, the plan that I would prefer is:

	a) get this patchset in [and we 'do no harm' here so
	_hopefully_ aren't introducing regressions]

	b) work on dynamic PRT lookups in a future patchset.

Thanks.

/ac

