Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbZDSKFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbZDSKFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 06:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbZDSKFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 06:05:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:40508 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbZDSKFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 06:05:34 -0400
Subject: Re: [PATCH] Intel IOMMU Pass Through Support
From: David Woodhouse <dwmw2@infradead.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Weidong Han <weidong.han@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       IOMMU <iommu@lists.linux-foundation.org>
In-Reply-To: <20090416001957.GA1527@linux-os.sc.intel.com>
References: <20090327212241.234500000@intel.com> >
	 <20090327212321.070229000@intel.com>
	 <20090416001957.GA1527@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Sun, 19 Apr 2009 11:05:08 +0100
Message-Id: <1240135508.3589.75.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 17:19 -0700, Fenghua Yu wrote:
> +       if (iommu_pass_through)
> +               if (!pass_through) {
> +                       printk(KERN_INFO
> +                               "Pass Through is not supported by hardware.\n");
> +                       iommu_pass_through = 0;
> +               }

So if we ask for pass-through and the hardware doesn't support it, we
end up in full-translation mode? Wouldn't it be better to set up 1:1
mappings for each device instead?

(We probably want to fix up the code which sets up 1:1 mappings to
actually share page tables where appropriate, and to use superpages).

Also, did we already have a discussion about whether this should be an
intel_iommu= parameter, or a generic iommu= one?

>                 ret = domain_context_mapping_one(domain,
> -                                                pci_domain_nr(parent->bus),
> -                                                parent->bus->number,
> -                                                parent->devfn);
> +                                               pci_domain_nr(parent->bus),
> +                                               parent->bus->number,
> +                                               parent->devfn, translation);

Whitespace damage here -- you're modifying continuation lines which used
to be right underneath the 'domain' parameter, and you're making them
not line up properly.

You have the same problem elsewhere for newly-added code too, in fact:

> +               ret = domain_context_mapping(domain, pdev,
> +                                               CONTEXT_TT_PASS_THROUGH);


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

