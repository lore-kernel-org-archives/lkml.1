Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbZIGMye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbZIGMye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 08:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZIGMyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 08:54:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:51591 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbZIGMyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 08:54:33 -0400
Subject: Re: [PATCH 0/8] Passthrough support for AMD-IOMMU (AMD-Vi)
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
References: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 13:54:30 +0100
Message-Id: <1252328070.4483.569.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 11:36 +0200, Joerg Roedel wrote:
> 
> this series of patches implement iommu=pt support for AMD IOMMU (AMD-Vi). If
> this option is passed on the kernel command line, the AMD-Vi driver will not
> register itself as the dma_ops backend and allows all devices unlimited access
> to main memory as long as no other kernel part (currently only KVM will do so)
> assigns the device to another domain using the IOMMU-API.

The Intel IOMMU used to behave like that in passthrough mode, but I've
now changed it. Now, it will still register itself as the dma_ops
backend, and it won't actually bypass the IOMMU for devices with a
limited dma_mask. So you don't end up having to use swiotlb for those
(which wasn't working anyway, iirc).

The devices for which you actually care about performance are still
going to end up with the passthrough mapping as you desire, anyway.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

