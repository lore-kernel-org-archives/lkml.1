Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbZKJBBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbZKJBBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 20:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbZKJBBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 20:01:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:38386 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbZKJBBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 20:01:45 -0500
Subject: Re: [PATCH] intel-iommu: Obey coherent_dma_mask for alloc_coherent
 on passthrough
From: David Woodhouse <dwmw2@infradead.org>
To: Alex Williamson <alex.williamson@hp.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <1257814014.25961.912.camel@macbook.infradead.org>
References: <20091104225359.2720.91502.stgit@nehalem.aw>
	 <1257814014.25961.912.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 01:01:46 +0000
Message-ID: <1257814906.25961.916.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 (2.28.1-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 00:46 +0000, David Woodhouse wrote:
> 
>         if (iommu_no_mapping(hwdev))
> -               return paddr;
> +               return paddr > dma_mask - size ? 0 : paddr; 

Hm, that's still wrong. If your mask is 0xffffffff and you map
0xfffff000 + 0x1000, that should be allowed, right? How about:

	return paddr <= dma_mask - size + 1 ? paddr : 0;

And is this strictly necessary as part of the patch we're discussing?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

