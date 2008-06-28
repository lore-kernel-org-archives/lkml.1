Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYF1LEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYF1LEh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 07:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbYF1LE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 07:04:28 -0400
Received: from 8bytes.org ([88.198.83.132]:44894 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbYF1LE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 07:04:27 -0400
Date: Sat, 28 Jun 2008 13:04:26 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Duran, Leo" <leo.duran@amd.com>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, Adrian Bunk <bunk@kernel.org>,
       "Richter, Robert" <rrichter@elbe.amd.com>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
       "Biemueller, Sebastian" <Sebastian.Biemueller@amd.com>,
       tglx@linutronix.de, mingo@redhat.com,
       "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>
Subject: Re: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Message-ID: <20080628110426.GJ10197@8bytes.org>
References: <20080627170546.GE10197@8bytes.org> <6453C3CB8E2B3646B0D020C1126132730120C444@sausexmb4.amd.com> <20080627222931.GB7201@il.ibm.com> <6453C3CB8E2B3646B0D020C1126132730120C4EE@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6453C3CB8E2B3646B0D020C1126132730120C4EE@sausexmb4.amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 05:47:56PM -0500, Duran, Leo wrote:
> On Friday, June 27, 2008 5:30 PM, Muli Ben-Yehuda wrote:
> 
> > > 2) IOMMU will not translate if the exclusion range has been enabled,
> > and
> > > the DMA address falls inside that range.
> > > The exclusion range can be enabled for specific devices, or for all
> > > devices... Enabling the exclusion range can be considered a
> > 'performance
> > > optimization' (no table-walks), with the caveat of not being able to
> > > provide protection for devices sharing the exclusion range (BTW,
> > there's
> > > a single exclusion address range per IOMMU).
> > 
> > So, if I understand this correctly, could we implement Joerg's
> > "almost-direct-map" by having 0-64MB translated for host-owned
> > devices, and then 64MB-end excluded (again, for host-owned devices
> > only)? If yes, it should provide a small boost in performance (may or
> > may not be measurable) over having 64MB-end be an identity
> > translation.
> > 
> > Cheers,
> > Muli
> 
> Hi Muli,
> 
> Yes, you could set an exclusion range for addresses about the virtual
> address space (or 'translation aperture').
> I played with that in the context of "dma.ops" (not surprisingly, the
> exclusion range was pretty busy!).
> 
> Again, keep in mind: no protection in the exclusion range (sort of
> defeating the purpose of having an IOMMU in the first place), and only
> ONE exclusion range per IOMMU.

Yes, there is only one exclusion range per IOMMU. The problem is that an
exclusion range from 64MB to the end may not be possible because there is
an exclusion range already configured in the ACPI table. On my System for
example the exclusion range is somewhere in the first megabyte of RAM.
In this case the direct mapping using page tables is needed. If there is
no exclusion range defined in ACPI this idea would work of course.

Joerg

