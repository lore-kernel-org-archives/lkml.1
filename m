Return-Path: <linux-kernel-owner+w=401wt.eu-S1762058AbXFDTb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058AbXFDTb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759076AbXFDTbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:31:52 -0400
Received: from havoc.gtf.org ([69.61.125.42]:36810 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191AbXFDTbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:31:51 -0400
Date: Mon, 4 Jun 2007 15:31:50 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/15] x86-64: Calgary - abstract how we find the iommu_table for a device
Message-ID: <20070604193150.GC20299@havoc.gtf.org>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <20070604113344.0e71ca8c.akpm@linux-foundation.org> <20070604190654.GA20299@havoc.gtf.org> <20070604191346.GL4556@rhun.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604191346.GL4556@rhun.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 10:13:46PM +0300, Muli Ben-Yehuda wrote:
> It's already being used in mainline by both NUMA and Calgary (but in
> such a way that both work. Magic). Clearly the solution is what we did
> for pciseg, have a struct sysdata that is extensible, but those pciseg
> bits don't seem any closer to going upstream?

You are missing:

* allocation code in arch/i386/pci/common.c
* use of the more-generic pci_iommu() wrapper in Calgary code
* ditto in arch/x86_64/kernel/tce.c
* pci_sysdata initialization in arch/x86_64/pci/k8-bus.c
* definition of pci_sysdata in include/asm-i386/pci.h
* bug fix in include/asm-i386/topology.h
* definition of pci_sysdata in include/asm-x86_64/pci.h
* bug fix in include/asm-x86_64/topology.h

You need to take the obviously relevant, non-PCI-domain code from
#pciseg and push it upstream.

	Jeff



