Return-Path: <linux-kernel-owner+w=401wt.eu-S933700AbZHEHXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbZHEHXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 03:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933647AbZHEHXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 03:23:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34211 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933576AbZHEHXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 03:23:12 -0400
Subject: Re: [PATCH 3/4] Bug Fix drivers/pci/intel-iommu.c: convert paddr
 to correct DMA pfn
From: David Woodhouse <dwmw2@infradead.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, iommu@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090804221058.GA21448@linux-os.sc.intel.com>
References: <bug-504363-150293@bugzilla.redhat.com>
	 <200908042017.n74KHsNw018095@bz-web1.app.phx.redhat.com>
	 <20090804221058.GA21448@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 08:23:09 +0100
Message-Id: <1249456989.9324.339.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 15:10 -0700, Fenghua Yu wrote:
> When calling domain_pfn_mapping(), paddr should be converted to DMA pfn
> correctly instead just shift by VTD_PAGE_SHIFT.
> 
> This issue causes kernel panic on PAGE_SIZE>VTD_PAGE_SIZE platforms e.g. ia64
> platforms.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

Using the word 'alignment' somewhere in the above commit would have
confused me a lot less -- I got most of the way through composing a mail
asking how this patch wasn't a no-op, before I spotted it.

An alternative would be to align the size to DMA pages? Would that make
the sg case easier? 

(Thanks for fixing this, btw)

-- 
dwmw2

