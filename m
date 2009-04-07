Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbZDGFxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbZDGFxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZDGFxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:53:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44887 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZDGFxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:53:16 -0400
Subject: Re: [GIT *] intel-iommu updates for 2.6.30 (second batch)
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090407054249.GA25772@elte.hu>
References: <1238839639.3560.37.camel@macbook.infradead.org>
	 <20090407053739.GA10500@elte.hu>  <20090407054249.GA25772@elte.hu>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 22:52:34 -0700
Message-Id: <1239083555.22733.392.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 07:42 +0200, Ingo Molnar wrote:
> hm, it breaks on all !ACPI configs AFAICS. The whole new code 
> section you added to dmar.c depends on ACPI functionality.
> 
> Restricting DMAR to "depends on ACPI" in the Kconfig would probably 
> work but is somewhat lame: 

Er, DMAR _does_ depend on ACPI:

config DMAR
        bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
        depends on PCI_MSI && ACPI && EXPERIMENTAL

DMAR is the name of an ACPI table. Much of dmar.c is dedicated to
parsing such tables... it was never going to work without ACPI.

> this built fine with !ACPI before and if the hw ever gets discovered
> purely via the PCI space 

That would be lovely... but probably isn't going to happen. Although
that doesn't stop me reminding people how lovely it would be, especially
when BIOS bugs keep screwing us over.

I suspect you have INTR_REMAP without ACPI or DMAR? And INTR_REMAP
should probably depend on ACPI too, unfortunately. As should X2APIC,
therefore.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

