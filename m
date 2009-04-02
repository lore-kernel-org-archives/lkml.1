Return-Path: <linux-kernel-owner+w=401wt.eu-S935257AbZDBGbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935257AbZDBGbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbZDBGan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:30:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:42083 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296AbZDBGam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:30:42 -0400
Date: Thu, 2 Apr 2009 15:29:15 +0900
To: jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, x86@kernel.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] swiotlb updates for Xen dom0
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1238539935-4295-1-git-send-email-jeremy@goop.org>
References: <1238539935-4295-1-git-send-email-jeremy@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090402152918I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 02 Apr 2009 15:29:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 15:52:06 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> This series adds Xen support to x86 swiotlb.  This is mostly a matter of
> adding some Xen code into the existing hooks in pci-swiotlb_64.c:
>   - swiotlb_alloc_boot
>   - swiotlb_arch_range_needs_mapping
>   - swiotlb_phys_to_bus/bus_to_phys
> 
> These hooks are conditional on xen_pv_domain(), which compiles to a
> constant 0 when CONFIG_XEN is not enabled (and is a simple variable
> read when it is).
> 
> All the Xen-specific code is in xen-iommu.c.
> 
> This series is just the patches which touch lib/swiotlb.c or
> pci-swiotlb_64.c.  You can see them with more context in:
>    git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git for-linus/xen/dom0/swiotlb
> 
> Thanks,
> 	J
> 
>  arch/x86/kernel/pci-swiotlb_64.c |   31 ++++++++++++++++-
>  arch/x86/xen/Kconfig             |    1 
>  drivers/pci/xen-iommu.c          |   68 ++++++++++++++++++++++++++++++++++++---
>  include/xen/swiotlb.h            |   38 +++++++++++++++++++++
>  lib/swiotlb.c                    |    3 +
>  5 files changed, 133 insertions(+), 8 deletions(-)

This patchset looks ugly.

You add 'if we are Xen, we do A. We do B if not' code into 6 functions
though pic-swiotlb_64.c has only 8 functions. In addition, 5 of 8
functions were added for Xen.

Why can't you have something like arch/x86/xen/pci-swiotlb.c, which
works as arch/x86/kernel/pci-swiotlb_64.c? That should be much
cleaner.
