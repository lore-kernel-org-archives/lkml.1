Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYF1Q2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYF1Q2D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 12:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYF1Q1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 12:27:52 -0400
Received: from 8bytes.org ([88.198.83.132]:60426 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbYF1Q1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 12:27:51 -0400
Date: Sat, 28 Jun 2008 18:27:48 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Duran, Leo" <leo.duran@amd.com>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, Adrian Bunk <bunk@kernel.org>,
       "Richter, Robert" <rrichter@elbe.amd.com>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
       "Biemueller, Sebastian" <Sebastian.Biemueller@amd.com>,
       tglx@linutronix.de, mingo@redhat.com,
       "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>
Subject: Re: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Message-ID: <20080628162748.GA31029@8bytes.org>
References: <20080627170546.GE10197@8bytes.org> <6453C3CB8E2B3646B0D020C1126132730120C444@sausexmb4.amd.com> <20080627222931.GB7201@il.ibm.com> <6453C3CB8E2B3646B0D020C1126132730120C4EE@sausexmb4.amd.com> <20080628110426.GJ10197@8bytes.org> <6453C3CB8E2B3646B0D020C1126132730120C518@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6453C3CB8E2B3646B0D020C1126132730120C518@sausexmb4.amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2008 at 09:40:57AM -0500, Duran, Leo wrote:
> On Saturday, June 28, 2008 6:04 AM, Joerg Roedel wrote:
> 
> > Yes, there is only one exclusion range per IOMMU. The problem is that
> > an
> > exclusion range from 64MB to the end may not be possible because there
> > is
> > an exclusion range already configured in the ACPI table. On my System
> > for
> > example the exclusion range is somewhere in the first megabyte of RAM.
> > In this case the direct mapping using page tables is needed. If there
> > is
> > no exclusion range defined in ACPI this idea would work of course.
> > 
> > Joerg
> > 
> 
> Direct 1:1 mappings have a couple of issues:
> 1) They don't provide a performance optimization (i.e., table-walk still
> required)

True. But the table walk is nothing which could be optimized in
software. The optimization here is that we don't need to map/unmap on
each dma_ops call. Mapping/Unmapping requires TLB flushing and
completion_wait. This is expensive for the CPU. But direct mapping
exclusion ranges inside the aperture and mark the area from 64mb to the
end as the exclusion range as you suggested could be a real option.

> 2) Your aperture would have to be large enough so that virtual==physical
> (i.e., lots of memory for page-tables)

The AMD IOMMU supports multiple page sizes from 4kb up to 4GB. I don't
think that we need too much memory for the page tables.

Joerg

